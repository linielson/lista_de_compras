require "rails_helper"

RSpec.describe Api::ListsController, type: :controller do

  describe "GET #index" do
    let!(:sabao) { List.create(name: "Mercado") }
    let!(:arroz) { List.create(name: "Farmácia") }

    before { get :index }

    it "responds successfully with an HTTP 200 status code" do
      expect(response).to have_http_status 200
    end

    it "renders the JSON" do
      expected = ActiveModel::ArraySerializer.new([sabao, arroz],
        each_serializer: ListPreviewSerializer, root: false).to_json

#, root: false NÃO é necessário

      expect(response.body).to eq expected
    end
  end

  describe "GET #show" do
    context "valid params" do
      let(:list) { List.create(name: "Mercado") }
      before { get :show, id: list }

      it "responds successfully with an HTTP 200 status code" do
        expect(response).to have_http_status 200
      end

      it "renders the JSON" do
        expected = ListSerializer.new(list).to_json

        expect(response.body).to eq expected
      end
    end

    context "invalid params" do
      before { get :show, id: 1 }

      it "responds successfully with an HTTP 404 status code" do
        expect(response).to have_http_status 404
      end

      it "renders the JSON" do
        expect(response.body).to match(/Couldn't find List/)
      end
    end
  end

  describe "POST #create" do
    context "valid params" do
      before { post :create, list: { name: "Mercado" } }

      it "responds successfully with an HTTP 201 status code" do
        expect(response).to have_http_status 201
      end

      it "renders the JSON" do
        expected = ListSerializer.new(List.last).to_json

        expect(response.body).to eq expected
      end

      it do
        should permit(:name, list_items_attributes: [
          :id, :list_id, :product_id, :quantity, :_destroy]).for(:create)
      end
    end

    context "invalid params" do
      before { post :create, list: { name: nil } }

      it "responds successfully with an HTTP 422 status code" do
        expect(response).to have_http_status 422
      end

      it "renders the errors" do
        expect(response.body).to match(/can't be blank/)
      end
    end
  end

  describe "PATCH #update" do
    let!(:list) { List.create(name: "Mercado") }

    context "valid params" do
      before { patch :update, id: list, list: { name: "Farmácia" } }

      it "responds successfully with an HTTP 200 status code" do
        expect(response).to have_http_status 200
      end

      it "renders the JSON" do
        expect(response.body).to match(/Farmácia/)
      end

      it "updates the list" do
        list.reload
        expect(list.name).to eq "Farmácia"
      end

      it do
        should permit(:name, list_items_attributes: [:id, :list_id, :product_id,
          :quantity, :_destroy]).for(:update, params: { id: list.id })
      end
    end

    context "invalid params" do
      before { patch :update, id: list, list: { name: nil } }

      it "responds successfully with an HTTP 422 status code" do
        expect(response).to have_http_status 422
      end

      it "renders the errors" do
        expect(response.body).to match(/can't be blank/)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:list) { List.create(name: "Mercado") }
    let(:destroy_list!) { delete :destroy, id: list }

    context "valid params" do
      it "responds successfully with an HTTP 200 status code" do
        destroy_list!

        expect(response).to have_http_status 200
      end

      it "renders the JSON" do
        destroy_list!

        expected = ListSerializer.new(list).to_json
        expect(response.body).to eq expected
      end

      it "destroy the list" do
        expect { destroy_list! }.to change(List, :count).by(-1)
      end
    end

    context "invalid params" do
      let!(:list) { List.new(id: 1) }

      before do
        list.valid?

        expect(List).to receive(:find).with("1").and_return(list)
        allow(list).to receive(:destroy).and_return(false)

        destroy_list!
      end

      it "responds successfully with an HTTP 422 status code" do
        expect(response).to have_http_status 422
      end

      it "renders the JSON" do
        expect(response.body).to match(/can't be blank/)
      end
    end
  end

end
