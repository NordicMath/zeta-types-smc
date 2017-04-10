︠fe51801e-461a-4d8e-bda6-db921c276ef7︠
%attach Tannakian-Symbol-Methods/TS-Methods.sage

TS = TannakianSymbols(ZZ, CC)
read = TS.parseSymbol

# Potential Bug! If you get i = 9999 or some similar bullshit, then uncomment the following line:
# i = I

A = read("{1}/Ø")
B = read("{2,2,2}/{1,3}")
C = read("{i,-i}/Ø")

print C
print B.gammaoperation(3)
#print B.lambdaoperation(40)









