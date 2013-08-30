require 'spec_helper'

describe "bundle update with git sources" do
  describe "without git installed" do
    it "prints a better error message" do

      install_gemfile <<-G
        git "#{lib_path('foo-1.0')}", :branch => "omg" do
          gem 'foo'
        end
      G

      bundle "update"
      expect(out).to include("Git is not installed!")
    end
  end
end