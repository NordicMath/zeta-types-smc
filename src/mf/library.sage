import collections
import json
import re
import itertools
import ast


number_parse = r"-?\d+|\d*\.\d+"

class MultiplicativeFunctionLibrary(object):
    def __init__(self):
        self.library = {}

    def __contains__(self, name):
        for reg, v in self.library.iteritems():
            res = reg.match(name)
            if res:
                return True
        return False

    def __getitem__(self, name):
        for reg, v in self.library.iteritems():
            res = reg.match(name)
            if res:
                if v.family:
                    params = {}
                    for k in v.family_vars:
                        params[k] = ast.literal_eval(res.group(k))
                    return v.get(**params)
                else:
                    return v.get()
        raise KeyError("Multiplicative Function not found.")

    
    def __iter__(self):
        singles = filter(lambda v: not v.family, self.library.values())
        fams = filter(lambda v: v.family, self.library.values())

        for v in singles:
            yield v.get()

        for level in itertools.count(0):
            for v in fams:
                yield v.get(k = level)

    def printLoaded(self):
        singles = filter(lambda v: not v.family, self.library.values())
        fams = filter(lambda v: v.family, self.library.values())

        for v in singles:
            print v.get()


        for v in fams:
            print v.params['name'].replace('$k$', 'k')

    def __setitem__(self, name, val):
        reg = re.escape(name)
        if val.family:
            for var in val.family_vars:
                reg = reg.replace(r"\$" + var + r"\$", "(?P<" + var + ">" + number_parse + ")")

        self.library[re.compile(reg + "\Z")] = val


class MultiplicativeFunctionObject(object):
    def __init__(self, family, family_vars, **kwargs):
        self.params = kwargs
        self.family = family
        self.family_vars = family_vars

    def varReplace(self, s, pars):
        if s:
            rep = {re.escape("$" + k + "$"): str(v) for k, v in pars.iteritems()}
            return re.sub( "|".join(rep.keys()), lambda m: rep[re.escape(m.group(int(0)))], s)
        else:
            return None

    def get(self, **parameters):
        return AtomicMultiplicativeFunction(**({k: self.varReplace(v, parameters) for k, v in self.params.iteritems()} if self.family else self.params))



multiplicativeFunctionLibrary = MultiplicativeFunctionLibrary()

def burnMultiplicativeLibrary():
    multiplicativeFunctionLibrary = MultiplicativeFunctionLibrary()

def defineMF():
    global mf
    mf = multiplicativeFunctionLibrary.__getitem__
    global mfd
    mfd = lambda dname, name=None: mf(dname).define(name=name)

def loadMultiplicativeLibrary(source):
    data = json.load(open(source, "r"))

    if data["format"] == "Edinburgh 1":
        parseEdinburgh1(data)
    else:
        print "Data version of JSON file is unknown. Will not parse. "

def parseEdinburgh1(data):
    for obj in data["functions"]:
        if not "name" in obj:
            raise KeyError("All multiplicative functions must have a name")
        multiplicativeFunctionLibrary[obj["name"]] = MultiplicativeFunctionObject(name        =obj.get("name"), 
                                                                                  symbol      =obj.get("symbol"), 
                                                                                  latex       =obj.get("latex"), 
                                                                                  latex_eval  =obj.get("latex_eval"),
                                                                                  family      =False,
                                                                                  family_vars  =None)

    for obj in data["function-families"]:
        if not "name" in obj:
            raise KeyError("All multiplicative functions must have a name")
        multiplicativeFunctionLibrary[obj["name"]] = MultiplicativeFunctionObject(name        =obj.get("name"), 
                                                                                  symbol      =obj.get("symbol"), 
                                                                                  latex       =obj.get("latex"), 
                                                                                  latex_eval  =obj.get("latex_eval"),
                                                                                  family      =True,
                                                                                  family_vars  =obj.get("indexed_by"))


