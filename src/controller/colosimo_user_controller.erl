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

login2('GET', []) ->
    Form = boss_form:new(login_form, []),
    {ok, [{form, Form}, {redirect, Req:header(referer)}]};

login2('POST', []) ->
    Form = boss_form:new(login_form, []),
    case boss_form:validate(Form, Req:post_params()) of
        {ok, LoginCookies} ->
            {redirect, proplists:get_value("redirect",
                    Req:post_params(), "/"), LoginCookies};
	{error, FormWithErrors} ->
            {ok, [{form, FormWithErrors}]}
    end.

logout('GET', []) ->
    {redirect, "/",
        [mochiweb_cookies:cookie("colosimo_user_id", "", [{path, "/"}]),
	 mochiweb_cookies:cookie("session_id", "", [{path, "/"}])]
    }.
