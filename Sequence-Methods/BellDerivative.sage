def BellAntiDerivativeZetaType(inlist):  #Bell antiderivative of a Zeta-type
    length=len(inlist)
    outlist=[]
    for i in range(0,length):
        outlist.append(InverseShiftedLogDerivative(inlist[i]))
    return outlist

def BellDerivativeZetaType(inlist):  #Bell derivative of a Zeta-type
    length=len(inlist)
    outlist=[]
    for i in range(0,length):
        outlist.append(ShiftedLogDerivative(inlist[i]))
    return outlist

def ShiftedLogDerivative(inlist): #Let inlist=[b_1,b_2,b_3....] , previously BellDerivative
    inlist=[0]+inlist
    Output=[0]
    for n in range(1,len(inlist)):
        ledd=n*inlist[n]
        for i in range(1, n):
            ledd-=(inlist[i]*Output[n-i])
        Output.append(ledd)
    return Output[1:]

def InverseShiftedLogDerivative(inlist): #Let inlist=[b_1,b_2,b_3....], previously BellAntiDerivative
    inlist=[0]+inlist
    Output=[0, inlist[1]]
    for n in range(2,len(inlist)):
        Output.append(1/n)
        storfaktor=inlist[n]
        for z in range(1, n):
            storfaktor+=(inlist[z]*Output[n-z])
        Output[n]=Output[n]*storfaktor
    del Output[0]
    del inlist[0]
    return Output