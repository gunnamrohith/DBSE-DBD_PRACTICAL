from datetime import date
from pydantic import BaseModel, field_validator

class BookSchema(BaseModel):
    title: str
    author: str | None = None
    description: str | None = None
    isbn: str
    price: float
    published_date: date

    @field_validator("isbn")
    @classmethod
    def isbn_must_be_13_chars(cls, v: str) -> str:
        if len(v) != 13:
            raise ValueError("isbn must be exactly 13 characters")
        return v

    @field_validator("price")
    @classmethod
    def price_must_be_positive(cls, v: float) -> float:
        if v <= 0:
            raise ValueError("price must be a positive number")
        return v

    @field_validator("published_date")
    @classmethod
    def date_not_in_future(cls, v: date) -> date:
        if v > date.today():
            raise ValueError("published_date cannot be in the future")
        return v


class UserRegisterSchema(BaseModel):
    username: str
    password: str