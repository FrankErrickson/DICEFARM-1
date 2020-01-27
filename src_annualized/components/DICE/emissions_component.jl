@defcomp emissions begin
	SIG0	= Variable()				#Carbon intensity 2010-2015 (kgCO2 per output 2010 USD)
	GSIG	= Variable(index=[time])	#Change in sigma (cumulative improvement of energy efficiency)
	SIGMA	= Variable(index=[time])	#CO2-equivalent-emissions output ratio
    EIND    = Variable(index=[time])    #Industrial emissions (GtCO2 per year)
    E       = Variable(index=[time])    #Total CO2 emissions (GtCO2 per year)
	CUMETREE= Variable(index=[time])	#Cumulative from land
    CCA     = Variable(index=[time])    #Cumulative industrial emissions
	CCATOT	= Variable(index=[time])	#Cumulative total carbon emissions
	N2oE  	= Variable(index=[time])	#N2O emissions by time
	MethE 	= Variable(index=[time]) 	#Methane emissions by time

	# TEMPORARY VARIABLES (Possibly remove in the future, just putting here to get model working).
	total_CO₂emiss_GtC   = Variable(index=[time]) # FAIR requires CO2 emissions in units GtC.
	landuse_CO₂emiss_GtC = Variable(index=[time]) # FAIR requires land-use CO2 emissions in units GtC.
    ETREE	= Parameter(index=[time])	#Exogenous Emissions from landuse/deforestation

	EIndReduc 	= Parameter()				#Allows you to toggle off emissions
	Co2EFarm	= Parameter(index=[time])   #Animal Ag Co2 Emissions (GtCO2)
	gsigma1 	= Parameter()				#Initial growth of sigma (per year)
	dsig		= Parameter()				#Decline rate of decarbonization (per period)
	e0			= Parameter()				#Industrial emissions 2015 (GtCO2 per year)
    MIU     	= Parameter(index=[time])   #Emission control rate GHGs
    YGROSS  	= Parameter(index=[time])   #Gross world product GROSS of abatement and damages (trillions 2010 USD per year)
    cca0    	= Parameter()               #Initial cumulative industrial emissions
	cumetree0	=Parameter()				#Initial emissions from deforestation (see GAMS code)
	MethERCP	= Parameter(index=[time])	#RCP methane emissions (baseline animal emissions removed in code)
	MethEFarm	= Parameter(index=[time])	#Methane missions from farmed animals
	N2oERCP		= Parameter(index=[time])	#RCP N2O emissions (baseline animal emissions removed in code)
	N2oEFarm 	= Parameter(index=[time])	#N2O missions from farmed animals
	DoubleCountCo2 = Parameter(index=[time]) #eliminate CO2 emissions from animal products here
	CO2Marg  	= Parameter(index=[time])  #Marginal CO2

    function run_timestep(p, v, d, t)
		#Define SIG0 
		# NOTE: need to index based off of "t", or else arrays in Mimi are mismatched.
		if is_first(t)
			v.SIG0 = p.e0/(p.YGROSS[t] * (1 - p.MIU[t]))
		end

		#Define function for GSIG
		if is_first(t)
			# NOTE THIS THROWS AN ERROR BECAUSE LOGGING A NEGATIVE
			v.GSIG[t] = p.gsigma1
		else
			v.GSIG[t] = v.GSIG[t-1] * (1 + p.dsig)
		end
		
		#Define function for SIGMA
		if is_first(t)
			v.SIGMA[t] = v.SIG0
		else
			v.SIGMA[t] = v.SIGMA[t-1] * exp(v.GSIG[t-1])
		end
		
        #Define function for EIND
        if gettime(t) < 2020 #reductions only possible starting in 2020
			v.EIND[t] = v.SIGMA[t] * p.YGROSS[t] * (1 - p.MIU[t])
		else
			v.EIND[t] = v.SIGMA[t] * p.YGROSS[t] * (1 - p.MIU[t]) * (1-p.EIndReduc)
		end

        #Define function for E
        v.E[t] = v.EIND[t] + p.ETREE[t] + p.Co2EFarm[t] - p.DoubleCountCo2[t] + p.CO2Marg[t]
		#TODO : Remove temporary variable to convert emissions to GtC using CO₂ molecular weight (just including here as a check).
		v.total_CO₂emiss_GtC[t] = v.E[t] * (12.01/44.01)
		# Also convert land use emissions (FAIR needs to calculate forcings from land-use albedo changes).
		# Note: Need to subtract FARM emissions from ETREE to avoid double counting (done in model set up stage).
		v.landuse_CO₂emiss_GtC[t] = (p.ETREE[t] + p.Co2EFarm[t]) * (12.01/44.01)

		#Define function for CUMETREE
		if is_first(t)
			v.CUMETREE[t] = p.cumetree0
		else
			v.CUMETREE[t] = v.CUMETREE[t-1] + (p.ETREE[t] + p.Co2EFarm[t])
		end

        #Define function for CCA
        if is_first(t)
            v.CCA[t] = p.cca0
        else
            v.CCA[t] = (v.CCA[t-1] + v.EIND[t-1]) /3.666
        end

		#Define function for CCATOT
		v.CCATOT[t] = v.CCA[t] + v.CUMETREE[t]

		#Methane and N2o for FAIR module (scale agriculture CH₄ and N₂O emissions from kg to Mt with factor 1e9).
		v.MethE[t] = p.MethEFarm[t] / 1e9 + p.MethERCP[t]
		# Currently assuming FARM emissions in kg N2O. FAIR and RCP have Mt N₂/yr. kg -> Mt = 1e9. N₂O -> N₂ = (28.01/44.01)
		v.N2oE[t] 	= p.N2oEFarm[t] / 1e9 * (28.01/44.01) + p.N2oERCP[t]

    end
end
