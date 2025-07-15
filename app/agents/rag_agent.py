from app.rag.retriever import get_retriever
from app.tools.sql_tools import (
    get_student_progress, get_students_by_parent, get_students_by_teacher,
    log_chatbot_interaction, get_learning_insights, get_learning_tips,
    get_learning_profile, get_feedbacks, get_subject_performance
)
from app.config.gemini_config import llm
from datetime import datetime
import json


class EducationalAgent:
    def __init__(self):
        self.retriever = get_retriever()

    def build_comprehensive_prompt(self, question, context, role_context, insights=None):
        base_prompt = f"""
        Kamu adalah asisten pendidikan yang cerdas dan membantu. Tugasmu adalah membantu siswa, orang tua, dan guru dengan memberikan jawaban yang personal dan berbasis data.

        KONTEKS PENGGUNA:
        {role_context}

        KONTEKS PEMBELAJARAN:
        {context}

        INSIGHTS PEMBELAJARAN:
        {insights or 'Tidak ada insights khusus tersedia'}

        PERTANYAAN:
        {question}

        INSTRUKSI JAWABAN:
        1. Berikan jawaban yang personal berdasarkan data performa siswa
        2. Gunakan bahasa yang ramah dan mudah dipahami
        3. Berikan saran konkret dan actionable
        4. Jika relevan, berikan tips belajar yang sesuai dengan gaya belajar siswa
        5. Jika ada data performa rendah, berikan motivasi dan strategi perbaikan
        6. Maksimal 300 kata

        JAWABAN:
        """
        return base_prompt

    def get_educational_context(self, user_id, role):
        if role == 'student':
            return self._get_student_context(user_id)
        elif role == 'parent':
            return self._get_parent_context(user_id)
        elif role == 'teacher':
            return self._get_teacher_context(user_id)
        return ""

    def _get_student_context(self, student_id):
        progress = get_student_progress(student_id)
        insights = get_learning_insights(student_id)
        tips = get_learning_tips(student_id)
        profile = get_learning_profile(student_id)
        feedbacks = get_feedbacks(student_id=student_id)

        context = []

        if progress:
            context.append("PERFORMA AKADEMIK:")
            for p in progress[:5]:
                context.append(
                    f"- {p['subject_name']}: {p['score']:.1f}% ({p['correct_answers']}/{p['total_questions']} benar)")

        if insights:
            context.append("\nINSIGHTS PEMBELAJARAN:")
            for insight in insights:
                if insight['strength']:
                    context.append(f"- Kekuatan: {insight['strength']}")
                if insight['weakness']:
                    context.append(f"- Area yang perlu diperbaiki: {insight['weakness']}")

        if profile:
            context.append(f"\nPROFIL BELAJAR:")
            context.append(f"- Gaya belajar: {profile['preferred_learning_style']}")
            context.append(f"- Kecepatan belajar: {profile['learning_pace']}")
            context.append(f"- Area fokus: {profile['focus_area']}")

        if feedbacks:
            context.append("\nFEEDBACK GURU:")
            for fb in feedbacks[:3]:
                context.append(f"- {fb['content']}")

        return "\n".join(context)

    def _get_parent_context(self, parent_id):
        students = get_students_by_parent(parent_id)
        if not students:
            return "Tidak ada data siswa untuk orang tua ini."

        context = []
        context.append("RINGKASAN PERFORMA ANAK-ANAK:")

        for student in students:
            student_id = str(student["id"])
            context.append(f"\n=== {student['name']} (Kelas {student['grade']}) ===")

            progress = get_student_progress(student_id)
            if progress:
                context.append("Performa terkini:")
                for p in progress[:3]:
                    context.append(f"- {p['subject_name']}: {p['score']:.1f}%")

            insights = get_learning_insights(student_id)
            if insights:
                for insight in insights:
                    if insight['strength']:
                        context.append(f"- Kekuatan: {insight['strength']}")
                    if insight['weakness']:
                        context.append(f"- Perlu diperbaiki: {insight['weakness']}")

        return "\n".join(context)

    def _get_teacher_context(self, teacher_id):
        students = get_students_by_teacher(teacher_id)
        context = []
        context.append("RINGKASAN SISWA YANG DIAJAR:")

        grade_groups = {}
        for student in students:
            grade = student['grade']
            if grade not in grade_groups:
                grade_groups[grade] = []
            grade_groups[grade].append(student)

        for grade, students_in_grade in grade_groups.items():
            context.append(f"\n=== KELAS {grade} ===")

            for student in students_in_grade[:10]:
                student_id = str(student["id"])
                context.append(f"\n{student['name']}:")

                progress = get_student_progress(student_id)
                if progress:
                    recent_scores = [p['score'] for p in progress[:3]]
                    avg_score = sum(recent_scores) / len(recent_scores) if recent_scores else 0
                    context.append(f"  - Rata-rata nilai: {avg_score:.1f}%")

                insights = get_learning_insights(student_id)
                if insights:
                    for insight in insights:
                        if insight['weakness']:
                            context.append(f"  - Perlu bantuan: {insight['weakness']}")

        return "\n".join(context)

    def answer_as_student(self, user_input, student_id):
        rag_docs = self.retriever.get_relevant_documents(user_input)
        rag_context = "\n".join([doc.page_content for doc in rag_docs])

        educational_context = self.get_educational_context(student_id, 'student')

        insights = get_learning_insights(student_id)
        insights_text = ""
        if insights:
            insights_text = "Berdasarkan analisis pembelajaran kamu:\n"
            for insight in insights:
                if insight['strength']:
                    insights_text += f"✓ {insight['strength']}\n"
                if insight['weakness']:
                    insights_text += f"⚠ {insight['weakness']}\n"

        full_context = f"{educational_context}\n\nINFORMASI TAMBAHAN:\n{rag_context}"

        role_context = f"Kamu sedang membantu seorang siswa dengan ID {student_id}."

        prompt = self.build_comprehensive_prompt(
            user_input, full_context, role_context, insights_text
        )

        try:
            response = llm.invoke(prompt)

            log_chatbot_interaction(student_id, "user", user_input)
            log_chatbot_interaction(student_id, "ai", response)

            return response

        except Exception as e:
            return f"Maaf, terjadi kesalahan saat memproses pertanyaan kamu. Error: {str(e)}"

    def answer_as_parent(self, user_input, parent_id):
        students = get_students_by_parent(parent_id)
        if not students:
            return "Maaf, tidak ada data siswa yang terkait dengan akun orang tua ini."

        rag_docs = self.retriever.get_relevant_documents(user_input)
        rag_context = "\n".join([doc.page_content for doc in rag_docs])

        educational_context = self.get_educational_context(parent_id, 'parent')

        children_insights = []
        for student in students:
            student_id = str(student["id"])
            insights = get_learning_insights(student_id)
            if insights:
                for insight in insights:
                    children_insights.append(
                        f"{student['name']}: {insight.get('strength', '')} | {insight.get('weakness', '')}")

        insights_text = "\n".join(children_insights) if children_insights else "Belum ada insights khusus tersedia."

        full_context = f"{educational_context}\n\nINFORMASI TAMBAHAN:\n{rag_context}"

        role_context = f"Kamu sedang membantu orang tua yang memiliki {len(students)} anak."

        prompt = self.build_comprehensive_prompt(
            user_input, full_context, role_context, insights_text
        )

        try:
            response = llm.invoke(prompt)

            for student in students:
                student_id = str(student["id"])
                log_chatbot_interaction(student_id, "parent", user_input)
                log_chatbot_interaction(student_id, "ai", response)

            return response

        except Exception as e:
            return f"Maaf, terjadi kesalahan saat memproses pertanyaan Anda. Error: {str(e)}"

    def answer_as_teacher(self, user_input, teacher_id):
        students = get_students_by_teacher(teacher_id)
        if not students:
            return "Maaf, tidak ada data siswa yang terkait dengan akun guru ini."

        rag_docs = self.retriever.get_relevant_documents(user_input)
        rag_context = "\n".join([doc.page_content for doc in rag_docs])

        educational_context = self.get_educational_context(teacher_id, 'teacher')

        class_insights = []
        for student in students[:10]:
            student_id = str(student["id"])
            insights = get_learning_insights(student_id)
            if insights:
                for insight in insights:
                    if insight.get('weakness'):
                        class_insights.append(f"{student['name']}: {insight['weakness']}")

        insights_text = "Siswa yang memerlukan perhatian khusus:\n" + "\n".join(
            class_insights[:5]) if class_insights else "Semua siswa menunjukkan performa yang baik."

        full_context = f"{educational_context}\n\nINFORMASI TAMBAHAN:\n{rag_context}"

        role_context = f"Kamu sedang membantu guru yang mengajar {len(students)} siswa."

        prompt = self.build_comprehensive_prompt(
            user_input, full_context, role_context, insights_text
        )

        try:
            response = llm.invoke(prompt)

            for student in students[:5]:
                student_id = str(student["id"])
                log_chatbot_interaction(student_id, "teacher", user_input)
                log_chatbot_interaction(student_id, "ai", response)

            return response

        except Exception as e:
            return f"Maaf, terjadi kesalahan saat memproses pertanyaan Anda. Error: {str(e)}"

agent = EducationalAgent()