-module(intf).
-export([new/0, add/4, remove/2, lookup/2, ref/2, name/2, list/1, broadcast/2]).

%% return empty set of interfaces
new() ->
  [].


%% adds a new entry to the set
%% returns the new set of interface

add(Name, Ref, Pid, Intf) ->
  case lists:member({Name, Ref, Pid}, Intf) of
    true ->
      Intf;
    false ->
      [{Name, Ref, Pid}| Intf]
  end.


%% removes an entry
remove(Name, Intf) ->
  lists:keydelete(Name, 1, Intf).


%% finds the process identifier given a Name

lookup(Name, Intf) ->
  case lists:keyfind(Name, 1, Intf) of
    {_, _, Pid}->
      {ok, Pid};
    false ->
      notfound
end.


%% finds reference given a name

ref(Name, Intf) ->
case lists:keyfind(Name, 1, Intf) of
  {_, Ref, _} ->
    {ok, Ref};
  false ->
    notfound
end.


%% finds name given a reference

name(Ref, Intf) ->
case lists:keyfind(Ref, 2, Intf) of
  {Name, _, _} ->
    {ok, Name};
  false ->
      notfound
end.

%% returns list with all names

list(Intf) ->
  list(Intf, []).


list(Intf, ElList) ->
  case Intf of
    [] ->
      ElList;
    [{Name, _, _ } | T] -> list (T, [Name | ElList])
  end.


%% sends msg to all interface processes

broadcast(Message, Intf) ->
  lists:foreach(fun({_, _, Pid}) ->
    Pid ! Message end,
    Intf).
