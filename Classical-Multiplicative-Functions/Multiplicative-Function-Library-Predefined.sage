# Grand dictionary of the latex names of various multiplicative functions
functionLatexNames = {TS.parseSymbol(k): v for k, v in {
        'Ø/Ø': r'\mathbf{0}',
        '{1}/Ø': r'\mathbf{1}',
        'Ø/{1}': r'\mu',
        '{p}/Ø': r'id',
        '{p^2}/Ø': r'id_2',
        '{p^3}/Ø': r'id_3',
        '{1, 1}/Ø': r'\tau',
        '{1, p}/Ø': r'\sigma_1',
        '{1, p^2}/Ø': r'\sigma_2',
        '{1, p^3}/Ø': r'\sigma_3',
        '{p}/{1}': r'\varphi',
        '{-1}/Ø': r'\lambda',
        '{1}/{2}': r'\gamma',
        '{1, -1}/Ø': r'\varepsilon_2',
        'Ø/{-1}': r'\xi_2',
        '{1, 1, 1}/Ø': r'\tau_3',
        '{1, 1, 1, 1}/Ø': r'\tau_4',
        '{p^2}/{1}': r'J_2',
        '{p^3}/{1}': r'J_3',
        '{p,-1}/Ø': r'\beta',
        '{1}/{1-p}': r'core',
        '{1}/{-1}': r'\theta',
        '{p}/{-1}': r'\psi',
        '{p^2}/{-1}': r'\psi_2',
        '{p^3}/{-1}' : r'\psi_3'}.items()}

# Induced dictionary of the written evaluation of a function
functionLatexEvaluations = {k: (lambda n, v=v: v + '(' + str(n) + ')') for k, v in functionLatexNames.items()}

# Exceptions:
functionLatexEvaluations[TS.parseSymbol('{1}/Ø')] = lambda n: '1'
functionLatexEvaluations[TS.parseSymbol('{p}/Ø')] = lambda n: str(n)
functionLatexEvaluations[TS.parseSymbol('{p^2}/Ø')] = lambda n: str(n) + '^2'
functionLatexEvaluations[TS.parseSymbol('{p^3}/Ø')] = lambda n: str(n) + '^3'

# Induced list of Tannakian Symbols that have multiplicative functions attached
symbols = list(functionLatexEvaluations.keys())

# Grand dictionary of multiplicative functions and their associated master function. The excpetion at e = 0 is handled.
functionMasterFunctions = {TS.parseSymbol(k): (lambda p, e, v=v: 1 if e == 0 else v(p, e)) for k, v in {
        'Ø/Ø':             lambda p, e: 0,
        '{1}/Ø':           lambda p, e: 1,
        'Ø/{1}':           lambda p, e: -1 if e == 1 else 0,
        '{p}/Ø':           lambda p, e: p^e,
        '{p^2}/Ø':         lambda p, e: p^(2*e),
        '{p^3}/Ø':         lambda p, e: p^(3*e),
        '{1, 1}/Ø':        lambda p, e: e + 1,
        '{1, p}/Ø':        lambda p, e: (p^(e + 1) - 1)/(p - 1),
        '{1, p^2}/Ø':      lambda p, e: (p^(2*(e + 1)) - 1)/(p - 1),
        '{1, p^3}/Ø':      lambda p, e: (p^(3*(e + 1)) - 1)/(p - 1),
        '{p}/{1}':         lambda p, e: p^e - p^(e - 1),
        '{-1}/Ø':          lambda p, e: (-1)^(e % 2),
        '{1}/{2}':         lambda p, e: -1,
        '{1, -1}/Ø':       lambda p, e: 1 if e % 2 == 0 else 0,
        'Ø/{-1}':          lambda p, e: 1 if e < 2 else 0,
        '{1, 1, 1}/Ø':     lambda p, e: binomial(e + 2, e),
        '{1, 1, 1, 1}/Ø':  lambda p, e: binomial(e + 3, e),
        '{p^2}/{1}':       lambda p, e: p^(2*e) - p^(2*(e-1)),
        '{p^3}/{1}':       lambda p, e: p^(3*e) - p^(3*(e-1)),
        '{p,-1}/Ø':        lambda p, e: (p^(e+1) + (-1)^e)/(p+1),
        '{1}/{1-p}':       lambda p, e: p,
        '{1}/{-1}':        lambda p, e: 2,
        '{p}/{-1}':        lambda p, e: p^e + p^(e-1),
        '{p^2}/{-1}':      lambda p, e: p^(2*e) + p^(2*(e-1)),
        '{p^3}/{-1}' :     lambda p, e: p^(3*e) + p^(3*(e-1))}.items()}

# Induced dictionary of the global evaluation of a multiplicative function

functionEvaluations = {k: (lambda n, v=v: reduce(lambda x, y: x * y, itertools.starmap(v, factor(n)), 1)) for k, v in functionMasterFunctions.items()}
