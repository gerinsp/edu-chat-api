from sqlalchemy import create_engine, text
from datetime import datetime
import uuid
from typing import List, Dict, Optional
from app.config.config import DATABASE_URL

engine = create_engine(DATABASE_URL)

def verify_user_role(user_id: str) -> Optional[str]:
    try:
        with engine.connect() as conn:
            result = conn.execute(text("""
                SELECT role FROM users WHERE id = :user_id
            """), {"user_id": user_id})
            row = result.fetchone()
            return row[0] if row else None
    except Exception:
        return None


def get_students_by_parent(parent_id: str) -> List[Dict]:
    with engine.connect() as conn:
        result = conn.execute(text("""
            SELECT id, name, grade FROM users 
            WHERE parent_id = :parent_id AND role = 'student'
            ORDER BY name
        """), {"parent_id": parent_id})
        return [row._mapping for row in result]


def get_student_progress(student_id: str) -> List[Dict]:
    with engine.connect() as conn:
        result = conn.execute(text("""
            SELECT 
                s.name as subject_name,
                qr.total_questions,
                qr.correct_answers,
                qr.score,
                qr.submitted_at,
                qp.title as package_title
            FROM quiz_results qr
            JOIN question_packages qp ON qp.id = qr.package_id
            JOIN subjects s ON s.id = qp.subject_id
            WHERE qr.student_id = :student_id
            ORDER BY qr.submitted_at DESC
            LIMIT 10
        """), {"student_id": student_id})
        return [row._mapping for row in result]


def get_students_by_teacher(teacher_id: str, grade: Optional[str] = None) -> List[Dict]:
    query = text("""
        SELECT u.id, u.name, u.grade 
        FROM student_teachers st
        JOIN users u ON u.id = st.student_id
        WHERE st.teacher_id = :teacher_id
        AND (:grade IS NULL OR u.grade = :grade)
        ORDER BY u.grade, u.name
    """)
    with engine.connect() as conn:
        result = conn.execute(query, {"teacher_id": teacher_id, "grade": grade})
        return [row._mapping for row in result]


def get_learning_insights(student_id: str) -> List[Dict]:
    with engine.connect() as conn:
        result = conn.execute(text("""
            SELECT strength, weakness, last_updated
            FROM learning_insights
            WHERE student_id = :student_id
            ORDER BY last_updated DESC
            LIMIT 5
        """), {"student_id": student_id})
        return [row._mapping for row in result]


def get_learning_tips(student_id: str) -> List[Dict]:
    with engine.connect() as conn:
        result = conn.execute(text("""
            SELECT lt.tip, s.name as subject_name, lt.created_at
            FROM learning_tips lt
            LEFT JOIN subjects s ON s.id = lt.subject_id
            WHERE lt.student_id = :student_id
            ORDER BY lt.created_at DESC
            LIMIT 5
        """), {"student_id": student_id})
        return [row._mapping for row in result]


def get_learning_profile(student_id: str) -> Optional[Dict]:
    with engine.connect() as conn:
        result = conn.execute(text("""
            SELECT preferred_learning_style, learning_pace, focus_area, updated_at
            FROM learning_profiles
            WHERE student_id = :student_id
            ORDER BY updated_at DESC
            LIMIT 1
        """), {"student_id": student_id})
        row = result.fetchone()
        return row._mapping if row else None


def get_feedbacks(student_id: str = None, teacher_id: str = None) -> List[Dict]:
    if student_id:
        query = text("""
            SELECT f.content, f.created_at, u.name as teacher_name
            FROM feedbacks f
            JOIN users u ON u.id = f.teacher_id
            WHERE f.student_id = :student_id
            ORDER BY f.created_at DESC
            LIMIT 5
        """)
        params = {"student_id": student_id}
    elif teacher_id:
        query = text("""
            SELECT f.content, f.created_at, u.name as student_name
            FROM feedbacks f
            JOIN users u ON u.id = f.student_id
            WHERE f.teacher_id = :teacher_id
            ORDER BY f.created_at DESC
            LIMIT 10
        """)
        params = {"teacher_id": teacher_id}
    else:
        return []

    with engine.connect() as conn:
        result = conn.execute(query, params)
        return [row._mapping for row in result]


def get_subject_performance(student_id: str) -> List[Dict]:
    with engine.connect() as conn:
        result = conn.execute(text("""
            SELECT 
                s.name as subject_name,
                AVG(qr.score) as avg_score,
                COUNT(qr.id) as total_attempts,
                MAX(qr.score) as best_score,
                MIN(qr.score) as worst_score
            FROM quiz_results qr
            JOIN question_packages qp ON qp.id = qr.package_id
            JOIN subjects s ON s.id = qp.subject_id
            WHERE qr.student_id = :student_id
            GROUP BY s.id, s.name
            ORDER BY avg_score DESC
        """), {"student_id": student_id})
        return [row._mapping for row in result]


def log_chatbot_interaction(student_id: str, message_from: str, message: str):
    try:
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
    except Exception as e:
        print(f"Error logging interaction: {e}")


def add_learning_insight(student_id: str, strength: str = None, weakness: str = None):
    with engine.begin() as conn:
        conn.execute(text("""
            INSERT INTO learning_insights (id, student_id, strength, weakness, last_updated)
            VALUES (:id, :student_id, :strength, :weakness, :last_updated)
            ON CONFLICT (student_id) DO UPDATE SET
                strength = EXCLUDED.strength,
                weakness = EXCLUDED.weakness,
                last_updated = EXCLUDED.last_updated
        """), {
            "id": str(uuid.uuid4()),
            "student_id": student_id,
            "strength": strength,
            "weakness": weakness,
            "last_updated": datetime.utcnow()
        })


def add_learning_tip(student_id: str, tip: str, subject_id: str = None):
    with engine.begin() as conn:
        conn.execute(text("""
            INSERT INTO learning_tips (id, student_id, subject_id, tip, created_at)
            VALUES (:id, :student_id, :subject_id, :tip, :created_at)
        """), {
            "id": str(uuid.uuid4()),
            "student_id": student_id,
            "subject_id": subject_id,
            "tip": tip,
            "created_at": datetime.utcnow()
        })