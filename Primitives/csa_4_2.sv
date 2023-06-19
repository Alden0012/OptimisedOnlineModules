module csa_4_2 #(
        parameter WIDTH = 16,
        parameter TRUNCATED_WIDTH = 16
    ) (
        input logic[WIDTH-1:0] a,
        input logic[WIDTH-1:0] b,
        input logic[WIDTH-1:0] c,
        input logic[WIDTH-1:0] d,
        input logic cin1,
        input logic cin2,
        output logic[WIDTH-1:0] ws,
        output logic[WIDTH-1:0] wc
    );
    localparam LAST_INDEX = WIDTH-TRUNCATED_WIDTH;
    logic[WIDTH:0] carry_pipe0;
    logic[WIDTH:0] carry_pipe1;

    genvar i;
    generate
        for(i = LAST_INDEX;i<WIDTH;i++) 
        begin : generate_CSA
            csa_4_2_bitslice csa_bitslice(
                .a(a[i]),
                .b(b[i]),
                .c(c[i]),
                .d(d[i]),
                .cin1(carry_pipe0[i]),
                .cin2(carry_pipe1[i]),
                .sum(ws[i]),
                .carry(wc[i]),
                .cout1(carry_pipe0[i+1]),
                .cout2(carry_pipe1[i+1])
            );
        end
    endgenerate
    
    always_comb
    begin 
        if(WIDTH != TRUNCATED_WIDTH)
        begin 
            ws[LAST_INDEX-1:0] = 0;
            wc[LAST_INDEX-1:0] = 0;
        end
        carry_pipe0[LAST_INDEX] = cin1;
        carry_pipe1[LAST_INDEX] = cin2;
    end

endmodule