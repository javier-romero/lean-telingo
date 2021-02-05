% clingo example1.lp --output=reify | clingo - ../meta-encodings/meta-tel.lp -c lambda=5

%
% Domain predicates
%

dom(1..1).


%
% Temporal program
%

{next(a(X))}             :- dom(X), initially.
next(next(always(b(X)))) :- a(X).
c(X)                     :- prev(always(b(X))).


%
% Display
%

#show show(a(X)) : dom(X). % corresponds to #show a(X) : a(X), dom(X).
#show show(b(X)) : dom(X). % corresponds to #show b(X) : b(X), dom(X).
#show show(c(X)) : dom(X). % corresponds to #show c(X) : c(X), dom(X).


%
% Externals (for all temporal atoms in the bodies)
%

#external initially.
#external a(X) : dom(X).
#external prev(always(b(X))) : dom(X).
