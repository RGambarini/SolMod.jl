function NRTL_table(model::Dict{Any, Any}, solvent::String; 
    start::Int64 = 1, finish::Int64 = length(model[solvent][2]))
  
    x1 = start
    x2 = finish
  
    df = DataFrame(Partial_Molar_Composition = model[solvent][1], 
    Calculated_Temperature = model[solvent][2])
    
    df[x1:x2, 1:2]
  
end