#!/bin/env ruby
# encoding: utf-8

require 'active_support/concern'

module Mongoid::CommonScopes

  extend ActiveSupport::Concern

  included do |base|

    scope :today, where(:created_at.gte => Time.now.utc.at_beginning_of_day)
    scope :yesterday, where(:created_at.gte => 1.day.ago.utc.at_beginning_of_day)
    scope :last_week, where(:created_at.gte => 7.day.ago.utc.at_beginning_of_day)
    scope :last_month, where(:created_at.gte => 30.day.ago.utc.at_beginning_of_day)

  end

end
