function Isoquants()
isotemps = [1.5 2 2.5 3]
MReduc1 = collect(0:.02:1) #change back to 0.02 for main figure
EIndReduc1 = zeros(length(MReduc1), length(isotemps))
m = create_dice_farm()
for MAXTEMP = 1:length(isotemps)
	println("Finished a temp!")
	for j = 1:length(MReduc1)
		global CO2step = .002
		global Co2Reduc = 1 + CO2step
		maxtemp = 1.
			while maxtemp<isotemps[MAXTEMP]
			Co2Reduc = Co2Reduc - CO2step
			update_param!(m, :MeatReduc, MReduc1[j])
			update_param!(m, :EIndReduc, Co2Reduc)
			run(m) 
			temp = m[:co2_cycle, :T]
			maxtemp = maximum(temp[TwentyTwenty:TwentyTwenty+100])  #temp in next 100 years
			end
	EIndReduc1[j, MAXTEMP] = Co2Reduc
	end
end

M1 = 100*(ones(length(MReduc1)) - MReduc1)
E1 = 100*(ones(size(EIndReduc1)[1], length(isotemps)) - EIndReduc1)
plot(E1, M1, label=["1.5 Deg" "2 Deg" "2.5 Deg" "3 Deg"], color=:black, linestyle=[:solid :dash :dashdot :dot], linewidth=2, ylabel="Agricultural Emissions \n (% of Baseline)", xlabel="Industrial Emissions \n (% of Baseline)", xlims=(0, 100), xticks=0:10:100, yticks=0:10:100, legend=:topright, grid=false)
savefig(joinpath(output_directory, "Figure2.pdf"))
savefig(joinpath(output_directory, "Figure2.svg"))
end