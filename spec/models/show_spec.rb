require 'spec_helper'

describe Show do 
  before(:all) do
    empty_database
  end

  after(:all) do
    empty_database
  end

  describe "name" do
    describe "uniqueness" do
      it "should enforce uniqueness" do
        show1 = FactoryGirl.create(:show, name: "Foo the Animated Series")
        show2 = FactoryGirl.build(:show, name: "Foo the Animated Series")
        show2.should_not be_valid
      end

      it "should ignore case" do
        show1 = FactoryGirl.create(:show, name: "SHOUTING")
        show2.should_not be_valid
      end
    end
  end

  describe "wiki_page" do
    it "should be created on show creation if no wiki_page is provided" do
      show = FactoryGirl.create(:show)
      show.wiki_page.should be_valid
    end

    it "missing should invalidate the show" do
      show = FactoryGirl.create(:show)
      show.wiki_page.destroy
      show.should_not be_valid
    end
  end
end