from datetime import datetime
from fastapi import FastAPI, Depends, HTTPException, BackgroundTasks
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import text
from passlib.context import CryptContext

from database import get_db
from models import Book
from schemas import BookSchema, UserRegisterSchema

app = FastAPI(title="BookFlow Gatekeeper API")
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Mock "text to vector" function standing in for a real embedding model
MOCK_VECTORS = {
    "space": [0.10, 0.85, 0.20],
    "adventure": [0.30, 0.20, 0.90],
    "society": [0.80, 0.10, 0.70],
}

def mock_embed(query: str) -> list[float]:
    query_lower = query.lower()
    for keyword, vector in MOCK_VECTORS.items():
        if keyword in query_lower:
            return vector
    return [0.5, 0.5, 0.5]  # neutral fallback


def log_new_book(title: str):
    with open("logs/activity.log", "a") as f:
        f.write(f"{datetime.utcnow().isoformat()} - New Book Added: {title}\n")


@app.post("/books", status_code=201)
async def create_book(
    book: BookSchema,
    background_tasks: BackgroundTasks,
    db: AsyncSession = Depends(get_db),
):
    new_book = Book(**book.model_dump())
    db.add(new_book)
    await db.commit()
    await db.refresh(new_book)

    # Runs AFTER the response is sent
    background_tasks.add_task(log_new_book, new_book.title)

    return {"id": new_book.id, "title": new_book.title}


@app.get("/books/search")
async def search_books(q: str, limit: int = 3, db: AsyncSession = Depends(get_db)):
    if not q.strip():
        raise HTTPException(status_code=400, detail={
            "error": {"code": "INVALID_PARAMETER", "message": "'q' must not be empty."}
        })
    if not (1 <= limit <= 20):
        raise HTTPException(status_code=400, detail={
            "error": {"code": "INVALID_PARAMETER", "message": "'limit' must be between 1 and 20."}
        })

    query_vector = mock_embed(q)

    result = await db.execute(
        text("""
            SELECT id, title, 1 - (embedding <=> CAST(:qvec AS vector)) AS score
            FROM books
            WHERE embedding IS NOT NULL
            ORDER BY embedding <=> CAST(:qvec AS vector)
            LIMIT :limit
        """),
        {"qvec": str(query_vector), "limit": limit},
    )
    rows = result.mappings().all()

    return {
        "query": q,
        "results": [
            {"id": r["id"], "title": r["title"], "score": round(float(r["score"]), 2)}
            for r in rows
        ],
    }


@app.post("/register", status_code=201)
async def register_user(user: UserRegisterSchema):
    hashed_password = pwd_context.hash(user.password)
    # A full build would save (user.username, hashed_password) to a users table.
    return {"username": user.username, "message": "Registered successfully"}