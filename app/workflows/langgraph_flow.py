# langgraph_flow.py
from typing import TypedDict, Optional
from langgraph.graph import StateGraph, END
from app.agents.rag_agent import answer_as_student, answer_as_parent, answer_as_teacher

# 1. State schema dengan field answer
class ChatState(TypedDict):
    user_id: str
    role: str
    question: str
    answer: Optional[str]  # Tambahkan field answer

# 2. Init graph
workflow = StateGraph(state_schema=ChatState)

# 3. Node untuk identifikasi role
def identify_role_node(inputs: ChatState) -> dict:
    return {}

# 4. Path function untuk conditional routing
def route_by_role(inputs: ChatState) -> str:
    return inputs["role"]

# 5. Node per role yang update state dengan answer
def student_flow_node(inputs: ChatState):
    result = answer_as_student(inputs["question"], inputs["user_id"])
    print("🎯 Jawaban dari student_flow_node:", result)
    return {"answer": result}

def parent_flow_node(inputs: ChatState):
    result = answer_as_parent(inputs["question"], inputs["user_id"])
    print("🎯 Jawaban dari parent_flow_node:", result)
    return {"answer": result}

def teacher_flow_node(inputs: ChatState):
    result = answer_as_teacher(inputs["question"], inputs["user_id"])
    print("🎯 Jawaban dari teacher_flow_node:", result)
    return {"answer": result}

# 6. Tambahkan node
workflow.add_node("start", identify_role_node)
workflow.add_node("student", student_flow_node)
workflow.add_node("parent", parent_flow_node)
workflow.add_node("teacher", teacher_flow_node)

# 7. Entry point dengan conditional routing
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

# 8. Akhiri semua cabang
workflow.add_edge("student", END)
workflow.add_edge("parent", END)
workflow.add_edge("teacher", END)

# 9. Compile TANPA return_all
langgraph_app = workflow.compile()