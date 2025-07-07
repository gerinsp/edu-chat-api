from app.rag.retriever import get_retriever
from app.tools.sql_tools import get_student_progress, get_students_by_parent, get_students_by_teacher, log_chatbot_interaction
from app.config.gemini_config import llm

def build_prompt_with_context(question, context):
    return f"""
            Konteks:
            {context}
            
            Pertanyaan:
            {question}
            
            Jawaban:
            """

def answer_as_student(user_input, student_id):
    retriever = get_retriever()
    rag_docs = retriever.get_relevant_documents(user_input)
    rag_context = "\n".join([doc.page_content for doc in rag_docs])

    progress = get_student_progress(student_id)
    progress_context = "\n".join([
        f"Mata Pelajaran: {p['subject_id']}, Score: {p['score']}, Tanggal: {p['submitted_at']}"
        for p in progress
    ])

    final_context = f"{progress_context}\n\n{rag_context}"
    prompt = build_prompt_with_context(user_input, final_context)

    response = llm.invoke(prompt)

    log_chatbot_interaction(student_id, "user", user_input)
    log_chatbot_interaction(student_id, "ai", response)

    return response

def answer_as_parent(user_input, parent_id):
    students = get_students_by_parent(parent_id)
    if not students:
        return "Tidak ada data murid untuk orang tua ini."

    context_lines = []
    for s in students:
        student_id = str(s["id"])

        progress = get_student_progress(student_id)
        for p in progress:
            context_lines.append(f"Anak: {s['name']}, Mata Pelajaran: {p['subject_name']}, Skor: {p['score']}, Tanggal: {p['submitted_at']}")

    retriever = get_retriever()
    rag_docs = retriever.get_relevant_documents(user_input)
    rag_context = "\n".join([doc.page_content for doc in rag_docs])

    final_context = "\n".join(context_lines) + "\n\n" + rag_context
    prompt = build_prompt_with_context(user_input, final_context)

    response = llm.invoke(prompt)

    # Log for each child
    for s in students:
        student_id = str(s["id"])
        log_chatbot_interaction(student_id, "parent", user_input)
        log_chatbot_interaction(student_id, "ai", response)

    return response

def answer_as_teacher(user_input, teacher_id):
    students = get_students_by_teacher(teacher_id)
    context_lines = []
    for s in students:
        student_id = str(s["id"])

        progress = get_student_progress(student_id)
        for p in progress:
            context_lines.append(f"Murid: {s['name']}, Mata Pelajaran: {p['subject_name']}, Skor: {p['score']}, Tanggal: {p['submitted_at']}")

    retriever = get_retriever()
    rag_docs = retriever.get_relevant_documents(user_input)
    rag_context = "\n".join([doc.page_content for doc in rag_docs])

    final_context = "\n".join(context_lines) + "\n\n" + rag_context
    prompt = build_prompt_with_context(user_input, final_context)

    response = llm.invoke(prompt)

    for s in students:
        student_id = str(s["id"])
        log_chatbot_interaction(student_id, "teacher", user_input)
        log_chatbot_interaction(student_id, "ai", response)

    return response