@defcomp factoryfarm begin

    # ------ Output of Farm (Animals and Emissions) ---------- #

    Cows           = Variable(index=[time])    #Number of animal life-years per year (millions)
    Pigs           = Variable(index=[time])    #Number of animal life-years per year (millions)
    Chickens       = Variable(index=[time])    #Number of animal life-years per year (millions)

    Co2EFarm       = Variable(index=[time])    #GtCO2
    MethEFarm      = Variable(index=[time])    # kg
    N2oEFarm       = Variable(index=[time])    # kg

    MethEBeef  = Variable(index=[time])    #Methane emitted Beef (kg)
    Co2EBeef   = Variable(index=[time])    #Co2 emitted from Beef (kg)
    N2oEBeef   = Variable(index=[time])    #N2O emitted from Beef (kg)

    #MethEDairy  = Variable(index=[time])    #Methane emitted Beef (kg)
    #Co2EDairy   = Variable(index=[time])    #Co2 emitted from Beef (kg)
    #N2oEDairy   = Variable(index=[time])    #N2O emitted from Beef (kg)

    MethEPoultry  = Variable(index=[time])    #Methane emitted Beef (kg)
    Co2EPoultry   = Variable(index=[time])    #Co2 emitted from Beef (kg)
    N2oEPoultry   = Variable(index=[time])    #N2O emitted from Beef (kg)

    MethEPork  = Variable(index=[time])    #Methane emitted Beef (kg)
    Co2EPork   = Variable(index=[time])    #Co2 emitted from Beef (kg)
    N2oEPork   = Variable(index=[time])    #N2O emitted from Beef (kg)

    #MethEEggs  = Variable(index=[time])    #Methane emitted Beef (kg)
    #Co2EEggs   = Variable(index=[time])    #Co2 emitted from Beef (kg)
    #N2oEEggs   = Variable(index=[time])    #N2O emitted from Beef (kg)

    #MethESheepGoat  = Variable(index=[time])    #Methane emitted Beef (kg)
    #Co2ESheepGoat   = Variable(index=[time])    #Co2 emitted from Beef (kg)
    #N2oESheepGoat   = Variable(index=[time])    #N2O emitted from Beef (kg)

    # --------- Inputs (TFP; Number of Kg of each Animal consumed; Emissions Intensities --------- #

    ABeef          = Parameter()               #How effectively do we turn animals into meat
    APork          = Parameter()
    APoultry       = Parameter()
    Beef           = Parameter(index=[time])   #Beef Produced (kgs of protein) [Annual]
    Dairy         = Parameter(index=[time])   #Dairy Produced (kgs of protein) [Annual]
    Poultry        = Parameter(index=[time])   #Poultry Produced (kgs of protein) [Annual]
    Pork           = Parameter(index=[time])   #Pork Produced (kgs of protein) [Annual]
    Eggs          = Parameter(index=[time])   #Eggs Produced (kgs of protein) [Annual]
    SheepGoat     = Parameter(index=[time])   #Sheep & Goat Produced (kgs of protein) [Annual]
    MeatReduc      = Parameter()                #New Vegetarian Fraction from 2020 onward

    # ------ Emissions Intensities for each gas-animal -------- #

    sigmaBeefMeth   = Parameter(index=[time])   #Kg of Methane Emissions from Beef (need to convert millions of animals into Megatons CH4)
    sigmaBeefCo2    = Parameter(index=[time])   #Kg of CO2 per kg of protein from Beef (need to convert millions of animals into Gigatons)
    sigmaBeefN2o    = Parameter(index=[time])  #Kg of Nitrous Oxide per kg of protein from Beef

    sigmaDairyMeth  = Parameter(index=[time])   #Kg of Methane Emissions from Beef (need to convert millions of animals into Megatons CH4)
    sigmaDairyCo2   = Parameter(index=[time])   #Kg of CO2 per kg of protein from Beef (need to convert millions of animals into Gigatons)
    sigmaDairyN2o   = Parameter(index=[time])  #Kg of Nitrous Oxide per kg of protein from Beef
   
    sigmaPoultryMeth  = Parameter(index=[time])   #Kg of Methane Emissions from Beef (need to convert millions of animals into Megatons CH4)
    sigmaPoultryCo2   = Parameter(index=[time])   #Kg of CO2 per kg of protein from Beef (need to convert millions of animals into Gigatons)
    sigmaPoultryN2o   = Parameter(index=[time])  #Kg of Nitrous Oxide per kg of protein from Beef
   
    sigmaPorkMeth  = Parameter(index=[time])   #Kg of Methane Emissions from Beef (need to convert millions of animals into Megatons CH4)
    sigmaPorkCo2   = Parameter(index=[time])   #Kg of CO2 per kg of protein from Beef (need to convert millions of animals into Gigatons)
    sigmaPorkN2o   = Parameter(index=[time])  #Kg of Nitrous Oxide per kg of protein from Beef

    sigmaEggsMeth  = Parameter(index=[time])   #Kg of Methane Emissions from Beef (need to convert millions of animals into Megatons CH4)
    sigmaEggsCo2   = Parameter(index=[time])   #Kg of CO2 per kg of protein from Beef (need to convert millions of animals into Gigatons)
    sigmaEggsN2o   = Parameter(index=[time])  #Kg of Nitrous Oxide per kg of protein from Beef

    sigmaSheepGoatMeth  = Parameter(index=[time])   #Kg of Methane Emissions from Beef (need to convert millions of animals into Megatons CH4)
    sigmaSheepGoatCo2   = Parameter(index=[time])   #Kg of CO2 per kg of protein from Beef (need to convert millions of animals into Gigatons)
    sigmaSheepGoatN2o   = Parameter(index=[time])  #Kg of Nitrous Oxide per kg of protein from Beef

    # ----- Start component --------- #
 
    function run_timestep(p, v, d, t)
	
    if gettime(t) >= 2020 #Allows planner to solve for optimal veg frac
        Beef = (1-p.MeatReduc)*p.Beef[t]
        Pork = (1-p.MeatReduc)*p.Pork[t]
        Poultry = (1-p.MeatReduc)*p.Poultry[t]
    else
        Beef = p.Beef[t]
        Pork = p.Pork[t]
        Poultry = p.Poultry[t]
    end

    v.Cows[t]       = p.ABeef*Beef
    v.Pigs[t]       = p.APork*Pork
    v.Chickens[t]   = p.APoultry*Poultry

    v.MethEBeef[t] = p.sigmaBeefMeth[t]*Beef  # kg
    v.Co2EBeef[t]  = p.sigmaBeefCo2[t]*Beef   # kg
    v.N2oEBeef[t]  = p.sigmaBeefN2o[t]*Beef  # kg 

    #v.MethEDairy[t] = p.sigmaDairyMeth[t]*Dairy  # kg
    #v.Co2EDairy[t]  = p.sigmaDairyCo2[t]*Dairy   # kg
    #v.N2oEDairy[t]  = p.sigmaDairyN2o[t]*Dairy  # kg 

    v.MethEPoultry[t] = p.sigmaPoultryMeth[t]*Poultry  # kg
    v.Co2EPoultry[t]  = p.sigmaPoultryCo2[t]*Poultry   # kg
    v.N2oEPoultry[t]  = p.sigmaPoultryN2o[t]*Poultry  # kg 

    v.MethEPork[t] = p.sigmaPorkMeth[t]*Pork  # kg
    v.Co2EPork[t]  = p.sigmaPorkCo2[t]*Pork   # kg
    v.N2oEPork[t]  = p.sigmaPorkN2o[t]*Pork  # kg 

    #v.MethEEggs[t] = p.sigmaEggsMeth[t]*Eggs  # kg
    #v.Co2EEggs[t]  = p.sigmaEggsCo2[t]*Eggs   # kg
    #v.N2oEEggs[t]  = p.sigmaEggsN2o[t]*Eggs  # kg

    #v.MethESheepGoat[t] = p.sigmaSheepGoatMeth[t]*SheepGoat  # kg
    #v.Co2ESheepGoat[t]  = p.sigmaSheepGoatCo2[t]*SheepGoat   # kg
    #v.N2oESheepGoat[t]  = p.sigmaSheepGoatN2o[t]*SheepGoat  # kg

    v.MethEFarm[t]  = (v.MethEBeef[t] + v.MethEPoultry[t] + v.MethEPork[t])       #kg
    v.Co2EFarm[t]   = ((v.Co2EBeef[t] + v.Co2EPoultry[t] + v.Co2EPork[t])/1e12)    #GtC02
    v.N2oEFarm[t]   = (v.N2oEBeef[t] + v.N2oEPoultry[t] + v.N2oEPork[t])        #kg
    end
end