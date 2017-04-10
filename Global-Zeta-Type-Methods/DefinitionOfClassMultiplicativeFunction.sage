class MultiplicativeFunction:
    def __init__(self, symbol):
        self.symbol = TS.parseSymbol(symbol)
        if(not self.symbol in symbols):
            print str(self.symbol) + " does not represent any known multiplicative functions! This will cause problems..."
    
    def __repr__(self, latex=true):
        return functionLatexNames[self.symbol]
    
    def _latex_(self):
        return self._repr_(latex=true)
    
    def __call__(self, n, e = None):
        if e == None:
            return functionEvaluations[self.symbol](n)
        else:
            return functionMasterFunctions[self.symbol](n, e)