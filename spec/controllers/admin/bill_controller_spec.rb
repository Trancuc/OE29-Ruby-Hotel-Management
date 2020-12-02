require "rails_helper"
RSpec.describe Admin::BillsController , type: :controller do
  include_examples "index_examples"
  let! (:bill){FactoryBot.create(:bill, user: user_admin, status: "accept")}
  # let! (:bill2){FactoryBot.create(:bill)}
  let! (:booking){FactoryBot.create(:booking, bill: bill)}

  context "When normal user login" do
    before {log_in user}
    describe "GET #index" do
      before{get :index, params: {user_id: user.id, page: 1}, format: :js}
      it "should redirect to page client" do
        expect(response).to redirect_to root_path
      end
    end

    describe "GET #show" do
      before{get :show, params: {id: bill.id, page: 1}}
      it "should redirect to page client" do
        expect(response).to redirect_to root_path
      end
    end

    describe "PATCH #update" do
      before{ patch :update, params: {id: bill.id,price: bill.price, status: "complete", page: 1}}
      it "should redirect to page client" do
        expect(response).to redirect_to root_path
      end
    end
  end

  context "When normal user login" do
    before {log_in user_admin}
    
    describe "GET #index" do
      before do
        get :index, params: {user_id: user_admin.id, page: 1}, format: :js
      end

      it "should response js" do
        expect(response).to render_template :index
      end
    end

    describe "GET #show" do
      context "when valid param" do
        before do
          get :show, params: {id: bill.id, page: 1}
        end

        it "should render show template" do
          expect(response).to render_template :show
        end

        it "should assigns @bill" do
          expect(assigns(:bill).id).to eq bill.id
        end
      end

      context "when invalid param" do
        before do
          get :show, params: {id: -4 , page: 1}
        end

        it "respond with 404 if page not found" do
          expect(response.status).to eq(404)
        end
      end
    end

    describe "PATCH #update" do
      context "when valid param" do
        before do
          patch :update, params: {id: bill.id,price: bill.price, status: "complete", page: 1}
        end

        it "should update and redirect to admin_users_path" do
          expect(response).to redirect_to admin_users_path
        end

        it "should return success message" do
          expect(flash[:info]).to eq I18n.t("global.complete")
        end

        it "should assigns @bill" do
          expect(assigns(:bill).id).to eq bill.id
        end

      end

      context "when invalid param" do
        before { patch :update, params: {id: bill.id,price: "", page: 1} }

        it "should return error message" do
          expect(flash.now[:danger]).to eq I18n.t("global.complete_error")
        end

        it "should render show" do
          expect(response).to render_template :show
        end
      end
    end
  end
end
