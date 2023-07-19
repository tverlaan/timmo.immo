import Config

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  origins =
    [
      "https://timmo.immo",
      "https://" <> System.get_env("PHX_HOST")
    ]
    |> Enum.reject(&is_nil/1)

  config :timmo, TimmoWeb.Endpoint,
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000"),
      transport_options: [socket_opts: [:inet6]]
    ],
    url: [host: "timmo.immo", scheme: "https", port: 443],
    secret_key_base: secret_key_base,
    check_origin: origins
end
