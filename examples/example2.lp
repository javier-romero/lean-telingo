% clingo example2.lp --output=reify | clingo - ../meta/meta-tel.lp -c lambda=5 0

%
% Domain predicates
%

dom(1..1).


%
% Temporal program
%

next(eventually(until(a(X),b(X)))) :- dom(X), initially.


%
% Display
%

#show show(a(X)) : dom(X). % corresponds to #show a(X) : a(X), dom(X).
#show show(b(X)) : dom(X). % corresponds to #show b(X) : b(X), dom(X).


%
% Externals (for all temporal atoms in the bodies)
%

#external initially.
