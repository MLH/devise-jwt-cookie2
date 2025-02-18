# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Devise::JWT::Cookie do
  it 'has a version number' do
    expect(Devise::JWT::Cookie::VERSION).not_to be_nil
  end
end
