module ca_reg 
    import rbr_pkg::*;
    #(
        parameter           WIDTH = 32
    ) (
        input logic                 clk,
        input logic                 rst_n,
        input logic                 en,
        input signed_digit          x,
        output logic [WIDTH-1:0]    x_plus,
        output logic [WIDTH-1:0]    x_minus
    );

    logic [WIDTH-1:0]           Q;
    logic [WIDTH-1:0]           QM;
    logic [$clog2(WIDTH)-1:0]   j;

    always_ff @(posedge clk)
    begin 
        if(!rst_n)
        begin 
            j   <= '0;
            Q   <= '0;
            QM  <= '0;
        end
        else 
        begin 
            if(j==WIDTH-1)
                j <= j + 1;
            else 
                j <= j + en;
            if(en)
                if(x.plus && !x.minus)
                begin 
                    Q   <=  Q | (x.plus << WIDTH-1-j); 
                    QM  <=  Q;
                end
                else if(!x.plus && x.minus)
                begin 
                    Q   <=  QM | (x.minus << WIDTH-1-j);
                    QM  <=  QM;
                end 
                else 
                begin 
                    Q   <=  Q | (x.plus << WIDTH-1-j); 
                    QM  <=  QM | (1 << WIDTH-1-j);
                end
        end
    end

    assign x_plus = Q;
    assign x_minus = QM;

endmodule