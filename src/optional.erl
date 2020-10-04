-module(optional).
-export([sweden/0, russia/0, sweitz/0, join/0 ,test/0]).

%%
%%  Nodes
%%

%% 'sweden@130.123.112.23'
%% 'russia@130.123.112.23'
%% 'sweitz@130.123.112.23'

%% START WITH:
%% erl -name sweden@130.123.112.23 -setcookie routy -connect_all false


sweden() ->
  routy: start(r1, stockholm),
  routy: start(r2, uppsala),

r2 ! {add, stockholm, {r1, 'sweden@130.123.112.23'}},
r1 ! {add, uppsala, {r2, 'sweden@130.123.112.23'}}.

%%
%% Syntax problems..
%%

%%  r2 ! {add, stockholm, 'sweden@130.123.112.23'},
%%  r1 ! {add, uppsala, 'sweden@130.123.112.23'}.
  %% r2 ! {add, stockholm, {r1, 'sweden@130.123.112.23'}},
  %% r1 ! {add, uppsala, {uppsala, 'sweden@130.123.112.23'}}.



russia () ->
    routy: start(r1, moscow).


sweitz () ->
  routy: start(r1, zurich),
  routy: start(r2, zermatt),
  r2 ! {add, zurich, {zurich, 'sweitz@130.123.112.23'}},
  r1 ! {add, zermatt, {zermatt, 'sweitz@130.123.112.23'}}.

%% joining sweden, russia, sweitz
join() ->

%% stockholm reached from zurich
  {stockhom, 'sweden@130.123.112.23'} ! {add, zurich, {zurich, 'sweitz@130.123.112.23'}},

%% zurich reached from stockholm
  {zurich, 'sweitz@130.123.112.23'} ! {add, stockholm, {stockholm, 'sweden@130.123.112.23'}},

%% uppsala reached from moscow
  {uppsala, 'sweden@130.123.112.23'} ! {add, moscow, {moscow, 'russia@130.123.112.23'}},

%%moscow from uppsala
  {moscow, 'russia@130.123.112.23'} ! {add, uppsala, {uppsala, 'sweden@130.123.112.23'}}.


test() ->
    Routers = [{stockholm, 'sweden@130.123.112.23'}, {uppsala, 'sweden@130.123.112.23'}, {zurich, 'sweitz@130.123.112.23'}, {zermatt, 'sweitz@130.123.112.23'}, {moscow, 'russia@130.123.112.23'}],
    lists:foreach(fun(Router) -> Router ! broadcast end, Routers),
    time:sleep(1000),
    lists:foreach(fun(Router) -> Router! update end, Routers).
