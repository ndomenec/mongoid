# frozen_string_literal: true

require "spec_helper"

describe BSON::ObjectId do

  describe "#as_json" do

    let(:object_id) do
      described_class.new
    end

    context "when use_bson_ruby_as_json is set" do
      around do |example|
        saved_flag = Mongoid.use_bson_ruby_as_json
        Mongoid.use_bson_ruby_as_json = true
        begin
          example.run
        ensure
          Mongoid.use_bson_ruby_as_json = saved_flag
        end
      end

      it "uses bson-ruby's implementation of as_json" do
        expect(object_id.as_json).to eq(object_id.bson_ruby_as_json)
      end
    end

    context "when use_bson_ruby_as_json is not set" do
      around do |example|
        saved_flag = Mongoid.use_bson_ruby_as_json
        Mongoid.use_bson_ruby_as_json = false
        begin
          example.run
        ensure
          Mongoid.use_bson_ruby_as_json = saved_flag
        end
      end

      it "returns the $oid plus string" do
        expect(object_id.as_json).to eq("$oid" => object_id.to_s)
      end
    end
  end
end

describe BSON::Document do

  describe "#symbolize_keys" do

    let(:doc) do
      described_class.new("foo" => "bar")
    end

    it "returns key as symbol" do
      expect(doc.symbolize_keys.keys).to eq [:foo]
    end
  end
end
