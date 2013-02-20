# -*- encoding: utf-8 -*-
require "rumoji/version"
require "rumoji/emoji"
require 'stringio'

module Rumoji
  extend self

  # Transform emoji into its cheat-sheet code
  def encode(str, encode_basics = true)
    remapped_codepoints = str.codepoints.flat_map do |codepoint|
      emoji = Emoji.find_by_codepoint(codepoint) if encode_basics || codepoint.to_i >= 2190
      emoji ? emoji.code.codepoints.entries : codepoint
    end
    remapped_codepoints.pack("U*")
  end

  # Transform a cheat-sheet code into an Emoji
  def decode(str)
    str.gsub(/:(\S?\w+):/) {|sym| Emoji.find($1.intern).to_s }
  end

  def encode_io(readable, writeable=StringIO.new(""))
    readable.each_codepoint do |codepoint|
      emoji = Emoji.find_by_codepoint(codepoint)
      emoji_or_character = emoji ? emoji.code : [codepoint].pack("U")
      writeable.write emoji_or_character
    end
    writeable
  end

  def decode_io(readable, writeable=StringIO.new(""))
    readable.each_line do |line|
      writeable.write decode(line)
    end
    writeable
  end

end
