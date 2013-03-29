require 'test_helper'

class QuotesControllerTest < ActionController::TestCase
  setup do
    @quote = quotes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quotes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quote" do
    assert_difference('Quote.count') do
      post :create, quote: { date: @quote.date, eps_actual: @quote.eps_actual, eps_estimate: @quote.eps_estimate, neg1_close: @quote.neg1_close, neg1_open: @quote.neg1_open, stock_id: @quote.stock_id, time: @quote.time, zero_close: @quote.zero_close, zero_open: @quote.zero_open }
    end

    assert_redirected_to quote_path(assigns(:quote))
  end

  test "should show quote" do
    get :show, id: @quote
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @quote
    assert_response :success
  end

  test "should update quote" do
    put :update, id: @quote, quote: { date: @quote.date, eps_actual: @quote.eps_actual, eps_estimate: @quote.eps_estimate, neg1_close: @quote.neg1_close, neg1_open: @quote.neg1_open, stock_id: @quote.stock_id, time: @quote.time, zero_close: @quote.zero_close, zero_open: @quote.zero_open }
    assert_redirected_to quote_path(assigns(:quote))
  end

  test "should destroy quote" do
    assert_difference('Quote.count', -1) do
      delete :destroy, id: @quote
    end

    assert_redirected_to quotes_path
  end
end
