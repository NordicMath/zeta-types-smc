︠3191b0c9-e2d8-4c38-934f-870bda2f5dfa︠
︡14200665-2936-4515-8542-8cc5ef41ff9e︡
︠24396917-d634-4adc-b7fe-53f6be74aa84︠

︡05715867-b46c-42b3-821a-2b313e3914b6︡
︠2985f83f-abb5-4b34-b394-e7e238baa5a6s︠

#This program constructs a point count table over finite fields from one or several equations
#The point count is AFFINE and uses a NAIVE algorithm
#For fields which are larger than a certain size, the point count is not computed. These entries are set to -1.
#The algorithm accepts as many equations as you like, in anything between ONE and FOUR variables.

#In order to use the algorithm, you must specify 4 pieces of information, marked as TODO 1, 2, 3, 4.

import numpy

#TODO 1: Set the number of variables (i.e. the dimension of the ambient affine space)
#Currently only 1 or 2 variables are supported.
V = 2

#TODO 2: Define functions. Use * for multiplication. 
#You may keep many functions here, just specify in the next step which ones should be used.
#(The algorithm will count the common zeroes of these functions.)
def f1(x,y):
    return y^2+y-x^3+x^2

def f2(x):
    return x^2-2

def f3(x):
    return x^2-2

def f4(x):
    return x*(x+2)

def f5a(x, y, z):
    return x^2+y^2+z^2-25

def f5b(x, y, z):
    return x+y+z

def f5c(x, y, z):
    return 2*x^2+2*y^2+2*x*y

def f6(x, y):
    return y^2+y-x^3+x^2

#TODO 3: Create a list of the functions you actually want to use. 
#All these must take the right number of variables as input, corresponding to your choice of V above.
#The algorithm is faster if you list the simplest functions first.

my_list_of_functions = [f1]

#TODO 4: Set number of rows in table:
R = 4

#TODO 5: Set number of columns in table:
C = 5

#TODO 6: Set a limit on the size of the finite field. If this number is too large, the algorithm needs a lot of time.
field_size_limit = 10000

#We define a function, capable of producing an affine point count matrix from a set of polynomial functions
def affine_point_count(number_of_rows, number_of_columns, number_of_variables, function_list):
    #Setting a timer starting at 0
    total_time = 0;
    #Constructing a list L containing the required primes
    L = primes_first_n(number_of_rows)
    #Initiating a point count matrix with all entries equal to -1
    point_count_matrix = (-1)*numpy.ones((number_of_rows,number_of_columns), int)
    #Iterating over primes in L and then over exponents from 1 to C, searching for solutions by checking all possible values in the corresponding finite field
    row_index = 0
    for p in L:
        print 'Starting row with prime %s.' % p
        #print 'Counting columns:'
        for k in range(C): #The number k goes from 0 to C-1, inclusive
            e=k+1; #The number e goes from 1 to C, inclusive
            q=p^e;
            if q > field_size_limit:
                break
            R.<a> = GF(q);
            m=0
            t = cputime();
            if V == 1:
                for i, x in enumerate(R):
                    b = True
                    for f in function_list:
                        if f(x) != 0:
                            b = False;
                            break
                    if b == True:
                        m = m+1;
            elif V == 2:
                for i1,x1 in enumerate(R):
                    for i2, x2 in enumerate(R):
                        b = True
                        for f in function_list:
                            if f(x1,x2) != 0:
                                b = False;
                                break
                        if b == True:
                            m = m+1;
            elif V == 3:
                for i1,x1 in enumerate(R):
                    for i2, x2 in enumerate(R):
                        for i3, x3 in enumerate(R):
                            b = True
                            for f in function_list:
                                if f(x1,x2, x3) != 0:
                                    b = False;
                                    break
                            if b == True:
                                m = m+1;
            elif V == 4:
                for i1,x1 in enumerate(R):
                    for i2, x2 in enumerate(R):
                        for i3, x3 in enumerate(R):
                            for i4, x4 in enumerate(R):
                                b = True
                                for f in function_list:
                                    if f(x1,x2,x3,x4) != 0:
                                        b = False;
                                        break
                                if b == True:
                                    m = m+1;
            else:
                print 'To many variables! The algorithm does not work!'
                break
            point_count_matrix[row_index,k] = m;
            entry_time = cputime(t);
            total_time = total_time + entry_time;
            print 'Column %s in %s seconds.' % (e, entry_time)
        #print 'Finished row number %s' % row_index
        row_index = row_index+1
    print 'The total time used was %s seconds' % total_time
    return point_count_matrix


#Here we execute the function to actually produce the desired matrix
pcm = affine_point_count(R, C, V, my_list_of_functions)
print pcm


︡359957cb-21ca-46b3-a198-69c3b325e2ea︡{"stdout":"Starting row with prime 2.\nColumn 1 in 0.0 seconds.\nColumn 2 in 0.0 seconds."}︡{"stdout":"\nColumn 3 in 0.0 seconds.\nColumn 4 in 0.0 seconds.\nColumn 5 in 0.004 seconds.\nStarting row with prime 3.\nColumn 1 in 0.0 seconds.\nColumn 2 in 0.0 seconds.\nColumn 3 in 0.0 seconds.\nColumn 4 in 0.028 seconds.\nColumn 5 in 0.172 seconds."}︡{"stdout":"\nStarting row with prime 5.\nColumn 1 in 0.0 seconds.\nColumn 2 in 0.004 seconds.\nColumn 3 in 0.032 seconds.\nColumn 4 in 1.308 seconds."}︡{"stdout":"\nColumn 5 in 32.728 seconds."}︡{"stdout":"\nStarting row with prime 7.\nColumn 1 in 0.0 seconds.\nColumn 2 in 0.008 seconds.\nColumn 3 in 0.24 seconds."}︡{"stdout":"\nColumn 4 in 18.832 seconds."}︡{"stdout":"\nThe total time used was 53.356 seconds\n"}︡{"stdout":"[[   4    4    4   24   24]\n [   4   14   19   74  274]\n [   4   34  139  594 3024]\n [   9   59  309 2399   -1]]\n"}︡{"done":true}︡
︠8d08aadf-fda8-4321-8db7-7a6797af099bs︠
︡e699b481-7900-4ff7-9bbf-7bc3071a299b︡{"done":true}︡
︠7e728bb4-d311-4920-9bde-4c38b9429c34︠
















