import collections
import string

# Enum of parser types
ptNEXT, ptLOOK, ptRETURN, ptERROR, ptOR, ptADD, ptBIND, ptINJECT, ptCUSTOM = range(9)
# See comments on functions below for explanations

# Tree structure of the parser.
class Parser(object):
    def __init__(self, type, *values, **kwargs):
        self.type = type
        self.values = values
        self.name = kwargs.get('name', None)
        self.atomic = kwargs.get('atomic', False)

    def setname(self, name):
        self.name = name
        self.atomic = True
        return self

    def nonatomic(self):
        self.atomic = False
        return self

    # Does self first, then other
    def __add__(self, other):
        return Parser(ptADD, self, other)

    # Does self first, and if it fails, does other
    def __or__(self, other):
        return Parser(ptOR, self, other)

    # Does self, and sends result into other as a function (only one value, use tuples for more)
    def __rshift__(self, other):
        return Parser(ptBIND, self, other)

    # Does self and other, but returns the result of other.
    def __lt__(self, other):
        return (self >> (lambda res: other + pReturn(res))).setname('return %s if then %s' % (str(self), str(other)))

    # Same as +
    def __gt__(self, other):
        return self + other

    # Does self and other, and returns the result as a tuple of both
    def __and__(self, other):
        return (self >> (lambda res1: other >> (lambda res2: pReturn((res1, res2))))).setname('return %s and %s' % (str(self), str(other)))

    # String representation
    def __str__(self):
        return self.name or {
            ptNEXT:   "next",
            ptRETURN: "return (%s)",
            ptERROR:  "error",
            ptOR:     "(%s) or (%s)",
            ptADD:    "(%s) then (%s)",
            ptBIND:   "(%s) then value to (%s)",
            ptLOOK:   "look",
            ptINJECT: "inject (%s)",
            ptCUSTOM: "custom (%s)"
        }[self.type] % tuple(map(str, self.values))

# Parser that returns the next symbol
def pNext():
    return Parser(ptNEXT)

# Parser that looks ahead, without consuming anything
def pLook():
    return Parser(ptLOOK)

# Parser that returns val
def pReturn(val):
    return Parser(ptRETURN, val)

# Parser that fails.
def pError():
    return Parser(ptERROR)

# Parser that injects str
def pInject(str):
    return Parser(ptINJECT, str)

def pCustom(f):
    return Parser(ptCUSTOM, f)

# Takes a parser and a string, and applies the parser to the string, returning all possible parses with tails
def parses(parser, string, debug = False, scope = {}):

    if(not isinstance(parser, Parser)):
        raise TypeError("Can't parse with %s, it isn't a Parser! Perhaps you forgot a pReturn in a bind?" % (str(parser)))

    # Partial function, so "debug = ..., scope = ...." isn't required at every parse-call
    def parses_ (parser_, string_):
        return parses(parser_, string_, debug=(debug and not parser.atomic), scope = scope)

    def callWithScope(f, value):
        try:
            return f(value, **scope)
        except:
            return f(value)

    def fNEXT():
        if(len(string) == 0):
            return []

        return [(string[0], string[1:])]

    def fLOOK():
        return [(string, string)]

    def fRETURN(val):
        return [(val, string)]

    def fERROR():
        return []

    def fOR(a, b):
        p1 = parses_(a, string)
        p2 = parses_(b, string)
        return p1 + p2

    def fADD(a, b):
        p1 = parses_(a, string)
        return sum([parses_(b, last) for value, last in p1], [])

    def fBIND(a, f):
        p1 = parses_(a, string)
        return sum([parses_(callWithScope(f, value), last) for value, last in p1], [])

    def fINJECT(str):
        return [(str, str + string)]

    def fCUSTOM(f):
        return f(string)

    results = {
        ptNEXT   : fNEXT,
        ptLOOK   : fLOOK,
        ptRETURN : fRETURN,
        ptERROR  : fERROR,
        ptOR     : fOR,
        ptADD    : fADD,
        ptBIND   : fBIND,
        ptINJECT : fINJECT,
        ptCUSTOM : fCUSTOM
    }.get(parser.type)(*parser.values)

    if debug:
        print "%s gave %s at the input \"%s\"" % (str(parser), str(results), string)

    return results

# Purifies parses, optionally removing nonterminal parses and tails. Returns optionaly only one.
def parse(parser, text, debug=False, mustFinish=True, includeTail=False, returnList=False, allowAmbiguousButEqual=True, scope = {}):
    results = parses(parser, text, debug=debug, scope=scope)

    results = [(result, tail) if includeTail else result for result, tail in results if not (mustFinish and tail != "")]

    if returnList:
        return results
    elif len(results) == 1:
        return results[0]
    elif len(results) == 0:
        raise ValueError("No parse! Using parser '%s' on '%s'" % (parser, text))
    elif allowAmbiguousButEqual and all([results[i] == results[i-1] for i in range(1, len(results))]):
        return results[0]
    else:
        raise ValueError("Ambiguous parse! Using parser '%s' on '%s' returned %s" % (str(parser), text, str(results)))


# Parser that does nothing, returns ()
def empty():
    return pReturn(())

# Does parser and parsers, and applies f to the accumulated result. For tree structures, use lambda: ... and this method will eval that.
def liftP(f, parser, *parsers):
    parser = parser if not isinstance(parser, collections.Callable) else parser()
    return (parser >> (lambda res: liftP(lambda *vals: f(res, *vals), *parsers) if parsers else pReturn(f(res)))
           ).setname("liftP with " + str(map(lambda x: "(%s)" % str(x), [parser] + list(parsers))) + " into " + str(f)).nonatomic()

# Does parser and parsers, and applies f to the accumulated result, and parses using the result. For tree structures, use lambda: ... and this method will eval that.
def liftPP(f, parser, *parsers):
    parser = parser if not isinstance(parser, collections.Callable) else parser()
    return (parser >> (lambda res: liftPP(lambda *vals: f(res, *vals), *parsers) if parsers else f(res))
           ).setname("liftP with " + str(map(lambda x: "(%s)" % str(x), [parser] + list(parsers))) + " into " + str(f)).nonatomic()


# Parser that consumes (and returns) c
def expect(c):
    if len(c) != 1:
        raise ValueError("expect only takes single characters, " + c + " is not!")
    return expectBy(lambda c1: c == c1).setname('expect ' + c)

# Parser that gets a symbol, and fails if f returns False, returns the symbol else.
def expectBy(f):
    return pNext() >> (lambda c: pReturn(c) if f(c) else pError())

# Expects certain character classes

def expectLetter():
    return expectBy(lambda c: c in string.ascii_letters).setname('letter')

def expectUppercase():
    return expectBy(lambda c: c in string.ascii_uppercase).setname('uppercase')

def expectLowercase():
    return expectBy(lambda c: c in string.ascii_lowercase).setname('lowercase')

def expectDigit():
    return expectBy(lambda c: c in string.digits).setname('digit')

def expectHexdigit():
    return expectBy(lambda c: c in string.hexdigits).setname('hexdigit')

def expectOctdigit():
    return expectBy(lambda c: c in string.octdigits).setname('octdigit')

def expectPunctuation():
    return expectBy(lambda c: c in string.punctuation).setname('punctuation')

def expectSpace():
    return expectBy(lambda c: c in string.whitespace).setname('whitespace')

# Parser that consumes str (and returns) c
def text(string):
    return (sum(map(expect, string), empty()) + pReturn(string)).setname('text ' + string)

# Parser that takes string and returns value
def valuePair(string, value):
    return (text(string) + pReturn(value)).setname('value pair \'%s\' to \'%s\'' % (string, value))

# Does parser if possible, empty otherwise
def maybe(parser):
    return (empty() | parser).setname('maybe ' + str(parser))

# Same as many, but at least 1.
def some(parser):
    return (parser >> (lambda out:
           many(parser) >> (lambda rest:
           pReturn ([out] + rest)))).setname('some ' + str(parser))

# Does parser arbitrarily many times, including 0. Returns a list of the results.
def many(parser):
    return (parser >> (lambda out:
           many(parser) >> (lambda rest:
           pReturn ([out] + rest))) | pReturn([])).setname('many ' + str(parser))

# Does f composed with itself more than 0 times, applied to parser
def manyAp(f, parser):
    return (empty() >> (lambda _: f(manyAp(f, parser)) | parser)).setname('many %s applied to %s' % (str(f), str(parser)))

# Does f composed with itself more than 1 times, applied to parser
def someAp(f, parser):
    return manyAp(f, f(parser)).setname('some %s applied to %s' % (str(f), str(parser)))

# Same as many, but end_parser instead of parser at the very end.
def manyWithEnd(parser, end_parser):
    return (many(parser) >> (lambda accum: end_parser >> (lambda final: pReturn(accum + [final]))) | pReturn([])
           ).setname('manyWithEnd (' + str(parser) + '), (' + str(end_parser) + ')')

# Same as some, but end_parser instead of parser at the very end.
def someWithEnd(parser, end_parser):
    return (many(parser) >> (lambda accum: end_parser >> (lambda final: pReturn(accum + [final])))
           ).setname('someWithEnd (' + str(parser) + '), (' + str(end_parser) + ')')

# Same as many, but begin_parser instead of parser at the very beginning.
def manyWithBeginning(begin_parser, parser):
    return (begin_parser >> (lambda begin: many(parser) >> (lambda accum: pReturn([begin] + accum))) | pReturn([])
           ).setname('manyWithBeginning (' + str(begin_parser) + '), (' + str(parser) + ')')

# Same as some, but begin_parser instead of parser at the very beginning.
def someWithBeginning(begin_parser, parser):
    return (begin_parser >> (lambda begin: many(parser) >> (lambda accum: pReturn([begin] + accum)))
           ).setname('someWithBeginning (' + str(begin_parser) + '), (' + str(parser) + ')')

# Consumes begin, does parser, consumes end, returns parser output.
def between(begin, end, parser):
    begin_ = begin if isinstance(begin, Parser) else text(begin)
    end_   = end   if isinstance(end  , Parser) else text(end  )
    return (begin_ + parser >> (lambda x: end_ + pReturn(x))).setname('between ' + str(begin) + ' ' + str(end) + ' with ' + str(parser))

# Between parentheses
def paren(parser):
    return between('(',')', parser)

# Between 0 or more parentheses
def parens(parser):
    return manyAp(paren, parser)

# Between 1 or more parentheses
def parenss(parser):
    return someAp(paren, parser)

# Parses many parser delimited by the string 'delimiter'. PaddingSpaces specifies if the delimiter can be padded by spaces, and 'some' if there must be at least one.
def delimited(parser, delimiter, paddingSpaces = True, some = False):

    delimiter_ = delimiter
    if not isinstance(delimiter, Parser):
        delimiter_ = text(delimiter)

    parser_ = parser
    if paddingSpaces:
        parser_ = many(expectSpace()) + parser < many(expectSpace())

    func = someWithEnd if some else manyWithEnd

    return func(parser_ < delimiter_, parser_).setname('%s %s delimited by %s' % ('some' if some else 'many', str(parser), str(delimiter)))

# Parses many parser(...) delimited by the parser 'delimiter'. The value of delimiter is bound to parser. begin_value is the value passed to the first element. 'paddingSpaces' specifies if the delimiter can be padded by spaces, and 'some' if there must be at least one
def delimitedWith(parser, delimiter, begin_value, paddingSpaces = True, some = False):
    parser__ = parser
    if not isinstance(parser, collections.Callable):
        parser__ = lambda x: parser

    parser_ = parser__
    if paddingSpaces:
        parser_ = lambda x: many(expectSpace()) + parser__(x) < many(expectSpace())

    func = someWithBeginning if some else manyWithBeginning

    return func(pReturn(begin_value) >> parser_, delimiter >> parser_).setname('%s %s delimitedWith by %s (first value %s)' % ('some' if some else 'many', str(parser), str(delimiter), str(begin_value)))





