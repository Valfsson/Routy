-module (hist).
-export([new/1, update/3]).


%% returns new history, where messages from Name will always be seen as old

new (Name) ->
  Dictionary= dict:new(),                     %% creates new Dictionary
  dict:append (Name, inf, Dictionary).       %% (Key, Value, Dictionary)

%% checks if message number N is old or new
%% return old but if it new return{new, Updated}, Updated-> history

update(Node, N, History) ->
  case dict:find(Node, History) of
    {ok, [Value |_]} ->
      if
        N > Value ->
          DictOld = dict:erase(Node, History),
          DictNew = dict:append(Node, N , DictOld),
          {new, DictNew};
        true ->
            old
      end;
    error ->
      {new, dict:append(Node, N, History)}
end.
