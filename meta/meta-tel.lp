%
% Meta-encoding using hold(A,T)
%

conjunction(B,T) :- literal_tuple(B), time(T),
        hold(L,T) : literal_tuple(B, L), L > 0;
    not hold(L,T) : literal_tuple(B,-L), L > 0.

body(normal(B),T) :- rule(_,normal(B)), conjunction(B,T), time(T).
body(sum(B,G),T)  :- rule(_,sum(B,G)), time(T),
    #sum { W,L :     hold(L,T), weighted_literal_tuple(B, L,W), L > 0 ;
           W,L : not hold(L,T), weighted_literal_tuple(B,-L,W), L > 0 } >= G.

  hold(A,T) : atom_tuple(H,A)   :- rule(disjunction(H),B), body(B,T), time(T).
{ hold(A,T) : atom_tuple(H,A) } :- rule(     choice(H),B), body(B,T), time(T).

time(0..lambda).

#show.
#show (S,T) : output(show(S),_), true(S,T).


%
% Connect true/2 with hold/2
% * WARNING: This is dependent on how clingo reifies the program!
%            I do not know how to make it completely general: is it even possible?
%

true(O,T) :- hold(L,T), output(O,B), literal_tuple(B,L).
hold(L,T) :- true(O,T), output(O,B), literal_tuple(B,L).


%
% Temporal connectives using true/2
%

% formulas
formula(O) :- output(O,_).

% initially
true(initially,0) :-       formula(initially).
:- true(initially,T), T>0, formula(initially).

% finally
true(finally,lambda) :-       formula(initially).
:- true(finally,T), T<lambda, formula(initially).

% weak prev
formula(F) :- formula(prev(F)).
%
true(F,T-1) :- true(prev(F),T), formula(prev(F)), time(T), time(T-1).
true(prev(F),T) :- true(F,T-1), formula(prev(F)), time(T), time(T-1).

% weak next
formula(F) :- formula(next(F)).
%
true(F,T+1) :- true(next(F),T), formula(next(F)), time(T), time(T+1).
true(next(F),T) :- true(F,T+1), formula(next(F)), time(T), time(T+1).

% always
formula(F) :- formula(always(F)).
%
true(F,TT) :- true(always(F),T),  time(TT), TT>=T; formula(always(F)), time(T).
true(always(F),T) :- true(F,TT) : time(TT), TT>=T; formula(always(F)), time(T).

% eventually
formula(F) :- formula(eventually(F)).
%
true(F,TT) : time(TT), TT>=T :- true(eventually(F),T),  formula(eventually(F)), time(T).
true(eventually(F),T)  :- time(TT), TT>=T, true(F,TT),  formula(eventually(F)), time(T).

% until
%
% (check this!)
%
formula(F) :- formula(until(F,G)).
formula(G) :- formula(until(F,G)).
%
true(until(F,G),T1,T2) : time(T2), T2>=T1 :- true(until(F,G),T1),    formula(until(F,G)), time(T1).
true(until(F,G),T1) :-   time(T2), T2>=T1,   true(until(F,G),T1,T2), formula(until(F,G)), time(T1).

%
% definition of true(until(F,G),T1,T2)
%
true(F,T3) :- formula(until(F,G)), time(T1), time(T2), T1<=T2,
              true(until(F,G),T1,T2), time(T3), T1<=T3, T3<T2.
true(G,T2) :- formula(until(F,G)),           time(T2),
              true(until(F,G),_,T2).
true(until(F,G),T1,T2) :- formula(until(F,G)), time(T1), time(T2), T1<=T2,
                          true(G,T2), true(F,T3) : time(T3), T1<=T3, T3<T2.


%
% Defined predicates
%

#defined literal_tuple/1.
#defined literal_tuple/2.
#defined rule/2.
#defined atom_tuple/2.
#defined weighted_literal_tuple/3.
