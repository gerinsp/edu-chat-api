from langchain_community.vectorstores import Chroma
from app.rag.embedding import get_embeddings

def get_retriever(persist_dir="chroma_db"):
    vectordb = Chroma(
        persist_directory=persist_dir,
        embedding_function=get_embeddings()
    )
    return vectordb.as_retriever(search_kwargs={"k": 3})