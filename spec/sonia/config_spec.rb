require 'spec_helper'

require 'sonia/config'

describe Sonia::Config do
  describe "#new" do
    let(:data) {{
      :name   => 'Sonia',
      :nested => {
        :one => 1,
        :two => 2
      }
    }}

    subject { Sonia::Config.new(data) }


    its(:name) { should == 'Sonia' }
    its(:nested) { should be_kind_of Sonia::Config }
    it "has nested data" do
      subject.nested.one.should == 1
      subject.nested.two.should == 2
    end
  end

  describe "#[]" do
    let(:data) {{ :name => 'Sonia' }}
    subject { Sonia::Config.new(data) }

    it "returns same data" do
      subject.name.should == 'Sonia'
      subject[:name].should == 'Sonia'
      subject["name"].should == 'Sonia'
    end
  end

  describe "#[]=" do
    let(:data) {{ :name => 'Sonia' }}
    subject { Sonia::Config.new(data) }

    it "allows updating data" do
      subject.name.should == 'Sonia'

      subject[:name] = "Piotr"
      subject.name.should == 'Piotr'
      subject[:name].should == 'Piotr'
      subject["name"].should == 'Piotr'

      subject["name"] = "John"
      subject.name.should == 'John'
      subject[:name].should == 'John'
      subject["name"].should == 'John'
    end
  end

  describe "#each" do
    let(:data) {{ :name => 'Sonia', :age => 21 }}
    subject { Sonia::Config.new(data) }

    it "returns enumerator" do
      subject.each.should be_kind_of(Enumerator)
    end

    it "allows to iterate over keys" do
      hash = {}
      subject.each do |k, v|
        hash[k] = v
      end

      hash.keys.size.should == 2
      hash.values.size.should == 2

      hash.keys.should include(:name)
      hash.keys.should include(:age)

      hash.values.should include(21)
      hash.values.should include('Sonia')
    end
  end

  describe "#to_hash" do
    let(:data) {{ "age" => 21 }}
    subject { Sonia::Config.new(data) }

    it "returns whole config data" do
      subject.to_hash.should == { :age => 21 }
    end
  end
end
