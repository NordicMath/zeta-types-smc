︠e6ca42f4-a1ff-4d80-8a99-fc112074d0cd︠

%attach ../Sequence-Methods/EulerTransform.sage
%attach ../Sequence-Methods/Berlekamp.sage
%attach ../WorkInProgress/OlavOgMagnus.sage


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


T=50
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
    #Multiplication=listmult(minelliptiskeliste,minelliptiskeliste)
    Multi=minelliptiskeliste+[]
    newM=Multi+[]
    for j in range(0,len(Multi)):
        newM[j]=Multi[j]*Multi[j]
    print minkurve.cremona_label()
    bmM=bmcheck(newM)
    if bmM!=[]:
        #print "Rekursjon: ", bmM
        print "Graden til teller: ", len(bmM[-1][0])-1
        print "Graden til nevner: ", len(bmM[-1][1])-1
    else: print "no formula found"
print "ferdig"
︡784c2ca0-d157-4ce5-8b5a-b85b247d49a7︡{"stdout":"started\n"}︡{"stdout":"11a2\nno formula found\n14a5\nno formula found"}︡{"stdout":"\n15a5\nno formula found\n17a3\nno formula found"}︡{"stdout":"\n19a2\nno formula found\n20a4\nno formula found"}︡{"stdout":"\n21a5\nno formula found\n24a5\nno formula found"}︡{"stdout":"\n26a2\nno formula found\n26b2\nno formula found"}︡{"stdout":"\n27a2\nno formula found\n30a7\nno formula found"}︡{"stdout":"\n"}︡{"stdout":"ferdig\n"}︡{"done":true}︡
︠df7cce41-2de7-412b-ba03-7f219b4ea5bfs︠


#CODE FOR TESTING, NOT WORKING GREAT!


%attach Sequence-Methods/EulerTransform.sage
%attach Local-Zeta-Type-Methods/Berlekamp.sage
%attach WorkInProgress/OlavOgMagnus.sage

T=50
#minkurve=EllipticCurve([0, -1, 1, -10, -20])
minkurve=EllipticCurve([0, 1, 1, 1, 0])
minelliptiskeliste=minkurve.anlist(T)
del minelliptiskeliste[0]
del minelliptiskeliste[0]
My=EulerInversePartTwo(EulerInversePartOne(minelliptiskeliste))
#My=EulerInversePartTwo(EulerInversePartOne(Mytemp))
#My=EulerInversePartTwo(EulerInversePartOne(Mytemp2))
#My=EulerInversePartTwo(EulerInversePartOne(Mytemp2))
#My=EulerInversePartOne(minelliptiskeliste)
#ET=EulerTransform(minelliptiskeliste)
#bmET=bmcheck(ET)
# minnyeliste=My+[]
# for j in range(0,len(My)):
#     minnyeliste[j]=My[j]*(j+1)
# print "minnyeliste: ",minnyeliste
#print "My: ", My
# My=minnyeliste





bmMy=bmcheck(My)






print minkurve.cremona_label()
print "minelliptiskeliste: ",minelliptiskeliste
print "My: ", My
if bmMy!=[]:
    print "bmEI: ", bmMy[-1]
    print "Graden til teller: ", len(bmMy[-1][0])-1
    print "Graden til nevner: ", len(bmMy[-1][1])-1
else:
    print "no formula found"
︡0f55e345-95ec-405a-b840-eb25bdccb87b︡{"stdout":"19a3\n"}︡{"stdout":"minelliptiskeliste:  [0, -2, -2, 3, 0, -1, 0, 1, 0, 3, 4, -4, 0, -6, 4, -3, 0, 1, -6, 2, 0, 0, 0, 4, 0, 4, 2, 6, 0, -4, 0, -6, 0, -3, -2, 2, 0, 8, 0, -6, 0, -1, -6, 3, 0, -3, -8, -6, 0]\n"}︡{"stdout":"My:  [0, -2, -2, 2, -4, 2, -2, -6, 4, -6, 4, -2, -10, 14, -18, 10, 6, -34, 48, -46, 18, 34, -114, 158, -140, 26, 184, -418, 526, -386, -80, 802, -1522, 1750, -1034, -806, 3408, -5636, 5738, -2294, -4924, 14014, -20456, 18258, -2904, -24990, 56424, -73658, 55508]\n"}︡{"stdout":"no formula found\n"}︡{"done":true}︡
︠e865007d-e8a5-441a-87cc-99d044bbd903︠
#test
%attach Local-Zeta-Type-Methods/PolynomialFormulaCheck.sage
pcheck([0, -2, -2, 2, -4, 2, -2, -6, 4, -6, 4, -2, -10, 14, -18, 10, 6, -34, 48, -46, 18, 34, -114, 158, -140, 26, 184, -418, 526, -386, -80, 802, -1522, 1750, -1034, -806, 3408, -5636, 5738, -2294, -4924, 14014, -20456, 18258, -2904, -24990, 56424, -73658, 55508])
︡ba008e4a-0352-4663-ab97-854dab91eb77︡{"stdout":"[]\n"}︡{"done":true}︡
︠42ddb007-5eb5-4b26-aa91-576c60346d11︠
%attach Local-Zeta-Type-Methods/Berlekamp.sage

def differansetallfolge(inlist):
    out=inlist+[]
    del out[0]
    for j in range(0,len(out)):
        out[j]=inlist[j+1]-inlist[j]
    return out

a=differansetallfolge([0, -2, -2, 2, -4, 2, -2, -6, 4, -6, 4, -2, -10, 14, -18, 10, 6, -34, 48, -46, 18, 34, -114, 158, -140, 26, 184, -418, 526, -386, -80, 802, -1522, 1750, -1034, -806, 3408, -5636, 5738, -2294, -4924, 14014, -20456, 18258, -2904, -24990, 56424, -73658, 55508])

print bmcheck(a)









