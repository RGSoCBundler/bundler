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
        #{Bundler::VERSION}  # 1.4.0.rc.1
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
        #{Bundler::VERSION}
    L

    expect(File.read(bundled_app("Gemfile.lock"))).to match("BUNDLER\n  1.3.5")

    lockfile_bundler_version = File.read(bundled_app("Gemfile.lock")).gsub(/#{Bundler::VERSION}/, "1.5.0.0")

    File.open(bundled_app("Gemfile.lock"), "wb"){|f| f.puts(lockfile_bundler_version) }

    expect(File.read(bundled_app("Gemfile.lock"))).not_to match("BUNDLER\n  1.3.5")

    expect(bundle :install).to include("Your bundle is complete!")

  end

end