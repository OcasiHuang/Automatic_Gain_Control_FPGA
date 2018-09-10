module cmp_thtl(t1,t8,sel,fin);
`include "para_verilog.v"
input unsigned [bit_width-1:0] t1,t8;
output sel,fin;

//assign {fin,sel} = (t1 >= 21'd518400) ? 2'b00 : (t8 >= 21'd518400) ? 2'b01 : 2'b10;
assign {fin,sel} = (t1 >= th) ? 2'b00 : (t8 >= th) ? 2'b01 : 2'b10;

endmodule
