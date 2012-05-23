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

  describe "#comments" do
    subject { api.comments(1) }

    it "is a collection of GithubPulls::Comment" do
      should satisfy {|comments| comments.all?{|comment| comment.is_a? GithubPulls::Comment } }
    end

  end
end

describe GithubPulls::Pull do
  let(:api) { GithubPulls::API.new('holysugar/github_pulls') }
  let(:pull) { api.pulls.last }

  subject { pull }

  its(:sha) { should == '483bef9dcd6e2f99f885be5011fafc1b5dc82bbf' }

  describe "#branch" do
    it "is branch name of head pull requested" do
      pull.branch.should == "pull-sample"
    end
  end
end

describe GithubPulls::Comment do
  let(:api) { GithubPulls::API.new('holysugar/github_pulls') }
  let(:comment) { api.comments(1).first }

  subject { comment }

  it { should be }

  describe "#body" do
    it 'is comment body' do
      comment.body.should == 'first comment'
    end
  end
end

