-module (map).
-export([newTest/0, updateTest/3, reachableTest/2, allTest/1]).


%% tests new method
newtTest()->
      map:new().

updateTest(***)->
  map:update().

reachTest()->
    map:reachable().


%%updates Map to reflect that Node has directional links to all all_nodes
%%in the list Links. The old entry is removed.
update(Node, Links, Map) ->
      New = lists:keydelete(Node, 1, Map),
      [{Node, Links} | New].


%%returns list of nodes directly reachable from the node
reachable(Node, Map) ->
  case lists:keyfind(Node, 1, Map) of
    {_, FoundList}->
      FoundList;
    false ->
      []
    end.


%%returns list of all nodes in the map, also those without outgoing
%%links.
all_nodes(Map) ->
  NodesMap= lists:map (fun {Node,Links}) ->       %%or :flatmap
    [Node | Links] end, Map),
    lists:sort(NodesMap).                             %%or :usort???
