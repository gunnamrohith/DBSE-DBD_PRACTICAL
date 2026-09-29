import os

from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from pymongo import MongoClient

load_dotenv()

app = FastAPI(title="Inventory Service")
client = MongoClient(os.getenv("MONGO_URI"))
db = client.get_default_database()
inventory = db["inventory"]


class StockCreate(BaseModel):
    productId: str
    availableQuantity: int = Field(ge=0)


class QuantityRequest(BaseModel):
    quantity: int = Field(gt=0)


@app.get("/health")
def health():
    return {"service": "inventory-service", "status": "UP"}


@app.post("/inventory")
def create_stock(stock: StockCreate):
    doc = {
        "productId": stock.productId,
        "availableQuantity": stock.availableQuantity,
        "reservedQuantity": 0,
    }
    result = inventory.insert_one(doc)
    return {
        "id": str(result.inserted_id),
        "productId": stock.productId,
        "availableQuantity": stock.availableQuantity,
        "reservedQuantity": 0,
    }


@app.get("/inventory/{product_id}")
def get_inventory(product_id: str):
    item = inventory.find_one({"productId": product_id})
    if not item:
        raise HTTPException(404, "Inventory record not found")
    item["_id"] = str(item["_id"])
    return item


@app.post("/inventory/{product_id}/reserve")
def reserve(product_id: str, req: QuantityRequest):
    item = inventory.find_one({"productId": product_id})
    if not item:
        raise HTTPException(404, "Inventory record not found")

    if item["availableQuantity"] < req.quantity:
        raise HTTPException(409, "Insufficient stock")

    inventory.update_one(
        {"productId": product_id},
        {"$inc": {
            "availableQuantity": -req.quantity,
            "reservedQuantity": req.quantity,
        }},
    )
    return {"message": "Stock reserved", "productId": product_id}


@app.post("/inventory/{product_id}/release")
def release(product_id: str, req: QuantityRequest):
    item = inventory.find_one({"productId": product_id})
    if not item:
        raise HTTPException(404, "Inventory record not found")

    if item["reservedQuantity"] < req.quantity:
        raise HTTPException(409, "Cannot release more than reserved")

    inventory.update_one(
        {"productId": product_id},
        {"$inc": {
            "availableQuantity": req.quantity,
            "reservedQuantity": -req.quantity,
        }},
    )
    return {"message": "Stock released", "productId": product_id}