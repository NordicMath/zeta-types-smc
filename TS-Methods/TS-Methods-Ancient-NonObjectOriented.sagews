︠c97af2c1-009b-4376-963d-99fe67a6ce46︠

###INTRODUCTION###

###Define a monoid:

#Multiplies two monoid elements.
def mult(a, b):
    return a*b

#Calculates a raised to the power of n
def selfmult(a, n):
    return a^n

#Determines whether two monoid elements are equals
def elementequal(a, b):
    return a == b

#Returns the identity element
def getidentity():
    return 1

####METHODS####

#Print a Tannakian symbol in nice human-readable notation
def printelement(p):
    return str(p)


def printTS(X):
    upstairs = []
    downstairs = []
    for a,m in X:
        if m < 0:
            for i in range(-m):
                downstairs.append(a)
        if m > 0:
            for i in range(m):
                upstairs.append(a)
        if m == 0:
            print "cleanup not proper"
    if not upstairs:
        if not downstairs:
            print "Ø/Ø"
        else:
            print "Ø/{" + ', '.join([printelement(a) for a in downstairs]) + "}"
    elif not downstairs:
        print "{" + ', '.join([printelement(a) for a in upstairs]) + "}/Ø" #str(upstairs)[1:-1]
    else:
        print "{" + ', '.join([printelement(a) for a in upstairs]) + "}/{" + ', '.join([printelement(a) for a in downstairs]) + "}"


#Cleanup after operations; merges pairs with identical monoid elements and then removes elements of multiplicity 0
def cleanup(X):
    length = len(X)
    output = []
    while length>0:
        #last = length-1
        u = X.pop()
        length = length-1
        current_monoid_element = u[0]
        multiplicity = u[1]
        for i in range(length):
            if length - 1 - i < 0:
                continue
            j = length-1-i
            v = X[j]
            if elementequal(v[0],current_monoid_element):
                multiplicity = multiplicity+v[1]
                del X[j]
                length = length-1
        if multiplicity != 0:
            new_pair = [current_monoid_element, multiplicity]
            output.append(new_pair)
    return output

#Determines whether two Tannakian symbols are equal
def TSequal(X,Y):
    for a,m in X:
        s = 0
        for b,n in Y:
            if elementEqual(a,b):
                s += n
        if s != m:
            return false
    return true
    
    
###Operations###

#Computes Direct Sum of Tannakian symbols
def directsum(X, Y):
    return cleanup(X + Y)

#Computes the additive inverse of a Tannakian symbol
def additiveinverse(X):
    new_list = []
    for a,m in X:
        new_list.append([a,-m])
    return new_list

#Computes "Direct Difference" of Tannakian symbols
def difference(X,Y):
    return directsum(X,additiveinverse(Y))

#Computes Tensor Product of Tannakian symbols
def tensorproduct(X, Y):
    prod = []
    for a,m in X:
        for b,n in Y:
            prod.append([mult(a,b), m * n])
    return cleanup(prod)

#Allows you to multiply a Tannakian symbol by an integer. Also allows you to divide a Tannakian symbol by an integer. Causes weird stuff if X can't actually be divided. For use in lambda-operations. Assuming cleanup not necessary.
def multiplybyinteger(X,n):
    new_list =[]
    for a,m in X:
        new_list.append([a,m*n])
    return cleanup(new_list)

#Computes k-th Adams operation of Tannakian symbols
def adamsoperation(X, k):
    adams = []
    for a,m in X:
        adams.append([selfmult(a,k),m])
    return cleanup(adams)

#Computes the k-th lambda-operation
def lambdaoperation(X, k):
    if k == 0:
        return [[getidentity(),1]]
    if k == 1:
        return X
    output = []
    for i in range(k):
        term = multiplybyinteger(tensorproduct(lambdaoperation(X,i),adamsoperation(X,k-i)), (-1)^i)
        output = directsum(output, term)
    return cleanup(multiplybyinteger(output, 1/k * (-1)^(k+1)))

#Computes the k-th gamma operation
def gammaoperation(X, k):
    output = []
    for i in range(k):
        output = directsum(output, multiplybyinteger(lambdaoperation(X,k-i),binomial(k-1,i)))
    return cleanup(output)

#Computes the dot product
def dotproduct(X,Y):
    bX = bellseries(X)
    bY = bellseries(Y)
    bXY = [0]*len(bX)
    for i in range(len(bX)):
        bXY[i] = bX[i] * bY[i]
    XY = tannakiansymbol(bXY,20)
    return XY

####TO AND FROM BELL COEFFS###

#Creates the bell series of a motivic symbol. DOES NOT USE MULT FUNCTION
def bellseries(X):
    R.<t> = PowerSeriesRing(ZZ)
    output = 1
    for a, m in X:
        output *= (1 - a * t)^(-m)
    return output.coefficients()

#Fix this method - it sometimes fails, maybe when some characteristic polynomial has non-real roots
def tannakiansymbol(s, betti_sum_bound):
    row_length = len(s)
    #Making sure the length is even, so acceptable as berlekamp input:
    if (row_length%2) == 1:
        trash = row_as_list.pop()
        row_length = row_length - 1
    #Now computing the denominator bb of degree jj:
    bm = berlekamp_massey(s)
    bb = bm.reverse()
    #print 'Printing zeta denominator:'
    #print bb
    jj = bb.degree()
    bb_list = bb.list()
    #print bb_list
    #Now computing the numerator cc of degree nn:
    nn = betti_sum_bound - jj
    M = matrix(QQ,nn+1,nn+1)
    for i in xrange(nn+1):
        for j in xrange(i+1):
            M[i,j] = s[i-j]
    #print 'Printing matrix M:'
    #print M
    B = matrix(QQ, nn+1, 1)
    for i in xrange(jj+1):
        B[i, 0] = bb_list[i]
    #print 'Printing matrix B:'
    #print B
    C = M*B
    #print 'Printing matrix C:'
    #print C
    cc_list = []
    #flag stays True as long as we're still deleting trailing zeroes from C
    flag = True
    for i in xrange(nn+1):
        k = nn - i
        if flag == True:
            entry = C[k,0]
            if entry != 0:
                flag = False
                cc_list.insert(0, entry)
        else:
            entry = C[k,0]
            cc_list.insert(0, entry)
    zeta_output = [cc_list, bb_list]
    #print 'Printing local zeta function:'
    #print zeta_output
    #creating motivic symbol:
    #creating polynomials
    P.<t> = PolynomialRing(QQ)#CHANGE BASE RING HERE TOO! <<<<<<<<<<<<<<<<<<<<<<<<<<<<---##############################
    upstairs_p = P(bb_list)
    downstairs_p = P(cc_list)
    #finding roots of the polynomials
    uproots = upstairs_p.roots();
    downroots = downstairs_p.roots();
    #print uproots
    #print downroots
    #Creating Tannakian symbol
    tan_sym = []
    
    for r,m in uproots:
        tan_sym.append([r^(-1), m])
    
    for r,m in downroots:
        tan_sym.append([r^(-1), -m])
    
    tan_sym = cleanup(tan_sym)
    
    #print tan_sym
    
    return tan_sym

###TEST VARIABLES###
a = var('a')
b = var('b')
c = var('c')
d = var('d')

X = [[a,1],[b,1]]
Y = [[b,1],[d,-1]]

W = [[2,-1],[1,1]]
Z = [[3,1],[1,-1], [-1, -1]]


###TESTING###

I = CC


printTS(X)
printTS(Y)

printTS(directsum(X,Y))
printTS(tensorproduct(X,Y))
printTS(adamsoperation(X,4))
printTS(adamsoperation(Y,4))
printTS(lambdaoperation(X,3))
printTS(lambdaoperation(Y,3))

for i in range(1,10):
    print "lambda^"+str(i)
    printTS(lambdaoperation(Y,i))


︡f9bafc85-ed2f-47fb-af05-f87184c2d9e4︡{"stdout":"{a, b}/Ø\n"}︡{"stdout":"{1}/{d}\n"}︡{"stdout":"{1, b, a}/{d}\n"}︡{"stdout":"{b, a}/{b*d, a*d}\n"}︡{"stdout":"{b^4, a^4}/Ø\n"}︡{"stdout":"{1}/{d^4}\n"}︡{"stdout":"Ø/Ø\n"}︡{"stdout":"{d^2}/{d^3}\n"}︡{"stdout":"lambda^1\n{1}/{d}\nlambda^2\n{d^2}/{d}\nlambda^3\n{d^2}/{d^3}\nlambda^4\n{d^4}/{d^3}"}︡{"stdout":"\nlambda^5\n{d^4}/{d^5}"}︡{"stdout":"\nlambda^6\n{d^6}/{d^5}"}︡{"stdout":"\nlambda^7\n{d^6}/{d^7}"}︡{"stdout":"\nlambda^8\n{d^8}/{d^7}"}︡{"stdout":"\nlambda^9\n{d^8}/{d^9}"}︡{"stdout":"\n"}︡{"done":true}︡
︠57e71a82-a449-4f65-9a28-2a0c15d02d19︠
︡73f3a59f-bd6c-49e8-bc1e-079307f78541︡
︠e7a2c572-79b2-4ba9-81a5-cfdbea7fd3e6︠
CC.algebra?


T = TannakianSymbols(R,CC)
︡aad66ef9-3f64-4bc9-8220-16af5b41e918︡{"code":{"filename":null,"lineno":-1,"mode":"text/x-rst","source":"File: /projects/sage/sage-6.10/local/lib/python2.7/site-packages/sage/categories/sets_cat.py\nSignature : CC.algebra(self, base_ring, category=None)\nDocstring :\nReturn the algebra of \"self\" over \"base_ring\".\n\nINPUT:\n\n* \"self\" -- a parent S\n\n* \"base_ring\" -- a ring K\n\n* \"category\" -- a super category of the category of S, or \"None\"\n\nThis returns the K-free module with basis indexed by S, endowed\nwith whatever structure can be induced from that of S. Note that\nthe \"category\" keyword needs to be fed with the structure on S to\nbe used, not the structure that one wants to obtain on the result;\nsee the examples below.\n\nEXAMPLES:\n\nIf S is a monoid, the result is the monoid algebra KS:\n\n   sage: S = Monoids().example(); S\n   An example of a monoid: the free monoid generated by ('a', 'b', 'c', 'd')\n   sage: A = S.algebra(QQ); A\n   Free module generated by An example of a monoid: the free monoid generated by ('a', 'b', 'c', 'd') over Rational Field\n   sage: A.category()\n   Category of monoid algebras over Rational Field\n\nIf S is a group, the result is the group algebra KS:\n\n   sage: S = Groups().example(); S\n   General Linear Group of degree 4 over Rational Field\n   sage: A = S.algebra(QQ); A\n   Group algebra of General Linear Group of degree 4 over Rational Field over Rational Field\n   sage: A.category()\n   Category of group algebras over Rational Field\n\nwhich is actually a Hopf algebra:\n\n   sage: A in HopfAlgebras(QQ)\n   True\n\nBy Maschke's theorem, for a finite group whose cardinality does not\ndivide the characteristic of the base field, the algebra is\nsemisimple:\n\n   sage: SymmetricGroup(5).algebra(QQ) in Algebras(QQ).Semisimple()\n   True\n   sage: CyclicPermutationGroup(10).algebra(FiniteField(5)) in Algebras.Semisimple\n   False\n   sage: CyclicPermutationGroup(10).algebra(FiniteField(7)) in Algebras.Semisimple\n   True\n\nOne may specify for which category one takes the algebra:\n\n   sage: A = S.algebra(QQ, category=Sets()); A\n   Free module generated by General Linear Group of degree 4 over Rational Field over Rational Field\n   sage: A.category()\n   Category of set algebras over Rational Field\n\nOne may construct as well algebras of additive magmas, semigroups,\nmonoids, or groups:\n\n   sage: S = CommutativeAdditiveMonoids().example(); S\n   An example of a commutative monoid: the free commutative monoid generated by ('a', 'b', 'c', 'd')\n   sage: U = S.algebra(QQ); U\n   Free module generated by An example of a commutative monoid: the free commutative monoid generated by ('a', 'b', 'c', 'd') over Rational Field\n\nDespite saying \"free module\", this is really an algebra and its\nelements can be multiplied:\n\n   sage: U in Algebras(QQ)\n   True\n   sage: (a,b,c,d) = S.additive_semigroup_generators()\n   sage: U(a) * U(b)\n   B[a + b]\n\nConstructing the algebra of a set endowed with both an additive and\na multiplicative structure is ambiguous:\n\n   sage: Z3 = IntegerModRing(3)\n   sage: A = Z3.algebra(QQ)\n   Traceback (most recent call last):\n   ...\n   TypeError:  `S = Ring of integers modulo 3` is both an additive and a multiplicative semigroup.\n   Constructing its algebra is ambiguous.\n   Please use, e.g., S.algebra(QQ, category=Semigroups())\n\nThe ambiguity can be resolved using the \"category\" argument:\n\n   sage: A = Z3.algebra(QQ, category=Monoids()); A\n   Free module generated by Ring of integers modulo 3 over Rational Field\n   sage: A.category()\n   Category of finite dimensional monoid algebras over Rational Field\n\n   sage: A = Z3.algebra(QQ, category=CommutativeAdditiveGroups()); A\n   Free module generated by Ring of integers modulo 3 over Rational Field\n   sage: A.category()\n   Category of finite dimensional commutative additive group algebras over Rational Field\n\nSimilarly, on , we obtain for additive magmas, monoids, groups.\n\nWarning: As we have seen, in most practical use cases, the result\n  is actually an algebra, hence the name of this method. In the\n  other cases this name is misleading:\n\n     sage: A = Sets().example().algebra(QQ); A\n     Free module generated by Set of prime numbers (basic implementation) over Rational Field\n     sage: A.category()\n     Category of set algebras over Rational Field\n     sage: A in Algebras(QQ)\n     False\n\n  Suggestions for a uniform, meaningful, and non misleading name\n  are welcome!"}}︡{"done":true}︡
︠84d20644-4855-489b-970b-906a8916a19a︠









