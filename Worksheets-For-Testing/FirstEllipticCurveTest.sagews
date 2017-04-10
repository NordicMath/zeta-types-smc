︠8659c8e1-89c6-474f-86c8-023690ec1754︠

#Se bedre versjon lenger nede


%attach ../Sequence-Methods/EulerTransform.sage
%attach ../Sequence-Methods/Berlekamp.sage
%attach ../WorkInProgress/OlavOgMagnus.sage

def variabel(number):
    return "a"+str(number)

# mylist = [1, 4, 5, 2]
# 
# EulerInversePartOne(mylist)

T = 15 #Number of Fourier coefficients to request for the elliptic curve
MaxC = 20  #maximum conductor
# def variabel(tall, b, tall2):
#     out=str(tall)+str(b)+str(tall2)
#     return out
cremona=CremonaDatabase()
#print c.allcurves(100)


# E=EllipticCurve([7,3,-1,2,6])
# myellipticlist = E.anlist(10)
# print myellipticlist
#     print myellipticlist

#E = EllipticCurve("5a1")
#E = EllipticCurve([0, -1, 1, 0, 0])
#print 'Conductor:'
#print E.conductor()
for P in range(1,MaxC+1):
    curves=cremona.allcurves(P)
    for i in range(1,len(curves)+1):
        specificcurve=curves[variabel(i)]
        myellipticcurve=EllipticCurve(specificcurve[0])
        myellipticlist = myellipticcurve.anlist(T)
        del myellipticlist[0]
        c=EulerInversePartOne(myellipticlist)
        a=EulerInversePartTwo(c)
        d=EulerTransform(myellipticlist)
        if bmcheck(a)!=[]:
            print "Recursion found after Euler Inverse:"
            print "specificcurve: ", specificcurve
            print "myellipticlist: ", myellipticlist
            print "Conductor: ", P
            print "a number:", i
            print "Recursion formula: ", bmcheck(a)
            print
        if bmcheck(myellipticlist)!=[]:
            print "Recursion found:"
            print "Conductor: ", P
            print "a number:", i
            print "Recursion formula: ", bmcheck(myellipticlist)
            print "myellipticlist: ", myellipticlist
            print
        if bmcheck(d)!=[]:
            print "Recursion found after Euler Transform:"
            print "specificcurve: ", specificcurve
            print "myellipticlist: ", myellipticlist
            print "Conductor: ", P
            print "a number:", i
            print "Recursion formula: ", bmcheck(d)
            print
print "done"
# m=c.allcurves(14)
# m
# len(m)
# print m["a1"]
# for E in c.allcurves(14):
#     print E
#     myellipticlist = E.anlist(T)
#     print myellipticlist
#     c=EulerInversePartOne(myellipticlist)
#     a=EulerInversePartTwo(c)
#    print a


#s=[1,4,1,5,6,6,5]
#print EulerTransform(EulerInversePartTwo(EulerInversePartOne(s)))

#kanskje vi kan lage global zetatype for ellipsegreiene
︡7b95ce22-92c3-4dac-85aa-e654f02793cb︡{"stderr":"Error in lines 1-1\nTraceback (most recent call last):\n  File \"/projects/sage/sage-7.3/local/lib/python2.7/site-packages/smc_sagews/sage_server.py\", line 976, in execute\n    exec compile(block+'\\n', '', 'single') in namespace, locals\n  File \"\", line 1, in <module>\n  File \"/projects/sage/sage-7.3/local/lib/python2.7/site-packages/smc_sagews/sage_server.py\", line 1021, in execute_with_code_decorators\n    code = code_decorator(code)\n  File \"/projects/sage/sage-7.3/local/lib/python2.7/site-packages/smc_sagews/sage_salvus.py\", line 3367, in attach\n    raise IOError('did not find file %r to attach' % fname)\nIOError: did not find file u'Sequence-Methods/EulerTransform.sage' to attach\n"}︡{"done":true}︡
︠3a9b22fd-2e49-4329-8bd4-1b8ff97f4a19s︠
#Dette programmet finner rekursjonsformler for Fourierkoeffisienter (?) etter at de er kjørt gjennom Euler Inverse

%attach Sequence-Methods/EulerTransform.sage
%attach Local-Zeta-Type-Methods/Berlekamp.sage
%attach WorkInProgress/OlavOgMagnus.sage


# Elliptic curves downloaded from the LMFDB downloaded on 20 December 2016.
# Below is a list called data. Each entry has the form:
#   [Weierstrass Coefficients]


data = [\
[0, -1, 1, -7820, -263580],\
[0, -1, 1, -10, -20],\
[0, -1, 1, 0, 0],\
[1, 0, 1, -2731, -55146],\
[1, 0, 1, -171, -874],\
[1, 0, 1, -36, -70],\
[1, 0, 1, -11, 12],\
[1, 0, 1, -1, 0],\
[1, 0, 1, 4, -6],\
[1, 1, 1, -2160, -39540],\
[1, 1, 1, -135, -660],\
[1, 1, 1, -110, -880],\
[1, 1, 1, -80, 242],\
[1, 1, 1, -10, -10],\
[1, 1, 1, -5, 2],\
[1, 1, 1, 0, 0],\
[1, 1, 1, 35, -28],\
[1, -1, 1, -91, -310],\
[1, -1, 1, -6, -4],\
[1, -1, 1, -1, -14],\
[1, -1, 1, -1, 0],\
[0, 1, 1, -769, -8470],\
[0, 1, 1, -9, -15],\
[0, 1, 1, 1, 0],\
[0, 1, 0, -41, -116],\
[0, 1, 0, -36, -140],\
[0, 1, 0, -1, 0],\
[0, 1, 0, 4, 4],\
[1, 0, 0, -784, -8515],\
[1, 0, 0, -49, -136],\
[1, 0, 0, -39, 90],\
[1, 0, 0, -34, -217],\
[1, 0, 0, -4, -1],\
[1, 0, 0, 1, 0],\
[0, -1, 0, -384, -2772],\
[0, -1, 0, -64, 220],\
[0, -1, 0, -24, -36],\
[0, -1, 0, -4, 4],\
[0, -1, 0, 1, 0],\
[0, -1, 0, 16, -180],\
[1, 0, 1, -460, -3830],\
[1, 0, 1, -5, -8],\
[1, 0, 1, 0, 0],\
[1, -1, 1, -213, -1257],\
[1, -1, 1, -3, 3],\
[0, 0, 1, -270, -1708],\
[0, 0, 1, -30, 63],\
[0, 0, 1, 0, -7],\
[0, 0, 1, 0, 0],\
[1, 0, 1, -5334, -150368],\
[1, 0, 1, -454, -544],\
[1, 0, 1, -334, -2368],\
[1, 0, 1, -289, 1862],\
[1, 0, 1, -69, -194],\
[1, 0, 1, -19, 26],\
[1, 0, 1, -14, -64],\
[1, 0, 1, 1, 2]]


T=40
print "started"
lastanlist=[]
for i in range(0,len(data)):
    minkurve=EllipticCurve(data[i])
    minelliptiskeliste=minkurve.anlist(T)
    if minelliptiskeliste==lastanlist:
        continue
    lastanlist=minelliptiskeliste+[]         #eksempel på bug i sage, når vi ikke la til [] ble navnene synkronisert
    del minelliptiskeliste[0]
    del minelliptiskeliste[0]
    EI=EulerInversePartTwo(EulerInversePartOne(minelliptiskeliste))
    #ET=EulerTransform(minelliptiskeliste)
    bmEI=bmcheck(EI)
    #bmET=bmcheck(ET)
    print minkurve.cremona_label()
    if bmEI!=[]:
        print "bmEI: ", bmEI[-1]
        print "Graden til teller: ", len(bmEI[-1][0])-1
        print "Graden til nevner: ", len(bmEI[-1][1])-1
    else:
        print "no formula found"
    #if bmET!=[]:
        #print "Recursion found after Euler Transform:"
        #print "minelliptiskeliste: ", minelliptiskeliste
        #print "Recursion formula: ", bmET
        #print
    #else:
        #print "no formula"
print "ferdig"
︡7296c93a-9f69-49dd-aedc-cdc851e5f602︡{"stdout":"### reloading attached file EulerTransform.sage modified at 19:47:45 ###"}︡{"stdout":"\n"}︡{"stdout":"started\n"}︡{"stdout":"11a2"}︡{"stdout":"\nbmEI:  [[-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -4], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1]]\nGraden til teller:  10\nGraden til nevner:  11\n14a5"}︡{"stdout":"\nbmEI:  [[-1, -2, -1, -2, -1, -2, -2, -2, -1, -2, -1, -2, -1, -4], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1]]\nGraden til teller:  13\nGraden til nevner:  14\n15a5"}︡{"stdout":"\nbmEI:  [[-1, -1, -2, -1, -2, -2, -1, -1, -2, -2, -1, -2, -1, -1, -4], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1]]\nGraden til teller:  14\nGraden til nevner:  15\n17a3\nno formula found\n19a2"}︡{"stdout":"\nno formula found\n20a4"}︡{"stdout":"\nbmEI:  [[0, -2, 0, -2, 0, -2, 0, -2, 0, -4], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1]]\nGraden til teller:  9\nGraden til nevner:  10\n21a5\nno formula found\n24a5"}︡{"stdout":"\nbmEI:  [[0, -1, 0, -2, 0, -2, 0, -2, 0, -1, 0, -4], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1]]\nGraden til teller:  11\nGraden til nevner:  12\n26a2\nno formula found\n26b2"}︡{"stdout":"\nno formula found\n27a2"}︡{"stdout":"\nbmEI:  [[0, 0, -2, 0, 0, -2, 0, 0, -4], [1, 0, 0, 0, 0, 0, 0, 0, 0, -1]]\nGraden til teller:  8\nGraden til nevner:  9\n30a7\nno formula found\n"}︡{"stdout":"ferdig\n"}︡{"done":true}︡
︠01f0d7d6-b0b4-421d-8d04-992b037c4384︠
#bare litt testing med Berlekamp2forsok, nb, berlekamp2forsok er ikke ferdigstilt!
%attach Sequence-Methods/EulerTransform.sage
%attach Local-Zeta-Type-Methods/Berlekamp2forsok.sage
%attach WorkInProgress/OlavOgMagnus.sage

#print bmcheck([1,1,2,3,5,8,13])
print bmcheck([1,1,2,4,7,13,24,44,81])
print bmcheck([1,0,-1,0,0,-1,4])
print bmcheck([65364365464545564565634,62435,654343654,563,3654,564,3564,56,4,3564,5634])
#rekursjonsgrad 2 fra 7 tall, altså er 5 gitt ved rekursjonsformelen
︡a309c5ea-f8bf-4ad3-85eb-6e06f7407cba︡{"stdout":"breaked at second break statement, when d was:  4\n[[[1], [1, -1, -1, -1]]]\n"}︡{"stdout":"breaked at first break statement, when d was:  3\n[]\n"}︡{"stdout":"breaked at second break statement, when d was:  5\n[]\n"}︡{"done":true}︡
︠6920d8d2-c840-4017-a180-e7a95a0171c2s︠
#NBBBBBBBBBBBB, dette er kode kopiert fra ovenfor for å teste litt
%attach Sequence-Methods/EulerTransform.sage
%attach Local-Zeta-Type-Methods/Berlekamp.sage
%attach WorkInProgress/OlavOgMagnus.sage
data = [\
[0, -1, 1, -7820, -263580],\
[0, -1, 1, -10, -20],\
[0, -1, 1, 0, 0],\
[1, 0, 1, -2731, -55146],\
[1, 0, 1, -171, -874],\
[1, 0, 1, -36, -70],\
[1, 0, 1, -11, 12],\
[1, 0, 1, -1, 0],\
[1, 0, 1, 4, -6],\
[1, 1, 1, -2160, -39540],\
[1, 1, 1, -135, -660],\
[1, 1, 1, -110, -880],\
[1, 1, 1, -80, 242],\
[1, 1, 1, -10, -10],\
[1, 1, 1, -5, 2],\
[1, 1, 1, 0, 0],\
[1, 1, 1, 35, -28],\
[1, -1, 1, -91, -310],\
[1, -1, 1, -6, -4],\
[1, -1, 1, -1, -14],\
[1, -1, 1, -1, 0],\
[0, 1, 1, -769, -8470],\
[0, 1, 1, -9, -15],\
[0, 1, 1, 1, 0],\
[0, 1, 0, -41, -116],\
[0, 1, 0, -36, -140],\
[0, 1, 0, -1, 0],\
[0, 1, 0, 4, 4],\
[1, 0, 0, -784, -8515],\
[1, 0, 0, -49, -136],\
[1, 0, 0, -39, 90],\
[1, 0, 0, -34, -217],\
[1, 0, 0, -4, -1],\
[1, 0, 0, 1, 0],\
[0, -1, 0, -384, -2772],\
[0, -1, 0, -64, 220],\
[0, -1, 0, -24, -36],\
[0, -1, 0, -4, 4],\
[0, -1, 0, 1, 0],\
[0, -1, 0, 16, -180],\
[1, 0, 1, -460, -3830],\
[1, 0, 1, -5, -8],\
[1, 0, 1, 0, 0],\
[1, -1, 1, -213, -1257],\
[1, -1, 1, -3, 3],\
[0, 0, 1, -270, -1708],\
[0, 0, 1, -30, 63],\
[0, 0, 1, 0, -7],\
[0, 0, 1, 0, 0],\
[1, 0, 1, -5334, -150368],\
[1, 0, 1, -454, -544],\
[1, 0, 1, -334, -2368],\
[1, 0, 1, -289, 1862],\
[1, 0, 1, -69, -194],\
[1, 0, 1, -19, 26],\
[1, 0, 1, -14, -64],\
[1, 0, 1, 1, 2]]
T=50
print "started"
lastanlist=[]
for i in range(0,len(data)):
    minkurve=EllipticCurve(data[i])
    minelliptiskeliste=minkurve.anlist(T)
    if minelliptiskeliste==lastanlist:
        continue
    lastanlist=minelliptiskeliste+[]         #eksempel på bug i sage, når vi ikke la til [] ble navnene synkronisert
    #del minelliptiskeliste[0]
    del minelliptiskeliste[0]
    #EI=EulerInversePartTwo(EulerInversePartOne(minelliptiskeliste))
    #ET=EulerTransform(minelliptiskeliste)
    CI=Cauchy_inv_approximation(minelliptiskeliste)
    #print CI
    #bmEI=bmcheck(EI)
    #bmET=bmcheck(ET)
    bmCI=bmcheck(CI)
    print minkurve.cremona_label()
    if bmCI!=[]:
        print "bmCI: ", bmCI
    else:
        print "no formula found"
    #if bmCI!=[]:
        #print "bmCI: ", bmCI
        #print "Graden til teller: ", len(bmEI[-1][0])-1
        #print "Graden til nevner: ", len(bmEI[-1][1])-1
    #else:
        #print "no formula found"
    #if bmEI!=[]:
        #print "bmEI: ", bmEI[-1]
        #print "Graden til teller: ", len(bmEI[-1][0])-1
        #print "Graden til nevner: ", len(bmEI[-1][1])-1
    #else:
        #print "no formula found"
    # if bmET!=[]:
#         print "Recursion found after Euler Transform:"
 #      print "minelliptiskeliste: ", minelliptiskeliste
#         print "Recursion formula: ", bmET
#         print
#     else:
#        print "no formula"
print "ferdig"
︡ac3f23bb-8926-4986-ae01-e2ced49db8d0︡{"stdout":"started\n"}︡{"stdout":"11a2"}︡{"stdout":"\nno formula found\n14a5"}︡{"stdout":"\nno formula found\n15a5"}︡{"stdout":"\nno formula found\n17a3"}︡{"stdout":"\nno formula found\n19a2"}︡{"stdout":"\nno formula found\n20a4"}︡{"stdout":"\nno formula found\n21a5"}︡{"stdout":"\nno formula found\n24a5"}︡{"stdout":"\nno formula found\n26a2"}︡{"stdout":"\nno formula found\n26b2"}︡{"stdout":"\nno formula found\n27a2"}︡{"stdout":"\nno formula found\n30a7"}︡{"stdout":"\nno formula found\n"}︡{"stdout":"ferdig\n"}︡{"done":true}︡










