
module parallel_sel(amp_ok_m0, amp_ok_m1, amp_ok_m2, amp_ok_m3, sel);
input amp_ok_m0, amp_ok_m1, amp_ok_m2, amp_ok_m3;
output reg [1:0] sel;

always@(*) begin
    casex({amp_ok_m0, amp_ok_m1, amp_ok_m2, amp_ok_m3})
        4'b1xxx: sel = 2'b00;
        4'b01xx: sel = 2'b01;
        4'b001x: sel = 2'b10;
        4'b0001: sel = 2'b11;
	default: sel = 2'b11;
    endcase
end
endmodule
