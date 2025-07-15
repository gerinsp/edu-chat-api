from typing import TypedDict, Optional
from langgraph.graph import StateGraph, END
from datetime import datetime
from app.agents.rag_agent import agent

class EnhancedChatState(TypedDict):
    user_id: str
    role: str
    question: str
    answer: Optional[str]
    timestamp: Optional[str]
    context: Optional[str]

# Create workflow
workflow = StateGraph(state_schema=EnhancedChatState)

def identify_role_node(inputs: EnhancedChatState) -> dict:
    return {
        "timestamp": datetime.now().isoformat()
    }

def route_by_role(inputs: EnhancedChatState) -> str:
    return inputs["role"]

def student_flow_node(inputs: EnhancedChatState) -> dict:
    try:
        result = agent.answer_as_student(inputs["question"], inputs["user_id"])
        return {"answer": result}
    except Exception as e:
        return {"answer": f"Maaf, terjadi kesalahan saat memproses pertanyaan kamu: {str(e)}"}

def parent_flow_node(inputs: EnhancedChatState) -> dict:
    try:
        result = agent.answer_as_parent(inputs["question"], inputs["user_id"])
        return {"answer": result}
    except Exception as e:
        return {"answer": f"Maaf, terjadi kesalahan saat memproses pertanyaan Anda: {str(e)}"}

def teacher_flow_node(inputs: EnhancedChatState) -> dict:
    try:
        result = agent.answer_as_teacher(inputs["question"], inputs["user_id"])
        return {"answer": result}
    except Exception as e:
        return {"answer": f"Maaf, terjadi kesalahan saat memproses pertanyaan Anda: {str(e)}"}

workflow.add_node("start", identify_role_node)
workflow.add_node("student", student_flow_node)
workflow.add_node("parent", parent_flow_node)
workflow.add_node("teacher", teacher_flow_node)

workflow.set_entry_point("start")

workflow.add_conditional_edges(
    "start",
    route_by_role,
    {
        "student": "student",
        "parent": "parent",
        "teacher": "teacher",
    }
)

workflow.add_edge("student", END)
workflow.add_edge("parent", END)
workflow.add_edge("teacher", END)

langgraph_app = workflow.compile()