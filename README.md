# Zeta Types (Sage)
***Implementation of Tannakian symbols and multiplicative functions in sagemath*** <p>
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## Description
This repository is cleaned up version of the Sagemath cloud (project this was forked from). It will let you use code for computing with Tannakian Symbols and Multiplicative Functions.

## Installation
There are two main ways to install:

#### Create a CoCalc Project (and account if you haven't already)
The advantage of using CoCalc is that it works on all operating systems, and Sagemath is already installed. Everything can be done free of charge, but we recommend paying for CoCalc, as the services it provides are excellent.



If you want to pay for Internet access, you can create a terminal and write 'git clone "https://github.com/NordicMath/zeta-types-smc/"'.


If you don't want to pay, download a release (for instance [https://github.com/NordicMath/zeta-types-smc/releases/tag/v1.1](https://github.com/NordicMath/zeta-types-smc/releases/tag/v1.1)), upload it to CoCalc, and unpack the zip file.

#### Clone/download to your own computer
This requires installation of sage, which only works on the Linux operating system (one can also virtualise Linux on windows or mac using VirtualBox, VMWare, or similar)

1. Install Sagemath
2. Clone "https://github.com/NordicMath/zeta-types-smc/" or download [https://github.com/NordicMath/zeta-types-smc/releases/tag/v1.1](https://github.com/NordicMath/zeta-types-smc/releases/tag/v1.1)) to your own computer 

### Usage

Inside demo you can test out and use the code we have shown. In particular, Edinburgh Notebook.ipynb contains a tutorial for using the code.

### Help

Technical help will always be available by mailing Torstein Vik  ([torsteinv64@gmail.com](mailto:torsteinv64@gmail.com)).

## Current features

#### Tannakian symbols
* Tannakian symbols for any monoid, ring, and the complex numbers (with increasingly more features)
* Algorithms to find the (Complex) Tannakian symbol for any sequence 
* Tannakian symbol structure methods, such as upstairs and downstairs multisets, super-, odd-, and even dimension, augmentation, and whether a Tannakian symbol is a line element
* Tannakian symbol circle- and box-operations 
* Bell derivative of Tannakian symbols and sequences

#### LazyList
* So called LazyLists, which are lazily evaluated potentially infinite sequences of numbers
* Various ways of combinating and using these

#### Multiplicative Functions
* Parsing libraries of multiplicative functions (spec. in Edinburgh 1 format, data file in /data)
* Library 'search' for multiplicative functions, including infinite families of multiplicative functions such as phi_k.
* Multiplicative function features:
    * Evaluation
    * Convolutions and operations
    * Latex printing
    * Latex-evaluation printing
    * Keeping track of the "history" of a multiplicative function (how it was built up)

## Usage Examples

See files inside demo

## Contributors

_Ask Torstein ([torsteinv64@gmail.com](mailto:torsteinv64@gmail.com)) to add you here if you contribute to this project_
* Magnus Hellebust Haaland
* Olav Hellebust Haaland
* Andreas Holmstrom
* Torstein Vik

## Copyright


This framework is and will remain completely open source, under the GNU General Public License version 3+:

    Copyright (C) 2017, Torstein Vik, Andreas Holmstrom, Magnus Hellebust Haaland, Olav Hellebust Haaland.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    

## Languages/Frameworks

* Code: Sagemath
* Demos: Jupyter Notebook

## Folder structure

* /src/ -- Source directory, where the original Sagemath code is.
* /src/mf -- Sage code for multiplicative functions
* /src/ts -- Sage code for Tannakian symbols
* /src/util -- Sage code for lazy lists, and the Berlekamp-Massey algorithm (utility functionality) 
* /zetatypes/ -- The preparsed python-compatible code
* /zetatypes/mf -- Python code for multiplicative functions
* /zetatypes/ts -- Python code for Tannakian symbols
* /zetatypes/util -- Python code for lazy lists, and the Berlekamp-Massey algorithm (utility functionality) 
* /spec -- Specification for formats (currently Edinburgh 1 format)
* /data -- Example data. Currently contains a set of the most common multiplicative functions, in the Edinburgh 1 format.
* /demo -- Contains Jupyter notebooks with extensive usage examples of the code, as well as an automated identity explorer that can produce arbitrarily many identities between multiplicative functions.
