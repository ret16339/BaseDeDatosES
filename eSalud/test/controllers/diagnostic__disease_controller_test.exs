defmodule ESalud.Diagnostic_DiseaseControllerTest do
  use ESalud.ConnCase

  alias ESalud.Diagnostic_Disease
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, diagnostic__disease_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    diagnostic__disease = Repo.insert! %Diagnostic_Disease{}
    conn = get conn, diagnostic__disease_path(conn, :show, diagnostic__disease)
    assert json_response(conn, 200)["data"] == %{"id" => diagnostic__disease.id,
      "diagnostic_id" => diagnostic__disease.diagnostic_id,
      "disease_id" => diagnostic__disease.disease_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, diagnostic__disease_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, diagnostic__disease_path(conn, :create), diagnostic__disease: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Diagnostic_Disease, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, diagnostic__disease_path(conn, :create), diagnostic__disease: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    diagnostic__disease = Repo.insert! %Diagnostic_Disease{}
    conn = put conn, diagnostic__disease_path(conn, :update, diagnostic__disease), diagnostic__disease: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Diagnostic_Disease, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    diagnostic__disease = Repo.insert! %Diagnostic_Disease{}
    conn = put conn, diagnostic__disease_path(conn, :update, diagnostic__disease), diagnostic__disease: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    diagnostic__disease = Repo.insert! %Diagnostic_Disease{}
    conn = delete conn, diagnostic__disease_path(conn, :delete, diagnostic__disease)
    assert response(conn, 204)
    refute Repo.get(Diagnostic_Disease, diagnostic__disease.id)
  end
end
