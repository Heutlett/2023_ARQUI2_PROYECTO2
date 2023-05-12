transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/segment_mem_wb.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/segment_if_id.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/segment_id_ex.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/segment_ex_mem.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/regfile.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/pc_control_unit.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/mux3.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/mux2_vec.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/mux2.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/flopr.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/flopenr.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/datapath.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/cpu.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/control_unit.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/alu_lanes.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/alu_defs.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/address_offset.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/alu.sv}

vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/TESTBENCHES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/TESTBENCHES/TB_TOP.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/top.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/segment_if_id.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/segment_id_ex.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/segment_mem_wb.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/segment_ex_mem.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/regfile.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/pc_control_unit.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/mux3.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/mux2_vec.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/mux2.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/instr_mem.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/flopr.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/flopenr.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/datapath.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/data_mem.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/cpu.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/control_unit.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/clockDivider.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/clock_manager.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/alu_lanes.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/alu_defs.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/alu.sv}
vlog -sv -work work +incdir+C:/Users/jeyki/OneDrive\ -\ Estudiantes\ ITCR/semesters/2023\ -\ Sem\ I/Arquitectura\ 2/project2/vectorial_cpu/VECTOR_CPU/MODULES {C:/Users/jeyki/OneDrive - Estudiantes ITCR/semesters/2023 - Sem I/Arquitectura 2/project2/vectorial_cpu/VECTOR_CPU/MODULES/address_offset.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiv_hssi_ver -L cycloneiv_pcie_hip_ver -L cycloneiv_ver -L rtl_work -L work -voptargs="+acc"  TB_TOP

add wave *
view structure
view signals
run -all
