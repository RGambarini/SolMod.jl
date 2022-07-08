"""

    UNIQUAC_FredenslundParameters(x::Vector; 
    database = pathof(SolMod)[1:end-13]*"examples/Database/UNIQUAC-UNIFAC molecular parameters.xlsx")

Calculates the variables r and q as a measure of the molecule's size and external surface area to use in the UNIQUAC model.

Inputs: 
1. x = Vector that includes a list of strings that are the molecular components of the full molecule

Optional:
1. database = dataframe of the predetermined molecular component values from the UNIFAC/UNIQUAC

"""
function UNIQUAC_FredenslundParameters(x::Vector;
    database = pathof(SolMod)[1:end-13]*"examples/Database/UNIQUAC-UNIFAC molecular parameters.xlsx")

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