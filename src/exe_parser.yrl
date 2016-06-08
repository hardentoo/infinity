
% Copyright Groupoid Infinity, Inc.

Nonterminals names type clauses clause pattern patterns forms form fields fields2 field list.
Terminals    int str1 str2 var atom ':=' '(' ')' '->' ',' '.' '|' ']' '[' ':' '()' '{' '}' '*'
             case of let in data record extend
             try do raise
             lambda fun pi forall
             spawn send receive.
Rootsymbol   forms.

forms        -> '$empty'                                       : [].
forms        -> form forms                                     : ['$1'|'$2'].
form         -> '(' form ')'                                   : '$2'.
form         -> fun    var ':' type               ':=' clauses : {'fun',          line('$1'), '$2','$4'}.
form         -> fun        ':' type               ':=' clauses : {'fun',          line('$1'), [],  '$3'}.
form         -> data   var ':' type               ':=' fields  : {'data',   '$2', line('$1'), '$4', '$6'}.
form         -> data       ':' type               ':=' fields  : {'data',   [],   line('$1'), '$3', '$5'}.
form         -> record var ':' type               ':=' fields  : {'record', '$2', line('$1'), '$4', [],   '$6'}.
form         -> record     ':' type               ':=' fields  : {'record', [],   line('$1'), '$3', [],   '$5'}.
form         -> record var ':' type extend fields ':=' fields  : {'record', '$2', line('$1'), '$4', '$6', '$8'}.
form         -> record     ':' type extend fields ':=' fields  : {'record', [],   line('$1'), '$3', '$5', '$7'}.
form         -> receive form of clauses                        : {'receive',      line('$1'), '$2', '$4'}.
form         -> case form of clauses                           : {'case',         line('$1'), '$2', '$4'}.
form         -> let fields in form                             : {'let',          line('$1'), '$2', '$4'}.
form         -> list                                           : '$1'.
form         -> type                                           : '$1'.

list         -> '[' ']'				     : {nil,line('$1')}.
list         -> '[' list ']'	         : consify('$2', {nil,line('$1')}).
list         -> '[' form '|' list ']'    : consify('$2', '$4').

names        -> '$empty'	    	     : [].
names        -> var names  		         : ['$1'|'$2'].

type         -> '*'                                  : '$1'.
type         -> '()'                                 : '$1'.
type         -> '(' type ')'                         : '$2'.
type         -> var                                  : '$1'.
type         -> '(' names ':' type ')' '->' type     : {pi,   '$2','$4','$7'}.
type         -> type type                            : {app,  '$1','$2'}.
type         -> type '->' type                       : {arrow,'$1','$3'}.

clauses      -> clause				     : ['$1'].
clauses      -> clause  '|'  clauses	 : ['$1'|'$3'].
clause       -> pattern '->' form        : {clause,line('$1'),'$1','$3'}.

patterns     -> pattern					     : ['$1'].
patterns     -> pattern ',' patterns         : ['$1'|'$3'].
pattern      -> '(' pattern ')'			     : '$2'.
pattern      -> '[' ']'					     : {nil,line('$1')}.
pattern      -> '[' patterns ']'			 : consify('$2', {nil,line('$1')}).
pattern      -> '[' patterns '|' pattern ']' : consify('$2', '$4').
pattern      -> var names				     : {tuple,'$1',line('$1'),'$2'}.

fields       -> '()'                         : [].
fields       -> field fields2                : ['$1'|'$2'].
fields2      -> '$empty'                     : [].
fields2      -> field fields2                : ['$1'|'$2'].
field        -> '(' var ':' form ')'         : {field,'$2','$4'}.

Erlang       code.

line([T|_])              -> line(T);
line(T) when is_tuple(T) -> element(2, T).

consify([], T)           -> T;
consify([H|Hs], T)       -> {cell,element(2,H),H,consify(Hs, T)}.