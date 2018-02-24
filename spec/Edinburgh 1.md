# Specification for Edinburgh 1

Edinburgh 1 uses json as storage. The main object has the following keywords:

* format
* functions
* function-families

## Format

The format of storage as a string string. This should just be "Edinburgh 1"

## Functions

A list (array) of multiplicative function objects, for which the following keywords are supported (\* means required):

* name\*
* symbol\*
* latex
* latex_eval

#### name
The name of the function, for instance "id" or "phi"

#### symbol
The tannakian symbol of the multiplicative function as a string, for example "{1, p}/{I, -I}". Here I is the imaginary unit and p is the prime number we're working at.

#### latex
The latex represantation of the name of the function, for instance "\\\\varphi" (two backspaces to escape the latter). By default, this is "\\\\text{" + name + "}"

#### latex_eval
The latex representation of the function evaluated at "-". For instance, "-^4". Use "\\\\-" to write a normal dash.

## Function Families

Similar to functions, but defines families (like psi<sub>k</sub>) instead of individual functions. Introduces one new keyword, indexed_by. This is a list (array) of the strings which index the functions, for instance ['k']. This is also a required keyword. The other keyword values may contain $k$ and this will be replaced by k once given a value of k. 