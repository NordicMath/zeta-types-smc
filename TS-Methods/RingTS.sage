
### Requires LazyList.sage, Berlekamp.sage, MonoidTS.sage
###


### Methods for Tannakian symbols with elements from a commutative ring ###
###
### Method for computing the trace of a Tannakian symbol:
###    trace
###
### Methods for extracting list of Bell coefficients/list of point counts as a LazyList:
###    getBellCoefficients
###    getPointCounts
###
### NOTE: The convention used here is that both of these lists have the number 1 as the zero'th element.

class RingTannakianSymbols(TannakianSymbols):
    def __init__(self, R):
        TannakianSymbols.__init__(self, ZZ, R, multiplicative=True)
        self.base_monoid = R
        
    class Element(TannakianSymbols.Element):

        # Trace of a zeta type
        def trace(self):
            return sum([n * x for (x, n) in self])

        # Returns a generator (lazy list) containing the bell coefficients of a Tannakian symbol
        def getBellCoefficients(self, length = None):
            #inverted = self * parent(self).createElement([(-parent(self).base_monoid.one(), -1)])
            #list = LazyList(lambda x: inverted.lambdaoperation(x).trace())
            return self.getPointCounts(length = length).applyRecursiveTransform(BellAntiTransform)
            
            # eigenvektorene kommer til å være l funnkjoner interconnectedness T_X(E_1) = theta_1 E <-> T_(E_1)(X) = ...                         T
            # T_(X + Y)(E) = T_X(E) + T_Y(E)??? Find T_E(E) = x * E                                 E -> E = T^2

        # Returns a generator (lazy list) containing the point counts of a Tannakian symbol
        def getPointCounts(self, length = None):
            return LazyList(lambda x: parent(self).base_monoid.one() if x==0 else self.adamsoperation(x).trace(), printed=length)

