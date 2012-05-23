# GithubPulls

Simple library to get github pull requests via github api v3

## Installation

Add this line to your application's Gemfile:

    gem 'github_pulls', :git => 'https://github.com/holysugar/github_pulls'

And then execute:

    $ bundle

## Usage

    require 'github_pulls'
    api = GithubPulls::API.new('holysugar/github_pulls')
    pulls = api.pulls # gets collection of GithubPulls::Pull
    pull = pulls.first

    pull.fetch_and_merge_command
		  #=> git fetch git@github.com:holysugar/github_pulls.git pull-sample\n  git merge FETCH_HEAD
    pull.html_url
			#=> "https://github.com/holysugar/github_pulls/pull/1"
		pull.username
			#=> "holysugar"
    pull.branch
		  #=> "pull-sample"
		pull.number
			#=> 1
		pull.body
			#=> "this is pull request sample, using in spec"
		pull.label
			#=> "holysugar:pull-sample"
		pull.sha
			#=> "483bef9dcd6e2f99f885be5011fafc1b5dc82bbf"

If you want pulls of private repository, need OAuth2 access_token.

    require 'github_pulls'
    api = GithubPulls::API.new('holysugar/github_pulls', :access_token => '.....')

or set `ENV['GITHUB_ACCESS_TOKEN']` .

We can create access token to use bin/create_github_access_token .

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
