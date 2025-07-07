from app.config.config import GOOGLE_API_KEY
from langchain_google_genai import GoogleGenerativeAI

llm = GoogleGenerativeAI(
        model="gemini-2.0-flash",
        api_key=GOOGLE_API_KEY
    )