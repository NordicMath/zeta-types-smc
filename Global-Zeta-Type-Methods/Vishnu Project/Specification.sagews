︠efb31f34-8f78-4862-b22c-4749ca004b6a︠
SPECIFICATION FOR LOCAL ZETA TYPES

1. A class LocalZetaType that works as a kind of "Vishnu" thing for a single row.

2. Methods for creating a LocalZetaType instance from a list of point counts, from a list of Bell coefficients, from a Tannakian symbol, from a local zeta function.

3. Methods for performing our four binary operations on local zeta types.

4. Methods for performing our four types of Adams operations on local zeta types.

5. Methods for performing lamda operations, gamma operations, and symmetric power operations on local zeta types.

6. Methods for performing Bell derivative and Bell antiderivative on local zeta types.

7. Methods for extracting the various parts of a local zeta type as a single number, as a list or as a Tannakian symbol (according to what is appropriate).

8. Methods for printing any specified part of the local zeta type in LaTeX format.

9. Method(s) for equality checking.

10. Methods for archimedean and p-adic weight computation and pruning.

Discussion:

Suggestion: Do NOT include any form of metadata/namespace information on the local level, the gains are not worth the extra work.

Q: How do we handle the fact that Bell coefficient rows may not be linearly recursive, or be linearly recursive but with unknown recursion formula?
Partial solution: When appropriate, for zeta types known to be rational, to use the local zeta function as internal representation of the data.


SPECIFICATION FOR GLOBAL ZETA TYPES

1. A class GlobalZetaType that works as a kind of "Vishnu" thing.

2. Methods for creating a GlobalZetaType instance from an array of point counts, from an array of Bell coefficients, from a list of Tannakian symbols, from a list of local zeta functions, from a sequence of Fourier coefficients, and from a list of local zeta types.

3. Methods for performing our four binary operations on global zeta types (inherited from local case)

4. Methods for performing our four types of Adams operations on global zeta types (inherited from local case)

5. Methods for performing lamda operations, gamma operations, and symmetric power operations on global zeta types (inherited from local case)

6. Methods for performing Bell derivative and Bell antiderivative on global zeta types (inherited from local case)

7. Methods for extracting various parts of the global zeta type as a single number, as a list, as an array, or as Tannakian symbols.

8. Methods for printing any specified part of the global zeta type in LaTeX format

9. Method(s) for equality checking.

10. Methods for archimedean and p-adic weight computation and pruning.

11. Namespace for storing optional metadata, like conductor

12. Methods for creating and working with the associated multiplicative function???

13. Methods for creating and working with the associated global zeta function???

14. Methods for computing global pairings and invariants, like Selberg inner product, norm, Sato-Tate moments, etc.

# zt1.add(zt2) -> zt1 endres, eller returnere en verdi???
# zetatypes.add(zt1, zt2) <-------------------------------------------
# zt1 + zt2 men ka me boxplus?
# 

# Use sage's coercion system for type safety
zetatypes = new Zetatypes()
z1 = zetatypes.fromTannakianSymbol(...)
z2 = zetatypes.scalarmult(z1, 2)


### BIG PROBLEM: EQUALITY CHECKING (both with respect to metadata, range differences, and rounding problems)

# MAYBE!!!
namespace.conductor = 20
namespace.monoidaly_safe = true

zetatypes.metadataHandler.addPropertyPreservevance(operation, property, handler)

handler : function property1 property2 -> property




















