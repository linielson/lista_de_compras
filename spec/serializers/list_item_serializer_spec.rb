require "rails_helper"

describe ListItemSerializer do
  let(:product) { Product.new(id: 1, name: "Arroz") }

  subject { described_class.new ListItem.new(id: 123, quantity: 2, product: product) }

  it "creates special JSON for the API" do
    expected = {
      list_item: {
        id: 123,
        quantity: 2,
        product: {
          id: 1,
          name: "Arroz"
        }
      }
    }.to_json

    expect(subject.to_json).to eql(expected)
  end
end
