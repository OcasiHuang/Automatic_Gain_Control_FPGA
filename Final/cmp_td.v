

module cmp_td(t_amp,t_ori_a,t_ori_b,sel,amp_ok,sel_new);
`include "para_verilog.v" 
input unsigned [bit_width-1:0] t_amp,t_ori_a,t_ori_b;
input unsigned [3:0] sel;
output unsigned amp_ok;
output unsigned [3:0] sel_new;
wire unsigned [bit_width-1:0] tmp;

//assign tmp = t_ori_a + t_ori_b + 22'd124420;
assign tmp = t_ori_a + t_ori_b + td;
assign amp_ok = (tmp > t_amp) ? 1'b1 : 1'b0;
assign sel_new = (sel == 4'b0) ? 4'b0 : sel - !amp_ok;

endmodule
