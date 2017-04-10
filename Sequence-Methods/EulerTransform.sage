def finnfaktorer(a):
    outputlist=[]
    for i in range(1,a+1):
        if a%i==0:
            outputlist.append(i)
    return outputlist
def finnprimfaktorer(a):
    output=[]
    b=finnfaktorer(a)
    for w in b:
        if is_prime(w)==True:
            output.append(w)
    return output


def MobiusFunction(a):
    b=finnprimfaktorer(a)
    output=1
    c=len(b)
    for w in b:
        if a/(w^2)==floor(a/w^2):
            output=0
    output=(-output)^(c)
    return output

def EulerInversePartOne(inlist):
    output=[0]
    inlist=[0]+inlist
    for i in range(1,len(inlist)):
        output.append(0)
    #if len(inlist)<4:
        #print "input might be too short, Euler_inv may not work properly""
    temp=0
    for i in range(1,len(inlist)):
        temp=0
        for k in range(1,i):
            temp=temp+output[k]*inlist[i-k]
        output[i]=i*inlist[i]-temp
    del output[0]
    del inlist[0]
    return output

def EulerInversePartTwo(inlist):
    OUTPUT=[]
    for n in range(1,len(inlist)+1):
        allfactors=finnfaktorer(n)
        summen=0
        for j in range(0,len(allfactors)):
            f=MobiusFunction(n/(allfactors[j]))
            g=inlist[allfactors[j]-1]
            summen=summen+(f*g)
        OUTPUT.append(summen/n)
    return OUTPUT

# Just an alias
reverseJacobiTransform = lambda x: [1] + EulerInversePartTwo(EulerInversePartOne(x[1:]))





