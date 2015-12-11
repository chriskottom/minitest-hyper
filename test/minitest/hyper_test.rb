require 'test_helper'

describe Minitest::Hyper do
  it "has a version" do
    expect(Minitest::Hyper::VERSION).wont_be_nil
  end

  it "can be enabled" do
    Minitest::Hyper.class_variable_set(:@@enabled, false)
    Minitest::Hyper.enable!
    assert Minitest::Hyper.enabled?
  end
end
