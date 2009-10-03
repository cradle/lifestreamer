-module(config).
-export([fields/0, value_for/1, value_for/2]).

value_for(Key) ->
  value_for(Key, Key).

value_for(Key, Default) ->
  case config:find({key, '=', 'site:name'}) of
    [{config, _, _, _, Value}] ->
      Value;
    Result ->
      io:format("~n~nKey not found: ~p~n~n", [Result]),
      Default
  end.

fields() ->
  [id, key, value].