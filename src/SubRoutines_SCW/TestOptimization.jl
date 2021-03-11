Outcomes = zeros(7,4)

function veg_outcome(Veg, SufferingEquiv=1.0, alphaM = alpha)
	m = create_AnimalWelfareOpt()
	update_param!(m, :CowEquiv, SufferingEquiv)
	update_param!(m, :PigEquiv, SufferingEquiv)
	update_param!(m, :ChickenEquiv, SufferingEquiv)
	update_param!(m, :alphameat, alphaM)
	update_param!(m, :MeatReduc, Veg)
	run(m)
	return m[:welfare, :UTILITY]
end

function ByAnimals_outcome(x::Array{Float64, 1}, SufferingEquiv=1.0)
	m 	= create_AnimalWelfareOpt()
	update_param!(m, :BeefReduc, x[1])
	update_param!(m, :PoultryReduc, x[2])
	update_param!(m, :PorkReduc, x[3])
	update_param!(m, :CowEquiv, SufferingEquiv)
	update_param!(m, :PigEquiv, SufferingEquiv)
	update_param!(m, :ChickenEquiv, SufferingEquiv)
	run(m)
	return m[:welfare, :UTILITY]
end

function optveg(x, grad)
	if length(grad)>0
	grad[1] = 1000
	end
    result = veg_outcome(x[1])
	return result
end
opt = Opt(:LN_SBPLX, 1)
opt.lower_bounds=[-1.0]
opt.upper_bounds=[.9999999999]
init = [.5]
opt.xtol_rel = 1e-3
opt.max_objective = optveg
sol = optimize(opt, init)[2]
Outcomes[1, 1] = sol[1]

function optanimals(x, grad)
	if length(grad)>0
	grad[1] = 1
	end
	result = ByAnimals_outcome(x)
	return result
end
opt = Opt(:LN_SBPLX, 3)
opt.lower_bounds=-1*ones(3)
opt.upper_bounds=ones(3)
init = .75*ones(3)
opt.xtol_rel = 1e-3
opt.max_objective = optanimals
sol2 = optimize(opt, init)[2]
Outcomes[1,2] = sol2[1]
Outcomes[1,3] = sol2[2]  
Outcomes[1,4] = sol2[3]

#--- No Externalities ----#
function veg_outcome(Veg, SufferingEquiv=1.0, alphaM = alpha)
	m = create_AnimalWelfareOpt()
	update_param!(m, :CowEquiv, SufferingEquiv)
	update_param!(m, :PigEquiv, SufferingEquiv)
	update_param!(m, :ChickenEquiv, SufferingEquiv)
	update_param!(m, :alphameat, alphaM)
	update_param!(m, :MeatReduc, Veg)
	update_param!(m, :sigmaBeefCo2, 0)
	update_param!(m, :sigmaBeefMeth, 0)
	update_param!(m, :sigmaBeefN2o, 0)
	update_param!(m, :sigmaPoultryCo2, 0)
	update_param!(m, :sigmaPoultryMeth, 0)
	update_param!(m, :sigmaPoultryN2o, 0)
	update_param!(m, :sigmaPorkCo2, 0)
	update_param!(m, :sigmaPorkMeth, 0)
	update_param!(m, :sigmaPorkN2o, 0)
	run(m)
	return m[:welfare, :UTILITY]
end

function ByAnimals_outcome(x::Array{Float64, 1}, SufferingEquiv=1.0)
	m 	= create_AnimalWelfareOpt()
	update_param!(m, :BeefReduc, x[1])
	update_param!(m, :PoultryReduc, x[2])
	update_param!(m, :PorkReduc, x[3])
	update_param!(m, :CowEquiv, SufferingEquiv)
	update_param!(m, :PigEquiv, SufferingEquiv)
	update_param!(m, :ChickenEquiv, SufferingEquiv)
	update_param!(m, :sigmaBeefCo2, 0)
	update_param!(m, :sigmaBeefMeth, 0)
	update_param!(m, :sigmaBeefN2o, 0)
	update_param!(m, :sigmaPoultryCo2, 0)
	update_param!(m, :sigmaPoultryMeth, 0)
	update_param!(m, :sigmaPoultryN2o, 0)
	update_param!(m, :sigmaPorkCo2, 0)
	update_param!(m, :sigmaPorkMeth, 0)
	update_param!(m, :sigmaPorkN2o, 0)
	run(m)
	return m[:welfare, :UTILITY]
end

function optveg(x, grad)
	if length(grad)>0
	grad[1] = 1000
	end
    result = veg_outcome(x[1], 1.9, 0.025)
	return result
end
opt = Opt(:LN_SBPLX, 1)
opt.lower_bounds=[-1.0]
opt.upper_bounds=[.9999999999]
init = [.5]
opt.xtol_rel = 1e-3
opt.max_objective = optveg
sol = optimize(opt, init)[2]
Outcomes[2, 1] = sol[1]

function optanimals(x, grad)
	if length(grad)>0
	grad[1] = 1
	end
	result = ByAnimals_outcome(x, 1.9)
	return result
end
opt = Opt(:LN_SBPLX, 3)
opt.lower_bounds=-1*ones(3)
opt.upper_bounds=ones(3)
init = .75*ones(3)
opt.xtol_rel = 1e-3
opt.max_objective = optanimals
sol2 = optimize(opt, init)[2]
Outcomes[2,2] = sol2[1]
Outcomes[2,3] = sol2[2]  
Outcomes[2,4] = sol2[3]

#--- Only Climate ----#
function veg_outcome(Veg, SufferingEquiv=1.0, alphaM = alpha)
	m = create_AnimalWelfareOpt()
	update_param!(m, :CowEquiv, SufferingEquiv)
	update_param!(m, :PigEquiv, SufferingEquiv)
	update_param!(m, :ChickenEquiv, SufferingEquiv)
	update_param!(m, :alphameat, alphaM)
	update_param!(m, :MeatReduc, Veg)
	run(m)
	return m[:welfare, :UTILITY]
end

function ByAnimals_outcome(x::Array{Float64, 1}, SufferingEquiv=1.0)
	m 	= create_AnimalWelfareOpt()
	update_param!(m, :BeefReduc, x[1])
	update_param!(m, :PoultryReduc, x[2])
	update_param!(m, :PorkReduc, x[3])
	update_param!(m, :CowEquiv, SufferingEquiv)
	update_param!(m, :PigEquiv, SufferingEquiv)
	update_param!(m, :ChickenEquiv, SufferingEquiv)
	run(m)
	return m[:welfare, :UTILITY]
end

function optveg(x, grad)
	if length(grad)>0
	grad[1] = 1000
	end
    result = veg_outcome(x[1], 1.9, 0.025)
	return result
end
opt = Opt(:LN_SBPLX, 1)
opt.lower_bounds=[-1.0]
opt.upper_bounds=[.9999999999]
init = [.5]
opt.xtol_rel = 1e-3
opt.max_objective = optveg
sol = optimize(opt, init)[2]
Outcomes[3, 1] = sol[1]

function optanimals(x, grad)
	if length(grad)>0
	grad[1] = 1
	end
	result = ByAnimals_outcome(x, 1.9)
	return result
end
opt = Opt(:LN_SBPLX, 3)
opt.lower_bounds=-1*ones(3)
opt.upper_bounds=ones(3)
init = .75*ones(3)
opt.xtol_rel = 1e-3
opt.max_objective = optanimals
sol2 = optimize(opt, init)[2]
Outcomes[3,2] = sol2[1]
Outcomes[3,3] = sol2[2]  
Outcomes[3,4] = sol2[3]

#--- 15*climate ----#
function veg_outcome(Veg, SufferingEquiv=1.0, alphaM = alpha)
	m = create_AnimalWelfareOpt()
	update_param!(m, :CowEquiv, SufferingEquiv)
	update_param!(m, :PigEquiv, SufferingEquiv)
	update_param!(m, :ChickenEquiv, SufferingEquiv)
	update_param!(m, :alphameat, alphaM)
	update_param!(m, :MeatReduc, Veg)
	update_param!(m, :sigmaBeefCo2, 3*65.1)
	update_param!(m, :sigmaBeefMeth, 3*6.5)
	update_param!(m, :sigmaBeefN2o, 3*0.22)
	update_param!(m, :sigmaPoultryCo2, 3*25.6)
	update_param!(m, :sigmaPoultryMeth, 3*0.02)
	update_param!(m, :sigmaPoultryN2o, 3*0.03)
	update_param!(m, :sigmaPorkCo2, 3*25.1)
	update_param!(m, :sigmaPorkMeth, 3*.7)
	update_param!(m, :sigmaPorkN2o, 3*.04)
	run(m)
	return m[:welfare, :UTILITY]
end

function ByAnimals_outcome(x::Array{Float64, 1}, SufferingEquiv=1.0)
	m 	= create_AnimalWelfareOpt()
	update_param!(m, :BeefReduc, x[1])
	update_param!(m, :PoultryReduc, x[2])
	update_param!(m, :PorkReduc, x[3])
	update_param!(m, :CowEquiv, SufferingEquiv)
	update_param!(m, :PigEquiv, SufferingEquiv)
	update_param!(m, :ChickenEquiv, SufferingEquiv)
	update_param!(m, :sigmaBeefCo2, 3*65.1)
	update_param!(m, :sigmaBeefMeth, 3*6.5)
	update_param!(m, :sigmaBeefN2o, 3*0.22)
	update_param!(m, :sigmaPoultryCo2, 3*25.6)
	update_param!(m, :sigmaPoultryMeth, 3*0.02)
	update_param!(m, :sigmaPoultryN2o, 3*0.03)
	update_param!(m, :sigmaPorkCo2, 3*25.1)
	update_param!(m, :sigmaPorkMeth, 3*.7)
	update_param!(m, :sigmaPorkN2o, 3*.04)	
	run(m)
	return m[:welfare, :UTILITY]
end

function optveg(x, grad)
	if length(grad)>0
	grad[1] = 1000
	end
    result = veg_outcome(x[1], 1.9, 0.025)
	return result
end
opt = Opt(:LN_SBPLX, 1)
opt.lower_bounds=[-1.0]
opt.upper_bounds=[.9999999999]
init = [.5]
opt.xtol_rel = 1e-3
opt.max_objective = optveg
sol = optimize(opt, init)[2]
Outcomes[4, 1] = sol[1]

function optanimals(x, grad)
	if length(grad)>0
	grad[1] = 1
	end
	result = ByAnimals_outcome(x, 1.9)
	return result
end
opt = Opt(:LN_SBPLX, 3)
opt.lower_bounds=-1*ones(3)
opt.upper_bounds=ones(3)
init = .75*ones(3)
opt.xtol_rel = 1e-3
opt.max_objective = optanimals
sol2 = optimize(opt, init)[2]
Outcomes[4,2] = sol2[1]
Outcomes[4,3] = sol2[2]  
Outcomes[4,4] = sol2[3]


#--- 15* Beef ----#
function veg_outcome(Veg, SufferingEquiv=1.0, alphaM = alpha)
	m = create_AnimalWelfareOpt()
	update_param!(m, :CowEquiv, SufferingEquiv)
	update_param!(m, :PigEquiv, SufferingEquiv)
	update_param!(m, :ChickenEquiv, SufferingEquiv)
	update_param!(m, :alphameat, alphaM)
	update_param!(m, :MeatReduc, Veg)
	update_param!(m, :sigmaBeefCo2, 3*65.1)
	update_param!(m, :sigmaBeefMeth, 3*6.5)
	update_param!(m, :sigmaBeefN2o, 3*0.22)
	update_param!(m, :sigmaPoultryCo2, 25.6)
	update_param!(m, :sigmaPoultryMeth, 0.02)
	update_param!(m, :sigmaPoultryN2o, 0.03)
	update_param!(m, :sigmaPorkCo2, 25.1)
	update_param!(m, :sigmaPorkMeth, .7)
	update_param!(m, :sigmaPorkN2o, .04)	
	run(m)
	return m[:welfare, :UTILITY]
end

function ByAnimals_outcome(x::Array{Float64, 1}, SufferingEquiv=1.0)
	m 	= create_AnimalWelfareOpt()
	update_param!(m, :BeefReduc, x[1])
	update_param!(m, :PoultryReduc, x[2])
	update_param!(m, :PorkReduc, x[3])
	update_param!(m, :CowEquiv, SufferingEquiv)
	update_param!(m, :PigEquiv, SufferingEquiv)
	update_param!(m, :ChickenEquiv, SufferingEquiv)
	update_param!(m, :sigmaBeefCo2, 3*65.1)
	update_param!(m, :sigmaBeefMeth, 3*6.5)
	update_param!(m, :sigmaBeefN2o, 3*0.22)
	update_param!(m, :sigmaPoultryCo2, 25.6)
	update_param!(m, :sigmaPoultryMeth, 0.02)
	update_param!(m, :sigmaPoultryN2o, 0.03)
	update_param!(m, :sigmaPorkCo2, 25.1)
	update_param!(m, :sigmaPorkMeth, .7)
	update_param!(m, :sigmaPorkN2o, .04)	
	run(m)
	return m[:welfare, :UTILITY]
end

function optveg(x, grad)
	if length(grad)>0
	grad[1] = 1000
	end
    result = veg_outcome(x[1], 1.9, 0.025)
	return result
end
opt = Opt(:LN_SBPLX, 1)
opt.lower_bounds=[-1.0]
opt.upper_bounds=[.9999999999]
init = [.5]
opt.xtol_rel = 1e-3
opt.max_objective = optveg
sol = optimize(opt, init)[2]
Outcomes[5, 1] = sol[1]

function optanimals(x, grad)
	if length(grad)>0
	grad[1] = 1
	end
	result = ByAnimals_outcome(x, 1.9)
	return result
end
opt = Opt(:LN_SBPLX, 3)
opt.lower_bounds=-1*ones(3)
opt.upper_bounds=ones(3)
init = .75*ones(3)
opt.xtol_rel = 1e-3
opt.max_objective = optanimals
sol2 = optimize(opt, init)[2]
Outcomes[5,2] = sol2[1]
Outcomes[5,3] = sol2[2]  
Outcomes[5,4] = sol2[3]


#--- rho = .001 & climate = 20* ----#
function veg_outcome(Veg, SufferingEquiv=1.0, alphaM = alpha)
	m = create_AnimalWelfareOpt()
	update_param!(m, :CowEquiv, SufferingEquiv)
	update_param!(m, :PigEquiv, SufferingEquiv)
	update_param!(m, :ChickenEquiv, SufferingEquiv)
	update_param!(m, :alphameat, alphaM)
	update_param!(m, :MeatReduc, Veg)
	update_param!(m, :rho, 0.001)
	update_param!(m, :sigmaBeefCo2, 3*65.1)
	update_param!(m, :sigmaBeefMeth, 3*6.5)
	update_param!(m, :sigmaBeefN2o, 3*0.22)
	update_param!(m, :sigmaPoultryCo2, 3*25.6)
	update_param!(m, :sigmaPoultryMeth, 3*0.02)
	update_param!(m, :sigmaPoultryN2o, 3*0.03)
	update_param!(m, :sigmaPorkCo2, 3*25.1)
	update_param!(m, :sigmaPorkMeth, 3*.7)
	update_param!(m, :sigmaPorkN2o, 3*.04)	
	run(m)
	return m[:welfare, :UTILITY]
end

function ByAnimals_outcome(x::Array{Float64, 1}, SufferingEquiv=1.0)
	m 	= create_AnimalWelfareOpt()
	update_param!(m, :BeefReduc, x[1])
	update_param!(m, :PoultryReduc, x[2])
	update_param!(m, :PorkReduc, x[3])
	update_param!(m, :CowEquiv, SufferingEquiv)
	update_param!(m, :PigEquiv, SufferingEquiv)
	update_param!(m, :ChickenEquiv, SufferingEquiv)
	update_param!(m, :rho, 0.001)
	update_param!(m, :sigmaBeefCo2, 3*65.1)
	update_param!(m, :sigmaBeefMeth, 3*6.5)
	update_param!(m, :sigmaBeefN2o, 3*0.22)
	update_param!(m, :sigmaPoultryCo2, 3*25.6)
	update_param!(m, :sigmaPoultryMeth, 3*0.02)
	update_param!(m, :sigmaPoultryN2o, 3*0.03)
	update_param!(m, :sigmaPorkCo2, 3*25.1)
	update_param!(m, :sigmaPorkMeth, 3*.7)
	update_param!(m, :sigmaPorkN2o, 3*.04)	
	run(m)
	return m[:welfare, :UTILITY]
end

function optveg(x, grad)
	if length(grad)>0
	grad[1] = 1000
	end
    result = veg_outcome(x[1], 1.9, 0.025)
	return result
end
opt = Opt(:LN_SBPLX, 1)
opt.lower_bounds=[-1.0]
opt.upper_bounds=[.9999999999]
init = [.5]
opt.xtol_rel = 1e-3
opt.max_objective = optveg
sol = optimize(opt, init)[2]
Outcomes[6, 1] = sol[1]

function optanimals(x, grad)
	if length(grad)>0
	grad[1] = 1
	end
	result = ByAnimals_outcome(x, 1.9)
	return result
end
opt = Opt(:LN_SBPLX, 3)
opt.lower_bounds=-1*ones(3)
opt.upper_bounds=ones(3)
init = .75*ones(3)
opt.xtol_rel = 1e-3
opt.max_objective = optanimals
sol2 = optimize(opt, init)[2]
Outcomes[6,2] = sol2[1]
Outcomes[6,3] = sol2[2]  
Outcomes[6,4] = sol2[3]

#--- Theta A up 10% ----#
function veg_outcome(Veg, SufferingEquiv=1.0, alphaM = alpha)
	m = create_AnimalWelfareOpt()
	update_param!(m, :CowEquiv, SufferingEquiv)
	update_param!(m, :PigEquiv, SufferingEquiv)
	update_param!(m, :ChickenEquiv, SufferingEquiv)
	update_param!(m, :thetaChicken, 1.5)
	update_param!(m, :alphameat, alphaM)
	update_param!(m, :MeatReduc, Veg)
	update_param!(m, :thetaC, 1.5)
	update_param!(m, :thetaB, 1.5)
	update_param!(m, :thetaP, 1.5)
	run(m)
	return m[:welfare, :UTILITY]
end

function ByAnimals_outcome(x::Array{Float64, 1}, SufferingEquiv=1.0)
	m 	= create_AnimalWelfareOpt()
	update_param!(m, :BeefReduc, x[1])
	update_param!(m, :PoultryReduc, x[2])
	update_param!(m, :PorkReduc, x[3])
	update_param!(m, :CowEquiv, SufferingEquiv)
	update_param!(m, :PigEquiv, SufferingEquiv)
	update_param!(m, :ChickenEquiv, SufferingEquiv)
	update_param!(m, :thetaC, 1.5)
	update_param!(m, :thetaB, 1.5)
	update_param!(m, :thetaP, 1.5)	
	run(m)
	return m[:welfare, :UTILITY]
end

function optveg(x, grad)
	if length(grad)>0
	grad[1] = 1000
	end
    result = veg_outcome(x[1])
	return result
end
opt = Opt(:LN_SBPLX, 1)
opt.lower_bounds=[-1.0]
opt.upper_bounds=[.9999999999]
init = [.5]
opt.xtol_rel = 1e-3
opt.max_objective = optveg
#sol = optimize(opt, init)[2]
Outcomes[7, 1] = sol[1]

function optanimals(x, grad)
	if length(grad)>0
	grad[1] = 1
	end
	result = ByAnimals_outcome(x)
	return result
end
opt = Opt(:LN_SBPLX, 3)
opt.lower_bounds=-1*ones(3)
opt.upper_bounds=ones(3)
init = .75*ones(3)
opt.xtol_rel = 1e-3
opt.max_objective = optanimals
#sol2 = optimize(opt, init)[2]
Outcomes[7,2] = sol2[1]
Outcomes[7,3] = sol2[2]  
Outcomes[7,4] = sol2[3]