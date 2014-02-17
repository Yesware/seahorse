require 'spec_helper'

describe Seahorse::FloatType do
  let(:instance) { described_class.new('test_float') }

  it 'is a kind of Type' do
    described_class.new.should be_kind_of(Seahorse::Type)
  end

  describe '#from_input' do
    it 'returns a Float from a String' do
      instance.from_input('1.5').should be_instance_of(Float)
    end

    it 'returns a Float from an Integer' do
      instance.from_input(42).should be_instance_of(Float)
    end
  end

  describe '#to_output' do
    it 'calls #pull_value and converts the result to a Float' do
      mock_data = mock('Object')
      instance.should_receive(:pull_value).with(mock_data).and_return('3.14')
      instance.to_output(mock_data).should be_instance_of(Float)
    end

    it 'returns nil if the pulled value is nil' do
      mock_data = mock('Object')
      instance.should_receive(:pull_value).with(mock_data).and_return(nil)
      instance.to_output(mock_data).should be_nil
    end

    it 'returns nil if the pulled value is False' do
      # This behavior is questionable but left as is for now for consistency
      # with IntegerType.
      mock_data = mock('Object')
      instance.should_receive(:pull_value).with(mock_data).and_return(false)
      instance.to_output(mock_data).should be_nil
    end
  end
end

# To better understand how ListType works ...
describe Seahorse::ListType do

  before(:each) do
    Seahorse::ShapeBuilder.send(:reset_types!)
  end

  context 'a list of strings' do
    before(:each) do
      Seahorse::ShapeBuilder.type(:scalar_list, 'list') do
        string
      end
    end

    it 'uses the string type as the collection' do
      instance = Seahorse::ShapeBuilder.instance_of_type(:scalar_list)
      instance.collection.
          should be_instance_of(Seahorse::StringType)
    end
  end

  context 'a list of inline structures' do
    before(:each) do
      Seahorse::ShapeBuilder.type(:structure_list, 'list') do
        structure :person do
          string :name
          string :email
          integer :age
        end
      end
    end

    it 'uses the structure type as the collection' do
      instance = Seahorse::ShapeBuilder.instance_of_type(:structure_list)
      col = instance.collection
      col.should be_instance_of(Seahorse::StructureType)
    end

    it 'names the inline structure' do
      instance = Seahorse::ShapeBuilder.instance_of_type(:structure_list)
      col = instance.collection
    end

    it 'does not store the definition of the inline structure' do
      instance = Seahorse::ShapeBuilder.instance_of_type(:structure_list)
      col = instance.collection
      Seahorse::ShapeBuilder.type_class_for(:person).should be_nil
    end

  end

  context 'a list of a predefined structure type' do
    before(:each) do
      Seahorse::ShapeBuilder.type(:person) do
        string :name
        string :email
        integer :age
      end
      Seahorse::ShapeBuilder.type(:structure_list, 'list') { person }
    end

    it 'uses the structure type as the collection' do
      instance = Seahorse::ShapeBuilder.instance_of_type(:structure_list)
      instance.collection.should \
          be_instance_of(Seahorse::ShapeBuilder.type_class_for(:person))
    end
  end
end

describe Seahorse::MapType do


end