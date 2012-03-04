#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      #
      # = whois.nic.uk parser
      #
      # Parser for the whois.nic.uk server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      # @see http://www.nominet.org.uk/other/whois/detailedinstruct/
      #
      class WhoisNicUk < Base

        # == Values for Status
        #
        # @see http://www.nominet.org.uk/registrars/systems/data/regstatus/
        # @see http://www.nominet.org.uk/registrants/maintain/renew/status/
        #
        property_supported :status do
          if content_for_scanner =~ /\s+Registration status:\s+(.+?)\n/
            case $1.downcase
              when "registered until renewal date."
                :registered
              when "registration request being processed."
                :registered
              when "renewal request being processed."
                :registered
              when "no registration status listed."
                :reserved
              # NEWSTATUS (redemption?)
              when "renewal required."
                :registered
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          elsif invalid?
            :invalid
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /This domain name has not been registered/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /\s+Registered on:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /\s+Last updated:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /\s+Renewal date:\s+(.+)\n/
            Time.parse($1)
          end
        end


        # @see http://www.nic.uk/other/whois/instruct/
        property_supported :registrar do
          if content_for_scanner =~ /Registrar:\n(.+) \[Tag = (.+)\]\n\s*URL: (.+)\n/
            name, id, url = $1.strip, $2.strip, $3.strip
            org, name = name.split(" t/a ")

            Record::Registrar.new(
              :id           => id,
              :name         => (name || org),
              :organization => org,
              :url          => url
            )
          elsif content_for_scanner =~ /This domain is registered directly with Nominet/
            Record::Registrar.new(
              :id           => nil,
              :name         => "Nominet",
              :organization => "Nominet UK",
              :url          => "http://www.nic.uk/",
            )
          end
        end


        property_supported :registrant_contacts do
          if content_for_scanner =~ /Registrant's address:\n((.+\n)+)\n/
            lines = $1.split("\n").map(&:strip)
            address = lines[0..-5]
            city    = lines[-4]
            state   = lines[-3]
            zip     = lines[-2]
            country = lines[-1]
            
            Record::Contact.new(
              :type => Record::Contact::TYPE_REGISTRANT,
              :name => content_for_scanner[/Registrant:\n\s*(.+)\n/, 1],
              :address => address.join("\n"),
              :city => city,
              :state => state,
              :zip => zip,
              :country => country
            )
          end
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Name servers:\n((.+\n)+)\n/
            $1.split("\n").reject { |value| value =~ /No name servers listed/ }.map do |line|
              Record::Nameserver.new(*line.strip.split(/\s+/))
            end
          end
        end


        def response_throttled?
          !!(content_for_scanner =~ /The WHOIS query quota for .+ has been exceeded/)
        end


        # NEWPROPERTY
        def valid?
          cached_properties_fetch(:valid?) do
            !invalid?
          end
        end

        # NEWPROPERTY
        def invalid?
          cached_properties_fetch(:invalid?) do
            !!(content_for_scanner =~ /This domain cannot be registered/)
          end
        end

        # NEWPROPERTY
        # def suspended?
        # end

      end

    end
  end
end
