from sqlalchemy import Column, Integer, String, Numeric, Date, Text
from pgvector.sqlalchemy import Vector
from database import Base

class Book(Base):
    __tablename__ = "books"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(200), nullable=False)
    author = Column(String(200))
    description = Column(Text)
    isbn = Column(String(13))
    price = Column(Numeric(10, 2))
    published_date = Column(Date)
    embedding = Column(Vector(3))