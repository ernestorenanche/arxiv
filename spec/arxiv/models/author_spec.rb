require 'spec_helper'

module Arxiv
  describe Author do
    before(:all) { @author = Arxiv.get('1202.0819').authors.first }

    describe "name" do
      it "should return the author's name" do
        expect(@author.name).to eql("Michael T. Murphy")
      end
    end

    describe "affiliations" do
      it "should return an array of the author's affiliations" do
        expect(@author.affiliations).to include("Swinburne University of Technology")
      end
    end

  end
end
