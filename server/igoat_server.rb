#!/usr/bin/env ruby

#==============================================================================
#
# iGoat Server
#
# Authors:
#   Sean Eidemiller (sean@krvw.com)
#   Jonathan Carter (jcarter@arxan.com)
#
# Ports:
#   8080/HTTP
#   8443/HTTPS (SSL)
#
# Endpoints:
#   POST /igoat/user
#   POST /igoat/exercise/certificatePinning
#   GET /igoat/token?username=<username>&password=<password>
#   GET /igoat/exercise/certificatePinning
#
# Examples:
#   POST http://localhost:8080/igoat/user
#     { firstName: <string>, lastName: <string>, accountNumber: <string>, ... }
#   POST https://localhost:8443/igoat/user
#     { firstName: <string>, lastName: <string>, accountNumber: <string>, ... }
#   POST https://localhost:8443/igoat/exercise/certificatePinning
#     { firstName: <string>, lastName: <string>, accountNumber: <string>, ... }
#
#   GET http://localhost:8080/igoat/token?username=sean&password=igoat
#   GET https://localhost:8443/igoat/token?username=sean&password=igoat
#
#==============================================================================

#==============================================================================
#
# Malicious SSL Server
#
# Authors:
#   Jonathan Carter (jcarter@arxan.com)
#
# Ports:
#   8442/HTTPS (SSL)
#
# Endpoints:
#   POST /igoat/exercise/certificatePinning
#   GET /igoat/exercise/certificatePinning
#
# Examples:
#   POST https://localhost:8442/igoat/exercise/certificatePinning
#     { firstName: <string>, lastName: <string>, accountNumber: <string>, ... }
#
#   GET https://localhost:8442/igoat/exercise/certificatePinning
#
#==============================================================================

require 'rubygems'
require 'sinatra/base'
require 'webrick'
require 'webrick/https'
require 'openssl'
require 'json'

$request_count = 0
$mutex = Mutex.new

class GoatServer < Sinatra::Base

  # Endpoint definitions.
  post "/igoat/user" do
    if (!request.secure?)
      log_stolen_info "The user's account information was stolen by anyone on your Wi-Fi!"
    end
    headers "X-Goat-Secure" => request.secure?.to_s
    content_type :json
    json = JSON.parse request.body.read
    json['id'] = increment_count
    JSON.pretty_generate json
  end

  post "/igoat/exercise/certificatePinning" do
    if (!request.secure?)
      log_stolen_info "The user's account information was stolen by anyone on your Wi-Fi!"
    else
      headers "X-Goat-Secure" => request.secure?.to_s
      content_type :json
      json = JSON.parse request.body.read
      json['id'] = increment_count
      JSON.pretty_generate json
    end
  end

  get "/igoat/token" do
    if (!request.secure?)
      log_stolen_info "The user's login credentials were stolen by everyone on your Wi-Fi!"
      response.body="The user's login credentials were stolen by everyone on your Wi-Fi!"
    else
    headers "X-Goat-Secure" => request.secure?.to_s
    response.set_cookie("SessionID", "34A7EF-115C24-8F21CD-#{increment_count}")
    end
  end

  get "/igoat/exercise/certificatePinning/token" do
    if (!request.secure?)
      log_stolen_info "The client has connected to the legitimate server; however, the user's login credentials were stolen by everyone on your Wi-Fi!"
      response.body="The client has connected to the legitimate server; however, the user's login credentials were stolen by everyone on your Wi-Fi!"
    else
      headers "X-Goat-Secure" => request.secure?.to_s
      response.set_cookie("SessionID", "34A7EF-115C24-8F21CD-#{increment_count}")
      response.body="The client has connected to the legitimate SSL server; the user's login credentials cannot be stolen via unencrypted traffic interception"
    end
  end

  private

  def increment_count
    $mutex.synchronize do
      return $request_count += 1
    end
  end

  def log_stolen_info(message)
    puts "\n********************************************************************************"
    puts "WARNING: #{message}"
    puts "********************************************************************************\n\n"
  end

  def log(message)
    puts "GoatServer [#{Time.new.strftime("%Y-%m-%d %H:%M:%S")}]: #{message}"
  end
end

class HostileSSLServer < Sinatra::Base

  # Endpoint definitions.
  post "/igoat/exercise/certificatePinning" do
      # The mobile app has been tricked into connecting to this server instead of the original.
      # Normally, a hostile server will intercept and pass the original request onto the legitimate destination
      # The destination will process the request and issue a response back to the non-legitimate server
      # The non-legitimate server will then pass the intended response back to the client
      # Here, we just hard-code the response and duplicate the original logic for ease of deployment

      log_stolen_info "The mobile app has been tricked into connecting to this non-legitimate SSL server; the user's account information was stolen by this server"
      headers "X-Goat-Secure" => request.secure?.to_s
      headers "X-Goat-LegitimateServer" => "false"
      content_type :json
      json = JSON.parse request.body.read
      json['id'] = increment_count
      JSON.pretty_generate json
  end

  get "/igoat/exercise/certificatePinning" do
    # The mobile app has been tricked into connecting to this server instead of the original.
    # Normally, a hostile server will intercept and pass the original request onto the legitimate destination
    # The destination will process the request and issue a response back to the non-legitimate server
    # The non-legitimate server will then pass the intended response back to the client
    # Here, we just hard-code the response and duplicate the original logic for ease of deployment

    log_stolen_info "The mobile app has connected to a non-legitimate SSL server"
    headers "X-Goat-Secure" => request.secure?.to_s
    headers "X-Goat-LegitimateServer" => "false"
    response.set_cookie("SessionID", "34A7EF-115C24-8F21CD-#{increment_count}")
    response.body="The mobile app has been tricked into connecting to this non-legitimate SSL server; the user's login credentials will be transmitted directly to this server"
  end

  private

  def increment_count
    $mutex.synchronize do
      return $request_count += 1
    end
  end

  def log_stolen_info(message)
    puts "\n********************************************************************************"
    puts "WARNING: #{message}"
    puts "********************************************************************************\n\n"
  end

  def log(message)
    puts "GoatServer [#{Time.new.strftime("%Y-%m-%d %H:%M:%S")}]: #{message}"
  end
end

# GoatServer configuration.
goatServer_options_hashes = [
  {
    :Port => 8443,
    :Logger => WEBrick::Log::new($stderr, WEBrick::Log::WARN),
    :DocumentRoot => "/",
    :SSLEnable => true,
    :SSLVerifyClient => OpenSSL::SSL::VERIFY_NONE,
    :SSLCertificate => OpenSSL::X509::Certificate.new(File.open("legitimateServers.crt").read),
    :SSLPrivateKey => OpenSSL::PKey::RSA.new(File.open("legitimateServers.private.key").read),
    :SSLCertName => [[ "CN", WEBrick::Utils::getservername ]]
  },
  {
    :Port => 8080,
    :Logger => WEBrick::Log::new($stderr, WEBrick::Log::WARN),
    :DocumentRoot => "/",
    :SSLEnable => false
  }
]

# HostileSSLServer configuration.
hostileSSLServer_options_hashes = [
    {
        :Port => 8442,
        :Logger => WEBrick::Log::new($stderr, WEBrick::Log::WARN),
        :DocumentRoot => "/",
        :SSLEnable => true,
        :SSLVerifyClient => OpenSSL::SSL::VERIFY_NONE,
        :SSLCertificate => OpenSSL::X509::Certificate.new(File.open("hostileSSLServer.crt").read),
        :SSLPrivateKey => OpenSSL::PKey::RSA.new(File.open("hostileSSLServer.private.key").read),
        :SSLCertName => [[ "CN", WEBrick::Utils::getservername ]]
    }
]

# Start each server in a separate thread.
server_threads = []

goatServer_options_hashes.each do |options_hash|
  server_threads << Thread.new(options_hash) { |options|
    Rack::Handler::WEBrick.run(GoatServer, options)
  }
end

hostileSSLServer_options_hashes.each do |options_hash|
  server_threads << Thread.new(options_hash) { |options|
    Rack::Handler::WEBrick.run(HostileSSLServer, options)
  }
end

puts "OWASP iGoat servers initialized; accepting connections..."
server_threads.each { |server_thread| server_thread.join }