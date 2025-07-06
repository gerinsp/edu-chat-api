from langchain_community.vectorstores import Chroma
from langchain.schema import Document
from langchain.text_splitter import CharacterTextSplitter
from app.rag.embedding import get_embeddings

def create_vectorstore_from_data(data: list[dict], persist_dir: str = "chroma_db"):
    splitter = CharacterTextSplitter(chunk_size=500, chunk_overlap=50)

    docs = [Document(page_content=item["content"], metadata=item.get("metadata", {})) for item in data]
    split_docs = splitter.split_documents(docs)

    vectordb = Chroma.from_documents(
        documents=split_docs,
        embedding=get_embeddings(),
        persist_directory=persist_dir
    )
    vectordb.persist()
    return vectordb