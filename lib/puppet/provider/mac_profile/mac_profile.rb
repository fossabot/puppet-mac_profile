# frozen_string_literal: true

require 'puppet/resource_api/simple_provider'

# Implementation for the mac_profile type using the Resource API.
class Puppet::Provider::MacProfile::MacProfile < Puppet::ResourceApi::SimpleProvider
  def initialize
    require 'puppet/util/plist'
    # require 'cfpropertylist'
  end

  def canonicalize(context, resources)
    resources.each do |resource|
      resource[:uuid] = resource[:uuid].upcase unless resource[:uuid].nil?
    end
  end

  def get(context)
    context.debug('Returning pre-canned example data')
    [
      {
        name: 'foo',
        ensure: 'present',
      },
      {
        name: 'bar',
        ensure: 'present',
      },
    ]
  end

  def create(context, name, should)
    context.notice("Creating '#{name}' with #{should.inspect}")
    create_or_update(context, name, should)
  end

  def update(context, name, should)
    validate_should(should)
    context.notice("Updating '#{name}' with #{should.inspect}")
    create_or_update(context, name, should)
  end

  def delete(context, name)
    context.notice("Deleting '#{name}'")
  end

  def create_or_update(context, name, should)
    validate_should(should)
  end

  def validate_should(should)
  end
end
