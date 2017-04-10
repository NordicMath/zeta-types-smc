︠1e4b2cbd-619b-46e6-831e-a3eafcc32ec3s︠
%attach ../Sequence-Methods/Berlekamp.sage
%attach ../Tannakian-Symbol-Methods/TS-Methods.sage
%attach ../Tannakian-Symbol-Methods/RingTannakianSymbols.sage


L = [4, 6, 1, 1, 2, 3, 5, 8, 13, 21, 34]

bmcheck(L)
︡30613d0d-ec0b-4380-bd01-74417d0bc3ac︡{"stderr":"Error in lines 3-3\nTraceback (most recent call last):\n  File \"/projects/sage/sage-7.3/local/lib/python2.7/site-packages/smc_sagews/sage_server.py\", line 976, in execute\n    exec compile(block+'\\n', '', 'single') in namespace, locals\n  File \"\", line 1, in <module>\n  File \"/projects/sage/sage-7.3/local/lib/python2.7/site-packages/smc_sagews/sage_server.py\", line 1021, in execute_with_code_decorators\n    code = code_decorator(code)\n  File \"/projects/sage/sage-7.3/local/lib/python2.7/site-packages/smc_sagews/sage_salvus.py\", line 3363, in attach\n    load(fname)\n  File \"/projects/sage/sage-7.3/local/lib/python2.7/site-packages/smc_sagews/sage_salvus.py\", line 3462, in load\n    exec 'salvus.namespace[\"%s\"] = sage.structure.sage_object.load(*__args, **__kwds)'%t in salvus.namespace, {'__args':other_args, '__kwds':kwds}\n  File \"<string>\", line 1, in <module>\n  File \"sage/structure/sage_object.pyx\", line 992, in sage.structure.sage_object.load (/projects/sage/sage-7.3/src/build/cythonized/sage/structure/sage_object.c:11186)\n    sage.repl.load.load(filename, globals())\n  File \"/projects/sage/sage-7.3/local/lib/python2.7/site-packages/sage/repl/load.py\", line 290, in load\n    exec(preparse_file(open(fpath).read()) + \"\\n\", globals)\n  File \"<string>\", line 6\n    import ../General-Tools/LazyList\n           ^\nSyntaxError: invalid syntax\n"}︡{"done":true}︡
