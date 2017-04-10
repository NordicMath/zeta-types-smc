︠64e54ae3-42d1-4f4f-b6b2-c2b59eef2279s︠
import itertools
import functools

%attach ../Tannakian-Symbol-Methods/TS-Methods.sage
%attach ../General-Tools/LazyList.sage
%attach ../Sequence-Methods/Berlekamp.sage
%attach ../Tannakian-Symbol-Methods/RingTannakianSymbols.sage

TS = ComplexTannakianSymbols()

getTS = lambda x: TS.getTSFromBellCoeffs(x, 20)
getBC = TS.getBellCoefficients


ts = TS.parseSymbol
trace = TS.trace

A = ts("{2,4,5,6,2}/{1,-3}")

B = ts("Ø/{4}")

C = ts("Ø/{3}")

zeta3 = CyclotomicField(3).gen()

print zeta3

D = ts("{1, zeta3, zeta3^2}/Ø")

print TS.boxproduct(D, D)

#print (example * example).symmetricpoweroperation(6)
#print example.lambdaoperation(6)
︡4a9030d8-4f76-4d65-a5c1-39d0ac939cc7︡{"stdout":"zeta3\n"}︡{"stdout":"{1.00000000000000, -0.500000000000000 + 0.866025403784439*I, -0.500000000000000 - 0.866025403784439*I}/Ø"}︡{"stdout":"\n"}︡{"done":true}︡









