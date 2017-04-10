def myFourierCoefficient(n):
    #return euler_phi(n)
    E = EllipticCurve([1,2,3,4,5])
    A=E.anlist(10^4)
    return A[n]

#myfunction(10)
def printzetatype(f,r,c):
    for i in range(r):
        p=Primes().unrank(i)
        print p
        L=[]
        for j in range(c):
            L.append(f(p^(j+1)))
        print L
        
