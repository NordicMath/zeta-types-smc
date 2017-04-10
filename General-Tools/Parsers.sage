import operator

# Consumes whitespace
pSpaces = many(expectSpace())

# Parses a list of a specified parser
pList = lambda n, parens="[]": (between(parens[0], parens[1],
                manyWithEnd(
                      pSpaces + n >> (lambda n:
                      pSpaces + text(',') + pSpaces + pReturn(n)),
                      n < pSpaces
                )) < maybe(text('...') | text(',...'))).setname('list of %s with %s' % (n, parens))

# Parses 'digits' from start to end
pDigitsRange = lambda start, end: reduce(operator.or_, [expect(str(d)) + pReturn(d) for d in range(start, end)])

# Standard digits
pDigits = pDigitsRange(0, 10)

# Parses a natural number
pNatural = (some(pDigits) >> (lambda digs: pReturn(sum([ n * 10^e for e, n in enumerate(digs[::-1])])))).setname('natural')

# Parses an integer
pInteger = (pNatural | (expect('-') + pNatural >> (lambda n: pReturn(-n)))).setname('integer')

# Parses a positive rational number in decimal form
pPosrationalDecimals = liftP(lambda integral, _, decimals: integral + sum([n * (10 ** (-e - 1)) for e, n in enumerate(decimals)]), pNatural, text('.'), some(pDigits))

# Parses a positive rational number in fraction form
pPosrationalDivision = liftP(lambda numerator, _, denominator: numerator / denominator, pNatural, text('/'), pNatural)

# Parses a positive rational number
pPosrational = (pNatural | pPosrationalDecimals | pPosrationalDivision).setname('positive rational')

# Parses a rational number
pRational = (pPosrational | (expect('-') + pPosrational >> (lambda n: pReturn(-n)))).setname('rational')

# Parses a complex term
pComplexTerm = (pRational | liftP(lambda r, _: r * I, pRational, expect('i') | expect('I') | text('*i') | text('*I')) | 
               ((text('i') | text('I')) + pReturn(I)) | ((text('-i') | text('-I')) + pReturn(-I))).setname('complex term')

# Parses a sum or difference of a specified parser
pSumordiff = lambda parser: (liftP(lambda l, _, r: l + r, parser, many(expect(' ')) + text('+') + many(expect(' ')), parser) | 
                             liftP(lambda l, _, r: l - r, parser, many(expect(' ')) + text('-') + many(expect(' ')), parser)).setname('sum or difference of ' + str(parser))

# Parses a complex number (technically guassian rational)
pComplex = (pComplexTerm | pSumordiff(pComplexTerm)).setname('complex')

# Parses a tannakian set
pTannakianSet = lambda elem: between('{', '}', delimited(elem, ',')) | (text('Ø') + pReturn([]))

# Parses a tannakian symbol
pTannakianSymbol = lambda elem: (
    pTannakianSet(elem) >> (lambda x:
    expect('/') +
    pTannakianSet(elem) >> (lambda y:
    pReturn([(i, 1) for i in x] + [(i, -1) for i in y])
    ))
)
