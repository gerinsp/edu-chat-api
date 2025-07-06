from sqlalchemy import create_engine, text
import os
from dotenv import load_dotenv
from datetime import datetime
import uuid

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
engine = create_engine(DATABASE_URL)

def get_students_by_parent(parent_id):
    with engine.connect() as conn:
        result = conn.execute(text("""
            SELECT id, name FROM users WHERE parent_id = :parent_id
        """), {"parent_id": parent_id})
        return [dict(row) for row in result]

def get_student_progress(student_id):
    with engine.connect() as conn:
        result = conn.execute(text("""
            SELECT q.subject_id, qr.total_questions, qr.correct_answers, qr.score, qr.submitted_at
            FROM quiz_results qr
            JOIN question_packages q ON q.id = qr.package_id
            WHERE qr.student_id = :student_id
            ORDER BY qr.submitted_at DESC
        """), {"student_id": student_id})
        return [dict(row) for row in result]

def get_students_by_teacher(teacher_id, grade=None):
    query = text("""
        SELECT u.id, u.name, u.grade FROM student_teacher st
        JOIN users u ON u.id = st.student_id
        WHERE st.teacher_id = :teacher_id
        AND (:grade IS NULL OR u.grade = :grade)
    """)
    with engine.connect() as conn:
        result = conn.execute(query, {"teacher_id": teacher_id, "grade": grade})
        return [dict(row) for row in result]

def log_chatbot_interaction(student_id: str, message_from: str, message: str):
    with engine.begin() as conn:
        conn.execute(text("""
            INSERT INTO chatbot_logs (id, student_id, message_from, message, created_at)
            VALUES (:id, :student_id, :message_from, :message, :created_at)
        """), {
            "id": str(uuid.uuid4()),
            "student_id": student_id,
            "message_from": message_from,
            "message": message,
            "created_at": datetime.utcnow()
        })