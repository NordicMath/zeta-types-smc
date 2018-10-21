
# This file was *autogenerated* from the file src/util/berlekamp.sage
from sage.all_cmdline import *   # import sage library

_sage_const_2 = Integer(2); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0); _sage_const_5 = Integer(5); _sage_const_4 = Integer(4)#inputlist=[3,4,2,6,18,54,162,486,1458]


def bmcheckalternative(inlist, notused):  #prints lists for use in gp
    print inlist
    return []
    #gp.RgXQ_ratlift(Polrev(Vec(inlist)),x^len(inlist),len(inlist)-10,len(inlist)-10,gp.&num,gp.&denom)
    #myResult=gp.bestapprPade(gp.Ser(inlist))
    #return [map(Integer, gp.Vec(num)), map(Integer, gp.Vec(denom))]

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
    for j in range(_sage_const_0 ,len(list2)):
        if list1==list2[j]:
            xx=True
    return xx

def trimfinalzeroes(list1):
    if all(w==_sage_const_0  for w in list1):
        emptylist=[]
        print "obs"
        return emptylist
    while list1[-_sage_const_1 ]==_sage_const_0 :
        del list1[-_sage_const_1 ]
    return list1

def listadd(list1, list2):
    reslist=[]
    if len(list1)<len(list2):
        o=len(list2)-len(list1)
        for z in range(_sage_const_0 ,o):
            list1.append(_sage_const_0 )
    if len(list1)>len(list2):
        o=len(list1)-len(list2)
        for z in range(_sage_const_0 ,o):
            list2.append(_sage_const_0 )
    for z in range(_sage_const_0 ,len(list1)):
        u=list1[z]+list2[z]
        reslist.append(u)
    return reslist

def listsubt(list1, list2):
    reslist=[]
    if len(list1)<len(list2):
        o=len(list2)-len(list1)
        for z in range(_sage_const_0 ,o):
            list1.append(_sage_const_0 )
    if len(list1)>len(list2):
        o=len(list1)-len(list2)
        for z in range(_sage_const_0 ,o):
            list2.append(_sage_const_0 )
    for z in range(_sage_const_0 ,len(list1)):
        u=list1[z]-list2[z]
        reslist.append(u)
    return reslist

def listmult(list1, list2):
    l1=len(list1)
    l2=len(list2)
    l3=l1+l2-_sage_const_1 
    reslist=[_sage_const_0 ]*l3
    for i in range(_sage_const_0 ,l1):
        for j in range(_sage_const_0 ,l2):
            reslist[i+j]=reslist[i+j]+list1[i]*list2[j]
    return reslist


def bmcheck(inlist):
    prf=[]
    trimmedlist=inlist
    length=len(trimmedlist)
    for d in range(_sage_const_0 ,length+_sage_const_1 ):                     # length+1 er nok litt overdrevent høyt, det kan optimaliseres.
        t=length-d
        if t<=_sage_const_4 :
            break
        detlist=[]
        endlist=[]
        if d==_sage_const_0 :
            endlist.append(inlist[-_sage_const_2 ])     #gjenta denne prosessen hvis ønskelig med flere 0tall for å konkludere med rekursjonsgrad 0
            endlist.append(inlist[-_sage_const_1 ])
            if all(h==_sage_const_0  for h in endlist):
                q=[_sage_const_1 ]
                ptemp=inlist*_sage_const_1 
                if all(w==_sage_const_0  for w in ptemp):
                    return [[[_sage_const_0 ],[_sage_const_1 ]]]
                p=trimfinalzeroes(ptemp)
                #print "recursion degree might be 0"
                prftemp=[]
                prftemp.append(p)
                prftemp.append(q)
                prf.append(prftemp)
        elif d>=_sage_const_1 :
            for i in range(d, length-d):
                m=matrix(d+_sage_const_1 )
                for j in range(_sage_const_0 ,d+_sage_const_1 ):
                    for k in range(_sage_const_0 ,d+_sage_const_1 ):
                        m[j,k]=trimmedlist[j+k+i-d]
                detlist.append(m.det())

            if len(detlist)>=_sage_const_2 :
                enddetlist=[]
                enddetlist.append(detlist[-_sage_const_2 ])    #kan legges til mer i enddetlist hvis ønskelig
                enddetlist.append(detlist[-_sage_const_1 ])
                if all(w==_sage_const_0  for w in enddetlist):
                    A=matrix(d+_sage_const_1 ,d)
                    B=matrix(d+_sage_const_1 ,_sage_const_1 )
                    for c in range(_sage_const_0 ,d+_sage_const_1 ):
                        B[c,_sage_const_0 ]=-(trimmedlist[-_sage_const_1 -c])
                    for j in range(_sage_const_0 ,d+_sage_const_1 ):
                        for k in range(_sage_const_0 ,d):
                            A[j,k]=trimmedlist[length-_sage_const_2 -j-k]
                    X=matrixsolve(A,B)
                    if X!="ns":
                        q=[_sage_const_1 ]
                        for j in range(_sage_const_0 ,d):
                            q.append(X[j,_sage_const_0 ])
                        ptemp=listmult(q, inlist)
                        for z in range (_sage_const_0 ,d):
                            ptemp[-_sage_const_1 -z]=_sage_const_0 
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
                break
    return prf

def bmcheckguess(inlist, minmaxrusk): #(Informasjon: listen "[0,0,0,0,0...]" gir tom teller.) Denne antar at det ikke finnes mer enn minmax elementer med rusk, men kan også fungere med mer rusk. Runs faster than bmcheck
    for j in range(_sage_const_0 ,_sage_const_2 ):
        if j==_sage_const_0 :
            i=_sage_const_0 
        elif j==_sage_const_1  and minmaxrusk>=_sage_const_2 :
            i=minmaxrusk
        else:
            break
        #a_(n-2d-4) must be in the list:
        d=floor((len(inlist)-i-_sage_const_1 -_sage_const_4 )/_sage_const_2 ) #-i to detect recursive sequences with gradually more junk. kan trekke fra mer her for å øke antall ledd rekursjonen må gjelde for
        if d<_sage_const_1 :
            break

        detlist=[]

        for i in range(d, len(inlist)-d):
            m=matrix(d+_sage_const_1 )
            for j in range(_sage_const_0 ,d+_sage_const_1 ):
                for k in range(_sage_const_0 ,d+_sage_const_1 ):
                    m[j,k]=inlist[j+k+i-d]
            detlist.append(m.det())

        if len(detlist)>=_sage_const_2 :
            enddetlist=[]
            enddetlist.append(detlist[-_sage_const_2 ])    #kan legges til mer i enddetlist hvis ønskelig
            enddetlist.append(detlist[-_sage_const_1 ])
            if all(w==_sage_const_0  for w in enddetlist):
                A=matrix(d+_sage_const_5 ,d)
                B=matrix(d+_sage_const_5 ,_sage_const_1 )
                for c in range(_sage_const_0 ,d+_sage_const_5 ):
                    B[c,_sage_const_0 ]=-(inlist[-_sage_const_1 -c])
                for j in range(_sage_const_0 ,d+_sage_const_5 ):
                    for k in range(_sage_const_0 ,d):
                        A[j,k]=inlist[len(inlist)-_sage_const_2 -j-k]
                X=matrixsolve(A,B)
                if X!="ns":
                    q=[_sage_const_1 ]
                    for j in range(_sage_const_0 ,d):
                        q.append(X[j,_sage_const_0 ])
                    ptemp=listmult(q, inlist)
                    for z in range (_sage_const_0 ,d):
                        ptemp[-_sage_const_1 -z]=_sage_const_0 
                    p=trimfinalzeroes(ptemp)
                    trimfinalzeroes(q)
                    return [p,q]
    return []

#print bmcheck(inputlist)
# if result==[]:
#     print 'no recursion found. Possible reasons: there is no recursion or input list is too short'
# else:
#     print 'this is a list of lists with the possible formulas found, as lists for numerator and denominator', result

