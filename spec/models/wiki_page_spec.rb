require 'spec_helper'

describe WikiPage do 
  before(:all) do
    empty_database
  end

  after(:all) do
    empty_database
  end

  describe "wiki" do
    it "should create or find a default wiki upon creation if not given a wiki param" do
    end
  end
end