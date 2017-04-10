︠5cd3beae-18c7-482e-970c-3c74477b11f1︠
%attach ../General-Tools/LazyList.sage
%attach ../TS-Methods/MonoidTS.sage
%attach ../TS-Methods/RingTS.sage
%attach ../Sequence-Methods/Berlekamp.sage
%attach ../TS-Methods/ComplexTS.sage

%attach ../Classical-Multiplicative-Functions/Multiplicative-Function.sage
%attach ../Classical-Multiplicative-Functions/Multiplicative-Function-Library.sage

import itertools

loadMultiplicativeLibrary()
defineMF()

funcs = list(itertools.islice(multiplicativeFunctionLibrary, 25))

funcSums = [l + r for l in funcs for r in funcs]

for lhs in funcSums:
    for rhs in funcSums:
        if lhs == rhs:
            print lhs, "=", rhs

︡74e6b9ed-eb3b-4abf-96ab-6579ba37a152︡{"stdout":"tau_4 = tau_4\ncore = core\nchar_fn_squares = char_fn_squares\nmu = mu\nsigma = sigma\nsigma = sigma_1\ngamma = gamma\neuler_phi = euler_phi\ntheta = theta\ntheta = psi_0\nliouville = liouville\nid = id\ndedekind_psi = dedekind_psi\ndedekind_psi = zero\ndedekind_psi = jordan_0\ntau = tau\ntau = sigma_0\nzero = dedekind_psi\nzero = zero\nzero = jordan_0\none = one\none = id_0\nchar_fn_squarefree = char_fn_squarefree\ntau_3 = tau_3\nid_2 = id_2\nid_3 = id_3\nbeta = beta\npsi_0 = theta\npsi_0 = psi_0\nsigma_0 = tau\nsigma_0 = sigma_0\njordan_0 = dedekind_psi\njordan_0 = zero\njordan_0 = jordan_0\nid_0 = one\nid_0 = id_0\npsi_1 = psi_1\nsigma_1 = sigma\nsigma_1 = sigma_1\n"}︡{"done":true}︡









