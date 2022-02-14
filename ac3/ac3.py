from tabulate import tabulate
import pandas as pd

table = pd.DataFrame(columns=['arc', 'workpool', 'domain change'])
def mod(x,y):
    try:
        return x % y
    except:
        return 1

# DomainsStart = {
#     'x' : [0,1,2,3,4,5,6],
#     'y' : [2,3,4,5,6],
#     'z' : [0,2,4,6]
#     }

# Domains = {
#     'x' : [],
#     'y' : [],
#     'z' : []
#     }

# Constraints = {
#     ('y','x') : lambda y,x : y-x >= 3,
#     ('x','y') : lambda x,y : y-x >= 3,
#     ('x','z') : lambda x,z : mod(x,z) == 0,
#     ('z','x') : lambda z,x : mod(x,z) == 0,
#     ('z','y') : lambda z,y : z == y-2,
#     ('y','z') : lambda y,z : z == y-2
# }

# DomainsStart = {
#     'x' : [0,1,2,3,4,5],
#     'y' : [0,1,2,3,4,5]
#     }

# Domains = {
#     'x' : [],
#     'y' : []
#     }

# Constraints = {
#     ('x','x') : lambda x,y : mod(x,2) == 0,
#     ('x','y') : lambda x,y : x+y == 4,
#     ('y','x') : lambda y,x : x+y == 4
#     }

DomainsStart = {
    'x' : [0,1,2],
    'y' : [0,1,2],
    'z' : [0,1,2]
    }

Domains = {
    'x' : [],
    'y' : [],
    'z' : []
    }

Constraints = {
    ('x','y') : lambda x,y : x < y,
    ('y','x') : lambda y,x : x < y,
    ('z','y') : lambda z,y : y < z,
    ('y','z') : lambda y,z : y < z
    }

# clean the Domains by constraint
for constraint in Constraints:
    a,b = constraint
    c = Constraints[constraint]
    print(a,b)
    for value1 in DomainsStart[a]:
        exists = False
        for value2 in DomainsStart[b]:
            if c(value1,value2):
                exists = True
                print((value1,value2))
            else:
                continue
        if exists and value1 not in Domains[a]:
            Domains[a].append(value1)
        else:
            continue

workpool = list(Constraints.keys())
vars = list(Domains.keys())
table.loc[0] = ['', str(workpool), '']
iteration = 1

while workpool:
    arc = workpool.pop(0)
    a,b = arc

    constraint = Constraints[arc]
    change = False
    Domaina = Domains[a].copy()
    Domainb = Domains[b].copy()
    for value1 in Domains[a]:
        exists = False
        for value2 in Domains[b]:
            if constraint(value1,value2):
                exists = True
                break
            else:
                continue
        if exists:
            continue
        else:
            Domaina.remove(value1)
            change = True
            continue
    
    if change:
        Domains[a] = Domaina
        for var in [x for x in vars if x not in [a,b]]:
            if (a,var) in Constraints.keys():
                if (var,a) not in workpool:
                    workpool.append((var,a))
                if (a,var) not in workpool:
                    workpool.append((a,var))
        table.loc[iteration] = [arc, str(workpool), f'{a} = {Domains[a]}']
    else:
        table.loc[iteration] = [arc, str(workpool), 'no change']

    iteration +=1
    change = False


print(tabulate(table, headers = 'keys', tablefmt = 'github'))