import os

import httpx
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import JSONResponse

load_dotenv()
app = FastAPI(title="E-Commerce API Gateway")

USER = os.getenv("USER_SERVICE_URL")
ACTIVITY = os.getenv("ACTIVITY_SERVICE_URL")
PRODUCT = os.getenv("PRODUCT_SERVICE_URL")
INVENTORY = os.getenv("INVENTORY_SERVICE_URL")
ORDER = os.getenv("ORDER_SERVICE_URL")


async def forward(method, url, request, json=None):
    headers = {}
    authorization = request.headers.get("Authorization")
    if authorization:
        headers["Authorization"] = authorization

    try:
        async with httpx.AsyncClient(timeout=3.0) as client:
            response = await client.request(
                method, url, headers=headers, json=json
            )
            return JSONResponse(
                status_code=response.status_code,
                content=response.json(),
            )
    except httpx.TimeoutException:
        raise HTTPException(504, "Downstream service timed out")
    except httpx.RequestError:
        raise HTTPException(503, "Downstream service unavailable")


@app.get("/health")
def health():
    return {"service": "api-gateway", "status": "UP"}


@app.post("/users")
async def create_user(request: Request):
    return await forward(
        "POST", f"{USER}/users", request, await request.json()
    )


@app.post("/login")
async def login(request: Request):
    return await forward(
        "POST", f"{USER}/login", request, await request.json()
    )


@app.get("/users/{user_id}")
async def get_user(user_id: str, request: Request):
    return await forward(
        "GET", f"{USER}/users/{user_id}", request
    )


@app.post("/products")
async def create_product(request: Request):
    return await forward(
        "POST", f"{PRODUCT}/products", request, await request.json()
    )


@app.get("/products")
async def get_products(request: Request):
    return await forward("GET", f"{PRODUCT}/products", request)


@app.get("/products/{product_id}")
async def get_product(product_id: str, request: Request):
    return await forward(
        "GET", f"{PRODUCT}/products/{product_id}", request
    )


@app.post("/inventory")
async def create_inventory(request: Request):
    return await forward(
        "POST", f"{INVENTORY}/inventory", request, await request.json()
    )


@app.get("/inventory/{product_id}")
async def get_inventory(product_id: str, request: Request):
    return await forward(
        "GET", f"{INVENTORY}/inventory/{product_id}", request
    )


@app.post("/inventory/{product_id}/reserve")
async def reserve(product_id: str, request: Request):
    return await forward(
        "POST", f"{INVENTORY}/inventory/{product_id}/reserve",
        request, await request.json()
    )


@app.post("/inventory/{product_id}/release")
async def release(product_id: str, request: Request):
    return await forward(
        "POST", f"{INVENTORY}/inventory/{product_id}/release",
        request, await request.json()
    )


@app.post("/orders")
async def create_order(request: Request):
    return await forward(
        "POST", f"{ORDER}/orders", request, await request.json()
    )


@app.get("/orders/{order_id}")
async def get_order(order_id: str, request: Request):
    return await forward(
        "GET", f"{ORDER}/orders/{order_id}", request
    )


@app.get("/activities")
async def activities(request: Request):
    return await forward("GET", f"{ACTIVITY}/activities", request)