︠0aa92413-f56d-4f6a-81e0-5c87789205b2︠
### Helper functions ###

###Important: For public versions of code, we use the convention that a Bell row does NOT include f(p^0)
###Therefore, the code below uses the terminology bell_row_as_list for the list [f(p), f(p^2), f(p^3), ...]


#Transforming a row of Bell coefficients (previously called Dirichlet coefficients) to point counts:
def log_derivative(row_as_list):
    row_length = len(row_as_list)
    R.<x> = PowerSeriesRing(QQ)
    d = R(row_as_list, row_length)
    l = d.log()
    f = l.derivative()
    f_coefficient_list = f.padded_list()
    return f_coefficient_list


#Takes Bell derivative of a row of Bell coefficients. Neither input nor output contains the ever-present number 1
def bell_derivative(bell_row_as_list):
    row0 = bell_row_as_list
    row1 = [1]+row0
    row2 = log_derivative(row1)
    return row2


#Transforming a row of point counts to Bell coefficients:
def exp_integral(row_as_list):
    row_length = len(row_as_list)
    R.<x> = PowerSeriesRing(QQ)
    f = R(row_as_list, row_length)
    l = f.integral()
    d = l.exp()
    d_coefficient_list = d.padded_list()
    return d_coefficient_list


#Takes Bell antiderivative of a row of Bell coefficients. Neither input nor output contains the ever-present number 1
def bell_antiderivative(bell_row_as_list):
    row0 = bell_row_as_list
    row1 = exp_integral(row0)
    del row1[0]
    row2 = row1
    return row2


#Performing k-compression on a list. Setting offset=1 means that we delete all elements up to but not including the k'th one, etc.
def compression(input_list, k):
    output_length = floor(len(input_list)/k)
    output_list = []
    for i in range(output_length):
        output_list.append(input_list[k*(i+1)-1])
    return output_list


#Performing k-expansion on a list. The output begins with (k-1) copies of 0, followed by the initial element of the input list, etc.
def expansion(input_list, k):
    output_length = len(input_list)*k
    output_list = [0] * output_length
    for i in range(len(input_list)):
        #output_list[(i - 1)*k] = input_list[(i-1)]
        output_list[(i + 1)*k - 1] = input_list[i]
    return output_list


def boxadam(bell_row_as_list, k):
    input = bell_row_as_list
    output = compression(input, k)
    return output

def hatboxadam(bell_row_as_list, k):
    input = bell_row_as_list
    output = expansion(input, k)
    return output

def circleadam(bell_row_as_list, k):
    input = bell_row_as_list
    temp1 = bell_derivative(input)        #Applying the Bell derivative
    temp2 = boxadam(temp1, k)             #Applying boxadam, i.e. k-compression on Bell coefficients
    output = bell_antiderivative(temp2)   #Applying the Bell antiderivative
    return output

def hatcircleadam(bell_row_as_list, k):
    input = bell_row_as_list
    temp1 = bell_derivative(input)        #Applying the Bell derivative
    temp2 = hatboxadam(temp1, k)          #Applying hatboxadam, i.e. k-expansion on Bell coefficients
    output = bell_antiderivative(temp2)   #Applying the Bell antiderivative
    return output

def hadamard_product(row1, row2):
    outputlength = min(len(row1), len(row2))
    output = []
    for i in range(outputlength):
        new_element = row1[i]*row2[i]
        output.append(new_element)
    return output

def hadamard_sum(row1, row2):
    outputlength = min(len(row1), len(row2))
    output = []
    for i in range(outputlength):
        new_element = row1[i] + row2[i]
        output.append(new_element)
    return output

def hadamard_difference(row1, row2):
    outputlength = min(len(row1), len(row2))
    output = []
    for i in range(outputlength):
        new_element = row1[i] - row2[i]
        output.append(new_element)
    return output

def repeated_binary_operation(op, m, inputelement):
    result = inputelement
    for i in range(m-1):
        result = op(result, inputelement)
    return result


def boxsum(row1, row2):
    return hadamard_sum(row1, row2)

def boxproduct(row1, row2):
    return hadamard_product(row1, row2)

def circlesum(row1, row2):
    row1a = bell_derivative(row1)
    row2a = bell_derivative(row2)
    row3 = hadamard_sum(row1a, row2a)
    row4 = bell_antiderivative(row3)
    return row4

def circleproduct(row1, row2):
    row1a = bell_derivative(row1)
    row2a = bell_derivative(row2)
    row3 = hadamard_product(row1a, row2a)
    row4 = bell_antiderivative(row3)
    return row4


#Various example rows
nat = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
const1 = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
testrow = [3, 5, 0, 8, 0, -2, 123, 126, 12, -1, 6, 1, 3, 4, 5, 6]
Euler3 = [2, 6, 18, 54, 162, 486]
z = 3
const = [z, z, z, z, z, z, z, z, z, z, z, z]

#bell_derivative(Euler3)
Euler3_derivative = bell_derivative(Euler3)
testrow2 = [-15, 4, 5, -7, 4, 3, 2, 1, 7, 6, 8, 12, 12, 44, 47, 48, 99, 2, 2, 3, 1, 7, 8, 2]



#START OF: Testing distributivity of Adams ops
#t1 = testrow
#t2 = testrow2
#binaryops = [boxsum, boxproduct, circlesum, circleproduct]
#adams = [boxadam, hatboxadam, circleadam, hatcircleadam]

#k = 3
#binaryop = binaryops[0]
#adam = adams[1]
#print "LHS is:"
#adam(binaryop(t1, t2), k)
#print "RHS is:"
#binaryop(adam(t1, k), adam(t2, k))
#END OF: Testing distributivity of Adams ops


#START OF: Testing Wilkerson's congruence
t1 = testrow
adams = [boxadam, hatboxadam, circleadam, hatcircleadam]
binaryops = [boxproduct, boxproduct, circleproduct, circleproduct]

p = 5
operation_number = 0
adam = adams[operation_number]
binaryop = binaryops[operation_number]


print "Value of p:"
print p
print "Adams operation applied to test row:"
lhs = adam(t1, p)
print lhs
print "p'th power applied to test row"
rhs = repeated_binary_operation(binaryop, k, t1)
print rhs
print "Hadamard difference:"
hadamard_difference(lhs, rhs)
print "Hadamard difference of point counts:"
hadamard_difference(bell_derivative(lhs), bell_derivative(rhs))


#END OF: Testing Wilkerson's congruence


#Circle Adams ops

#boxadam(const, 5)

#hatboxadam(const, 5)

#circleadam(const, 5)

#rightapp = hatcircleadam(const, 5)

#print rightapp

#totalapp = circleadam(rightapp, 5)

#print totalapp

#testmachine(testrow2, True, 3)

#bell_derivative(const)

#hadamard_sum(Euler3, testrow2)

︡5f90a68d-da0f-496e-aa86-85f4cff3aca3︡{"stdout":"Value of p:\n"}︡{"stdout":"5\n"}︡{"stdout":"Adams operation applied to test row:\n"}︡{"stdout":"[0, -1, 5]\n"}︡{"stdout":"p'th power applied to test row\n"}︡{"stdout":"[243, 3125, 0, 32768, 0, -32, 28153056843, 31757969376, 248832, -1, 7776, 1, 243, 1024, 3125, 7776]\n"}︡{"stdout":"Hadamard difference:\n"}︡{"stdout":"[-243, -3126, 5]\n"}︡{"stdout":"Hadamard difference of point counts:\n"}︡{"stdout":"[-243, 52797, -12070767]\n"}︡{"done":true}︡









