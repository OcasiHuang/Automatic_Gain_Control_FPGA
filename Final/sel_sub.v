//Module for outer loop
module sel_sub(sel_in,sub_in,sel_out);
input unsigned [3:0] sel_in;
input unsigned [1:0] sub_in;
output unsigned [3:0] sel_out;

assign sel_out = (sel_in <= sub_in) ? 4'b0 : (sel_in - sub_in);

endmodule
