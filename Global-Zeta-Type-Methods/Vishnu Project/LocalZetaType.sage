# Depends on MonoidTS, RingTS, ComplexTS, LazyList, Berlekamp, Parsing
import abc

# Types:
# TANSYM = TS C (tannakian symbols)
# LOCZET = ([], []) # first is downstairs, second is upstairs (so standard division in local zeta function) the lists are coeffs, 1 first. (local zeta function)
# BELCOF = LazyList | List (bell coeffs)
# PNTCNT = LazyList | List (point counts)

# For converting to tannakian symbols
TSC = ComplexTannakianSymbols()

# For converting to local zeta functions
T = var('T')

# Identity function
_ = lambda x: x

# Converts local zeta function to bell coeffs
def getBellCoeffsFromLZF(lzf):
    num, den = map(toLazyList, lzf)
    l = LazyList(cache = True)
    l.data = lambda n: num[n] - sum([l[j] * den[n - j] for j in range(n)])
    return l

# 2D Table of functions from -> to
conversionTable =  {
    TANSYM: {
        TANSYM: _,
        LOCZET: lambda x: (lambda det: (det.numerator().list(), det.denominator().list()))(x.fmap(lambda y: 1 - y * T).determinant()),
        BELCOF: lambda x: x.getBellCoefficients(),
        PNTCNT: lambda x: x.getPointCounts()
    },
    LOCZET: {
        TANSYM: TSC.getTSFromLocalZetaFunction,
        LOCZET: _ ,
        BELCOF: getBellCoeffsFromLZF,
        PNTCNT: lambda x: BellDerivative()
    },
    BELCOF: {
        TANSYM: TSC.getTSFromBellCoeffs,
        LOCZET: getLZFromBellCoeffs,
        BELCOF: _ ,
        PNTCNT: BellDerivative
    },
    PNTCNT: {
        TANSYM: TSC.getTSFromPointCounts,
        LOCZET: getLZFromPointCounts,
        BELCOF: BellAntiderivative,
        PNTCNT: _
    }
}

def convertZT(data, form):
    preform = data.form()
    return conversionTable[preform][form](self.data.data())


# Abstract avatar-class
class Avatar(object):
    __metaclass__ = abc.ABCMeta

    @abc.abstractmethod
    def __init__(self, data):
        pass

    @abc.abstractmethod
    def data(self):
        pass

    @abc.abstractmethod
    def form(self):
        pass

    @abc.abstractmethod
    def __repr__(self, ltx = False):
        pass

    @abc.abstractmethod
    def __eq__(self, other):
        pass

# Tannakian symbol avatar
class AvTANSYM(Avatar):
    def __init__(self, data):
        self.data = data

    def form(self):
        return TANSYM

    def data(self):
        return self.data

    def __repr__(self, ltx=False):
        return self.data._repr_(latex=ltx)

    def __eq__(self, other):
        return isinstance(other, AvTANSYM) and self.data == other.data

# Local zeta function avatar
class AvLOCZET(Avatar):
    def __init__(self, data):
        self.data = data

    def form(self):
        return LOCZET

    def data(self):
        return self.data

    def __repr__(self, ltx=False):
        return repr(self.data)

    def __eq__(self, other):
        return isinstance(other, AvLOCZET) and self.data == other.data

# Bell coefficients avatar
class AvBELCOF(Avatar):
    def __init__(self, data):
        self.data = data

    def form(self):
        return BELCOF

    def data(self):
        return self.data

    def __repr__(self, ltx=False):
        return 'BC ' + repr(self.data)

    def __eq__(self, other):
        return isinstance(other, AvBELCOF) and self.data == other.data

# Point count avatar
class AvPNTCNT(Avatar):
    def __init__(self, data):
        self.data = data

    def form(self):
        return PNTCNT

    def data(self):
        return self.data

    def __repr__(self, ltx=False):
        return 'PC ' + repr(self.data)

    def __eq__(self, other):
        return isinstance(other, AvPNTCNT) and self.data == other.data

# The forms it may appear as
TANSYM, LOCZET, BELCOF, PNTCNT = range(4)

# Their associated classes
formClasses = {
    TANSYM: AvTANSYM,
    LOCZET: AvLOCZET,
    BELCOF: AvBELCOF,
    PNTCNT: AvPNTCNT
}

def defineLZT(elem = pComplex, parser_purely_global = None):
    global parser_purely_local
    tan_sym = pTannakianSymbol(elem) >> (lambda x: pReturn (LocalZetaType(TSC.createElement(x), TANSYM)))
    bel_cof_txt = text('BC') | text('Bell Coeffs') | text('BellCoeffs') | text('Bell Coefficients') | text('BellCoefficients')
    pnt_cnt_txt = text('PC') | text('Point Count') | text('PointCount') | text('Point Counts')      | text('PointCounts')
    
    bel_cof = bel_cof_txt + pSpaces + (pList(elem) | pList(elem, parens=("",""))) >> (lambda x: pReturn(LocalZetaType(x, BELCOF)))
    pnt_cnt = pnt_cnt_txt + pSpaces + (pList(elem) | pList(elem, parens=("",""))) >> (lambda x: pReturn(LocalZetaType(x, PNTCNT)))

    parser_purely_local = maybe(text('Local Zetatype:')) + pSpaces + (tan_sym | bel_cof | pnt_cnt)

    # Adding support for [GLOBAL ZETA TYPE] at p=? or n=? or just ? (= p=?)
    if parser_purely_global:
       parser_purely_local = parser_purely_local | liftP(lambda zt, _, (t, n): zt[n if t else Primes().unrank(n)], lambda: parser_purely_global, text(' at ') + pSpaces, pReturn(False) & natural,                    ((expect('p') + pReturn(False) | expect('n') + pReturn(False)) < pSpaces + expect('=') + pSpaces) & natural)

    global LZT
    def LZT(str):
        return parse(parser_purely_local, str)

    return parser_purely_local


class LocalZetaType(object):
    def __init__(self, data, form):
        self.data = formClasses[form](data)

    def convertedTo(self, form):
        return convertZT(self, form)

    def __repr__(self):
        return 'Local Zetatype: ' + repr(self.data)

    def __eq__(self, other):
        return self.data == other.data
