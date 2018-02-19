︠64e54ae3-42d1-4f4f-b6b2-c2b59eef2279s︠
import itertools
import functools

%attach ../General-Tools/LazyList.sage
%attach ../Sequence-Methods/Berlekamp.sage
#%attach ../TS-Methods/TannakianSymbols.sage
%attach ../TS-Methods/MonoidTS.sage
%attach ../TS-Methods/RingTS.sage
%attach ../TS-Methods/ComplexTS.sage

TS = ComplexTannakianSymbols()

getTS = lambda x: TS.getTSFromBellCoeffs(x, 20)
getBC = lambda x: x.getBellCoefficients


ts = TS.parseSymbol
#trace = TS.trace

A = ts("{2,4,5,6,2}/{1,-3}")

B = ts("Ø/{4}")

C = ts("Ø/{3}")

zeta3 = CyclotomicField(3).gen()

print zeta3

D = ts("{zeta3, zeta3^2}/Ø")

#print TS.boxproduct(D, D)
D.gammaoperation(3)

#print (example * example).symmetricpoweroperation(6)
#print example.lambdaoperation(6)
︡d1d85958-2d73-4ace-a51f-a34fbb48b487︡{"stdout":"zeta3\n"}︡{"stdout":"{1, 1, zeta3, -zeta3 - 1}/Ø\n"}︡{"done":true}︡
︠3909c910-0097-4ad8-bc3b-0f76ab8cd23e︠









