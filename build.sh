#!/bin/bash

for f in $( cd src && find * -type f -name "*.sage" ); do
    sage -q -preparse src/$f
    mv src/$f.py zetatypes/${f%.*}.py
    echo Compiled $f
done

