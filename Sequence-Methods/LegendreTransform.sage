def binomial(n,k):
    output=1
    output*=factorial(n)
    output/=factorial(n-k)
    output/=factorial(k)
    return output

def LegendreTransform(inlist):
    output=[]
    for i in range(0,len(inlist)):
        summen=0
        for k in range(0,i+1):
            temp=1
            temp*=binomial(i,k)
            temp*=binomial(i+k,k)
            temp*=inlist[k]
            summen+=temp
        output.append(summen)
    return output

def InverseLegendreTransform(inlist):
    output=[]
    for i in range(0,len(inlist)):
        summen=0
        for k in range(0,i+1):
            temp=1
            temp*=(-1)^(i-k)
            temp*=(2*k+1)/(i+k+1)
            temp*=binomial(2*i,i-k)
            temp*=inlist[k]
            summen+=temp
        summen=summen/(binomial(2*i,i))
        output.append(summen)
    return output