︠a6243b2d-ec9f-4bd9-ae93-a3b2f7db4b8es︠
%attach ../General-Tools/LazyList.sage
%attach ../Sequence-Methods/JacobiTransform.sage
%attach ../Sequence-Methods/EulerTransform.sage

import itertools

examples = [[1, -10, 7, -8, -6, 5, 9, 3, 2, 4, -2],
[1, 4, 2, 5, 9, -3, -4, 1, -10, 10, -5],
[1, -1, -7, 7, 9, -6, 5, -2, 2, -10, 3],
[1, 6, -9, 4, -7, 8, 9, -1, -2, 10, 2],
[1, 5, 2, -4, -6, -10, -9, -2, 10, 0, -3],
[1, 1, 5, 4, -7, -3, -4, 7, -2, 2, 8],
[1, 1, 6, 5, 0, -3, -9, 10, -2, 7, -6],
[1, -2, 6, -1, 5, 2, 10, -5, 4, -3, -8],
[1, -10, 1, -5, -9, -6, 10, 9, -4, -2, -8],
[1, -6, -9, 9, 6, 5, 1, -3, -1, 8, 10]]

#print reverseJacobiTransform([1, -24, 252, -1472, 4830, -6048, -16744, 84480, -113643, -115920, 534612, -370944, -577738, 401856, 1217160, 987136])
#print jacobiTransform([1, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24, -24])

#print reverseJacobiTransform([1, 2, 3, 4, 5, 6, 7, 8, 9])

#print jacobiTransform([1, 1, 1, 0, 0, 0, 0, 0, 0])
#print guessJacobiTransform([1, 1, 1])

print reverseJacobiTransform([1,2,4,8,16,32,64,128,256,512,1024,2048,4096])

#for i in range(1):
    #print "hey"
    #print examples[i]
    #j1 = jacobiTransform(examples[i])
    #print j1
    #r1 = reverseJacobiTransform(j1)
    #print r1
    #print r1 == examples[i]
    #r2 = reverseJacobiTransform(examples[i])
    #print r2
    #print j2
    #print j2 == examples[i]
︡37c146cc-826e-4c5e-b9c9-0925ad4103cc︡{"stdout":"[1, 2, 1, 2, 3, 6, 9, 18, 30, 56, 99, 186, 335]\n"}︡{"done":true}︡









