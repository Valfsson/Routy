-module(dijkstra).
-export([table/2, route/2]).

%% returns the length of the shortest path to the Node or 0

entry(Node, Sorted) ->
  case lists:keyfind (Node, 1, Sorted) of
    {_, Length, _} ->
          Length;
    false ->
          0
  end.

%% replaces entry for Node in Sorted with length N and Gateway
%% *! entry needs to be present
%% sorts the result

replace(Node, N, Gateway, Sorted) ->
      TmpList= lists:keyreplace(Node, 1, Sorted, {Node, N, Gateway}),
      lists:keysort(2, TmpList).



%% updates Sorted list that Node can be reached with N hops by Gateway
%% *! entry needs to be present
%% *! replace ONLY is the new path is shorter

update(Node, N, Gateway, Sorted) ->
  Length = entry(Node, Sorted),
  case (N < Length) of
    true ->
      replace(Node, N, Gateway, Sorted);
    false ->
      Sorted
  end.


%% constructs a table given a sorted list, a map, table constructed so far

iterate(Sorted, Map, Table) ->
  case Sorted of
    [] ->                           %% no entries
      Table;
    [{_, inf, _}| _ ] ->            %% first element is inf- dummy
      Table;
    [Entry | T ] ->
      {CityName, Length, Gateway} = Entry,                      %% takes 1st Entry i Sorted
      case lists:keyfind(CityName, 1, Map) of
          {_, Reachable} ->                                     %% finds Node in Map reachable from Entry
            NewList= lists:foldl( fun(City, SortedList)->
              update(City, Length+1, Gateway, SortedList)    %% updates Sorted list for each nodes
            end, T, Reachable);
          false ->
              NewList= T
        end,
      iterate(NewList, Map, [{CityName, Gateway} | Table])        %% recursion
    end.




%% constructs a routing table given gateways and a map

table(Gateways, Map) ->
 All_Nodes= map:all_nodes(Map),
 InitialSortList= lists:keysort(2, lists:map (fun(City)->
    case lists:member (City, Gateways) of
      true ->
        {City, 0, City};
      false ->
        {City, inf, unknown}
      end
    end, All_Nodes)),
  iterate (InitialSortList, Map, []).



%% search routing Table,
%% return the gateway suitable to route messages to a node.

route(Node, Table) ->
  case lists:keyfind(Node, 1, Table) of
    {CityName, Gateway}->
      {ok, Gateway};
    false ->
      notfound
  end.
