require_relative '../../../../lib/imports/constants_and_requires'
#
# Pull the information of the site that is available. Pulls the server (apache, redhat, etc) and the IP address
# that the site resolves to
#
module SiteInfo

  #
  # Get the IP address that the site resolves to using Socket
  #
  def self.capture_ip(site, regex)
    uri = URI.parse(site)
    true_url = uri.hostname
    ip = IPSocket::getaddress(true_url)
    if !(ip =~ /#{regex}/)  # IPv6 regex
      return ip.to_s.cyan
    else
      if ip.ipv4_mapped
        return ip.native.to_s.cyan
      else
        return ip.to_s.cyan
      end
    end
  end

  #
  # Get the site host name using Net::HTTP
  #
  def self.capture_host(site)
    uri = URI.parse(site)
    res = Net::HTTP.get_response(uri)
    return res['server'] # Pull it from the hash that is created
  end

  #
  # Get the database type from the error thrown, if it exists
  #
  def self.capture_db_type(site)
    data = SQL_ERROR[site]
    db_types = ["MySQL", "Microsoft Access", "Microsoft SQL Server",
                "Oracle", "DB2", "Firebird", "PostgreSQL"]  # Most commonly used DB types for web apps
    db_types.each { |db|
      if data.include?(db.downcase)
        return db.cyan
      else
        return 'Unable to resolve database type'.red
      end
    }
  end

end