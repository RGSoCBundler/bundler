require "spec_helper"

describe "lockfile" do
  include Bundler::GemHelpers

  it "prints out the Bundler version that generated the lockfile" do

    install_gemfile <<-G
      source "file://#{gem_repo1}"

      gem "rails"
    G

    lockfile_should_be <<-G
      GEM
        remote: file:#{gem_repo1}/
        specs:
          actionmailer (2.3.2)
            activesupport (= 2.3.2)
          actionpack (2.3.2)
            activesupport (= 2.3.2)
          activerecord (2.3.2)
            activesupport (= 2.3.2)
          activeresource (2.3.2)
            activesupport (= 2.3.2)
          activesupport (2.3.2)
          rails (2.3.2)
            actionmailer (= 2.3.2)
            actionpack (= 2.3.2)
            activerecord (= 2.3.2)
            activeresource (= 2.3.2)
            rake (= 10.0.2)
          rake (10.0.2)

      PLATFORMS
        #{generic(Gem::Platform.local)}

      DEPENDENCIES
        rails

      BUNDLER
        #{Bundler::VERSION}
    G

  end

  it "warns if the bundler version is older than the version that created" do
    gemfile <<-G
      source "file://#{gem_repo1}"

      gem "rails"
    G

    lockfile <<-L
      GEM
        remote: file:#{gem_repo1}/
        specs:
          actionmailer (2.3.2)
            activesupport (= 2.3.2)
          actionpack (2.3.2)
            activesupport (= 2.3.2)
          activerecord (2.3.2)
            activesupport (= 2.3.2)
          activeresource (2.3.2)
            activesupport (= 2.3.2)
          activesupport (2.3.2)
          rails (2.3.2)
            actionmailer (= 2.3.2)
            actionpack (= 2.3.2)
            activerecord (= 2.3.2)
            activeresource (= 2.3.2)
            rake (= 10.0.2)
          rake (10.0.2)

      PLATFORMS
        #{generic(Gem::Platform.local)}

      DEPENDENCIES
        rails

      BUNDLER
        100.1
    L

    bundle :install
    expect(out).to include("You're using an older version of Bundler (#{
      Bundler::VERSION}) than the one specified in your Gemfile (100.1)")
  end

end