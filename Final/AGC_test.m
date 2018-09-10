%Consider hardware implementation, try limiting the loop number of both
%outer loop and inner loop
%function AGC_test(file)
clear;
%file = 'test_b.png';
%file = 'test_a.png';
%file = 'test_9.jpg';
%file = 'test_6.jpg';
%file = 'fhd_2.jpg';
file = 'fhd_1.jpg';
%file = 'Skyrim-Lordbound.png';
outer_loop_max = 2;
inner_loop_max = 4;
TL = 0.25;
TH = 0.25;
TD = 0.06;
map = imread(file);
graymap = rgb2gray(map);
%graymap = graymap+120;
%graymap(graymap>255) = 255;
%graymap = graymap-20;
%graymap(graymap<0) = 0;

%imshow(graymap)%gray 
x = size(graymap,2);%columns
y = size(graymap,1);%rows 
total = x*y;

%get quantized histogram
T = [1:8];
for i = 1:8
    T(i) = size(find(graymap >= 32*(i-1) & graymap < 32*i),1)/total;
end
%T(1)+T(2)+T(3)+T(4)+T(5)+T(6)+T(7)+T(8) = 1

%LUT of gain value
amp_pos = [1.25 1.55 1.93 2.41 3.00 3.74 4.66 5.88 7.22 9.00];
amp_neg = [0.898 0.792 0.699 0.597 0.500 0.398 0.296 0.199 0.097 0.046];
lut_int = [0.27 0.31 0.39 0.47 0.53 0.58 0.69 0.78 0.94 1.00];
T_init = T;
graymap_init = graymap;

T_amp = T;
graymap_amp = graymap;
d_chk = 0;
b_chk = 0;
amp_conv = 0;
gain = 1;
tmp_gain = 1;
outer_loop_cnt = 0;
tic
while ((d_chk == 0 | b_chk == 0) & outer_loop_cnt < outer_loop_max)
    outer_loop_cnt = outer_loop_cnt+1;
    amp_conv = 0;
    first_trial = 1;
    d_chk = 0;
    b_chk = 0;
    if T(1) < TL
        d_chk = 1;
        if T(8) < TH
            b_chk = 1;
        else
            disp('Entering bright adjust loop');
            inner_loop_cnt = 0;
            while (amp_conv == 0 & inner_loop_cnt < inner_loop_max)
                inner_loop_cnt = inner_loop_cnt+1;
                disp_var = ['Wait bright loop to converge',first_trial,'j = ',j,T(8)];
                disp(disp_var);
                if first_trial
                    for j = 1:10
                        if T(8) <= lut_int(j)
                            tmp_gain = amp_neg(j);
                            first_trial = 0;
                            break;
                        end
                    end
                else
                    if j == 1
                        disp('out of bound!!!!!');
                        tmp_gain = 0.95;%TBD
                    else
                        j = j-1;
                        tmp_gain = amp_neg(j);
                    end
                end
            
                graymap_amp = graymap*tmp_gain;
                graymap_amp(graymap_amp>255) = 255;%replace all values >255 with 255
                for i = 1:8
                    T_amp(i) = size(find(graymap_amp >= 32*(i-1) & graymap_amp < 32*i),1)/total;
                end
            
                if (T_amp(1) - T_init(1) - T_init(2) < TD | j == 1 | inner_loop_cnt >= inner_loop_max)%TBD
                %if (T_amp(1) - T(1) - T(2) < TD | j == 1)%TBD
                    amp_conv = 1;
                    graymap = graymap_amp;
                    T = T_amp;
                    gain = gain*tmp_gain
                end
            end
        end
    else
        disp('Entering dark adjust loop');
        inner_loop_cnt = 0;
        while (amp_conv == 0 & inner_loop_cnt < inner_loop_max)
            inner_loop_cnt = inner_loop_cnt+1;
            %disp("R U allright?");
            disp_var = ['Wait dark loop to converge',first_trial,'j = ',j,T(1)];
            disp(disp_var);
            if first_trial
                for j = 1:10
                    if T(1) <= lut_int(j)
                        tmp_gain = amp_pos(j);
                        first_trial = 0;
                        break;
                    end
                end
            else
                if j == 1
                    disp('out of bound!!!!!');
                    tmp_gain = 1.10;%TBD
                else
                    j = j-1;
                    tmp_gain = amp_pos(j);
                end
            end
            
            graymap_amp = graymap*tmp_gain;
            graymap_amp(graymap_amp>255) = 255;%replace all values >255 with 255
            for i = 1:8
                T_amp(i) = size(find(graymap_amp >= 32*(i-1) & graymap_amp < 32*i),1)/total;
            end
            
            if (T_amp(8) - T_init(8) - T_init(7) < TD | j == 1 | inner_loop_cnt >= inner_loop_max)%TBD
            %if (T_amp(8) - T(8) - T(7) < TD | j == 1)%TBD
                amp_conv = 1;
                graymap = graymap_amp;
                T = T_amp;
                gain = gain*tmp_gain
            end
        end
    end
end
toc
%imshow(graymap)%gray
imshowpair(graymap_init, graymap, 'montage')
%result = (graymap_init == graymap)
%end