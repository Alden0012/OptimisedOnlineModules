impls=so3s_1D so3s_2D so3s_1D_tb so3s_2D_tb

so3s_1D:
	iverilog -g 2012 -o so3s_1D ../Primitives/rbr_pkg.sv hdl/so3s_1D.sv hdl/so3s_append.sv ../Primitives/csa_5_2.sv ../Primitives/csa_5_2_bitslice.sv 

so3s_1D_tb:
	iverilog -g 2012 -o so3s_1D_tb ../Primitives/rbr_pkg.sv tb/so3s_1D_tb.sv hdl/so3s_1D.sv hdl/so3s_append.sv ../Primitives/csa_5_2.sv ../Primitives/csa_5_2_bitslice.sv 

so3s_2D:
	iverilog -g 2012 -o so3s_2D ../Primitives/rbr_pkg.sv hdl/so3s_2D.sv hdl/so3s_2D_stage.sv hdl/so3s_append_2D.sv ../Primitives/csa_5_2.sv ../Primitives/csa_5_2_bitslice.sv 

so3s_2D_tb:
	iverilog -g 2012 -o so3s_2D_tb ../Primitives/rbr_pkg.sv tb/so3s_2D_tb.sv hdl/so3s_2D.sv hdl/so3s_2D_stage.sv hdl/so3s_append_2D.sv ../Primitives/csa_5_2.sv ../Primitives/csa_5_2_bitslice.sv 
clean:
	rm -f $(impls) *.o
	rm -f $(impls) *.vcd