from typing import TypedDict
from langgraph.graph import StateGraph, END
from app.agents.rag_agent import answer_as_student, answer_as_parent, answer_as_teacher

# 1. State schema
class ChatState(TypedDict):
    user_id: str
    role: str
    question: str
    answer: str

# 2. Init graph
workflow = StateGraph(state_schema=ChatState)

# 3. Node untuk identifikasi role - harus return dict
def identify_role_node(inputs: ChatState) -> dict:
    # Node harus return dict untuk update state
    # Dalam kasus ini, kita tidak perlu mengubah state
    return {}

# 4. Path function terpisah untuk conditional routing
def route_by_role(inputs: ChatState) -> str:
    # Return string untuk routing
    return inputs["role"]

# 5. Node per role menghasilkan dict {"answer": ...}
def student_flow_node(inputs: ChatState):
    return {"answer": answer_as_student(inputs["question"], inputs["user_id"])}

def parent_flow_node(inputs: ChatState):
    return {"answer": answer_as_parent(inputs["question"], inputs["user_id"])}

def teacher_flow_node(inputs: ChatState):
    return {"answer": answer_as_teacher(inputs["question"], inputs["user_id"])}

# 6. Tambahkan node
workflow.add_node("student", student_flow_node)
workflow.add_node("parent", parent_flow_node)
workflow.add_node("teacher", teacher_flow_node)

# 7. Entry point dengan conditional routing langsung
workflow.set_conditional_entry_point(
    route_by_role,  # path function yang return string
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

# 9. Compile
langgraph_app = workflow.compile()