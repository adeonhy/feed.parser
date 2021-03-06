# encoding: utf-8

module FeedParser


class Parser

  include LogUtils::Logging

  ### convenience class/factory method
  def self.parse( xml, opts={} )
    self.new( xml ).parse
  end

  ### Note: lets keep/use same API as RSS::Parser for now
  def initialize( xml )
    @xml = xml
  end


  def parse
    logger.debug "using stdlib rss/#{RSS::VERSION}"

    parser = RSS::Parser.new( @xml )

    parser.do_validate            = false
    parser.ignore_unknown_element = true

    logger.debug "Parsing feed..."
    feed_wild = parser.parse  # not yet normalized

    logger.debug "  feed.class=#{feed_wild.class.name}"

    if feed_wild.is_a?( RSS::Atom::Feed )
      feed = AtomFeedBuilder.build( feed_wild )
    else  # -- assume RSS::Rss::Feed
      feed = RssFeedBuilder.build( feed_wild )
    end

    logger.debug "== #{feed.format} / #{feed.title} =="
    feed # return new (normalized) feed
  end

end  # class Parser


end # module FeedParser
