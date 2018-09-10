clear;
%input_sample_rate = 4e6; % Hz 
%sim_time = 64e6
input_sample_rate = 30*1920*1080;

%resolution = 363*274; //test pattern for faster simulation
%file = 'test.jpeg';
resolution = 1920*1080;
file = 'fhd_1.jpg';

bit_width = ceil(log2(resolution)); 
latency = 2*resolution+12;
latency = latency/2;
BlockName = 'AGC_control';

map = imread(file);
graymap = rgb2gray(map);

A = reshape(graymap,resolution,1);
%total = 1920*1080;

T = [1:8];
for i = 1:8
    T(i) = size(find(graymap >= 32*(i-1) & graymap < 32*i),1);
end

for l = 1:2
set_param([BlockName '/Sub' num2str(l) '/CounterT1'],'syn_term_val','resolution-1')
set_param([BlockName '/Sub' num2str(l) '/CounterT2'],'syn_term_val','resolution-1')
set_param([BlockName '/Sub' num2str(l) '/CounterT7'],'syn_term_val','resolution-1')
set_param([BlockName '/Sub' num2str(l) '/CounterT8'],'syn_term_val','resolution-1')
set_param([BlockName '/Sub' num2str(l) '/CounterRDY'],'syn_term_val','latency-1')%each stage = 2*resolution+12
set_param([BlockName '/Sub' num2str(l) '/Comparator'],'syn_comp_val','resolution')
set_param([BlockName '/Sub' num2str(l) '/Comparator1'],'syn_comp_val','resolution')

set_param([BlockName '/Sub' num2str(l) '/Constant1'],'syn_cst_st','1/input_sample_rate')
set_param([BlockName '/Sub' num2str(l) '/Constant3'],'syn_cst_st','1/input_sample_rate')
set_param([BlockName '/Sub' num2str(l) '/Constant4'],'syn_cst_st','1/input_sample_rate')



for i=1:2
set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/Constant'],'syn_cst_st','1/input_sample_rate')
for j=1:5
    set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/Constant' num2str(j)],'syn_cst_st','1/input_sample_rate')
end

for k=1:11
    set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/Gain_LUT/Constant' num2str(k)],'syn_cst_st','1/input_sample_rate')
    set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/Reduce_LUT/Constant' num2str(k+9)],'syn_cst_st','1/input_sample_rate')
end

for j=1:7
    for k=1:11
      set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/Gain_LUT' num2str(j) '/Constant' num2str(k)],'syn_cst_st','1/input_sample_rate')
      set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/Reduce_LUT' num2str(j) '/Constant' num2str(k+9)],'syn_cst_st','1/input_sample_rate')
    end
end

set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/Counter Read Original'],'syn_term_val','resolution-1')
set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/Counter Write Original'],'syn_term_val','resolution-1')
set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/Counter Write Out'],'syn_term_val','resolution-1')
set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/Counter New T1'],'syn_term_val','resolution-1')
set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/Counter New T8'],'syn_term_val','resolution-1')

set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/RAM Original'],'syn_ram_depth','resolution')
set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/RAM Amplified'],'syn_ram_depth','2')

for j=1:4
    set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/sec_loop' num2str(j-1) '/Counter Write Amp T1'],'syn_term_val','resolution-1')
    set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/sec_loop' num2str(j-1) '/Counter Write Amp T8'],'syn_term_val','resolution-1')
    set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/sec_loop' num2str(j-1) '/Counter Write Fin'],'syn_term_val','resolution-1')
    set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/sec_loop' num2str(j-1) '/Comparator2'],'syn_comp_val','resolution-1')
    set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/sec_loop' num2str(j-1) '/Comparator4'],'syn_comp_val','resolution-1')
end
set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/Comparator5'],'syn_comp_val','resolution-1')
set_param([BlockName '/Sub' num2str(l) '/Sub' num2str(i) '/Comparator6'],'syn_comp_val','resolution-1')
end

end
%set_param([BlockName '/Port In Data1'],'syn_out_wl','bit_width')
%set_param([BlockName '/Port In Data2'],'syn_out_wl','bit_width')
%set_param([BlockName '/Port In Data3'],'syn_out_wl','1')
%set_param([BlockName '/Port In Data4'],'syn_out_wl','bit_width')
%set_param([BlockName '/Port In Data5'],'syn_out_wl','bit_width')
%set_param([BlockName '/Port In Data4'],'syn_out_wl','bit_width')
%set_param([BlockName '/Port In Data5'],'syn_out_wl','bit_width')
%set_param([BlockName '/Extract'],'syn_extract_vec','syn_inp_wl-3 syn_inp_wl-2 syn_inp_wl-1')

data_padding = [A;repelem(0,latency-resolution)'];
sync_padding = [repelem(1,resolution)';repelem(0,latency-resolution)'];
%zero_padding = repelem(0,resolution)';
zero_padding = repelem(0,latency)';
%t = [0:resolution*5-1]'/input_sample_rate;
t = [0:latency*4-1]'/input_sample_rate;

Pixel.time = t;
%Pixel.signals.values = [A;zero_padding;zero_padding;zero_padding;zero_padding];
Pixel.signals.values = [data_padding;data_padding;data_padding;data_padding];
Pixel.signals.dimensions = 1;

Sync.time = t;
%Sync.signals.values = [repelem(1,resolution)';zero_padding;zero_padding;zero_padding;zero_padding];
Sync.signals.values = [sync_padding;sync_padding;sync_padding;sync_padding];
Sync.signals.dimensions = 1;

%rdy.time = t;
%rdy.signals.values = [zero_padding;repelem(1,resolution*3)'];
%rdy.signals.dimensions = 1;
%
%T1.time = t;
%T1.signals.values = [zero_padding;repelem(T(1),resolution*3)'];
%T1.signals.dimensions = 1;
%
%T8.time = t;
%T8.signals.values = [zero_padding;repelem(T(8),resolution*3)'];
%T8.signals.dimensions = 1;

%T1_ori.time = t;
%T1_ori.signals.values = [zero_padding;repelem(T(1),resolution*3)'];
%T1_ori.signals.dimensions = 1;

%T2_ori.time = t;
%T2_ori.signals.values = [zero_padding;repelem(T(2),resolution*3)'];
%T2_ori.signals.dimensions = 1;

%T7_ori.time = t;
%T7_ori.signals.values = [zero_padding;repelem(T(7),resolution*3)'];
%T7_ori.signals.dimensions = 1;

%T8_ori.time = t;
%T8_ori.signals.values = [zero_padding;repelem(T(8),resolution*3)'];
%T8_ori.signals.dimensions = 1;

rst.time = t;
%rst.signals.values = [zero_padding;zero_padding;zero_padding;zero_padding;zero_padding];
rst.signals.values = [zero_padding;zero_padding;zero_padding;zero_padding];
rst.signals.dimensions = 1;

set_param([BlockName '/From Workspace'],'VariableName','Pixel')
set_param([BlockName '/From Workspace1'],'VariableName','Sync')
%set_param([BlockName '/From Workspace2'],'VariableName','T8')
%set_param([BlockName '/From Workspace3'],'VariableName','T1')
set_param([BlockName '/From Workspace4'],'VariableName','rst')
%set_param([BlockName '/From Workspace5'],'VariableName','rdy')
%set_param([BlockName '/From Workspace6'],'VariableName','T7_ori')
%set_param([BlockName '/From Workspace7'],'VariableName','T2_ori')
%set_param([BlockName '/From Workspace8'],'VariableName','T8_ori')
%set_param([BlockName '/From Workspace9'],'VariableName','T1_ori')

set_param([BlockName '/To Workspace'],'VariableName','y')
set_param([BlockName '/To Workspace'],'SaveFormat',['Structure With Time'])
set_param([BlockName '/To Workspace1'],'VariableName','new_T1_out')
set_param([BlockName '/To Workspace2'],'VariableName','new_T8_out')
set_param([BlockName '/To Workspace3'],'VariableName','Sync_out')
set_param([BlockName '/To Workspace4'],'VariableName','rdy_out')

set_param([BlockName '/To Workspace5'],'VariableName','new_T1_out1')
set_param([BlockName '/To Workspace6'],'VariableName','new_T8_out1')
set_param([BlockName '/To Workspace7'],'VariableName','rdy_out1')

set_param([BlockName '/To Workspace8'],'VariableName','debug_sel_out')
set_param([BlockName '/To Workspace9'],'VariableName','debug_sel_in')




%sim('AGC_control')
%x4 = y.signals.values(4*resolution+23:4*resolution+23+resolution-1);
%x8 = reshape(uint8(x4),274,363);
%imshowpair(graymap,x8,'montage');
