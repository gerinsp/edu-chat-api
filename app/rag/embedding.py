import os
from langchain_community.embeddings import HuggingFaceEmbeddings

def get_embeddings():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    model_path = os.path.abspath(
        os.path.join(base_dir, "..", "..", "model", "sentence-transformers", "all-MiniLM-L6-v2"))

    return HuggingFaceEmbeddings(model_name=model_path)