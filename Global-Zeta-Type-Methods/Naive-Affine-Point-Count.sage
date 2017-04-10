









#Kopiert fra en sagews fil i samme mappe for å kunne importere/attache på ønsket måte

#alle print-statement er commented (og defineringen av pcm nederst), samt definisjoner av f1, f2..., samt alt som inngår i TODOene.

#Når man skal attache må man huske å definere field_size_limit

#Har byttet ut C med number_of_columns, og byttet ut V med number_of_variables inne i definisjonen av affine_point_count












#This program constructs a point count table over finite fields from one or several equations
#The point count is AFFINE and uses a NAIVE algorithm
#For fields which are larger than a certain size, the point count is not computed. These entries are set to -1.
#The algorithm accepts as many equations as you like, in anything between ONE and FOUR variables.

#In order to use the algorithm, you must specify 4 pieces of information, marked as TODO 1, 2, 3, 4.

import numpy

#TODO 1: Set the number of variables (i.e. the dimension of the ambient affine space)
#Currently only 1 or 2 variables are supported.
#V = 1

#TODO 2: Define functions. Use * for multiplication. 
#You may keep many functions here, just specify in the next step which ones should be used.
#(The algorithm will count the common zeroes of these functions.)
#def f1(x,y):
#    return y^2-x^3+27*x-46
#
#def f2(x,y):
#    return x^2+y^2-1
#
#def f3(x):
#    return x^3 - x + 1
#
#def f4(x):
#    return x*(x+2)
#
#def f5a(x, y, z):
#    return x^2+y^2+z^2-25
#
#def f5b(x, y, z):
#    return x+y+z
#
#def f5c(x, y, z):
#    return 2*x^2+2*y^2+2*x*y
#
#def f6(x, y):
#    return y^2+y-x^3+x^2

#TODO 3: Create a list of the functions you actually want to use. 
#All these must take the right number of variables as input, corresponding to your choice of V above.
#The algorithm is faster if you list the simplest functions first.

#my_list_of_functions = [f3]

#TODO 4: Set number of rows in table:
#R = 30

#TODO 5: Set number of columns in table:
#C = 5

#TODO 6: Set a limit on the size of the finite field. If this number is too large, the algorithm needs a lot of time.
#field_size_limit = 10000

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
        #print 'Starting row with prime %s.' % p
        #print 'Counting columns:'
        for k in range(number_of_columns): #The number k goes from 0 to C-1, inclusive
            e=k+1; #The number e goes from 1 to C, inclusive
            q=p^e;
            if q > field_size_limit:
                break
            R.<a> = GF(q);
            m=0
            t = cputime();
            if number_of_variables == 1:
                for i, x in enumerate(R):
                    b = True
                    for f in function_list:
                        if f(x) != 0:
                            b = False;
                            break
                    if b == True:
                        m = m+1;
            elif number_of_variables == 2:
                for i1,x1 in enumerate(R):
                    for i2, x2 in enumerate(R):
                        b = True
                        for f in function_list:
                            if f(x1,x2) != 0:
                                b = False;
                                break
                        if b == True:
                            m = m+1;
            elif number_of_variables == 3:
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
            elif number_of_variables == 4:
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
                #print 'To many variables! The algorithm does not work!'
                break
            point_count_matrix[row_index,k] = m;
            entry_time = cputime(t);
            total_time = total_time + entry_time;
            #print 'Column %s in %s seconds.' % (e, entry_time)
        #print 'Finished row number %s' % row_index
        row_index = row_index+1
    #print 'The total time used was %s seconds' % total_time
    return point_count_matrix


#Here we execute the function to actually produce the desired matrix
#pcm = affine_point_count(R, C, V, my_list_of_functions)
#print pcm


