def binomial(n,k):
    output=1
    output*=factorial(n)
    output/=factorial(n-k)
    output/=factorial(k)
    return output

def binomialtransform(inlist):
    output=[]
    for i in range(0,len(inlist)):
        summen=0
        for k in range(0,i+1):
            temp=1
            temp*=(-1)^(i-k)
            temp*=binomial(i,k)
            temp*=inlist[k]
            summen+=temp
        output.append(summen)
    return output

def inversebinomialtransform(inlist):
    output=[]
    for i in range(0,len(inlist)):
        summen=0
        for k in range(0,i+1):
            summen+=(binomial(i,k))*inlist[k]
        output.append(summen)
    return output