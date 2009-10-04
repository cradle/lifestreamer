-module(lifestreamer).
-export([start/0, console/0, compile/0, migrate/0, join/0, join/1]).

-include("/usr/local/lib/yaws/include/yaws.hrl").
 
start() ->
    % mnesia:start(), % TODO: investigate erlydb:start()
    compile(),
    application:start(mnesia),
    application:start(yaws),
    GC = yaws_config:make_default_gconf(false,"lifestreamer"),
    SC = #sconf{port = 8080,
                % servername = "localhost",
                listen = {0,0,0,0},
                docroot = "www",
                appmods = [{"/", erlyweb}],
                opaque = [{"appname","controller"}] },
    yaws_api:setconf(GC, [[SC]]).

console() ->
  mnesia:start(),
  compile().

compile() ->
  {ok, CurDir} = file:get_cwd(),
  erlyweb:compile(CurDir, [
    {auto_compile, true}, 
    {erlydb_driver, mnesia}, 
    {skip_fk_checks, true} % TODO: investigate foreign keys
  ]).

join() ->
  join(lifestreamer@tbook).
join(MasterNode) ->
  mnesia:delete_schema([node()]),
  mnesia:start(),
  net_adm:ping(MasterNode),
  mnesia:change_config(extra_db_nodes, [MasterNode]),
  mnesia:change_table_copy_type(schema, node(), disc_copies),
  Tabs = mnesia:system_info(tables) -- [schema],
  [mnesia:add_table_copy(Tab,node(), disc_copies) || Tab <- Tabs].

bootstrap() ->
  create_table(migration).

migrate() ->
  mnesia:stop(),
  mnesia:create_schema([node()]),
  mnesia:start(),
  create_table(cell),
  create_table(config).

create_table(Name) ->
  mnesia:create_table(Name,
                      [{attributes, Name:fields()},
                       {disc_copies, [node()]},
                       {type, bag}]).
