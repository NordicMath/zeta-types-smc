
import functools
import itertools
import operator

### Methods for complex Tannakian symbols ###
###
### Binary operations:     boxsum
###                        boxsubtract
###                        boxproduct
###
### Factory methods:       getTSFromBellCoefficients
###                        getTSFromPointCounts
###
### Other:                 liftBellBinaryOp
###                        liftPointCountBinaryOp
###                        liftBellUnaryOp
###                        liftPointCountUnaryOp
###
### C-actions:             circleaction
###                        boxaction
###
### Unary operations:      adamshatoperation
###                        boxadamsoperation
###                        boxadamshatoperation
###                        bellderivative
###                        bellantiderivative
###
### Helper methods:        reciprocal_roots
###                        BellDerivative
###                        BellAntiderivative
###                        toNearestGaussianInteger
###                        toNearestInteger
###
### Plot methods:          showplot
###
### Global constant:       DEFAULT_BERLEKAMP_LENGTH

DEFAULT_BERLEKAMP_LENGTH = 20

class ComplexTannakianSymbols(RingTannakianSymbols):
    def __init__(self):
        RingTannakianSymbols.__init__(self, CC)
    
    # Takes a binary function C x C -> C and gives a function TS(C) x TS(C) -> TS(C) that evaluates the function on bell coeffs
    def liftBellBinaryOp(self, binary, exclude = -1):
        return lambda x, y, bell_length = DEFAULT_BERLEKAMP_LENGTH: self.getTSFromBellCoeffs(liftBinaryOpToLazyList(binary, exclude=exclude)(x.getBellCoefficients(), y.getBellCoefficients()), bell_length)
    
    # Takes a binary function C x C -> C and gives a function TS(C) x TS(C) -> TS(C) that evaluates the function on point coeffs
    def liftPointCountBinaryOp(self, binary, exclude = -1):
        return lambda x, y, point_length = DEFAULT_BERLEKAMP_LENGTH: self.getTSFromPointCounts(liftBinaryOpToLazyList(binary, exclude=exclude)(x.getPointCounts(), y.getPointCounts()), point_length)
    
    # Takes a unary function C -> C and gives a function TS(C) -> TS(C) that evaluates the function on bell coeffs
    def liftBellUnaryOp(self, unary, exclude = -1):
        return lambda x, bell_length = DEFAULT_BERLEKAMP_LENGTH: self.getTSFromBellCoeffs(liftUnaryOpToLazyList(unary, exclude=exclude)(x.getBellCoefficients()), bell_length)
    
    # Takes a unary function C -> C and gives a function TS(C) -> TS(C) that evaluates the function on point counts
    def liftPointCountUnaryOp(self, unary, exclude = -1):
        return lambda x, point_length = DEFAULT_BERLEKAMP_LENGTH: self.getTSFromPointCounts(liftUnaryOpToLazyList(unary, exclude=exclude)(x.getPointCounts()), point_length)
    
    boxsum = lambda self, *args, **kwargs: self.liftBellBinaryOp(operator.add, exclude = 0)(*args, **kwargs)
    boxsubtract = lambda self, *args, **kwargs: self.liftBellBinaryOp(operator.sub, exclude = 0)(*args, **kwargs)
    boxproduct = lambda self, *args, **kwargs: self.liftBellBinaryOp(operator.mul, exclude = 0)(*args, **kwargs)
    
    # Returns Tannakian Symbol from a list of Bell coefficients
    def getTSFromBellCoeffs(self, *args, **kwargs):
        return self.getTSFromLocalZetaFunction(getLZFromBellCoeffs(*args, **kwargs))
        

    def getTSFromLocalZetaFunction(self, local_zeta_function):
        upstairs = reciprocal_roots(local_zeta_function[1], CC)
        downstairs = reciprocal_roots(local_zeta_function[0], CC)
        sum = self.createElement([])
        for j in upstairs:
            sum += self.createElement([(j, 1)])
        for j in downstairs:
            sum += self.createElement([(j, -1)])
        return sum

    # Returns Tannakian Symbol from a list of point counts
    def getTSFromPointCounts(self, pointCounts, pc_length=DEFAULT_BERLEKAMP_LENGTH):
        list = pointCounts
        if isinstance(pointCounts, LazyList):
            list = pointCounts.toList(pc_length)
        bclist = BellAntiderivative(list)
        return self.getTSFromBellCoeffs(bclist)

    class Element(RingTannakianSymbols.Element):
        
        def circleaction(self, k, **kwargs):
            return parent(self).liftPointCountUnaryOp(lambda x: k*x, exclude = 0)(self,**kwargs)

        def boxaction(self, k, **kwargs):
            return parent(self).liftBellUnaryOp(lambda x: k*x, exclude = 0)(self,**kwargs)
        
        def adamshatoperation(self, k):
            return parent(self).getTSFromPointCounts(self.getPointCounts().expand(k))
        
        def boxadamsoperation(self, k):
            return parent(self).getTSFromBellCoeffs(self.getBellCoefficients().compress(k))
        
        def boxadamshatoperation(self, k):
            return parent(self).getTSFromBellCoeffs(self.getBellCoefficients().expand(k))
        
        def bellderivative(self):
            return parent(self).boxproduct(self, parent(self).parseSymbol("{1, 1}/Ø")) - self
        
        def bellantiderivative(self):
            return parent(self).getTSFromBellCoeffs(BellAntiderivative(self.getBellCoefficients()))
        
        def showplot(self, downstairscolor="red", upstairscolor="blue", showsymbol = False, p = None, showunitcircle = False, showelementcircles = False, dotsize = 72, returnPlot = False):
            if showsymbol:
                text("Plot for $" + latex(self) + "$", (0, 0)).show(axes = False)
            
            minabs = Infinity
            maxabs = 0
            
            
            result = Graphics()
            for z, n in self:
                result += point(CC(z), color = upstairscolor if n > 0 else downstairscolor, size=dotsize * abs(n), zorder=10)
                
                if maxabs < abs(z):
                    maxabs = abs(z)
                elif minabs > abs(z):
                    minabs = abs(z)
            
            if showunitcircle:
                result.set_aspect_ratio(1)
                result += circle((0, 0), 1, color = "black")
            
            if showelementcircles:
                result.set_aspect_ratio(1)
                for x, _ in self:
                    result += circle((0, 0), abs(x), color = "black")

            
            if p != None:
                result.set_aspect_ratio(1)
                for n in [n for n in range(2 * log(minabs)/log(p) - 1, 2 + 2 * log(maxabs)/log(p))]:
                    result += circle((0, 0), sqrt(p)^n, linestyle = "dashed" if n % 2 == 1 else "solid", color="black")
            
            if returnPlot:
                result.axes = True
                result.agridlies = True
                return result
            else:
                result.show(axes=True, gridlines=True)

def toNearestGaussianInteger(z):
    return round(real(z)) + round(imag(z)) * I

def toNearestInteger(z):
    return round(real(z))


# Local zeta function from bell coeffs
def getLZFromBellCoeffs(bellCoeffs, bell_length=None):
    list = bellCoeffs
    if isinstance(bellCoeffs, LazyList):
        list = bellCoeffs.toList(bell_length if bell_length != None else DEFAULT_BERLEKAMP_LENGTH)
    else:
        list = list if bell_length == None else list[:bell_length]
    #if any(map(lambda z: round(real(z)) - z != 0, list)):
    #    raise NotImplementedError("Berlekamp currently can't do this. The following is the coeff's input: " + str(list))
    local_zeta_function = bmcheck(list)#lambda x: round(real(x)), list))
    if local_zeta_function == []:
        raise ArithmeticError("Berlekamp produced an empty list")
    return tuple(local_zeta_function[-1])

# Local zeta functions from point counts
def getLZFromPointCounts(pointCounts, pc_length=DEFAULT_BERLEKAMP_LENGTH):
    list = pointCounts
    if isinstance(pointCounts, LazyList):
        list = pointCounts.toList(pc_length)
    bclist = BellAntiderivative(list)
    return getLZFromBellCoeffs(bclist)

### Computes a list of the reciprocal roots of a polynomial
### The input is given as a finite list on the form [1, a_1, a_2, ..., a_n]
###  representing the polynomial 1 + a_1 t + a_2 t^2 + ... + a_n t^n
def reciprocal_roots(coefficient_list, domain):
    R = PolynomialRing(domain,"t")
    t = R.gen()
    pol = R(coefficient_list)
    rev = pol.reverse()
    reciprocal_root_list = rev.roots(ring=domain)
    rrlist = reciprocal_root_list
    no_of_distinct_roots = len(rrlist)
    ndr = no_of_distinct_roots
    rrmultilist = []
    for j in xrange(ndr):
        rr_data = rrlist[j]
        rr = rr_data[0]
        multiplicity = rr_data[1]
        for k in xrange(multiplicity):
            rrmultilist.append(rr)
    return rrmultilist

### Transforming a row of Bell coefficients to point counts:
### The convention here is that both types of list starts with the element 1 at the zero'th position
def BellDerivative(A):
    if isinstance(A, LazyList):
        return A.applyRecursiveTransform(BellTransform)
    else:
        D = [1]
        for i in range(1, len(A)):
            D.append(i * A[i] - sum([A[j]*D[i - j] for j in range(1, i)]))
        return D
    
### Transforming a row of point counts to Bell coefficients:
### The convention here is that both types of list starts with the element 1 at the zero'th position
def BellAntiderivative(D):
    if isinstance(D, LazyList):
        return D.applyRecursiveTransform(BellAntiTransform)
    else:
        A = [1]
        for i in range(1, len(D)):
            A.append((D[i] + sum([A[j]*D[i - j] for j in range(1, i)])) / i)
        return A






### Transforming a row of Bell coefficients to point counts:
### The convention here is that both types of list starts with the element 1 at the zero'th position
def BellDerivativeOLDDEPRECATED(row_as_list):
    row_length = len(row_as_list)
    R.<x> = PowerSeriesRing(CC)
    d = R(row_as_list, row_length)
    l = d.log()
    f = l.derivative()
    f_coefficient_list = f.padded_list()
    f_coefficient_list.insert(0, 1)
    return f_coefficient_list


### Transforming a row of point counts to Bell coefficients:
### The convention here is that both types of list starts with the element 1 at the zero'th position
def BellAntiderivativeOLDDEPRECATED(row_as_list):
    trimmed_list = row_as_list[1:]
    row_length = len(trimmed_list)
    R.<x> = PowerSeriesRing(CC)
    f = R(trimmed_list, row_length)
    l = f.integral()
    d = l.exp()
    d_coefficient_list = d.padded_list()
    return d_coefficient_list

#def findLabelPlace