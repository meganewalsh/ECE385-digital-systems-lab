transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/ece385/lab6g {C:/ece385/lab6g/tristate.sv}
vlog -sv -work work +incdir+C:/ece385/lab6g {C:/ece385/lab6g/test_memory.sv}
vlog -sv -work work +incdir+C:/ece385/lab6g {C:/ece385/lab6g/SLC3_2.sv}
vlog -sv -work work +incdir+C:/ece385/lab6g {C:/ece385/lab6g/Mem2IO.sv}
vlog -sv -work work +incdir+C:/ece385/lab6g {C:/ece385/lab6g/ISDU.sv}
vlog -sv -work work +incdir+C:/ece385/lab6g {C:/ece385/lab6g/ALU.sv}
vlog -sv -work work +incdir+C:/ece385/lab6g {C:/ece385/lab6g/BEN_REG.sv}
vlog -sv -work work +incdir+C:/ece385/lab6g {C:/ece385/lab6g/HexDriver.sv}
vlog -sv -work work +incdir+C:/ece385/lab6g {C:/ece385/lab6g/MUX.sv}
vlog -sv -work work +incdir+C:/ece385/lab6g {C:/ece385/lab6g/NZP.sv}
vlog -sv -work work +incdir+C:/ece385/lab6g {C:/ece385/lab6g/REGISTER.sv}
vlog -sv -work work +incdir+C:/ece385/lab6g {C:/ece385/lab6g/SEXT.sv}
vlog -sv -work work +incdir+C:/ece385/lab6g {C:/ece385/lab6g/memory_contents.sv}
vlog -sv -work work +incdir+C:/ece385/lab6g {C:/ece385/lab6g/datapath.sv}
vlog -sv -work work +incdir+C:/ece385/lab6g {C:/ece385/lab6g/slc3.sv}
vlog -sv -work work +incdir+C:/ece385/lab6g {C:/ece385/lab6g/lab6_toplevel.sv}

vlog -sv -work work +incdir+C:/ece385/lab6g {C:/ece385/lab6g/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
