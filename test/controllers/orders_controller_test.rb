require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  test 'should return ok for status by reference' do
    get order_reference_status_path('UNIQUEREF1')
    assert_response :ok
  end

  test 'should return not_found for status by non-existent reference' do
    get order_reference_status_path('DOESNOTEXIST')
    assert_response :not_found
  end

  test 'should return ok for order status by client_name' do
    get order_client_status_path('NAME1')
    assert_response :ok
  end

  test 'should return not_found for status by non-existent client_name' do
    get order_client_status_path('DOESNOTEXIST')
    assert_response :not_found
  end

  test 'list should always return ok' do
    %w[CHAN NONEXIST].each do |purchase_channel|
      get order_list_path(purchase_channel)
      assert_response :ok
    end
  end

  test 'should create order and return created' do
    assert_difference 'Order.count', 1 do
      post create_order_path, params: {
        order: {
          reference: 'UNIQUEREF2',
          purchase_channel: 'CHAN2',
          client_name: 'NAME2',
          address: 'ADDR',
          delivery_service: 'DS',
          total_value: 'CURR',
          line_items: [
            '{ sku: case-my-best-friend, model: iPhone X, case type: Rose Leather}',
            '{ sku: powebank-sunshine, capacity: 10000mah}',
            '{sku: earphone-standard, color: white}'
            ]
        }
      }
      assert_response :created
    end
  end

  test 'should not create order and should return unprocessable entity' do
    assert_difference 'Order.count', 0 do
      post create_order_path, params: {
        order: {
          reference: '',
          purchase_channel: '',
          client_name: '',
          address: '',
          delivery_service: '',
          total_value: '',
          line_items: []
        }
      }
      assert_response :unprocessable_entity
    end
  end

end
