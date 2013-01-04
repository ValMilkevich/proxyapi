#!/bin/env ruby
# encoding: utf-8

require 'active_support/concern'

# Declares the interface to transform Realt params into our DB params
#
module Proxy::Formatter
  extend ActiveSupport::Concern

	def initial_latency=(val)
		self.latency = val.to_i
	end

	def type=(val)
		if val.is_a?(Array)
			self[:type] = val
		else
			self[:type] = val.to_s.split(',').map(&:strip)
		end
	end

end