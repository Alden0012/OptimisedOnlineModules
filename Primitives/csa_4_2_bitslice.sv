module csa_4_2_bitslice(
        input logic a,
        input logic b,
        input logic c,
        input logic d,
        input logic cin1,
        input logic cin2,
        output logic sum,
        output logic carry,
        output logic cout1,
        output logic cout2 
    );

    logic [1:0] fa1,fa2,fa3;

    always_comb
    begin 
        fa1 = a + b + cin1;
        cout1 = fa1[1];
        fa2 = fa1[0] + c + cin2;
        cout2 = fa2[1];
        fa3 = fa2[0] + d;
        sum = fa3[0];
        carry = fa3[1];
    end
endmodule