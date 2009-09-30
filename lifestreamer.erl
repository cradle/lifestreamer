-module(lifestreamer).
-export([start/0]).
 
-include("/usr/local/lib/yaws/include/yaws.hrl").
 
start() ->
    % mnesia:create_table(posts,
    %                     [{attributes, record_info(fields, post)},
    %                      {disc_copies, [node()]},
    %                      {type, bag}]),
    % mnesia:start(),
    erlyweb:compile(".",[{auto_compile, true}]),
                                    % {erlydb_driver, mnesia}]),
    application:start(yaws),
    GC = yaws_config:make_default_gconf(false,"lifestreamer"),
    SC = #sconf{port = 8081,
                % servername = "localhost",
                listen = {0,0,0,0},
                docroot = "www",
                appmods = [{"/", erlyweb}],
                opaque = [{"appname","lifestreamer"}] },
    yaws_api:setconf(GC, [[SC]]).