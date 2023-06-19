import rbr_pkg::*;
module so3s_append #(
        parameter X_WIDTH = 8,
        parameter WIDTH = 11
    ) (
        input signed_digit x,
        input logic en,
        input logic append_en,
        input logic[WIDTH-1:0] xp_prev,
        input logic[WIDTH-1:0] xm_prev,
        input logic[$clog2(X_WIDTH)-1:0] j,
        output logic[WIDTH-1:0] xp,
        output logic[WIDTH-1:0] xm,
        output logic[WIDTH-1:0] Q,
        output logic[WIDTH-1:0] QM
    );

    logic[WIDTH-1:0] xp_in, xm_in;
    logic[$clog2(X_WIDTH):0] SHIFT_AMOUNT;
    always_comb
    begin 
        SHIFT_AMOUNT = '0;
        xp_in = '0;
        xm_in = '0;
        xp = '0;
        xm = '0;
        Q = '0;
        QM = '0;
        if(en)
        begin
            SHIFT_AMOUNT  = ((X_WIDTH)-j);
            xp_in = xp_prev << 1;
            xp_in[WIDTH-1] = xp_prev[WIDTH-1];
            xm_in = xm_prev << 1;
            xm_in[WIDTH-1] = xm_prev[WIDTH-1];
            if(append_en)
            begin 
                if(x.plus && !x.minus)
                begin 
                    xp   =  xp_in | (x.plus << SHIFT_AMOUNT); 
                    Q   =  xp_prev | (x.plus << SHIFT_AMOUNT);  
                    xm  =  xp_in;
                    QM  =  xp_prev;
                end
                else if(!x.plus && x.minus)
                begin 
                    xp   =  xm_in | (x.minus << SHIFT_AMOUNT);
                    Q    =  xm_prev | (x.minus << SHIFT_AMOUNT);
                    xm   =  xm_in;
                    QM   =  xm_prev;
                end 
                else 
                begin 
                    xp   =  xp_in | (x.plus << SHIFT_AMOUNT); 
                    Q    =  xp_prev | (x.plus << SHIFT_AMOUNT); 
                    xm   =  xm_in | ('1 << SHIFT_AMOUNT);
                    QM   =  xm_prev | ('1 << SHIFT_AMOUNT);
                end
            end
            else 
            begin
                Q = xp_prev;
                xp = xp_in;
                QM = xm_prev; 
                xm = xm_in;
            end
        end
    end
endmodule