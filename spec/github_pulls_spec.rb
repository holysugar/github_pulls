require 'spec_helper'

# TODO: using webmock?

describe GithubPulls::API do
  let(:api) { GithubPulls::API.new('holysugar/github_pulls') }

  describe "#pulls" do
    subject { api.pulls }

    it "is a collection of GithubPulls::Pull" do
      should satisfy {|pulls| pulls.all?{|pull| pull.is_a? GithubPulls::Pull } }
    end
  end
end

describe GithubPulls::Pull do
  let(:api) { GithubPulls::API.new('holysugar/github_pulls') }
  let(:pull) { api.pulls.last }

  describe "#branch" do
    it "is branch name of head pull requested" do
      pull.branch.should == "pull-sample"
    end
  end
end

