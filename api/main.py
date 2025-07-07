from fastapi import FastAPI
from pydantic import BaseModel
from app.workflows.langgraph_flow import langgraph_app

app = FastAPI()

class ChatInput(BaseModel):
    user_id: str
    role: str
    question: str


@app.post("/chat")
async def chat(input_data: ChatInput):
    result = langgraph_app.invoke(input_data.dict())
    return {"answer": result.get("answer", "Tidak ada jawaban ditemukan.")}


