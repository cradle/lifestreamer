-module(lifestreamer).
-export([start/0, migrate/0, compile/0]).

-include("/usr/local/lib/yaws/include/yaws.hrl").
 
start() ->
    mnesia:start(), % TODO: investigate erlydb:start()
    compile(),
    application:start(yaws),
    GC = yaws_config:make_default_gconf(false,"lifestreamer"),
    SC = #sconf{port = 8081,
                % servername = "localhost",
                listen = {0,0,0,0},
                docroot = "www",
                appmods = [{"/", erlyweb}],
                opaque = [{"appname","lifestreamer"}] },
    yaws_api:setconf(GC, [[SC]]).

-record(cell, {id, body}).

compile() ->
  {ok, CurDir} = file:get_cwd(),
  erlyweb:compile(CurDir, [
    {auto_compile, true}, 
    {erlydb_driver, mnesia}, 
    {skip_fk_checks, true} % TODO: investigate foreign keys
  ]).

migrate() ->
  mnesia:create_schema([node()]),
  mnesia:create_table(config,
                      [{attributes, record_info(fields, config)},
                       {disc_copies, [node()]},
                       {type, bag}]).
  % mnesia:create_table(cell,
  %                     [{attributes, record_info(fields, cell)},
  %                      {disc_copies, [node()]},
  %                      {type, bag}]).