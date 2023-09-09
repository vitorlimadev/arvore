defmodule Arvore.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :arvore,
    adapter: Ecto.Adapters.MyXQL
end
