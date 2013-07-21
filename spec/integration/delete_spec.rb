require "integration_helper"

describe "deletion" do
  include_context "orm"

  context "when deleting a record" do
    before :each do
      connection[:movies].insert(:name => 'mo money')
      movie = session.find_all(Movie).first
      session.delete(movie)
    end

    it "should remove it from the database" do
      connection[:movies].all.count.should == 0
    end
  end
end
