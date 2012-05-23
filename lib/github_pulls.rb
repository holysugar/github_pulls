require 'httpclient'
require 'json'

require 'github_pulls/version'

# FIXME OctocatHerder
module GithubPulls
  class HTTPError < StandardError; end

  class API
    def initialize(repo, options = {})
      @repo = repo
      @access_token = options[:access_token] || ENV['GITHUB_ACCESS_TOKEN']
      @client = HTTPClient.new
    end

    def pulls
      call_pulls.map(&Pull.method(:new))
    end

    private
    def call(name)
      name.sub!(/^\//, '')
      http_result = @client.get("https://api.github.com/#{name}", :header => header)
      raise HTTPError, "stauts code is #{http_result.status_code}" unless http_result.status_code < 300
      http_result
    end

    def call_pulls
      JSON.parse(call("/repos/#{@repo}/pulls").body)
    end

    def header
      @access_token ? { 'Authorization' => "token #{@access_token}" } : {}
    end

  end

  class Pull
    attr :username, :label, :body, :sha, :html_url, :number, :private, :repo
    def initialize(pull)
      @username = pull['user']['login']
      @label    = pull['head']['label']
      @body     = pull['body']
      @sha      = pull['head']['sha']
      @html_url = pull['html_url']
      @number   = pull['number']
      @private  = pull['head']['repo']['private']
      @repo     = pull['head']['repo']['ssh_url']
    end

    alias private? private
    alias ssh_url repo

    def branch
      label.split(':', 2).last
    end

    def fetch_and_merge_command
      return <<-EOD
  git fetch #{repo} #{branch}
  git merge FETCH_HEAD
      EOD
    end

  end
end

