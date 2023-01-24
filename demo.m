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

%% demo 
%% HDR tone mapping 

% NOTE: 'memorial.hdr' is available on <http://www.cs.huji.ac.il/~danix/hdr/pages/memorial.html>
input_file = 'memorial.hdr';
if( ~exist(input_file,'file') )
 websave(input_file, 'http://www.cs.huji.ac.il/~danix/hdr/hdrs/memorial.hdr' );
end

outdir = 'res_HDRtonemap_memorial';
if( ~exist(outdir) )
 mkdir(outdir);
end

img = double(hdrread(sprintf(input_file)));

im_fin = sample_HDRtonemap_core(img, 0.015, 0.5, 0.5);
imwrite(uint8(im_fin), sprintf('%s/HDR_tonemapping_natural.bmp',outdir));


%% HDR tone mapping 

% NOTE: 'designCente.hdr' is available on <http://people.csail.mit.edu/fredo/PUBLI/Siggraph2002/>
% In our demo, the size of the HDR image is  656x1000 [pix].
input_file = 'designCenter.hdr';
if( ~exist(input_file,'file') )
 websave(input_file, 'http://people.csail.mit.edu/fredo/PUBLI/Siggraph2002/smalldesignCenter.hdr' );
end

outdir = 'res_HDRtonemap_designCenter';
if( ~exist(outdir) )
 mkdir(outdir);
end

img = double(hdrread(sprintf(input_file)));
im_fin = sample_HDRtonemap_core(img, 0.030, 0.5, 0.8);
imwrite(uint8(im_fin), sprintf('%s/HDR_tonemapping_detail_exagg.bmp',outdir));


%% detail enhancement

% NOTE: 'orig.png' is available on <http://www.cs.huji.ac.il/~danix/epd/MSTM/flower/>
input_file = 'orig.png';
if( ~exist(input_file,'file') )
 websave(input_file, 'http://www.cs.huji.ac.il/~danix/epd/MSTM/flower/orig.png' );
end

outdir = 'res_detail_enhance';
if( ~exist(outdir) )
 mkdir(outdir);
end

img = double(imread(input_file));

im_fin = sample_detail_enhance_core(img, 8, 0.8);
imwrite(uint8(im_fin), sprintf('%s/detail_enhance.bmp',outdir));

%% robust restoration (non-blind deconvolution)
img = double(imread('in.bmp'));
psf_e = fspecial('gaussian',15,2);

outdir = 'res_robust_restoration'; 
if( ~exist(outdir) )
 mkdir(outdir);
end

[im_fin, im_deconvlucy] = sample_robust_resotration_core(img, psf_e);

imwrite(uint8(im_fin), sprintf('%s/robust_restoration.bmp',outdir));

% Deblur image using Lucy-Richardson method (for comparison)
imwrite(uint8(im_deconvlucy), sprintf('%s/deconvlucy.bmp',outdir));

