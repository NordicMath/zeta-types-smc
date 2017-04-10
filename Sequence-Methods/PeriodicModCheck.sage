def PeriodicModCheck(x,m,maxperiodlength):
    for i in range(2,maxperiodlength):   #lurt å legge til støtte for rusk og 
        a=x^i%m
        if(a==x):
            p=i-1
            return p