






#ikke bruk denne, den er ikke ferdigstilt










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


def bmcheck(inlist):
    prf=[]
    length=len(inlist)
    for d in range(0,length+1):                     # length+1 er nok litt overdrevent høyt, det kan optimaliseres.
        t=length-d
        if t<=4:
            print "breaked at first break statement, when d was: ", d
            break
        detlist=[]
        endlist=[]
        if d==0:              #switch raskere?
            endlist.append(inlist[-2])         #kan legges til flere 0 tall for å konkludere med grad 0
            endlist.append(inlist[-1])
            if all(h==0 for h in endlist):
                q=[1]
                ptemp=inlist*1
                if all(w==0 for w in ptemp):
                    return [[[0],[1]]]
                p=trimfinalzeroes(ptemp)
                prftemp=[]
                prftemp.append(p)       #potensiale for effektivisering
                prftemp.append(q)
                prf.append(prftemp)
        elif d>=1:
            for i in range(d, length-d):
                m=matrix(d+1)
                for j in range(0,d+1):
                    for k in range(0,d+1):
                        m[j,k]=inlist[j+k+i-d]
                detlist.append(m.det())

            if len(detlist)>=2:
                enddetlist=[]
                enddetlist.append(detlist[-2])    #kan legges til mer i enddetlist hvis ønskelig
                enddetlist.append(detlist[-1])
                if all(w==0 for w in enddetlist):
                    A=matrix(d+1,d)
                    B=matrix(d+1,1)
                    for c in range(0,d+1):
                        B[c,0]=-(inlist[-1-c])
                    for j in range(0,d+1):
                        for k in range(0,d):
                            A[j,k]=inlist[length-2-j-k]
                    X=matrixsolve(A,B)
                    if X!="ns":
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
                        xx=False

                        if prf==[]:
                            prf.append(prftemp)
                            #print "recursion degree might be", d
                        else:
                            if iselementin(prftemp,prf)==False:
                                prf.append(prftemp)
                                #print "recursion degree might be", d

            else:
                print "breaked at second break statement, when d was: ", d
                break
    return prf