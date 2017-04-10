︠c54dc9de-8659-4b1a-96c4-907fb1853324s︠
# Global Modulus:
n = 6

# Ring we're working with
R.<x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10> = ZZ[]

# Helper functions

def adamsOpMatrix(k) :
    m = []
    for i in range(n):
        r = [0] * n
        j = (i*k) % n
        r[j] = 1
        m.append(r)
    return matrix(R,m).transpose()

def asColumnVector(u):
    RES = []
    for i in range(n):
        RES += [[u[i]]]
    return matrix(RES)

def printVector(u) :
    res = []
    for x in u:
        res.append(x[0])
    print res

# Basic arithmetic functions
def add(u, v) :
    return u + v

def Adams(u, k) :
    return adamsOpMatrix(k) * u

def multiply(u, v):
    res = [0] * n
    for i, x in enumerate(u):
        for j, y in enumerate(v):
            res[(i + j) % n] += x * y
    return res

# Oter
addVariables()

# Example objects:
u = asColumnVector([x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10])
v = asColumnVector([y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10])


w = asColumnVector([0, 0, 0, 0, 1, -1])
#z = asColumnVector([-1, 5, 12, 2])

# Testing area
printVector(w)
print ""
for k in range(1, n + 1):
    print "psi^" + str(k)
    printVector(Adams(w,k))
    print ""



︡180a175d-fe40-43a2-aa32-9e775b2ca3fa︡{"stdout":"[0, 0, 0, 0, 1, -1]\n"}︡{"stdout":"\n"}︡{"stdout":"psi^1\n[0, 0, 0, 0, 1, -1]\n\npsi^2\n[0, 0, 1, 0, -1, 0]\n\npsi^3\n[1, 0, 0, -1, 0, 0]\n\npsi^4\n[0, 0, -1, 0, 1, 0]\n\npsi^5\n[0, -1, 1, 0, 0, 0]\n\npsi^6\n[0, 0, 0, 0, 0, 0]\n\n"}︡{"done":true}︡









