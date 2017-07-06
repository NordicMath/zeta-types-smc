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
    if a<=0:
        print "Invalid input to mobius function"
        return "Invalid input to mobius function"
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




####Addtional functions added April 30., 2017:
def DirichletConvolutionWithh(inlist, hlist): #inlist[d]=b_(d+1), hlist[d]=h(d) og b_1, b_2, b_3... er inputtallfølgen
    if(type(hlist)==Expression):##to make it possible to input a function of x, for instance x^2, make sure to do x=var('x') first if you input an expression and not a list of values of h.
        h(x)=hlist+0
        hlist=[0]
        for i in range(1,len(inlist)+1):
            hlist.append(h(i))
    Output=[]
    for n in range(1,len(inlist)+1):
        alld=finnfaktorer(n)
        summen=0
        for j in range(0,len(alld)):
            f=hlist[n/(alld[j])]
            g=inlist[alld[j]-1]
            summen=summen+(f*g)
        Output.append(summen)
    return Output

def Doth(inlist, hlist):    #hlist[d]=h(d) og [b_1, b_2, b_3...] er inputtallfølgen, altså har vi inlist[d]=b_(d+1)
    if(type(hlist)==Expression):##to make it possible to input a function of x, for instance x^2, make sure to do x=var('x') first if you input an expression and not a list of values of h.
        h(x)=hlist+0
        newhlist=[0]
        for i in range(1,len(inlist)+1):
            newhlist.append(h(i))
    else:
        newhlist=hlist[:]
    inlist1=[0]+inlist   #adding a zero so that b_1=inlist[1]
    output=[0]
    for n in range(1,len(inlist1)):
        output.append(inlist1[n]*newhlist[n])
    return output[1:]


def EulerInverse2(inlist):    #inlist[d]=b_(d+1) og b_1, b_2, b_3... er inputtallfølgen. This is the same as EulerInversePartTwo(EulerInversePartOne(inlist)). Det er også slik transformen er definert på http://mathworld.wolfram.com/EulerTransform.html
    MobiusValues=[0]   #0 is just there as a placeholder, not used.
    onedivdlist=[0]    #0 is just there as a placeholder, not used.
    for i in range(1, len(inlist)+1):
        MobiusValues.append(MobiusFunction(i))
        onedivdlist.append(1/i)
    DirichletConvParam=MobiusValues
    Dothparam=onedivdlist
    return Doth(DirichletConvolutionWithh(EulerInversePartOne(inlist), DirichletConvParam),Dothparam)


def WittConvolutionWithFunctionh(b, listofvaluesfromh): #Let b=[b_1,b_2,b_3....], listofvaluesfromh[d]=h(d) where d is a natural number>=1
    if(type(listofvaluesfromh)==Expression):##to make it possible to input a function of x, for instance x^2, make sure to do x=var('x') first if you input an expression and not a list of values of h.
        h(x)=listofvaluesfromh+0
        listofvaluesfromh=[0]
        for i in range(1,len(b)+1):
            listofvaluesfromh.append(h(i))
    d=[0]+b
    Output=[]
    for i in range(1,len(d)):#iterating over all the output-elements
        OutputElement=0
        faktorer=finnfaktorer(i)
        for j in range(0,len(faktorer)):
            dennefaktoren=faktorer[j]
            OutputElement+=(d[dennefaktoren]*listofvaluesfromh[dennefaktoren])
        Output.append(OutputElement)
    return Output

def BellAntiDerivative(inlist): #Let inlist=[b_1,b_2,b_3....] , duplicate of inverseshiftedlogderivative found in BellDerivative.sage
    print "use InverseShiftedLogDerivative instead."
    inlist=[0]+inlist
    Output=[0, inlist[1]]
    for n in range(2,len(inlist)):
        Output.append(1/n)
        storfaktor=inlist[n]
        for z in range(1, n):
            storfaktor+=(inlist[z]*Output[n-z])
        Output[n]=Output[n]*storfaktor
    del Output[0]
    del inlist[0]
    return Output

def BellDerivative(inlist): #Let inlist=[b_1,b_2,b_3....], duplicate of shiftedlogderivative found in BellDerivative.sage
    print "use ShiftedLogDerivative instead."
    inlist=[0]+inlist
    Output=[0]
    for n in range(1,len(inlist)):
        ledd=n*inlist[n]
        for i in range(1, n):
            ledd-=(inlist[i]*Output[n-i])
        Output.append(ledd)
    return Output[1:]

def EulerTransform2(inlist): #Let inlist=[a_1,a_2,a_3....] - Det er også slik transformen er definert på http://mathworld.wolfram.com/EulerTransform.html
    x=var('x')
    return InverseShiftedLogDerivative(WittConvolutionWithFunctionh(inlist,x))







