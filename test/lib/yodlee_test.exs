defmodule YodleeTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open()
    Application.put_env(:yodlee, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  describe "yodlee" do
    test "make_request/2 returns HTTPoison.Reponse", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, "{\"status\":\"ok\"}")
      end)

      assert {:ok, %HTTPoison.Response{}} = Yodlee.make_request(:get, "any")
    end

    test "make_request/2 returns HTTPoison.Error", %{bypass: bypass} do
      Bypass.down(bypass)

      assert {:error, %HTTPoison.Error{}} = Yodlee.make_request(:get, "any")
    end

    test "make_request/2 handle XML response", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, "<h1>Why, Yodlee. Why.</h1>")
      end)

      assert {:ok, %HTTPoison.Response{body: {:invalid, _}}} = Yodlee.make_request(:get, "any")
    end
  end
end
