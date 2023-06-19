module csa_5_2 #(
        parameter WIDTH = 11
    ) (
        input logic[WIDTH-1:0] a,
        input logic[WIDTH-1:0] b,
        input logic[WIDTH-1:0] c,
        input logic[WIDTH-1:0] d,
        input logic[WIDTH-1:0] e,
        input logic cin1,
        input logic cin2,
        output logic[WIDTH-1:0] sum,
        output logic[WIDTH-1:0] carry
    );

    logic[WIDTH:0] carry_pipe0, carry_pipe1;

    genvar i;
    generate
        for(i = 0; i < WIDTH; i++) 
        begin : generate_CSA_slices 
            csa_5_2_bitslice bitslice(
                .a(a[i]),
                .b(b[i]),
                .c(c[i]),
                .d(d[i]),
                .e(e[i]),
                .cin1(carry_pipe0[i]),
                .cin2(carry_pipe1[i]),
                .sum(sum[i]),
                .carry(carry[i]),
                .cout1(carry_pipe0[i+1]),
                .cout2(carry_pipe1[i+1])
            );
        end
    endgenerate

    assign carry_pipe0[0] = cin1;
    assign carry_pipe1[0] = cin2;

endmodule