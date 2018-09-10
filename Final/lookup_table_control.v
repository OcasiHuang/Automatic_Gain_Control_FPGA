//Module for LUT of VH and VL

module lookup_table_control(pix_num, sel);
`include "para_verilog.v"
input unsigned [bit_width-1:0] pix_num;
output reg [3:0] sel;

//1920*1080 = 2073600
always@(*) begin
    if(pix_num <= th)//25%
        sel = 4'h0;
    else if(pix_num <= tl_27)//27%
        sel = 4'h1;
    else if(pix_num <= tl_31)//31%
        sel = 4'h2;
    else if(pix_num <= tl_39)//39%
        sel = 4'h3;
    else if(pix_num <= tl_47)//47%
        sel = 4'h4;
    else if(pix_num <= tl_53)//53%
        sel = 4'h5;
    else if(pix_num <= tl_58)//58%
        sel = 4'h6;
    else if(pix_num <= tl_69)//69%
        sel = 4'h7;
    else if(pix_num <= tl_78)//78%
        sel = 4'h8;
    else if(pix_num <= tl_94)//94%
        sel = 4'h9;
    else//>94%
        sel = 4'ha;
end

////1920*1080 = 2073600
//always@(*) begin
//    if(pix_num <= th)//25%
//        sel = 4'h0;
//    else if(pix_num <= 21'd559872)//27%
//        sel = 4'h1;
//    else if(pix_num <= 21'd642816)//31%
//        sel = 4'h2;
//    else if(pix_num <= 21'd808704)//39%
//        sel = 4'h3;
//    else if(pix_num <= 21'd974592)//47%
//        sel = 4'h4;
//    else if(pix_num <= 21'd1099008)//53%
//        sel = 4'h5;
//    else if(pix_num <= 21'd1202688)//58%
//        sel = 4'h6;
//    else if(pix_num <= 21'd1430784)//69%
//        sel = 4'h7;
//    else if(pix_num <= 21'd1617408)//78%
//        sel = 4'h8;
//    else if(pix_num <= 21'd1949184)//94%
//        sel = 4'h9;
//    else//>94%
//        sel = 4'ha;
//end

endmodule
