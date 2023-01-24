% LICENSE:
%  This code is available only for research purpose.
%  This code comes with no warranty or guarantee of any kind.
%  This code cannot be redistributed. 
%  This code and the link may be modified without any notice.
%  The copyright is owned by Tokyo Insititute of Technology and NEC Corporation.
% 
%  By using this code, the user accepts full liability.
% 
% RESTRICTIONS:
% You are NOT permitted to do the following:
%  1) reproduction, public transmission, transfer and rent of this code and its derivative work;
%  2) reverse engineer, disassemble or decompile of this code;
%  3) commercial use of this code; and
%  4) military use of this code.
% 
% DISCLAIMERS:
%  1) The user agree that Tokyo Insititute of Technology and NEC Corporation have NO duty or obligation to do technical support for the user, including explanation of the usage of this code.
%  2) The user agree that Tokyo Insititute of Technology and NEC Corporation make NO responsibility with respect to the operation of this code.
%  3) The user agree that Tokyo Insititute of Technology and NEC Corporation make NO express or implied warranties regarding this code, such as warranty of no defect and/or no infringement of third party's right.
%  4) The user agree that Tokyo Insititute of Technology and NEC Corporation make NO responsibility to any direct and indirect damages incurred to the user by installation and/or use of this code.
% 
% Copyright (C) 2016 T.Shibata, M.Tanaka, and M.Okutomi. All rights reserved.
% Email: tshibata@ok.ctrl.titech.ac.jp, {mtanaka, mxo}@ctrl.titech.ac.jp

%%
function u_fin = ProxSolver_core(u_ini, du_h, du_v, u_b, eta, itr, lmd, umin, umax, b)
%% 

%%
if( ~exist('eta', 'var') ); eta = 0.1; end
if( ~exist('itr', 'var') ); itr = 1E3; end
if( ~exist('lmd', 'var') ); lmd = 0; end

%% compute weight for gradient residual
if b~=0
    [dXh, dXv] = imgrad(u_ini);
    dXh = du_h - dXh;
    dXv = du_v - dXv;
    wh = abs(dXh);
    wv = abs(dXv);
    wh = (wh+1).^(-b);
    wv = (wv+1).^(-b);
else
    wh = 1;
    wv = 1;
end
%%
u_dst = u_ini;
%%
if ~lmd
    if numel(umin)==1
        %% homogeneous indicator function
        for i = 1:itr
            % laplacian dst
            u_dst = cmp_grad(u_dst,du_h,du_v,wh,wv,eta);
            % proximal operator for indicator function
            u_dst = prox( u_dst, umin, umax  );
        end
    else
        %% region adaptive indicator function
        for i = 1:itr
            % laplacian dst
            u_dst = cmp_grad(u_dst,du_h,du_v,wh,wv,eta);
            % proximal operator for indicator function
            u_dst = prox_mat(u_dst, umin, umax );
        end
    end
else
    if numel(umin)==1
        %% homogeneous indicator function
        for i = 1:itr
            % laplacian dst
            u_dst = cmp_grad(u_dst,du_h,du_v,wh,wv,eta);
            % proximal operator for lasso
            u_dst = prox_lasso( u_dst-u_b, eta * lmd ) + u_b;
            % proximal operator for indicator function
            u_dst = prox( u_dst, umin, umax  );
        end
    else
        %% region adaptive indicator function
        for i = 1:itr
            % laplacian dst
            u_dst = cmp_grad(u_dst,du_h,du_v,wh,wv,eta);
            % proximal operator for lasso
            u_dst = prox_lasso( u_dst-u_b, eta.*lmd ) + u_b;
            % proximal operator for indicator function
            u_dst = prox_mat( u_dst, umin, umax );
        end
    end
end
u_fin  = u_dst;
end

function u_dst = cmp_grad(u_dst,du_h,du_v,wh,wv,eta)
[Xdh,Xdv] = imgrad(u_dst);
dXh = Xdh - du_h;
dXv = Xdv - du_v;

dXh = dXh.*wh;
dXv = dXv.*wv;
Xgrad = grad2lap_fast(dXh,dXv);

u_dst = u_dst - eta * Xgrad;
end

%%
function lap = grad2lap_fast(du_h, du_v)
lap = circshift(du_h,[0,1]) + circshift(du_v,[1,0]) - du_h - du_v;
end

%% proximal operator for lasso (i.e soft thleshold )
function y = prox_lasso(x, lmd)
y = zeros(size(x));
y(x>lmd) = x(x>lmd)-lmd(x>lmd);
y(x<(-lmd)) = x(x<(-lmd))+lmd(x<(-lmd));
end

%% proximal operator (i.e. hard thleshold)
function y = prox(x, cmin, cmax)
y = x;
y(x<cmin) = cmin;
y(x>cmax) = cmax;
end

function y = prox_mat(x, cmin, cmax)
y = x;
y(x<cmin) = cmin(x<cmin);
y(x>cmax) = cmax(x>cmax);
end

