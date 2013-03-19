require 'backports'
require 'abstract_type'
require 'equalizer'
require 'concord'
require 'adamantium'
require 'addressable/uri'
require 'anima'

# ::Ducktrap needs this
require 'ducktrap/pretty_dump'

# Library namespace
module Ducktrap
  include AbstractType, PrettyDump, Adamantium::Flat

  class FailedTransformationError < RuntimeError
    include Adamantium::Flat, Concord.new(:result)

    # Return error message
    #
    # @return [String]
    #
    # @api private
    #
    def message
      result.pretty_inspect
    end
    memoize :message

  end
end

require 'ducktrap/formatter'
require 'ducktrap/error'
require 'ducktrap/result'
require 'ducktrap/result/static'
require 'ducktrap/result/invalid'
require 'ducktrap/builder'
require 'ducktrap/registry'
require 'ducktrap/nullary'
require 'ducktrap/unary'
require 'ducktrap/singleton'
require 'ducktrap/nary'
require 'ducktrap/node'
require 'ducktrap/node/key'
require 'ducktrap/node/key/fetch'
require 'ducktrap/node/key/dump'
require 'ducktrap/node/key/delete'
require 'ducktrap/node/key/add'
require 'ducktrap/node/noop'
require 'ducktrap/node/block'
require 'ducktrap/node/collect'
require 'ducktrap/node/map'
require 'ducktrap/node/disjunction'
require 'ducktrap/node/anima'
require 'ducktrap/node/anima/load'
require 'ducktrap/node/anima/dump'
require 'ducktrap/node/primitive'
require 'ducktrap/node/inverse'
require 'ducktrap/node/forward'
require 'ducktrap/node/fixnum'
require 'ducktrap/node/string'
require 'ducktrap/node/static'
require 'ducktrap/node/polymorphic'
require 'ducktrap/node/external'
