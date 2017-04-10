def FLCompile(str):
    scope = {}
    defs, udefs = parse(compiler, str, scope = scope)
    
    if [x for x in udefs if (x not in defs)] :
        print "Identifiers not defined! : {0}".format([x for x in udefs if (x not in defs)])
        return {}

    return defs

def Compile(path):
    with open(path, 'r') as file:
        return FLCompile(file.read())

letter          = reduce(lambda c1, c2: c1 | c2, map(lambda c: text(c),string.ascii_letters + "-_1234567890"))
word            = some(letter)
path            = some(letter | text('.') | text('/'))
pure_identifier = word

fileimport = (text("IMPORT ") + path < text(".flf")) >> (lambda w: pReturn((Compile(w), [])))


variable   = pure_identifier
assignment = ((pure_identifier & (many(variable) < pSpaces + text(' := ') + pSpaces)) >> (lambda (ident, vars): pReturn((ident, vars)) & expression(vars))) >> (lambda ((ident, vars), (expr, udefs)): ({ident: lambda inp: expr(inp)}, udefs))

line = text("") | fileimport | assignment

compiler = (line + pSpaces + text('\n') & compiler) >> (lambda ((defs1, defs2), (udefs1, udefs2)): (defs1.extend(defs2), udefs1 + udefs2))

def expression(vars):
    return ()