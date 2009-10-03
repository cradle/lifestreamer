-module(lifestreamer_app_controller).
-export([hook/1]).

hook(A) ->
  case yaws_arg:server_path(A) of
    "/" ->
      {ewr, config};
    _ ->
      {phased, {ewc, A},
        fun(_Ewc, Data, _PhasedVars) ->
          {ewc, html_layout, index, [A, {data, Data}]}
        end
      }
  end.