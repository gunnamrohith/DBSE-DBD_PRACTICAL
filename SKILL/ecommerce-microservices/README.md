# E-Commerce Microservices Platform

This project follows `ECommerce_Microservices_Step_by_Step_Postman_Guide.docx`. Postman is the client; there is no browser frontend.

## Architecture

```text
Postman -> API Gateway :8000
                 |-> User Service :4001 -> user_db
                 |-> Activity Service :4002 -> activity_db
                 |-> Product Service :8003 -> product_db
                 |-> Inventory Service :8004 -> inventory_db
                 `-> Order Service :8005 -> order_db
```

MongoDB runs at `mongodb://127.0.0.1:27017`. Each service accesses only its own database.

## Ports

| Component | Port |
| --- | ---: |
| API Gateway | 8000 |
| User Service | 4001 |
| Activity Service | 4002 |
| Product Service | 8003 |
| Inventory Service | 8004 |
| Order Service | 8005 |
| MongoDB | 27017 |

These application ports were checked and were free before setup. MongoDB was already running on its required port.

## Run on macOS

MongoDB and Python 3.11 or newer are required. Install the dependencies and create local environment files once:

```bash
cd user-service && npm install && cp .env.example .env && cd ..
cd activity-service && npm install && cp .env.example .env && cd ..

for service in product-service inventory-service order-service api-gateway; do
    python3 -m venv "$service/.venv"
    "$service/.venv/bin/pip" install -r "$service/requirements.txt"
    cp "$service/.env.example" "$service/.env"
done
```

Change `JWT_SECRET` in `user-service/.env` for any non-classroom deployment. Keep each command below running in a separate terminal.

```bash
cd user-service
npm start
```

```bash
cd activity-service
npm start
```

```bash
cd product-service
.venv/bin/uvicorn main:app --reload --port 8003
```

```bash
cd inventory-service
.venv/bin/uvicorn main:app --reload --port 8004
```

```bash
cd order-service
.venv/bin/uvicorn main:app --reload --port 8005
```

```bash
cd api-gateway
.venv/bin/uvicorn main:app --reload --port 8000
```

Send normal requests to `http://127.0.0.1:8000`.

## Postman

Import both files from `postman/`:

- `E-Commerce-Microservices.postman_collection.json`
- `E-Commerce-Local.postman_environment.json`

Select the **E-Commerce Local** environment and run the collection in numbered order. The tests automatically capture `userId`, `token`, `productId`, and `orderId`.

The registration request uses `anita@example.com` exactly as the guide specifies. If the collection is run again, delete that user from `user_db.users` or change the email because it is unique.