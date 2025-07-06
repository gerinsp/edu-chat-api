from app.rag.retriever import get_retriever

if __name__ == "__main__":
    retriever = get_retriever()
    query = "Saya bingung soal cerita matematika"
    docs = retriever.get_relevant_documents(query)

    print("📚 Context found:")
    for d in docs:
        print("-", d.page_content)