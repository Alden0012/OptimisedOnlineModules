module multiply_add_2D_tb;
    localparam WIDTH = 32;
    logic[WIDTH-1:0][2:0] x,c,y;
    logic[7:0] a;
    real result;
    multiply_add_2D #(
        .WIDTH(WIDTH),
        .P(WIDTH),
		.M(8)
    ) DUT (
        .a(a),
        .x(x),
        .c(c),
        .y(y)
    );

    initial begin 
        $dumpfile("multiply_add_2D.vcd");
        $dumpvars;
        x = '0;
        c = '0;
        a = 8'b00110000;
        for(int i = 0;i<WIDTH;i++)
        begin
            x[i] = 3'b001;
            c[i] = 3'b001;
        end
        #2
        result = 0;
        for(int i = 0;i<WIDTH;i++)
        begin
            $display("y %d : %b",i,y[i]);
            result = result + $signed(y[i])*1/($pow(4,i));
        end
        $display("Final Result: %f",result);
        for(int i = 0;i<WIDTH+2;i++)
            $display("%d, j:%d, z:%b,ws:%b,wc:%b, x_arr: %b, c_arr: %b",i,DUT.j[i],DUT.z[i],DUT.ws[i],DUT.wc[i], DUT.x_arr[i], DUT.c_arr[i]);
    end


endmodule