File.expand_path('../..', __FILE__).tap do |ilogos_em_root|
  $LOAD_PATH << File.join( ilogos_em_root, 'lib' )
  $LOAD_PATH << File.join( ilogos_em_root, 'lib/ilogos_em' )
end

require 'eventmachine'
require 'em-http-request'

require 'em_instance'
