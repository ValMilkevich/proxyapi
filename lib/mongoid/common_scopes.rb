#!/bin/env ruby
# encoding: utf-8

require 'active_support/concern'

module Mongoid::CommonScopes

  extend ActiveSupport::Concern

  included do |base|

    scope :today, where(:created_at.gte => Time.now.at_beginning_of_day.utc)
    scope :yesterday, where(:created_at.gte => 1.day.ago.at_beginning_of_day.utc)
    scope :last_week, where(:created_at.gte => 7.day.ago.at_beginning_of_day.utc)
    scope :last_month, where(:created_at.gte => 30.day.ago.at_beginning_of_day.utc)

  end

end
