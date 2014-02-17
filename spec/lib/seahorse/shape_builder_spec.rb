require 'spec_helper'

describe Seahorse::ShapeBuilder do
  let(:shape_builder_types) { described_class.class_variable_get(:@@types) }

  describe 'default types' do
    %w{
      String
      Timestamp
      Integer
      Boolean
      Float
      List
      Structure
    }.each do |type_name|
      it "includes #{type_name}Type in the known types with a nil init block" do
        shape_builder_types[type_name.downcase.to_sym].should ==
          [Seahorse.const_get("#{type_name}Type"), nil]
      end
    end
  end

  describe '.instance_of_type' do

  end
end