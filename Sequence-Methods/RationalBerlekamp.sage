def bmcheck(data):
    length = len(data)
    
    results = []
    
    # looping through all the possible recurrence degrees. You need 2 * degree + 1 n length at least
    for degree in range(1, (length - 1) / 2 - 1):
        if checkDegree(degree, data):
            M = createDataMatrix(data, degree)
            
            print M
            print matrix(degree * [[0]])
            
            X = M.solve_right(matrix(degree * [[0]]))
            
            print X
            
            results.append(X)
    return X

def checkDegree(degree, data):
    # looping through all possible matricies.
    for i in range((degree - 1) / 2):
        M = createDataMatrix(data, degree)
        
        if M.det() != 0:
            return False
    
    return True

def createDataMatrix(data, degree):
    # matrix array
    array = [0] * len(data)

    for i in range(len(data) - degree + 1):
        array[i] = data[i: i + degree] # creating the data in the matrix

    # making the actual matrix
    return matrix(array)