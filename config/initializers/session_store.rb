# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mock-oauth-echo-image-host_session',
  :secret      => 'f26036ebde2873fbe060090325c3e5af9f8c3d9cec77c079ac2c4e93fd38fb0a3dffe3bdfd73012777052de94e185690db752ee16e14f5e1bd6caf2a75b70601'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
