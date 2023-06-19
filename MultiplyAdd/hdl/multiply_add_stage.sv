module multiply_add_stage #(
        parameter TRUNCATED_WIDTH = 19,
        parameter M = 8,
        parameter RESIDUAL_WIDTH = 19,
        parameter J = 4
    ) (
        input logic[RESIDUAL_WIDTH-1:0] ws_prev,
        input logic[RESIDUAL_WIDTH-1:0] wc_prev,
        input logic[J-1:0] j,
        input logic[2:0] x,
        input logic[2:0] c,
        output logic[2:0] y,
        input logic[M-1:0] a,
        output logic[RESIDUAL_WIDTH-1:0] ws_next,
        output logic[RESIDUAL_WIDTH-1:0] wc_next
    );
    localparam SHIFT = RESIDUAL_WIDTH > M ? (RESIDUAL_WIDTH-M) : (M-RESIDUAL_WIDTH);

    logic[RESIDUAL_WIDTH-1:0] ax, c_ext, vs,vc;
    logic[8:0] v;
    always_comb
    begin 
        ax = '0;
        case(x)
            3'b000: ax = 0;
            3'b001: ax = a << SHIFT;
            3'b010:
            begin
            ax = a << SHIFT;
            ax = $signed(ax)<<<1;
            end
            3'b111: ax = ~(a << SHIFT);
            3'b110:
            begin
            ax = a << SHIFT;
            ax = $signed(ax)<<<1;
            ax = -ax;
            end
            default: ax = 0;
        endcase
        ax = {{4{ax[RESIDUAL_WIDTH-1]}},ax[RESIDUAL_WIDTH-1:4]};
        c_ext = '0;
        c_ext = c << (TRUNCATED_WIDTH-3);
        c_ext = {{4{c_ext[RESIDUAL_WIDTH-1]}},c_ext[RESIDUAL_WIDTH-1:4]};
        v = vs[RESIDUAL_WIDTH-1-:8] + (vc[RESIDUAL_WIDTH-1-:8] << 1) + 9'b000010000;
        if(j >= 2)
        begin 
            y = v[7:5];
            ws_next = ({3'b0,v[4:0],vs[RESIDUAL_WIDTH-9:0]} << 2) - (1 << RESIDUAL_WIDTH-2);
            wc_next = {9'b0,vc[RESIDUAL_WIDTH-9:0]} << 2;
        end
        else
        begin 
            y = '0;
            ws_next = vs << 2;
            wc_next = vc << 2;
        end
    end

    csa_4_2 #(
        .WIDTH(RESIDUAL_WIDTH),
        .TRUNCATED_WIDTH(TRUNCATED_WIDTH)
    ) csa (
        .a(ax),
        .b(c_ext),
        .c(wc_prev),
        .d(ws_prev),
        .cin1(x[2]),
        .cin2('0),
        .ws(vs),
        .wc(vc)
    );



endmodule