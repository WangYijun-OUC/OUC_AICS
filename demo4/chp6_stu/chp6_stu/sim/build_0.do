# set simulation path
# *** TODO: modify this path
set sim_home D:/zhi_neng_ji_suan/demo4/chp6_stu/chp6_stu/sim

# create work dir
vlib ${sim_home}/work

# map data in work dir to work lib
vmap work ${sim_home}/work

# compile source files listed in compile.f
vlog -f ${sim_home}/compile_0.f

