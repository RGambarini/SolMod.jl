"""

  importExperimentalSolubility(filepath::String)

Using the package XLSX we import the first 2 columns of every
sheet in the xlsx file. Every sheet name will be the key of our
dictionary and the values will be the 2 columns in the sheet

Inputs: 
1. filepath = String that includes the filepath of the xlsx 
file that we are intending to import

"""
function importExperimentalSolubility(filepath::String)

  Exp = Dict()

  xf = XLSX.readxlsx(filepath)
  solvents = XLSX.sheetnames(xf)[2:end]

  for l in range(1, length(solvents))

    Ti = Matrix(DataFrame(XLSX.readtable(filepath, solvents[l])...))[:,1]
    xi = Matrix(DataFrame(XLSX.readtable(filepath, solvents[l])...))[:,2]

    Exp[solvents[l]] = hcat(Ti, xi)

  end

  return Exp

  println("Try again")
  
end