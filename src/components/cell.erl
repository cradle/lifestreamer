-module(cell).
-export([fields/0, create_from_strings/1, relations/0, body_encoded/1]).

fields() ->
  [id, body].

relations() ->
  [{many_to_many, [cells]}].

create_from_strings(Vals) ->
  Record = cell:new_from_strings(Vals),
  cell:save(Record).

body_encoded(Cell) ->
  Body = cell:body(Cell),
  EscapedBody = re:replace(Body, "\"", "'", [global]),
  EscapedBody.