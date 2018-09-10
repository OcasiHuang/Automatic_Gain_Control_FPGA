%for i=1:resolution
  %z = find(debug_ram.signals.values(i+resolution+4) ~= Pixel.signals.values(i));
  %size(find(debug_ram.signals.values(i+resolution+4)*3 ~= debug_ram_first_gain.signals.values(i+resolution+5));
%end

%x1 = Pixel.signals.values(1:resolution);
%x2 = debug_ram.signals.values(resolution+5:resolution+5+resolution-1);
%x3 = debug_ram_first_gain.signals.values(resolution+6:resolution+6+resolution-1);
%x4 = y.signals.values(2*resolution+11:2*resolution+11+resolution-1);
%x4 = y.signals.values(4*resolution+23:4*resolution+23+resolution-1);
%x5 = round(x1*2.41);
%x5(x5>255) = 255;
%x4 = y.signals.values(4*resolution+23:4*resolution+23+resolution-1);
x4 = y.signals.values(4*resolution+28:4*resolution+28+resolution-1);
x5 = y.signals.values(4*resolution+28+latency:4*resolution+28+resolution-1+latency);
x8 = reshape(uint8(x5),274,363);
imshowpair(graymap,x8,'montage');

%298400,298408
%397874,497336

%err_1 = size(find(x1 ~= x2),1);
%err_2 = size(find(x2*3 ~= x3 & x3 ~= 255),1);
%err_3 = find(x2*3 ~= x3);
%err_4 = size(find(debug_cnt_amp_en.signals.values ~= 0),1);
%err_5 = size(find(debug_out_en.signals.values ~= 0),1);
%err_6 = size(find(x4 ~= x5),1);
%err_7 = find(x4 ~= round(x1*2.41));