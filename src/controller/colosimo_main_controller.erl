-module(colosimo_main_controller, [Req]).
-compile(export_all).

before_(_) ->
    user_lib:require_login(Req).

index('GET', [], ColosimoUser) ->
  {ok, [{colosimo_user, ColosimoUser}]}.

nope('GET', [], _) ->
  {ok, []}.

oops('GET', [], _) ->
  {ok, []}.

about('GET', [], ColosimoUser) ->
  {ok, [{colosimo_user, ColosimoUser}]}.

register('GET', [], ColosimoUser) ->
  {ok, [{colosimo_user, ColosimoUser}]};

register('POST', [], ColosimoUser) ->
  Email = Req:post_param("email"),
  Username = Req:post_param("username"),
  Password = Req:post_param("password"),
  Hash = user_lib:hash_password(Password),
  ColosimoUser = colosimo_user:new(id, Email, Username, Hash),
  Result = ColosimoUser:save(),
  {ok, [Result]}.
