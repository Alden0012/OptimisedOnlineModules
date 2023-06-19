import rbr_pkg::*;
module seld(
        input logic signed[3:0] v_hat,
        output signed_digit q
    );


always_comb
begin 
    if(v_hat >= $signed(4'b0001))
        q = 2'b10;
    else if(v_hat <= $signed(4'b1110))
        q = 2'b01;
    else 
        q = 2'b00;
end
endmodule