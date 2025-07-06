from app.rag.vectorstore import create_vectorstore_from_data

# Data dummy untuk simulasi tips dan feedback
data = [
    {"content": "Jika siswa kesulitan soal cerita, latih dengan soal langkah demi langkah.", "metadata": {"subject": "Matematika"}},
    {"content": "Siswa dengan gaya belajar visual sebaiknya gunakan diagram.", "metadata": {"learning_style": "visual"}},
    {"content": "Latihan soal berulang dapat membantu siswa kinestetik memahami konsep."},
]

if __name__ == "__main__":
    create_vectorstore_from_data(data)
    print("✅ Vectorstore created and persisted.")