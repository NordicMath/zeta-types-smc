BERLEKAMP_GP_FUNCTION = gp("""
berlekamplist(list, {legaljunk = 2}) = 
berlekamp((i) -> list[i + 1], #list, #list - 1, legaljunk);
berlekamp(func, degreelimit, sequencelimit, legaljunk) = 
{   
    my(memoized);
    
    memoized = apply((n) -> func(n), [0..sequencelimit]);
    
    my(degree = findminimalrecursiondegree(memoized, degreelimit, sequencelimit, legaljunk));
    
    if(degree == +oo,
        print("No recursion found!");return;
        ,
        my(M, B, Recursion, Numerator, Denominator);
        
        M = matrix(degree + 1, degree, X, Y, memoized[sequencelimit - 2 * (degree + 1) + X + Y + 1]);
        B = matrix(degree + 1, 1, X, Y, memoized[sequencelimit - 2 * (degree + 1) + X + degree + 1 + 1]);
                
        Recursion = matinverseimage(M, B);
        
        if(Recursion==[;], print("No recursion found!"); return;);
        
        Denominator = concat([1], -1 * Vecrev(Recursion[,1]));
        
        Numerator = Vecrev(Vec(truncate(Ser(memoized)*truncate(Ser(Denominator)))));
        
        return([Numerator, Denominator]);
    );
    
}
findminimalrecursiondegree(array, degreelimit, sequencelimit, legaljunk) =
{
    
    my(matrsize, matroffset, M, rank);
    
    matrsize = min(degreelimit, floor((sequencelimit - legaljunk) / 2));
    matroffset = legaljunk;
    
    M = matrix(matrsize, matrsize, i, j, array[i + j - 2 + matroffset + 1]);
    rank = matrank(M);
    
    return(if(rank == matrsize, +oo, if(rank == 0, 1, rank)));
    
}
""")

def bmcheck(seq, legal_junk = 2, ring = CC):
    result = BERLEKAMP_GP_FUNCTION(seq, legal_junk)
    if result == 0:
        print "No recursion found!"
        return []
    return [map(lambda x: map(ring, x), result)]
    
