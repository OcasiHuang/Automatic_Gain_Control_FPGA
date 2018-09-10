//Module for outer loop
module loop_ctrl(cnt, force_fin);
input [1:0] cnt;
output force_fin;

assign force_fin = (cnt==2'b10);

endmodule
