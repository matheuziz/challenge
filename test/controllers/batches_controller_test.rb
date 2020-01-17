require 'test_helper'

class BatchesControllerTest < ActionDispatch::IntegrationTest
  test 'should create a batch' do
    assert_difference 'Batch.count', 1 do
      post batch_create_path('CHAN')
    end
    assert_response :created
  end

  test 'created batch should have all orders from the production_channel' do
    post batch_create_path('CHAN')
    assert JSON.parse(response.body)['batch']['orders'] == 2
  end
  
  test 'should produce all orders in a batch' do
    post batch_create_path('CHAN')
    ref = JSON.parse(response.body)['batch']['reference']
    post batch_produce_path(ref)
    assert JSON.parse(response.body)['batch']['produced'] == 2
  end

  test 'produce action should return not_found if batch not found' do
    post batch_create_path('CHAN')
    JSON.parse(response.body)['batch']['reference']
    post batch_produce_path('alalalala')
    assert_response :not_found
  end

  test 'should close orders for the delivery service in a batch' do
    post batch_create_path('CHAN')
    ref = JSON.parse(response.body)['batch']['reference']
    post batch_produce_path(ref)
    post batch_close_path(ref, 'DHL')
    assert JSON.parse(response.body)['batch']['closed'] == 2
  end

  test 'close action should return not_found if batch not found' do
    post batch_create_path('CHAN')
    ref = JSON.parse(response.body)['batch']['reference']
    post batch_produce_path(ref)
    post batch_close_path('alalalalal', 'DHL')
    assert :not_found
  end

  test 'close action should close 0 orders if delivery_service is not found' do
    post batch_create_path('CHAN')
    ref = JSON.parse(response.body)['batch']['reference']
    post batch_produce_path(ref)
    post batch_close_path(ref, 'L')
    assert JSON.parse(response.body)['batch']['closed'].zero?
  end

  test 'close action should close 0 orders if there are no orders to close' do
    post batch_create_path('CHAN')
    ref = JSON.parse(response.body)['batch']['reference']
    post batch_close_path(ref, 'L')
    assert JSON.parse(response.body)['batch']['closed'].zero?
  end
end
