-module(colosimo_user_controller, [Req]).
-compile(export_all).

login('GET', []) ->
    {ok, [{redirect, Req:header(referer)}]};

login('POST', []) ->
    Username = Req:post_param("username"),
    case boss_db:find(colosimo_user, [{username, 'equals', Username}]) of
        [ColosimoUser] ->
            case ColosimoUser:check_password(Req:post_param("password")) of
                true ->
                   {redirect, proplists:get_value("redirect",
                       Req:post_params(), "/"), ColosimoUser:login_cookies()};
                false ->
                    {ok, [{error, "Authentication error"}]}
            end;
        [] ->
            {ok, [{error, "Authentication error"}]}
    end.

register('GET', []) ->
    {ok, []};

register('POST', []) ->
    Email = Req:post_param("email"),
    Username = Req:post_param("username"),
    Password = Req:post_param("password"),
    Hash = user_lib:hash_password(Password),
    ColosimoUser = colosimo_user:new(id, Email, Username, Hash),
    Result = ColosimoUser:save(),
    {ok, [Result]}.
