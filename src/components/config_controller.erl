-module(config_controller).
-export([index/1, new/1]).

index(_) ->
  Configs = config:find(),
  {data, Configs}.

new(A) ->
  case yaws_arg:method(A) of
  'GET' ->
    {data, ok};
  'POST' ->
    Vals = yaws_api:parse_post(A),
    Record = config:new(),
    Record1 = config:set_fields_from_strs(Record, Vals),
    config:save(Record1),
    {ewr, config, index}
  end.