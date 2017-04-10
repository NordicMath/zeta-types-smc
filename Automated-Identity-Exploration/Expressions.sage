class Identity:
    def __init__(self,LHS, RHS):
        self.LHS = LHS
        self.RHS = RHS
        
    def verify(self):
        return self.LHS.evaluate() == self.RHS.evaluate()
     
    def __repr__(self, latex=false):
        return ("$$" if latex else "") + self.LHS.__repr__(latex=latex) + " = " + self.RHS.__repr__(latex=latex) + ("$$" if latex else "")
    
    def _latex_(self):
        return self.__repr__(latex=true)
    
    def isExpressionallyEquivalent(self):
        return self.LHS.isExpressionallyEquivalent(self.RHS)
    
# Abstract element of an expression
class Expression(object):
    def __repr__(self, latex=false):
        return "something is wrong"
        
    def evaluate(self):
        return "something is wrong"
        
    def cost(self):
        return "something is wrong"
    
    def _latex_(self):
        return self.__repr__(latex=true)
    
    def isExpressionallyEquivalent(self, other):
        return False

functionNames = False

# Wrapper for Tannakian Symbols that extends expression
class Symbol(Expression):
    def __init__(self, symbol):
        self.symbol = symbol
    
    def __repr__(self, latex=false):
        if functionNames:
            return self.functionRepr()
        else:
            return self.symbol._repr_(latex=latex)
    
    def functionRepr(self):
        return functionLatexEvaluations[self.symbol]('n')
    
    def evaluate(self):
        return self.symbol
    
    def cost(self):
        sum=0
        for e, a in self.symbol:
            sum += abs(a)
        return sum;
    
    def isExpressionallyEquivalent(self, other):
        return isinstance(other, Symbol) and self.symbol == other.symbol

class BinaryOperation(Expression):
    expression1 = None
    expression2 = None
    
    def __init__(self,expression1,expression2):
        self.expression1=expression1
        self.expression2=expression2
        
    def isExpressionallyEquivalent(self, other):
        return isinstance(other, BinaryOperation) and (( self.expression1.isExpressionallyEquivalent(other.expression1) and self.expression2.isExpressionallyEquivalent(other.expression2)) or                     (self.expression1.isExpressionallyEquivalent(other.expression2) and self.expression2.isExpressionallyEquivalent(other.expression1)))
    
# Wrapper for the direct sum of two other expressions
class DirectSum(BinaryOperation):
    def __repr__(self, latex=false):
        return expressionText(self.expression1, latex=latex) + (" \\oplus " if latex else " + ") + expressionText(self.expression2, latex=latex)
    
    def evaluate(self):
        return self.expression1.evaluate() + self.expression2.evaluate()
    
    def cost(self):
        return self.expression1.cost() + self.expression2.cost() + 1
    
    def isExpressionallyEquivalent(self,other):
        return isinstance(other, DirectSum) and BinaryOperation.isExpressionallyEquivalent(self, other)

class DirectDifference(BinaryOperation):
    def __repr__(self, latex=false):
        return expressionText(self.expression1, latex=latex) + (" \\ominus " if latex else " - ") + expressionText(self.expression2, latex=latex, parentheses=true)
    
    def evaluate(self):
        return self.expression1.evaluate() - self.expression2.evaluate()
    
    def cost(self):
        return self.expression1.cost() + self.expression2.cost() + 1

    def isExpressionallyEquivalent(self,other):
        return isinstance(other, DirectDifference) and BinaryOperation.isExpressionallyEquivalent(self, other)
    
class TensorProduct(BinaryOperation):
    def __repr__(self, latex=false):
        return expressionText(self.expression1,latex=latex, parentheses=true) + (" \\otimes " if latex else " * ") + expressionText(self.expression2, latex=latex, parentheses=true)
    
    def evaluate(self):
        return self.expression1.evaluate() * self.expression2.evaluate()
    
    def cost(self):
        return self.expression1.cost() + self.expression2.cost() + 2

    def isExpressionallyEquivalent(self,other):
        return isinstance(other, TensorProduct) and BinaryOperation.isExpressionallyEquivalent(self, other)
    
# Small helper function to parenthesize when necessary (expression not a symbol)
def expressionText(expression, latex=false, parentheses=false):
    if isinstance(expression, Symbol) or not parentheses:
        return expression.__repr__(latex=latex)
    else:
        return "(" + expression.__repr__(latex=latex) + ")"

# Parses an expression in string form.
# Conventions:
# Direct sum - +
# Tannakian Symbol - inherit

# Order of operations:
# 0 - Symbol
# 1 - Direct sum / difference
#

# Algorithm:
# Split by spaces.
# Ignore empty strings.
# If it is a special character (+, -) then:
#   - create an operation expression.
# Otherwise interpret as tannakian symbol.

# Currently on hold so I can work on more interresting things
def parseExpression(string, toPriority = -1):
    if(string == ""):
        return None
    
    topExpression = None;
    currentStringLeft = string
    parts = splitOutside(string)
    for p in parts:
        if p == "":
            continue
        currentStringLeft = currentStringLeft.replace(p,'',1)
        if getPriority(p) < toPriority :
            break
        else:
            if p == "+":
                topExpression = DirectSum(topExpression, None)
            elif p == "-":
                topExpression = DirectDifference(topExpression, None)
            else:
                if topExpression is None:
                    topExpression = Symbol(TS.parseSymbol(p))
                elif isinstance(topExpression, BinaryOperation) and topExpression.expression2 is None:
                    topExpression.expression2 = Symbol(TS.parseSymbol(p))
                else:
                    print "parsing error on: " + p

    return topExpression
        
# Helper function, returns expression-priority of a string:
def getPriority(part):
    if part == "*":
        return 2
    elif part == "+" or part == "-" :
         return 1
    else: # Should only be a Tannakian symbol.
        return 10

# Helper function, returns string split with delimiter outside paranthesis.
def splitOutside(string):
    paranthesisCount = 0
    bracketCount = 0
    
    lastIndex = -1
    
    parts = []
    for i, s in enumerate(string):
        if(s == r"{"):
            bracketCount+=1
        elif(s == r"}"):
            bracketCount-=1
        elif(s == r"("):
            paranthesisCount+=1
        elif(s == r")"):
            paranthesisCount-=1
        elif(s == " " and paranthesisCount == 0 and bracketCount == 0):
            parts.append(string[lastIndex + 1: i])
            lastIndex = i
    parts.append(string[lastIndex + 1:])
            
    return parts