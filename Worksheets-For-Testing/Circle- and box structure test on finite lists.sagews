︠330f5794-0fbf-4452-b936-9b6005b3d939︠
# Imports

import itertools
import random
import operator

# Bell derivation and anti-derivation

def bellDerivative(data):
    ndata = [1] + [0] * (len(data) - 1)
    for i in range(1, len(data)):
        sum = data[i] * i
        for j in range(1, i):
            sum -= data[j] * ndata[i - j]
        ndata[i] = sum
    return ndata

def bellAntiDerivative(data):
    ndata = [1] + [0] * (len(data) - 1)
    for i in range(1, len(data)):
        sum = 0
        for j in range(0, i):
            sum += ndata[j] * data[i - j]
        ndata[i] = sum / i
    return ndata


# Composes a list of functions right to left
comp = lambda *funcs: lambda input: reduce(lambda x, f: f(x), funcs[::-1], input)

# Lifts a function to accept input as a list of inputs rather than just an input
starlift = lambda f: lambda l: f(*l)

# Drops a function from accepting a list of inputs to just inputs
stardrop = lambda f: lambda *l: f(l)

# Like haskell's liftM1 for the list monad, returns a function of a lists that evaluates a function f pointwisely.
pointwise1 = lambda f: lambda lx: map(f , lx)

# Like haskell's liftM2 for the list monad, returns a function of two lists that evaluates a function f pointwisely.
pointwise2 = lambda f: lambda lx, ly: list(itertools.starmap(f , zip(lx, ly)))

# pointwise sum and product resp.
puresum  = lambda x,y: [1] + pointwise2(operator.add)(x[1:], y[1:])
pureprod = lambda x,y: [1] + pointwise2(operator.mul)(x[1:], y[1:])

# compression and expansion resp.
compress = lambda k: lambda lx: lx[::k]
expand = lambda k: lambda lx: map(lambda e: (lx[e / k] if e % k == 0 else 0), range(0,len(lx)*k))

# Algebraic operations:
boxsum       = puresum
boxprod      = pureprod

circlesum    = stardrop(comp(bellAntiDerivative, starlift(puresum), pointwise1(bellDerivative)))
circleprod   = stardrop(comp(bellAntiDerivative, starlift(pureprod), pointwise1(bellDerivative)))

boxcomp      = compress
boxexpd      = expand

circlecomp   = lambda k: comp(bellAntiDerivative, compress(k), bellDerivative)
circleexpd   = lambda k: comp(bellAntiDerivative, expand(k), bellDerivative)

boxscalar    = lambda k: lambda X: pureprod(X, [1] + [k]*(len(X) - 1))
circlescalar = lambda k: comp(bellAntiDerivative, boxscalar(k), bellDerivative)

# Testing
def testWithRandomSequences(lhs, rhs, inputAmt, testAmt, inputLength=10, inputRange=(-10, 10)):
    lastPercent = 0
    for testNum in range(testAmt):
        # Generates a grid of random data
        data = [[0]*inputLength]*inputAmt
        data = map(lambda x: map(lambda x: random.randint(*inputRange), x), data)

        lhss = lhs(*data)
        rhss = rhs(*data)

        for left, right, i in zip(lhss, rhss, itertools.count(0)):
            if left != right:
                print "Counterexample at LHS(" + "..." + ") = " + str(left) + " and RHS(" + "..." + ") = " + str(right) + " !"
                    #", ".join(map(str,zip(*data))) + 
                    #", ".join(map(str,zip(*data)[i])) + 
        if(100 * testNum / testAmt - lastPercent >= 10):
            lastPercent = 100 * testNum / testAmt
            print str(int(100 * testNum / testAmt)) + "% done!"
    print "100% done!"


#circleexpd(2)(circlesum([1,2,4,8,16,32,64,128,256,512], [1,2,4,8,16,32,64,128,256,512]))

#LHS = lambda X, Y, Z: boxprod(circleprod(X, boxprod(Y, Z)),X)
#RHS = lambda X, Y, Z: boxprod(circleprod(X, Y), circleprod(X, Z))
#testWithRandomSequences(LHS, RHS, 3, 10000, inputLength=20, inputRange=(-100, 100))

LHS = lambda k: lambda f: comp(bellDerivative, boxexpd(k), bellAntiDerivative)(f)
RHS = lambda k: lambda f: boxscalar(k)(boxexpd(k)(f))
test = lambda k: testWithRandomSequences(LHS(k), RHS(k), 1, 100, inputLength=100, inputRange=(-100, 100))

test(8)
︡c324049c-98cd-44e2-9a47-19750528eeb6︡{"stdout":"10% done!"}︡{"stdout":"\n20% done!"}︡{"stdout":"\n30% done!"}︡{"stdout":"\n40% done!"}︡{"stdout":"\n50% done!"}︡{"stdout":"\n60% done!"}︡{"stdout":"\n70% done!"}︡{"stdout":"\n80% done!"}︡{"stdout":"\n90% done!"}︡{"stdout":"\n100% done!"}︡{"stdout":"\n"}︡{"done":true}︡









