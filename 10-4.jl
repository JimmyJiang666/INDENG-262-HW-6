using Pkg #In-built package manager of Julia
Pkg.add("JuMP")     #Add mathematical optimization package
Pkg.add("GLPK")     #Add solver

using JuMP, GLPK 


println("\n--------- Problem 10.4 ----------")

m = Model(GLPK.Optimizer)
@variable(m, x[j=1:3, i = 1:6] >= 0, Int);

c = [
    0.5 2.0 5.0 1.0 7.8 
    0.6 2.2 5.5 1.1 7.5
    0.7 2.5 6.0 1.3 7.0
];

d = [
    5 4 4 2 1 
    2 1 1 7 0
    3 4 3 0 2
];

@objective(m, Min, sum(x[:,1:5] .* c))

for i=1:4
    for j=1:3
        @constraint(m, sum(x[k,i] + x[k,6] for k=1:j) >= sum(d[k,i] for k=1:j))
    end
end

for j=1:3
    @constraint(m, sum(x[k,5] - x[k,6] for k=1:j) >= sum(d[k,5] for k=1:j))
    @constraint(m, x[j,6] <= x[j,5])
end

print(m)
optimize!(m)

println("The solution matrix X is")
for j=1:3
    for i=1:6
        print(value(x[j,i])," ")
    end
    println()
end