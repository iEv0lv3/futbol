require_relative 'calculateable'
require_relative 'gatherable'

module DataOrganization
  include Calculateable
  include Gatherable
end
