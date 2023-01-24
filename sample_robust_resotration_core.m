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

function [im_fin, im_deconvlucy] = sample_robust_resotration_core(img, psf_e)
% img: input image
% psf_e: inaccurate psf

%% decompose luminance and color
[u_ini,cmap]=RGB2Y(img);

%% generate guided gradient
[du_h, du_v, u_b, umin, umax, w] = gen_grad_robust_restoration(u_ini, psf_e);

%% compute compressed luminance by proximal gradient method

% minimize by proximal gradient method
eta = 0.2; % scaduling parameter
itr = 1E2;
b = 0.0;
u_fin = ProxSolver_core(u_ini,  du_h, du_v, u_b, eta, itr, w, umin, umax, b);

%% colorization
im_fin = zeros(size(img));
for ch=1:3; im_fin(:,:,ch) = u_fin.*cmap(:,:,ch); end

%% Deblur image using Lucy-Richardson method (for comparison)
im_deconvlucy = deconvlucy(img,psf_e);

end


