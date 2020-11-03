# frozen_string_literal: true

require 'puppet/resource_api/simple_provider'

# Implementation for the mac_profile type using the Resource API.
class Puppet::Provider::MacProfile::MacProfile < Puppet::ResourceApi::SimpleProvider
  def initialize
    require 'puppet/util/plist'
    require 'puppet/util/execution'
    # require 'cfpropertylist'
  end

  def canonicalize(_context, resources)
    resources.each do |resource|
      resource[:uuid] = resource[:uuid].upcase unless resource[:uuid].nil?

      unless resource[:mobileconfig].nil?
        # TODO: transform mobileconfigstring to hash plist
        # TODO: set PayloadIdentifier to name if absent
        # TODO: if PayloadUUID is absent, compute uuid from mobileconfig and set it
        # TODO: if one or more of the PayloadUUID in payloads is absent, compute uuid from payload and set it
      end

      if resource[:ensure] == :present
        # TODO: PayloadIdentifier must be same as name
        # TODO: PayloadUUID must be same as uuid
      end
    end
  end

  def get(_context)
    plistxml = Puppet::Util::Execution.execute(['/usr/bin/profiles', 'show', '-type', 'configuration', '-output', 'stdout-xml'])
    plist = Puppet::Util::Plist.parse_plist(plistxml)

    profiles = []
    unless plist[0].nil?
      plist[0].each do |item|
        profile = {
          name: item['ProfileIdentifier'],
          ensure: 'present',
          profile: item,
        }
        profiles.push(profile)
      end
    end
    return profiles
  end

  def create(context, name, should)
    context.notice("Creating '#{name}' with #{should.inspect}")
    create_or_update(context, name, should)
  end

  def update(context, name, should)
    context.notice("Updating '#{name}' with #{should.inspect}")
    create_or_update(context, name, should)
  end

  def create_or_update(context, name, should)
    context.notice("Creating or updating '#{name}' with #{should.inspect}")
  end

  def delete(context, name)
    context.notice("Deleting '#{name}'")
  end
end
