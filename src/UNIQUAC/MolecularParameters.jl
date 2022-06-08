function UNIQUAC_FredenslundParameters(x1::Vector, x2::Vector, x3::Vector; 
    database = pathof(SolMod)[1:end-13]*"examples/Database/UNIQUAC-UNIFAC molecular parameters.xlsx")

    # Inputs: 
    # 1. x1 = 
    # 2. x2 = 
    # 3. x3 = 
  
    # Optional:
    # 1. database = 

    groups = Matrix(DataFrame(XLSX.readtable(database, "Sheet1")...))[1:end, 1]
    R = Matrix(DataFrame(XLSX.readtable(database, "Sheet1")...))[1:end, 2]
    Q = Matrix(DataFrame(XLSX.readtable(database, "Sheet1")...))[1:end, 3]

    group_parameters = Dict()

    for i in range(1, length(groups))
        group_parameters[groups[i]] = [R[i], Q[i]]
    end

    m_params = [sum(group_parameters[i][1] for i in x1) sum(group_parameters[i][2] for i in x1) sum(group_parameters[i][2] for i in x1)
                sum(group_parameters[i][1] for i in x2) sum(group_parameters[i][2] for i in x2) sum(group_parameters[i][2] for i in x2)
                sum(group_parameters[i][1] for i in x3) sum(group_parameters[i][2] for i in x3) sum(group_parameters[i][2] for i in x3)]

    m_params

end