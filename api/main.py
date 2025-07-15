from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional
import uvicorn
from app.workflows.langgraph_flow import langgraph_app
from app.tools.sql_tools import verify_user_role

app = FastAPI(title="Educational Chatbot API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class ChatInput(BaseModel):
    user_id: str
    role: str
    question: str
    context: Optional[str] = None


class ChatResponse(BaseModel):
    answer: str
    user_id: str
    role: str
    timestamp: str


@app.post("/chat", response_model=ChatResponse)
async def chat(input_data: ChatInput):
    try:
        user_role = verify_user_role(input_data.user_id)
        if not user_role or user_role != input_data.role:
            raise HTTPException(status_code=403, detail="Invalid user role")

        result = langgraph_app.invoke(input_data.dict())

        return ChatResponse(
            answer=result.get("answer", "Maaf, saya tidak dapat memproses pertanyaan Anda saat ini."),
            user_id=input_data.user_id,
            role=input_data.role,
            timestamp=result.get("timestamp", "")
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing request: {str(e)}")

@app.get("/health")
async def health_check():
    return {"status": "healthy", "message": "Educational Chatbot API is running"}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)