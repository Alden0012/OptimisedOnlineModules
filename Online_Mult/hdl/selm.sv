import rbr_pkg::*;
module selm(
        input logic [2:0]           v,
        output signed_digit         p
    );
always_comb 
    case (v)
        3'b000 :    {p.plus,p.minus} = {'0,'0};
        3'b001 :    {p.plus,p.minus} = {'1,'0}; 
        3'b010 :    {p.plus,p.minus} = {'1,'0};
        3'b011 :    {p.plus,p.minus} = {'1,'0};
        3'b100 :    {p.plus,p.minus} = {'0,'1};
        3'b101 :    {p.plus,p.minus} = {'0,'1};
        3'b110 :    {p.plus,p.minus} = {'0,'1};
        3'b111 :    {p.plus,p.minus} = {'0,'0};
    endcase
endmodule