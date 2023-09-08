defmodule Arvore.Repo do
  use Ecto.Repo,
    otp_app: :arvore,
    adapter: Ecto.Adapters.MyXQL
end
