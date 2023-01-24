
function [Fh Fv Bh Bv] = imgrad(X)

Kh = [ 0,-1, 1 ];
Kv = [ 0;-1; 1 ];

Fh = imfilter(X,Kh,'replicate');
Fv = imfilter(X,Kv,'replicate');

if( nargout >= 3 )
 Bh = circshift(Fh,[0,1]);
 Bv = circshift(Fv,[1,0]);
end
