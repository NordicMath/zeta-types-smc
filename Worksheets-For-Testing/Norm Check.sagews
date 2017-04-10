︠0f7e9192-4431-4861-a5f1-3514ea669d24s︠
# Functions are local, ie. f(e) would be f(p^e), for some fixed prime p, when thinking of f as a multiplicative function.

### Helper functions ###

def getUnitaryRoot(k,e):
    return cos(e*2*pi/k) + I * sin(e*2*pi/k)

#Transforming a row of Bell coefficients (previously called Dirichlet coefficients) to point counts:
def log_derivative(row_as_list):
    row_length = len(row_as_list)
    R.<x> = PowerSeriesRing(QQ)
    d = R(row_as_list, row_length)
    l = d.log()
    f = l.derivative()
    f_coefficient_list = f.padded_list()
    return f_coefficient_list


#Transforming a row of point counts to Bell coefficients:
def exp_integral(row_as_list):
    row_length = len(row_as_list)
    R.<x> = PowerSeriesRing(QQ)
    f = R(row_as_list, row_length)
    l = f.integral()
    d = l.exp()
    d_coefficient_list = d.padded_list()
    return d_coefficient_list


#Performing n-compression on a list of point counts (so we delete all elements up to the n'th one, etc)
def compression(input_list, k):
    output_length = floor(len(input_list)/k)
    output_list = []
    for i in range(output_length):
        output_list.append(input_list[k*(i+1)-1])
    return output_list


### Norm functions ###

def normActual(f, e, k):
    bell_coeffs = []
    for i in range((e + 1) * k):
        bell_coeffs.append(f(i))
    point_counts = log_derivative(bell_coeffs)
    
    point_counts_2 = compression(point_counts, k)
    
    bell_coeffs_2 = exp_integral(point_counts_2)
    return bell_coeffs_2[e]

def normGuess(f, e, k): # Doesn't work with k = 1
    sum = 0
    for i in range(k * e + 1):
        sum += f(k * e - i) * f(i) * getUnitaryRoot(k,i)
    return sum

### Testing grounds ###

### Functions ###

def eunc(e):
    if e==0:
        return 1
    else:
        return 3^e - 3^(e-1)

def func(e):
    return e + 1

def gunc(e):
    return (3^(e+1) - 1)/(3-1)

def hunc(e):
    if e==0:
        return 1
    else:
        return 4*e-3

def munc(e):
    if e==0:
        return 1
    elif e==1:
        return -1
    else:
        return 0

### Commands ###

normActual(gunc, 1, 5)

normGuess(gunc, 1, 5)
︡666ad20b-3706-46ca-b479-bceb0eb43a7c︡{"stdout":"244\n"}︡{"stdout":"-18*sqrt(5) + 226\n"}︡{"done":true}︡









