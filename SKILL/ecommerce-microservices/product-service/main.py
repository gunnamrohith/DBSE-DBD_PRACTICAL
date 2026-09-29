import os

from bson import ObjectId
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from pymongo import MongoClient

load_dotenv()

app = FastAPI(title="Product Service")
client = MongoClient(os.getenv("MONGO_URI"))
db = client.get_default_database()
products = db["products"]


class ProductCreate(BaseModel):
    name: str = Field(min_length=2)
    category: str
    price: float = Field(gt=0)


@app.get("/health")
def health():
    return {"service": "product-service", "status": "UP"}


@app.post("/products", status_code=201)
def create_product(product: ProductCreate):
    result = products.insert_one(product.model_dump())
    return {"id": str(result.inserted_id), "message": "Product created"}


@app.get("/products")
def get_products():
    result = []
    for product in products.find():
        product["_id"] = str(product["_id"])
        result.append(product)
    return result


@app.get("/products/{product_id}")
def get_product(product_id: str):
    try:
        product = products.find_one({"_id": ObjectId(product_id)})
    except Exception:
        raise HTTPException(400, "Invalid product id")

    if not product:
        raise HTTPException(404, "Product not found")

    product["_id"] = str(product["_id"])
    return product