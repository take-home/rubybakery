require 'spec_helper'
# test new feature with sidekiq
require 'sidekiq/testing'
Sidekiq::Testing.inline!

describe CookiesController do
  let(:user) { FactoryGirl.create(:user) }
  let(:oven) { user.ovens.first }

  describe 'GET new' do
    let(:the_request) { get :new, params: { oven_id: oven.id } }

    context "when not authenticated" do
      before { sign_in nil }

      it "blocks access" do
        the_request
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "allows access" do
        the_request
        expect(response).to_not be_a_redirect
      end

      context "when a valid oven is supplied" do
        it "assigns @oven" do
          the_request

          expect(assigns(:oven)).to eq(oven)
        end

        it "assigns a new @cookie" do
          the_request

          cookie = assigns(:cookie)
          expect(cookie).to_not be_persisted
          expect(cookie.storage).to eq(oven)
        end
      end

      context "when an invalid oven is supplied" do
        let(:oven) { FactoryGirl.create(:oven) }

        it "is not successful" do
          expect {
            the_request
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe 'POST create' do
    context "one cookie in the oven" do
    let(:the_request) { post :create, params: { oven_id: oven.id, cookie: cookie_params, quantity: 1, oven_time: 0.1 } }
    let(:cookie_params) {
      {
        fillings: 'Vanilla',
      }
    }
  end
end
