  count_sort([], []).
  count_sort([H], [H]).
  count_sort(List, Sorted) :- c_sort(List, Sorted).

  c_sort(List, Sorted) :- find_min(List, Min), find_max(List, Max), count(List, Min, Max, [], Res), my_sort(Res, Min, 0, [], Sorted).


  find_max([H|T], Max) :- maximum(T, H, Max).

  maximum([H], CurrMax, CurrMax) :- H =< CurrMax, !.
  maximum([H], CurrMax, H) :- H > CurrMax, !.
  maximum([H|T], CurrMax, Max) :- CurrMax < H, NewMax is H, maximum(T, NewMax, Max).
  maximum([H|T], CurrMax, Max) :- CurrMax >= H, maximum(T, CurrMax, Max).

  find_min([H|T], Min) :- minimum(T, H, Min).

  minimum([H], CurrMin, CurrMin) :- H > CurrMin, !.
  minimum([H], CurrMin, H) :- H =< CurrMin, !.
  minimum([H|T], CurrMin, Min) :- CurrMin > H, NewMin is H, minimum(T, NewMin, Min).
  minimum([H|T], CurrMin, Min) :- CurrMin =< H, minimum(T, CurrMin, Min).

  count(_, Min, Max, Acc, Acc) :- Max < Min.
  count(List, Min, Max, Acc, Res) :- Max >= Min, how_many(Max, List, 0, Amount), Next is Max - 1, count(List, Min, Next, [Amount|Acc], Res).


  how_many(_, [], Curr, Curr).
  how_many(Elem, [H|T], Curr, Amount) :- Elem \= H, how_many(Elem, T, Curr, Amount).
  how_many(Elem, [H|T], Curr, Amount) :- Elem = H, NextCurr is Curr + 1, how_many(H, T, NextCurr, Amount).

  my_sort([], _, _, Acc, Acc).
  my_sort([H|T], Min, Iter, Acc, Sorted) :- H > 0, X is Iter + Min, NewH is H - 1, my_sort([NewH|T], Min, Iter, [X|Acc], Sorted).
  my_sort([0|T], Min, Iter, Acc, Sorted) :- NewIter is Iter + 1, my_sort(T, Min, NewIter, Acc, Sorted).


  czy_graficzny(List, Res) :- count_sort(List, Sorted), sequence(Sorted, _Temp, Res).

  sequence([-1|_], _,false).
  sequence([0], _,true).
  sequence([0|T], Temp, Res) :- sequence(T, Temp, Res).
  sequence([H|T], Temp, Res) :- subtract(H, T, 0, [], Temp), Temp \= false ->  (count_sort(Temp, Sorted), sequence(Sorted, _Temp, Res)) ; 
    (Temp = false, sequence([-1], _Temp, Res), !).

  subtract(Sub, [], Iter, Acc, Acc) :- Sub = Iter, !.
  subtract(Sub, [], Iter, _, false) :- Sub > Iter, !.
  subtract(Sub, [H|T], Iter, Acc, Res) :-  Iter < Sub, X is H - 1, NewIter is Iter + 1, append(Acc, [X], Temp), subtract(Sub, T, NewIter, Temp, Res).
  subtract(Sub, List, Iter, Acc, Res) :- Iter = Sub, append(Acc, List, Res), !.