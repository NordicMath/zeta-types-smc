def matrixsolve(a,b):
    try:
        X=a.solve_right(b)
        return X
    except:
        return None

def trimfinalzeroes(list1):
    while list1[-1]==0:
        del list1[-1]
    return list1

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
            reslist[i+j] += list1[i]*list2[j]
    return reslist


def bmcheck(inlist):
    prf=[]
    length=len(inlist)
    ring = parent(inlist[-1])
    for d in range(0, length-4): # Is this the optimal/correct range?

        if d==0:
            if all(w==0 for w in inlist):
                return [[[0],[1]]]
            ptemp=inlist[:]
            p=trimfinalzeroes(ptemp)
            prf.append([p, [1]])
        elif d>=1:
            detlist=[]
            for i in range(d, length-d):
                m=matrix(ring,d+1)
                for j in range(0,d+1):
                    for k in range(0,d+1):
                        m[j,k]=inlist[j+k+i-d]
                detlist.append(m.det())

            if all(w==0 for w in detlist):
                A=matrix(ring,d+1,d)
                B=matrix(ring,d+1,1)

                for c in range(0,d+1):
                    B[c,0]=-(inlist[-1-c])

                for j in range(0,d+1):
                    for k in range(0,d):
                        A[j,k]=inlist[length-2-j-k]

                X=matrixsolve(A,B)

                if X == None:
                    continue

                q=[1]
                for j in range(0,d):
                    q.append(X[j,0])
                ptemp=listmult(q, inlist)
                for z in range (0,d):
                    ptemp[-1-z]=0
                p=trimfinalzeroes(ptemp)
                trimfinalzeroes(q)
                prftemp=[]
                prftemp.append(p)
                prftemp.append(q)

                if not prftemp in prf:
                    prf.append(prftemp)

    return prf

