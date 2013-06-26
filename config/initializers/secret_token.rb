# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Claude::Application.config.secret_key_base = 'cd24f92c8153a8ff068eeb53ac7d72d5f59238f24e2c6585c147bb0f5d50447c3a4c36f942c251ddd43c34a7f91e819b34f08d7966867a27371717ab21901190'
