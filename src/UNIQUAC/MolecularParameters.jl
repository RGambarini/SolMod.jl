function UNIQUAC_FredenslundParameters(x::Vector;
    database = pathof(SolMod)[1:end-13]*"examples/Database/UNIQUAC-UNIFAC molecular parameters.xlsx")

    # Inputs: 
    # 1. x = 
  
    # Optional:
    # 1. database = 

    m_params = []

    groups = Matrix(DataFrame(XLSX.readtable(database, "Sheet1")...))[1:end, 1]
    R = Matrix(DataFrame(XLSX.readtable(database, "Sheet1")...))[1:end, 2]
    Q = Matrix(DataFrame(XLSX.readtable(database, "Sheet1")...))[1:end, 3]

    group_parameters = Dict()

    for i in range(1, length(groups))
        group_parameters[groups[i]] = [R[i], Q[i]]
    end

    for n in range(1, length(x))

        if length(m_params) == 0
            
            m_params = [sum(group_parameters[i][1] for i in x[n]) sum(group_parameters[i][2] for i in x[n]) sum(group_parameters[i][2] for i in x[n])]
        
        else
            m_params = vcat(m_params, 
            [sum(group_parameters[i][1] for i in x[n]) sum(group_parameters[i][2] for i in x[n]) sum(group_parameters[i][2] for i in x[n])])

        end
    
    end

    m_params

end