require 'time'
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

    def comments(number)
      get("/repos/#{@repo}/issues/#{number}/comments").map(&Comment.method(:new))
    end

    def post_comment(number, content)
      post("/repos/#{@repo}/issues/#{number}/comments", "body" => content )
    end

    private
    def call(name, options = {})
      name.sub!(/^\//, '')

      if options[:method] == :post
        http_result = @client.post("https://api.github.com/#{name}", :header => header, :body => options[:body])
      else
        http_result = @client.get("https://api.github.com/#{name}", :header => header)
      end
      raise HTTPError, "stauts code is #{http_result.status_code}" unless http_result.status_code < 300
      http_result
    end

    def get(name)
      JSON.parse(call(name).body)
    end

    def post(name, content_hash)
      body = content_hash.to_json
      JSON.parse(call(name, :method => :post, :body => body).body)
    end

    def call_pulls
      get("/repos/#{@repo}/pulls")
    end

    def header
      @access_token ? { 'Authorization' => "token #{@access_token}" } : {}
    end

  end

  class Pull
    attr :username, :label, :body, :sha, :html_url, :number, :private, :repo, :pushed_at

    def initialize(pull) # give a pull request api result json data
      @data       = pull
      @username   = pull['user']['login']
      @label      = pull['head']['label']
      @body       = pull['body']
      @sha        = pull['head']['sha']
      @html_url   = pull['html_url']
      @number     = pull['number']
      @private    = pull['head']['repo']['private']
      @repo       = pull['head']['repo']['ssh_url']
      @updated_at = Time.parse(pull['updated_at']).localtime
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


  class Comment
    attr :username, :body, :created_at, :updated_at
    def initialize(comment) # give a pull request api
      @data       = comment
      @username   = comment['user']['login']
      @body       = comment['body']
      @created_at = Time.parse(comment['created_at']).localtime
      @updated_at = Time.parse(comment['updated_at']).localtime
    end
  end
end

