%attach ../Global-Zeta-Type-Methods/myFourierCoefficient-and-printZetaType.sage

def myFourierCoefficient(n):
    #return euler_phi(n)
    E = EllipticCurve([1,2,3,4,5])
    A=E.anlist(10^4)
    return A[n]

printzetatype