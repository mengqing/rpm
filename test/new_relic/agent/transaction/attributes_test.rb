# encoding: utf-8
# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/rpm/blob/master/LICENSE for complete details.

require File.expand_path(File.join(File.dirname(__FILE__), '..', '..','..','test_helper'))
require 'new_relic/agent/transaction/attributes'
require 'new_relic/agent/attribute_filter'

class AttributesTest < Minitest::Test

  AttributeFilter = NewRelic::Agent::AttributeFilter

  def test_returns_hash_of_attributes_for_destination
    with_config({}) do
      attributes = create_attributes
      attributes.add(:foo, "bar")

      assert_equal({:foo => "bar"}, attributes.for_destination(AttributeFilter::DST_TRANSACTION_TRACER))
    end
  end

  def test_disabling_transaction_tracer_for_attributes
    with_config({:'transaction_tracer.attributes.enabled' => false}) do
      attributes = create_attributes
      attributes.add(:foo, "bar")

      assert_empty attributes.for_destination(AttributeFilter::DST_TRANSACTION_TRACER)
    end
  end

  def create_attributes
    filter = NewRelic::Agent::AttributeFilter.new(NewRelic::Agent.config)
    NewRelic::Agent::Transaction::Attributes.new(filter)
  end
end