-module(cell_controller).
-import(markdown).
-export([index/1, new/1,  new/2, clone/1]).

index(_) ->
  Cells = cell:find(),
  {data, Cells}.

clone(A) ->
  {ok, Body} = yaws_api:getvar(A, "body"),
  Cells = cell:find(),
  {data, [{cells, Cells}, {cell, Body}]}.

new(A, Type) ->
  case yaws_arg:method(A) of
    'POST' ->
      case Type of
        "generic" ->
          new(A);
        "markdown" ->
          {ok, Body} = yaws_api:getvar(A, "body"),
          HtmlBody = markdown:conv(Body),
          Vals = [{"body", HtmlBody}],
          cell:create_from_strings(Vals),
          {ewr, cell, index}
      end
  end.
  
new(A) ->
  case yaws_arg:method(A) of
  'GET' ->
    {data, ok};
  'POST' ->
    Vals = yaws_api:parse_post(A),
    cell:create_from_strings(Vals),
    {ewr, cell, index}
  end.
