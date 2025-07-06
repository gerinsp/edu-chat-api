from app.rag.retriever import get_retriever
from langchain_google_genai import GoogleGenerativeAI
from app.tools.sql_tools import get_student_progress, get_students_by_parent, get_students_by_teacher, log_chatbot_interaction
from config import GOOGLE_API_KEY

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
        f"Subject ID: {p['subject_id']}, Score: {p['score']}, Tanggal: {p['submitted_at']}"
        for p in progress
    ])

    final_context = f"{progress_context}\n\n{rag_context}"
    prompt = build_prompt_with_context(user_input, final_context)

    llm = GoogleGenerativeAI(
        model="gemini-2.0-flash",
        api_key=GOOGLE_API_KEY
    )
    response = llm.invoke(prompt)

    log_chatbot_interaction(student_id, "user", user_input)
    log_chatbot_interaction(student_id, "ai", response)

    return response

def answer_as_parent(user_input, parent_id):
    students = get_students_by_parent(parent_id)
    context_lines = []
    for s in students:
        progress = get_student_progress(s["id"])
        for p in progress:
            context_lines.append(f"Anak: {s['name']}, Subject ID: {p['subject_id']}, Score: {p['score']}, Tanggal: {p['submitted_at']}")

    retriever = get_retriever()
    rag_docs = retriever.get_relevant_documents(user_input)
    rag_context = "\n".join([doc.page_content for doc in rag_docs])

    final_context = "\n".join(context_lines) + "\n\n" + rag_context
    prompt = build_prompt_with_context(user_input, final_context)

    llm = GoogleGenerativeAI(
        model="gemini-2.0-flash",
        api_key=GOOGLE_API_KEY
    )
    response = llm.invoke(prompt)

    # Log for each child
    for s in students:
        log_chatbot_interaction(s["id"], "parent", user_input)
        log_chatbot_interaction(s["id"], "ai", response)

    return response

def answer_as_teacher(user_input, teacher_id):
    students = get_students_by_teacher(teacher_id)
    context_lines = []
    for s in students:
        progress = get_student_progress(s["id"])
        for p in progress:
            context_lines.append(f"Murid: {s['name']}, Subject ID: {p['subject_id']}, Score: {p['score']}, Tanggal: {p['submitted_at']}")

    retriever = get_retriever()
    rag_docs = retriever.get_relevant_documents(user_input)
    rag_context = "\n".join([doc.page_content for doc in rag_docs])

    final_context = "\n".join(context_lines) + "\n\n" + rag_context
    prompt = build_prompt_with_context(user_input, final_context)

    llm = GoogleGenerativeAI(
        model="gemini-2.0-flash",
        api_key=GOOGLE_API_KEY
    )
    response = llm.invoke(prompt)

    for s in students:
        log_chatbot_interaction(s["id"], "teacher", user_input)
        log_chatbot_interaction(s["id"], "ai", response)

    return response