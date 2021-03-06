# -*- coding: utf-8 -*-
require 'spec_helper'

describe ChartData::AssetsController, :type => :controller do
  fixtures :users

  describe "#show" do
    context "before login," do
      before do
        get :show, id: 200_802, format: :json
      end

      it_should_behave_like "Unauthenticated Access"
    end

    context "after login," do
      before do
        dummy_login
      end

      context "when id's length is not 6 digit," do
        before do
          get :show, id: '21222', format: :json
        end

        it_should_behave_like "Not Acceptable"
      end

      context "when id's initial char is not 0," do
        before do
          get :show, id: '021222', format: :json
        end

        it_should_behave_like "Not Acceptable"
      end

      context "when id has non-numeric char," do
        before do
          get :show, id: '2008a2', format: :json
        end

        it_should_behave_like "Not Acceptable"
      end

      context "id does not mean correct year-month" do
        before do
          get :show, id: '200815', format: :json
        end

        it_should_behave_like "Not Acceptable"
      end

      context "When there is no data to send," do
        before do
          Account.destroy_all
          get :show, id: '200301', format: :json
        end
        subject { response }
        it {  is_expected.to be_success }

        describe '#body' do
          subject { super().body }
          it { is_expected.to eq("[]") }
        end
      end

      context "When there are data to send," do
        before do
          Account.destroy_all
          @user = users(:user1)
          account1 = users(:user1).bankings.create!(name: "その1", active: true, order_no: 10)
          _ = users(:user1).incomes.create!(name: "その2", active: true, order_no: 20)
          account3 = users(:user1).bankings.create!(name: "その3", active: true, order_no: 30)
          account4 = users(:user1).bankings.create!(name: "その4", active: true, order_no: 40)

          users(:user1).monthly_profit_losses.create!(month: Date.new(1999, 5), account_id: account1.id, amount: -300)
          users(:user1).monthly_profit_losses.create!(month: Date.new(1988, 6), account_id: account1.id, amount: -100)
          users(:user1).monthly_profit_losses.create!(month: Date.new(1999, 1), account_id: account1.id, amount: 900)
          users(:user1).monthly_profit_losses.create!(month: Date.new(1999, 1), account_id: account3.id, amount: 900)
          users(:user1).monthly_profit_losses.create!(month: Date.new(1998, 3), account_id: account4.id, amount: -200)
        end

        context "when asset_type is not specify," do
          before do
            get :show, id: '199901', format: :json
          end

          describe "response" do
            subject { response }
            it {  is_expected.to be_success }
            specify do
              expect(ActiveSupport::JSON.decode(subject.body)).to eq([{ "label" => "その1", "data" => 800 }, { "label" => "その3", "data" => 900 }])
            end
          end
        end
        context "when asset_type is debt," do
          before do
            get :show, id: '199901', format: :json, asset_type: 'debt'
          end

          describe "response" do
            subject { response }
            it {  is_expected.to be_success }
            specify do
              expect(ActiveSupport::JSON.decode(subject.body)).to eq([{ "label" => "その4", "data" => 200 }])
            end
          end
        end
      end
    end
  end
end
