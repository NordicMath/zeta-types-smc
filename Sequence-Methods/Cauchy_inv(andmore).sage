#make sure to input a non-zero 0-degree-coeff (actually, it has to be 1, this is checked by an if-statement. Code for other 0-degreecoeffs is not implemented)















#Caution: Cauchy inverse function will never return an inverse with shorter length than the original list!


















def matrixsolve(a,b):
    try:
        X=a.solve_right(b)
        return X
    except:
        return "ns"

def listmult(list1, list2):
    l1=len(list1)
    l2=len(list2)
    l3=l1+l2-1
    reslist=[0]*l3
    for i in range(0,l1):
        for j in range(0,l2):
            reslist[i+j]=reslist[i+j]+list1[i]*list2[j]
    return reslist

def Cauchy_inv_approximation(inputlist):
    if(inputlist[0]!=1):
        Firstelementhastobe1forthiscauchyinverseapproxtoworksorry
    outputlist=[]
    outputlist.append(inputlist[0])
    A=matrix(len(inputlist)-1,len(inputlist)-1)
    C=matrix(len(inputlist)-1,1)
    for j in range(0,len(inputlist)-1):
        for i in range(0,len(inputlist)-1):
            if j-i<0:
                A[j,i]=0
            else:
                A[j,i]=inputlist[j-i]
    for j in range(0,len(inputlist)-1):
        C[j,0]=-inputlist[j+1]
    B=matrixsolve(A,C)
    for j in range(0,len(inputlist)-1):
        outputlist.append(B[j,0])
    return outputlist

def Cauchy_inv(inlist,n):
    if(inlist[0]!=1):
        Firstelementhastobe1forthiscauchyinversetoworksorry
    m=[]
    for i in range(n-len(inlist)):
        m.append(0)
    return Cauchy_inv_approximation(inlist+m)


def expand_rational_expression(numerator,denominator,numberofelements):
    n=[]
    for j in range(0,numberofelements-len(denominator)):
        n=n+[0]
    m=Cauchy_inv_approximation(denominator+n)
    result=listmult(numerator,m)
    output=[]
    for j in range(numberofelements):
        output.append(result[j])
    return output