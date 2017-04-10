import operator
import re
import itertools
import tokenize
import keyword

# Dictionary of operations
operations = {
    'ATOM': ('ATOM',),            # Atomic Multiplicative Function
    'OSUM': ('OSUM',),            # Circlesum
    'OPROD': ('OPROD',),          # Circleproduct
    'NEG': ('NEG',),              # Negation
    'PSI': lambda n: ('PSI', n)   # Adams operations
}

# returns the first element and the rest as a list
def head(seq):
    return (seq[0], seq[1:])

# The history of a multiplicative function ()
class MultiplicativeFunctionHistory():
    def __init__(self, operation, *values):
        self.operation = operation
        self.values = values

    # Get the symbol based of the history
    def getSymbol(self):
        a, prop = head(self.operation)
        symbols = [v.symbol for v in self.values]

        return {
            'ATOM' : lambda: symbols[0],
            'OSUM' : lambda: symbols[0] + symbols[1],
            'OPROD': lambda: symbols[0] * symbols[1],
            'NEG'  : lambda: -symbols[0],
            'PSI'  : lambda: symbols[0].adamsoperation(int(prop[0]))
        }.get(a, lambda: 'UnimplementedOperationUsed')()

    def getName(self):
        a, prop = head(self.operation)
        names = [(v.name, v.history.getPrecedence()) for v in self.values]

        paren = lambda v: self.paren(*v, latex=False)

        return {
            'ATOM' : lambda: names[0][0],
            'OSUM' : lambda: '%s + %s' % (paren(names[0]), paren(names[1])),
            'OPROD': lambda: '%s * %s' % (paren(names[0]), paren(names[1])),
            'NEG'  : lambda: '-%s' % paren(names[0]),
            'PSI'  : lambda: 'Psi^%s %s' % (str(prop[0]), paren(names[0]))
        }.get(a, lambda: 'UnimplementedOperationUsed')()

    def getLatex(self):
        a, prop = head(self.operation)
        latexes = [(v.latex, v.history.getPrecedence()) for v in self.values]

        paren = lambda v: self.paren(*v, latex=True)

        return {
            'ATOM' : lambda: latexes[0][0],
            'OSUM' : lambda: '%s \\oplus %s' % (paren(latexes[0]), paren(latexes[1])),
            'OPROD': lambda: '%s \\otimes %s' % (paren(latexes[0]), paren(latexes[1])),
            'NEG'  : lambda: '\\circleddash %s' % paren(latexes[0]),
            'PSI'  : lambda: '\\psi^{%s} %s' % (str(prop[0]), paren(latexes[0]))
        }.get(a, lambda: 'UnimplementedOperationUsed')()

    def getLatexEval(self):
        a, prop = head(self.operation)
        evals = [(lambda v: lambda n, variables: (v.latex_eval(n, variables = variables), v.history.getPrecedence()))(v) for v in self.values]

        paren = lambda v: self.paren(*v, latex=True)

        # Determines whether to enclose input with parentheses
        isCompoundRegex = re.compile("(\\[a-z]+|[a-z])(\_\d+)?$")
        def paramIsCompound(param):
            return isCompoundRegex.match(param) == None

        # Puts in parentheses if input is compound (see above) 
        pparen = lambda v: "\\left(%s\\right)" % v if paramIsCompound(v) else v

        def latex_atom_eval(n, variables=LatexEvalVariables()):
            return evals[0](n, variables)[0]

        def latex_osum_eval(n, variables=LatexEvalVariables()):
            n = pparen(n)

            d = variables.nextDivisor()
            f = paren(evals[0](d, variables))
            g = paren(evals[1]('\\frac{%s}{%s}' % (n,d), variables))
            return '\\sum_{%s \\mid %s} %s \\cdot %s' % (d, n, f, g)

        def latex_oprod_eval(n, variables=LatexEvalVariables()):
            if self.values[0].symbol.islineelement() or self.values[1].symbol.islineelement():
                return '%s \\cdot %s' % (paren(evals[0](n, variables)), paren(evals[1](n, variables)))
            else:
                return '\\left(%s\\right)\\left(%s\\right)' % (self.getLatex(), n)

        def latex_neg_eval(n, variables=LatexEvalVariables()):
            # We could maybe use an algebraic definition, but those seem to be recursive, and that won't work here (I think...).
            return '\\left(%s\\right)\\left(%s\\right)' % (self.getLatex(), n)

        def latex_psi_eval(n, variables=LatexEvalVariables()):
            # We don't have an algebraic formula expect for prop[0] == 2
            if prop[0] == 2:
                n = pparen(n)

                d = variables.nextDivisor()

                liouvilleFunc = lambda n: '\\lambda\\left(%s\\right)' % n
                if multiplicativeFunctionLibrary and "liouville" in multiplicativeFunctionLibrary:
                    liouvilleFunc = lambda n: multiplicativeFunctionLibrary["liouville"].latex_eval(n, variables=variables)

                f1 = paren(evals[0]('\\frac{%s^2}{%s}' % (n, d), variables=variables))
                f2 = paren((liouvilleFunc(d), 10))
                f3 = paren(evals[0](d, variables=variables))
                return '\\sum_{%s \\mid %s^2} %s \\cdot %s \\cdot %s' % (d, n, f1, f2, f3)
            return '\\left(%s\\right)\\left(%s\\right)' % (self.getLatex(), n)

        return {
            'ATOM' : lambda: latex_atom_eval,
            'OSUM' : lambda: latex_osum_eval,
            'OPROD': lambda: latex_oprod_eval,
            'NEG'  : lambda: latex_neg_eval,
            'PSI'  : lambda: latex_psi_eval,
        }.get(a, lambda: 'UnimplementedOperationUsed')()

    # Adds parenthesis to text if its precedence is less than our operations precedence
    def paren(self, text, prec, latex=False):
        if self.getPrecedence() > prec:
            return ("\\left(%s\\right)" if latex else "(%s)") % text
        else:
            return text

    # Returns the precedence of the operation of self
    def getPrecedence(self):
        a, prop = head(self.operation)

        return {
            'ATOM' : 10,
            'PSI'  : 9,
            'OPROD': 8,
            'NEG'  : 7,
            'OSUM' : 6
        }.get(a, 0)


# Matches '-' unless it is broken with '\\'
# Used for interpreting latex_eval.
dashes = re.compile("(?<!\\\\)-")
class MultiplicativeFunction(object):
    def __init__(self, history=None, name=None, symbol=None, latex=None, latex_eval=None):

        if not TS:
            defineTS()

        self.history = history

        hist = history and not self.isAtomic()

        if name:
            self.name = name
        elif hist:
            self.name = history.getName()
        else:
            raise ValueError("No name specified, either explicitly or through history!")

        if symbol:
            self.symbol = TS.parseSymbol(symbol.encode("utf8"))
        elif hist:
            self.symbol = history.getSymbol()
        else:
            raise ValueError("No symbol specified, either explicitly or through history!")

        # All related to evaluation
        # gives you the symbol at p = n, Todo: optimize
        self.symbol_list = LazyList(data = lambda n: self.symbol.fmap(lambda f: f(p = Primes().unrank(n)) if isinstance(f, collections.Callable) else f))

        # Memoization
        self.bellCoeffsMEM = LazyList(data = lambda n: self.symbol_list[n].getBellCoefficients())

        self.master = lambda p, e: self.bellCoeffsMEM[len(list(primes(p)))][e]
        self.evaluate = lambda n: reduce(operator.mul, [self.master(p, e) for p, e in factor(n)], 1)

        # Defining latex
        # Should latex from latex_eval or history be prioritized?
        if latex:
            self.latex = latex
        elif latex_eval:
            self.latex = latex_eval
        elif hist:
            self.latex = history.getLatex()
        elif self.name:
            self.latex = "\\text{" + latexifyName(self.name) + "}"
        else:
            self.latex = lambda n: "No latex available"

        # Defining latex_eval
        # Should latex_eval from latex or history be prioritized?
        if latex_eval:
            self.latex_eval = lambda n, variables=None: dashes.sub(lambda _: n, latex_eval)
        elif latex:
            self.latex_eval = lambda n, variables=None: latex + "\\left(" + n + "\\right)"
        elif hist:
            self.latex_eval = history.getLatexEval()
        else:
            self.latex_eval = lambda n, variables=None: ("\\left(" if not self.isAtomic() else "") + self.latex + ("\\right)" if not self.isAtomic() else "") + "\\left(" + str(n) + "\\right)"



    def __call__(self, n, e = None):
        if e != None:
            return self.master(n, e)
        else:
            return self.evaluate(n)

    def __add__(self, other):
        return MultiplicativeFunction(history=MultiplicativeFunctionHistory(operations['OSUM'], self, other))

    def __mul__(self, other):
        return MultiplicativeFunction(history=MultiplicativeFunctionHistory(operations['OPROD'], self, other))

    def __neg__(self):
        return MultiplicativeFunction(history=MultiplicativeFunctionHistory(operations['NEG'], self))

    def __sub__(self, other):
        return self + -other

    def __eq__(self, other):
        return self.symbol == other.symbol

    def __and__(self, other):
        return MIdentity(self, other)

    def __repr__(self):
        return self.name

    def _latex_(self):
        return self.latex

    def adamsoperation(self, n):
        return MultiplicativeFunction(history=MultiplicativeFunctionHistory(operations['PSI'](n), self))

    def printBellTable(self, latex = False, width = 10, height = 5, BellDegree = 0, latexCaption = "", latexLabel = "", includeOnes = True, latexIncludePE = True, latexBorder = True):
        offset = 0 if includeOnes else 1
        width += offset

        data = [[0] * width for i in range(height)]

        for i in range(width):
            for j in range(height):
                data[j][i] = self.master(Primes().unrank(j), i)

        data = reduce(lambda x, f: map(f, x), [BellDerivative if BellDegree > 0 else BellAntiderivative]*abs(BellDegree), data)

        if latex:
            print r"\begin{table}"
            print r"\centering"

            if latexCaption != "":
                print r"\latexCaption{" + latexCaption + "}"
            if latexLabel != "":
                print r"\latexLabel{" + latexLabel + "}"

            print r"\begin{tabular}{" + ("| " if latexBorder else "") + (" | " if latexBorder else "").join((['l |' if latexBorder else 'l'] if latexIncludePE else []) + ['c'] * (width - offset)) + (" |" if latexBorder else "") + "}"

            if latexIncludePE:
                if latexBorder:
                    print "\\hline"
                print "& " + " & ".join(map(lambda n: "$e = %i$" % n, range(offset, width))) + r"\\"
                if latexBorder:
                    print "\\hline"
                    print "\\hline"

            for j in range(height):
                print ("$p = %i$ & " % Primes().unrank(j) if latexIncludePE else "") + " & ".join(map(lambda x: "$" + x._latex_() + "$", data[j][offset:])) + r" \\"
                if latexBorder:
                    print "\\hline";

            print r"\end{tabular}"

            print r"\end{table}"
        else:
            for j in range(height):
                print "p =", Primes().unrank(j), ":", data[j][offset:]

    def isAtomic(self):
        return False

    def define(self, name = None):
        if not name:
            name = self.name
        if not re.match('^' + tokenize.Name + '$', name):
            raise ValueError("Name, " + name + " is not a valid python identifier!")
        elif keyword.iskeyword(name):
            raise ValueError("Name, " + name + " is a python keyword!")
        #elif name in globals():
        #    raise ValueError("Name, " + name + " already has a value, " + str(globals()[name]))
        else:
            globals()[name] = self
        return self


class AtomicMultiplicativeFunction(MultiplicativeFunction):
    def __init__(self, *args, **kwargs):
        MultiplicativeFunction.__init__(self, *args, **kwargs)
        self.history = MultiplicativeFunctionHistory(operations['ATOM'], self)

    def isAtomic(self):
        return True

def defineTS():
    global TS, p, ts
    p = var('p')
    TS = RingTannakianSymbols(CC[p])
    ts = TS.parseSymbol

# Credit: http://stackoverflow.com/questions/16259923/how-can-i-escape-latex-special-characters-inside-django-templates
latexify = {
    '&': r'\&',
    '%': r'\%',
    '$': r'\$',
    '#': r'\#',
    '_': r'\_',
    '{': r'\{',
    '}': r'\}',
    '~': r'\textasciitilde{}',
    '^': r'\^{}',
    '\\': r'\textbackslash{}',
    '<': r'\textless',
    '>': r'\textgreater'
}

latexifyRegex = re.compile('|'.join(re.escape(unicode(key)) for key in sorted(latexify.keys(), key = lambda item: - len(item))))

def latexifyName(name):
    return latexifyRegex.sub(lambda match: latexify[match.group()], name)


#PRIMARY_VARIABLE_POOL = lambda: (v + n for n in (itertools.chain([''], itertools.imap(lambda i: '_' + str(i), itertools.count()))) for v in ['a', 'b', 'c', 'd', 'x', 'y', 'z', 'n', 'm', 'k', 'l', 'i', 'j'] )
PRIMARY_VARIABLE_POOL = lambda: ['a', 'b', 'c', 'd', 'x', 'y', 'z', 'n', 'm', 'k', 'l', 'i', 'j']

PRIMARY_VARIABLE_POOL_INPUT = ['n', 'm']
PRIMARY_VARIABLE_POOL_DIVISOR = ['d']

class LatexEvalVariables(object):
    def __init__(self):
        # The amount of times any variable has been used
        self.pool = [(v, -1) for v in PRIMARY_VARIABLE_POOL()]

    def nextFrom(self, variables):
        cmax = -2
        cmaxi = None

        for i, (v, k) in enumerate(self.pool):
            if v in variables and k > cmax:
                cmax = k
                cmaxi = i

        v, k = self.pool[cmaxi]
        self.pool[cmaxi] = (v, k + 1)

        return v + ('' if k < 0 else '_' + str(k))

    def nextInput(self):
        return self.nextFrom(PRIMARY_VARIABLE_POOL_INPUT)

    def nextDivisor(self):
        return self.nextFrom(PRIMARY_VARIABLE_POOL_DIVISOR)

class MIdentity():
    def __init__(self, LHS, RHS):
        self.LHS = LHS
        self.RHS = RHS

    def check(self):
        return self.LHS == self.RHS

    def __repr__(self):
        return repr(self.LHS) + " = " + repr(self.RHS)

    def _latex_(self, var='n'):
        return self.LHS.latex_eval(var) + " = " + self.RHS.latex_eval(var)