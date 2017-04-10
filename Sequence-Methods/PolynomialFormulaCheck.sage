
def matrixsolve(a,b):
    try:
        X=a.solve_right(b)
        return X
    except:
        return "ns"               #ns means no solutions

def iselementin(list1, list2):
    length1=len(list1)
    length2=len(list2)
    xx=False
    for j in range(0,len(list2)):
        if list1==list2[j]:
            xx=True
    return xx

def trimfinalzeroes(list1):
    if all(w==0 for w in list1):
        emptylist=[]
        print "obs"
        return emptylist
    while list1[-1]==0:
        del list1[-1]
    return list1

def trimfinalzeroesmatrix(matrix):
    while matrix[-1,0]==0:
        del matrix[-1,0]
    return matrix

def listadd(list1, list2):
    reslist=[]
    if len(list1)<len(list2):
        o=len(list2)-len(list1)
        for z in range(0,o):
            list1.append(0)
    if len(list1)>len(list2):
        o=len(list1)-len(list2)
        for z in range(0,o):
            list2.append(0)
    for z in range(0,len(list1)):
        u=list1[z]+list2[z]
        reslist.append(u)
    return reslist

def listsubt(list1, list2):
    reslist=[]
    if len(list1)<len(list2):
        o=len(list2)-len(list1)
        for z in range(0,o):
            list1.append(0)
    if len(list1)>len(list2):
        o=len(list1)-len(list2)
        for z in range(0,o):
            list2.append(0)
    for z in range(0,len(list1)):
        u=list1[z]-list2[z]
        reslist.append(u)
    return reslist

def listmult(list1, list2):
    l1=len(list1)
    l2=len(list2)
    l3=l1+l2-1
    reslist=[0]*l3
    for i in range(0,l1):
        for j in range(0,l2):
            reslist[i+j]=reslist[i+j]+list1[i]*list2[j]
    return reslist


def pcheck(inlist):                       #pcheck=sjekk for polynomtallfølger
    ppf=[]        #possible polynomial formulas
    cmodified1=[0]+inlist
    if len(inlist)<=2:
        return "invalid input"
    OurDegreeList=[]
    for y in range(0,len(inlist)-2):
        del cmodified1[0]
        if len(cmodified1)<=2:
            print "this was not expected"
            break
        cmodified2=cmodified1+[]
        for i in range(0,len(cmodified1)-2):
            c1=[0]+cmodified2
            c2=cmodified2+[0]
            difftemp=listsubt(c2,c1)
            del difftemp[0],difftemp[-1]
            if all(w==0 for w in difftemp):
                A=matrix(i+1,i+1)
                B=matrix(i+1,1)
                for f in range(0,i+1):
                    B[f,0]=cmodified1[f]
                for j in range(0,i+1):
                    for k in range(0,i+1):
                        value=j^k
                        A[j,k]=value
                X=matrixsolve(A,B)
                if X!="ns":
                    q=[]
                    for j in range(0,i+1):
                        q.append(X[j,0])
                    q=trimfinalzeroes(q)

                    if ppf==[]:
                        out=[y,q]
                        ppf.append(out)
                        OurDegreeList.append(i)
                    else:
                        yy=False
                        for cc in range(0,len(OurDegreeList)):
                            if len(q)==OurDegreeList[cc]:
                                yy=True
                        if yy==True:
                            out=[y,q]
                            ppf.append(out)
                            OurDegreeList.append(i)


            cmodified2=difftemp
    return ppf