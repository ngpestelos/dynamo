Code.require_file "../../test_helper", __FILE__

defmodule Dynamo::DispatcherTest::Sample1 do
  use Dynamo::Dispatcher

  get "/1/bar" do
    1
  end

  get "/2/:bar" do
    bar
  end

  get "/3/bar-:bar" do
    bar
  end

  get "/4/*bar" do
    bar
  end

  get "/5/bar-*bar" do
    bar
  end

  get ["6", "foo"] do
    200
  end

  def not_found(_request, _response) do
    404
  end
end

defmodule Dynamo::DispatcherTest do
  use ExUnit::Case

  def test_dispatch_single_segment do
    assert_equal 1, Sample1.dispatch(:GET, ["1","bar"], {}, {})
  end

  def test_dispatch_dynamic_segment do
    assert_equal "baz", Sample1.dispatch(:GET, ["2","baz"], {}, {})
  end

  def test_dispatch_dynamic_segment_with_prefix do
    assert_equal "baz", Sample1.dispatch(:GET, ["3","bar-baz"], {}, {})
  end

  def test_dispatch_glob_segment do
    assert_equal ["baz", "baaz"], Sample1.dispatch(:GET, ["4", "baz", "baaz"], {}, {})
  end

  def test_dispatch_glob_segment_with_prefix do
    assert_equal ["bar-baz", "baaz"], Sample1.dispatch(:GET, ["5", "bar-baz", "baaz"], {}, {})
  end

  def test_dispatch_custom_route do
    assert_equal 200, Sample1.dispatch(:GET, ["6", "foo"], {}, {})
  end

  def test_dispatch_not_found do
    assert_equal 404, Sample1.dispatch(:GET, ["100", "foo"], {}, {})
  end

end