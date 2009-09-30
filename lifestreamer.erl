-module(lifestreamer).
-export([start/0, migrate/0, compile/0]).

-include("/usr/local/lib/yaws/include/yaws.hrl").
 
start() ->
    mnesia:start(),
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

-record(post, {id, body}).

compile() ->
  {ok, CurDir} = file:get_cwd(),
  erlyweb:compile(CurDir, [
    {auto_compile, true}, 
    {erlydb_driver, mnesia}, 
    {skip_fk_checks, true} 
  ]).

migrate() ->
  mnesia:create_schema([node()]),
  mnesia:create_table(post,
                      [{attributes, record_info(fields, post)},
                       {disc_copies, [node()]},
                       {type, bag}]).