defmodule Yodlee.UtilsTest do

  use ExUnit.Case
  alias Yodlee.Utils

  describe "yodlee_utils" do

    test "encode_params/1 converts map to binary" do
      params = %{key1: "value1", key2: "value2"}
      encoded = Utils.encode_params(params)

      assert encoded == "key1=value1&key2=value2"
    end

    test "encode_params/1 handles nested map" do
      params = %{key: %{another_key: "value"}}
      encoded = Utils.encode_params(params)

      assert encoded == "key={\"another_key\":\"value\"}"
    end

    test "encode_params/1 handles nested list" do
      params = %{key: [:one, :two, :three]}
      encoded = Utils.encode_params(params)

      assert encoded == "key=one%7Ctwo%7Cthree"
    end

    test "normalize_keys/1 converts camel case to snake case" do
      params = %{"camelCase" => "value"}
      map = Utils.normalize_keys(params)

      assert map == %{"camel_case" => "value"}
    end

    test "normalize_keys/1 handles nested map" do
      params = %{"camelCase" => %{"snakeCase" => "value"}}
      map = Utils.normalize_keys(params)

      assert map == %{"camel_case" => %{"snake_case" => "value"}}
    end

    test "normalize_keys/1 handles nested list" do
      params = %{"camelCase" => ["value1", "value2"]}
      map = Utils.normalize_keys(params)

      assert map == %{"camel_case" => ["value1", "value2"]}
    end

    test "handle_resp/2 handles parsing error" do
      payload = "<h1>Some XML payload</h1>"
      resp = success_resp(200, {:invalid, payload})

      assert {:error, body} = Utils.handle_resp(resp, :any)
      assert body == payload
    end

    test "handle_resp/2 handles HTTPoison.Error" do
      resp = error_resp()

      assert {:error, %HTTPoison.Error{}} = Utils.handle_resp(resp, :any)
    end

    test "handle_resp/2 handles empty body" do
      resp = success_resp(200, %{})

      assert {:ok, %{}} = Utils.handle_resp(resp, :any)
    end

    test "handle_resp/2 returns empty map for 200+ response" do
      resp = success_resp(204, %{"key" => "value"})

      assert {:ok, %{}} = Utils.handle_resp(resp, :any)
    end

    test "handle_resp/2 returns Yodlee.Error for 400+ response" do
      resp = success_resp(400, %{"error_code" => "error"})

      assert {:error, %Yodlee.Error{}} = Utils.handle_resp(resp, :any)
    end
  end

  defp success_resp(code, body) do
    {:ok, %HTTPoison.Response{status_code: code, body: body}}
  end

  defp error_resp do
    {:error, %HTTPoison.Error{}}
  end
end
