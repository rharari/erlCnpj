%% @author Ricardo A. Harari - ricardo.harari@gmail.com
%% @doc CNPJ is the brazilian federal tax id
%% @doc isValid/1 - return true when the argument is a valid CNPJ(string). 
%% @doc Ex: cnpj:isValid("03351287000192") -> true 
%% @doc Ex: cnpj:isValid("03.351.287/0001-92") -> true (works with mask also)
%% @doc Ex: cnpj:isValid("03x351---287xxxxxx0001nnnn92") -> true  (remove all chars except numbers before check)
%% @doc Ex: cnpj:isValid("033512870001-93") -> false
 
-module(cnpj).
-export([isValid/1]).

isValid(S) ->
	C = normalizar(lists:filter(fun(X) -> X>47 andalso X<58 end, S)),
	D = lists:sum( lists:zipwith(fun(X,Y) -> (X-48)*Y end, C, [6,7,8,9,2,3,4,5,6,7,8,9,0,0]) ) rem 11,
	D == lists:nth(13, C) - 48 andalso 
		( lists:sum(lists:zipwith(fun(X,Y) -> (X-48)*Y end, C, [5,6,7,8,9,2,3,4,5,6,7,8,0,0]) ) + D * 9 ) rem 11 == lists:nth(14, C) - 48.

%% Internal functions
%% ====================================================================
normalizar(S) when length(S) < 14 -> normalizar("0" ++ S);
normalizar(S) when length(S) =:= 14 -> S;
normalizar(S) when length(S) > 14 -> lists:sublist(S, 14).
