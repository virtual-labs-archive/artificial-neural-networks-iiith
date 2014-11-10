function [] = testXORcore(nbits)

nb=nbits;

load("mlffnnState.dat");

switch(nb)
	case 2
		[desout,actout,binout,input]=testXOR2bit(nnet);
	case 3
		[desout,actout,binout,input]=testXOR3bit(nnet);
	case 4
		[desout,actout,binout,input]=testXOR4bit(nnet);
	case -1
		[desout,actout,binout,input]=testXORlinear(nnet);
	case -2
		[desout,actout,binout,input]=testXORnonlinear(nnet);
end

fid=fopen('results.txt','w');
fprintf(fid,'<table border=1>\n');
fprintf(fid,'<tr><td> <b>Input pattern</b> </td><td> <b>MLFFNN out</b> </td><td> <b>Binary out</b> </td><td> <b>Desired out</b> </td></tr>\n');
for i=1:length(input)
	fprintf(fid,'<tr align=center><td>');
	fprintf(fid,'%1d ',input(:,i));
	fprintf(fid,'</td>');
	fprintf(fid,'<td> %1.4f </td>',actout(i));
	if (binout(i)==desout(i))
		fprintf(fid,'<td> %1d </td>',binout(i));
	else
		fprintf(fid,'<td><font color=ff0000> %1d </font></td>',binout(i));
	endif
	fprintf(fid,'<td> %1d </td>',desout(i));
	fprintf(fid,'</tr>\n');
end
fprintf(fid,'</table>\n');

fclose(fid);

return;
