class ApiController < ApplicationController
  @@log_level = 0
  # emulates TwitPic-like API
  def upload
    if @@log_level > 0
      log_this "incoming request headers", request.headers.inspect
      log_this "incoming parameters", params.inspect
    end
    continue = true
    force_continue = true if params[:success]
    continue = false if params[:fail]
    media_id = params[:media_id] || "abcd"
    media_domain = params[:media_domain] || "example.com"
    if continue
      oauth_echo_success = perform_oauth_echo
      log_this("(forced success)", force_continue) if force_continue
      if oauth_echo_success || force_continue
        render :status => 200, :xml => <<-EOF
<?xml version="1.0" encoding="UTF-8"?>
<rsp stat="ok">
<mediaid>#{media_id}</mediaid>
<mediaurl>http://#{media_domain}/#{media_id}</mediaurl>
</rsp>
EOF
      else
        render :status => 401, :xml => <<-EOF
<?xml version="1.0" encoding="UTF-8"?>
<rsp stat="fail">
  <err code="1001" msg="Invalid twitter username or password" />
</rsp>
EOF
      end
    end
  end

  def perform_oauth_echo
    # OAuth Echo requests can be sent to us either in HTTP headers or params
    authorization_header = request.headers['X-Verify-Credentials-Authorization'] || params[:x_verify_credentials_authorization]
    url = request.headers['X-Auth-Service-Provider'] || params[:x_auth_service_provider]
    if !authorization_header || !url
      log_this "OAuth Echo validation status", "Missing OAuth Echo headers or params!"
      return false
    end
    log_this "Received auth header", authorization_header
    log_this "Received verify credentials URL", url

    headers = { 'Authorization' => authorization_header }
    begin
      response = Credentials.get(url, :headers => headers)
      log_this "OAuth Echo validation status", "success!"
      log_this "Inspected response", response.inspect
      return true
    rescue Exception => e
      log_this "OAuth Echo validation status", "failed!"
      log_this "Inspected exception", e.inspect
      return false
    end
  end

  def log_this(title, message)
    logger.info "** #{title} **"
    logger.info message
    logger.info "** **"
  end

end

class Credentials
  include HTTParty
end