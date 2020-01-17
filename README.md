# Challenge

API for handling orders and batches in a production pipeline

## Creating an order

### POST /orders/create

Creates a new order in the production pipeline.

This action expects an json object with the following structure and non-empty values:
```yaml
{
    "order": {
        "reference": "BR112233",
        "purchase_channel": "Site BR",
        "client_name": "Matheus Nogueira",
        "address": "Rua Carolina Sucupira, 100 - Fortaleza, CE",
        "delivery_service": "SEDEX",
        "total_value": "$ 123,45",
        "line_items": [
            "{ sku: case-my-best-friend, model: iPhone X, case type: Rose Leather }",
            "{ sku: powebank-sunshine, capacity: 10000mah }",
            "{ sku: earphone-standard, color: white }"
        ],
    }
}
```
Returns the created order object, with status code *201 - Created* on success

Returns an errors object, with status code  *422 - Unprocessable Entity* on failure

**Example errors object**
```yaml
{
    "errors": {
        "client_name": [
            "can't be blank"
        ]
    }
}
```

## Getting an order's status

### GET /orders/status/reference/:reference

Returns the status for the order with this *:reference*, status code *200 - Ok* on success

### GET /orders/status/client/:client_name

Returns the status for the **latest** order with this *:client_name*, status code *200 - Ok* on success

**Example**
```yaml
{
    "order": {
        "reference": "BR112233",
        "status": "sent"
    }
}
```

Both actions return an errors object, with status code  *404 - Not Found* if the order is not found

## Listing orders

### GET /orders/list/:purchase_channel

Lists all orders from this *:purchase_channel*

Always returns an array of orders , status code *200 - Ok*. Returns an empty orders array if there are no orders for this *:purchase_channel*

**Example**
```yaml
{
    "orders": [
        {
            "id": 2,
            "reference": "BR112244",
            "purchase_channel": "Site BR",
            "client_name": "Jose",
            "address": "Rua Carolina Sucupira 100",
            "delivery_service": "DHL",
            "total_value": "50",
            "line_items": [
                "{\"sku\": \"case-my-best-friend\", \"model\": \"iPhone X\", \"case type\": \"Rose Leather\"}"
            ],
            "status": "sent",
            "batch_id": 10,
            "created_at": "2020-01-16T16:27:10.140Z",
            "updated_at": "2020-01-16T18:08:50.771Z"
        }
    ]
}
```

## Creating a batch

### POST /batches/create/:purchase_channel

Creates a new batch for the *:purchase_channel*

Returns a batch object containing both the created batch reference and order count, with status code *201 - Created* on success

**Example**
```yaml
{
    "batch": {
        "reference": "c4be343b-de",
        "orders": 10
    }
}
```

## Producing and closing a batch 

### POST /batches/produce/:reference

Produces the batch with this *:reference*

Returns a batch object containing the ammount of orders produced, with status code *200 - Ok* on success

**Example**
```yaml
{
    "batch": {
        "produced": 3
    }
}
```

### POST /batches/close/:reference/:delivery

Closes the orders for this *:delivery* service on the batch with this *:reference*

Returns a batch object containing the ammount of orders closed, with status code *200 - Ok* on success

**Example**
```yaml
{
    "batch": {
        "closed": 0
    }
}
```

Both actions return an errors object, with status code  *404 - Not Found* if the batch is not found
