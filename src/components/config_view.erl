-module(config_view).
-export([index/1, new/1]).

index(Data) ->
  config_list:index(Data).

new(ok) ->
  config_new:render().