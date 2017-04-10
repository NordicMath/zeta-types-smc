# WARNING! THIS IS WRONG!

def guessJacobiTransformWRONG(data):
    ndata = [0] * len(data)
    for i in range(1, len(data)):
        sum = 0
        for j in range(1, i + 1):
            sum += effectOf(i, j, -data[j])
        ndata[i] = sum
    ndata[0] = data[0]
    return ndata
    #return [data[0]].extend([sum([effectOf(i, j, -data[j]) for j in range(1, i + 1)]) for i in range(1, data.length)])

def guessReverseJacobiTransform(data):
    ndata = [1] + [0] * (len(data) - 1)
    for i in range(1, len(data)):
        totalEffect = 0
        for j in range(1, i + 1):
            totalEffect += effectOf(i, j, -ndata[j])
        ndata[i] = data[i] - totalEffect
    return ndata

R.<t> = PowerSeriesRing(QQ) # Be aware of this. Probably not a problem, but...
def jacobiTransform(data):
    length = len(data)
    product = R.one()
    for i in range(1, length):
        product *= (1 - t^(i))^(-data[i])
    coeffs = product.list()
    return product.list()[:length] + [0]*(length-len(coeffs))

def guessJacobiTransform(data):
    length = len(data)
    ndata = [1] + [0] * (length - 1)
    #for i in range(1, length):
        #sum = 0
        #for d in divisors(i):
            #sum += (-1)^d * binomial(-data[i/d], d)
        #ndata[i] = sum
    #for i in range(1, length):
        #if (data[i] != 0):
            #for k in range(1, ceil(length / float(i))):
                #print "i = " + str(i) + " has added an effect of " + str((-1)^k * binomial(-data[i], k)) + " on " + str(k*i)
                #ndata[k*i] += (-1)^k * binomial(-data[i], k)
    
    return ndata


def reverseJacobiTransformETHICALLYWRONG(data):
    length = len(data)
    current = R.one()
    ndata = [0] * length
    print "to match: " + str(data)
    for i in range(length):
        coeffs = current.coefficients()
        print "current: " + str(coeffs)
        ndata[i] = data[i] - (coeffs[i][0] if i < len(coeffs) else 0)
        current *= (1 - t^(i+1))^(-ndata[i])
    
    return ndata


def effectOf(polynomialExponent, jacobiPosition, jacobiExponent):
    if jacobiExponent == 0:
        return 0
    if jacobiPosition != 1 and (polynomialExponent % jacobiPosition != 1) :
        return 0
    effectivePolynomialExponent = floor(polynomialExponent / jacobiPosition)
    if jacobiExponent > 0:
        return (-1)^effectivePolynomialExponent * binomial(jacobiExponent, effectivePolynomialExponent)
    else:
        return binomial(-jacobiExponent + effectivePolynomialExponent - 1, effectivePolynomialExponent)
