%%
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
%
%  If you use this code for future publications, please cite the following paper.
% 
%  Takashi Shibata, Masayuki Tanaka, Masatoshi Okutomi; The IEEE Conference on Computer Vision and Pattern Recognition (CVPR), 2016, pp. 2745-2753
%
% DISCLAIMERS:
%  1) The user agree that Tokyo Insititute of Technology and NEC Corporation have NO duty or obligation to do technical support for the user, including explanation of the usage of this code.
%  2) The user agree that Tokyo Insititute of Technology and NEC Corporation make NO responsibility with respect to the operation of this code.
%  3) The user agree that Tokyo Insititute of Technology and NEC Corporation make NO express or implied warranties regarding this code, such as warranty of no defect and/or no infringement of third party's right.
%  4) The user agree that Tokyo Insititute of Technology and NEC Corporation make NO responsibility to any direct and indirect damages incurred to the user by installation and/or use of this code.
% 
% Copyright (C) 2016 T.Shibata, M.Tanaka, and M.Okutomi. All rights reserved.
% Email: tshibata@ok.ctrl.titech.ac.jp, {mtanaka, mxo}@ctrl.titech.ac.jp
% 
%%
function im_fin = sample_HDRtonemap_core(hdr, alpha, sat,b)
% hdr: input hdr image (e.g. memorial.hdr)
% alpha: target gradient strength control parameter
% sat: color saturation parameter
% b: sensitivity to the gradient residual

%% decompose luminance and color
[hdr_Y, cmap] = RGB2Y(hdr);

%% generate guided gradient
% original version of guided gradient for HDR tonemapping (CVPR2016)
[du_h, du_v, u_ini, umin, umax] = gen_grad_HDR(hdr_Y,alpha);

% latest version of guided gradient for HDR tonemapping
% [du_h, du_v, u_ini, umin, umax] = gen_grad_HDR_latest(hdr_Y, alpha);

%% compute compressed luminance by proximal gradient method

% parameter for optimization
eta = 0.25; % scaduling parameter
itr = 1E3; % iteration
lmd = 0; % strength of base-structure constraint

% minimize by proximal gradient method
u_fin = ProxSolver_core(u_ini, du_h, du_v, [], eta, itr, lmd,  umin, umax, b);

%% colorization
im_fin = zeros(size(hdr));
for ch=1:3; im_fin(:,:,ch) = u_fin.*(cmap(:,:,ch).^sat); end

end

