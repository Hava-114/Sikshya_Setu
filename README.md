Sikshya Setu – Offline AI-Powered Learning Platform
📌 Overview

  Sikshya Setu is an offline-first AI-powered education platform designed to bridge the digital divide in remote and low-connectivity regions. Unlike conventional ed-tech applications that rely heavily on cloud infrastructure, Sikshya Setu ensures uninterrupted learning by operating efficiently without continuous internet access.

The platform acts as a 24/7 academic assistant, enabling students to:

  Ask doubts and receive AI-generated explanations

  Access learning materials offline

  Continue education in low or zero network environments

❗ Problem Statement

  Students in rural and underserved areas often face:

      Lack of stable internet connectivity

      Limited access to quality teachers

Inability to use modern AI learning platforms

Most existing solutions are cloud-dependent, making them unusable in such conditions, which widens the educational gap.

💡 Solution

Sikshya Setu solves this by:

Running an offline AI model (Phi-3 via Ollama) locally

Providing instant doubt-solving without internet

Enabling offline storage and retrieval of study materials

Offering a scalable solution for schools with minimal infrastructure

🏗️ Tech Stack
Frontend

Flutter (Cross-platform UI)

Riverpod (State Management)

Backend

FastAPI (Python backend)

Ollama (Phi-3 Mini) (Local AI model)

Storage

Local file system for materials

(Optional) Vector DB like FAISS for semantic retrieval

📱 Flutter Architecture
🔹 Why Flutter?

Flutter is used because:

Single codebase for Web + Mobile

Smooth UI performance

Easy API integration with backend

Ideal for rapid prototyping in hackathons

🔄 State Management using Riverpod

The app uses Riverpod for clean, scalable state management.

📌 Provider Structure
1. Chat Provider

Handles AI interaction and message flow.

final chatProvider = StateNotifierProvider<ChatNotifier, List<Message>>((ref) {
  return ChatNotifier();
});

Responsibilities:

Store chat messages

Send user query to backend (/ask)

Receive and update AI response

2. API Service Provider

Handles backend communication.

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

Responsibilities:

Send POST request to FastAPI

Handle JSON responses

Error handling

3. Upload Provider

Handles file uploads.

final uploadProvider = StateNotifierProvider<UploadNotifier, UploadState>((ref) {
  return UploadNotifier();
});

Responsibilities:

Manage file selection

Send multipart request to /upload-material

Track upload status

🔁 Riverpod Flow (Data Flow)
UI (User Input)
   ↓
Chat Provider (StateNotifier)
   ↓
API Service Provider
   ↓
FastAPI Backend
   ↓
Ollama (Phi-3 Model)
   ↓
Response Returned
   ↓
Provider Updates State
   ↓
UI Rebuilds Automatically

🧠 AI Integration Flow

User enters a question in Flutter UI

Request is sent to FastAPI /ask endpoint

Backend calls:

ollama.chat(model="phi3:mini", ...)


AI generates response locally (offline)

Response is returned to Flutter

UI updates using Riverpod

📂 File Upload Flow

Teacher uploads material via Flutter UI

Data sent as multipart/form-data

FastAPI stores file in /uploads directory

Metadata is returned and stored

🔥 Key Features

✅ Offline AI Chat (No Internet Required)

✅ Cross-platform UI (Flutter Web + Mobile)

✅ Real-time state updates (Riverpod)

✅ File upload & content management

✅ Lightweight and scalable

🚧 Future Enhancements

🔍 Semantic Search using FAISS

🌐 Hybrid mode (Offline + Online sync)

🗣️ Voice-based learning assistant

📊 Student progress tracking

📚 Personalized learning paths

🏆 Why This Project Stands Out

Solves a real-world problem (digital divide)

Works offline (rare in AI apps)

Combines AI + EdTech + Accessibility

Scalable for government and NGOs

📸 Demo

https://drive.google.com/file/d/12IhiPGROt4bX-DlSIdd1l5WE2CpzSRHb/view?usp=sharing

👨‍💻 Contributors

Your Name

⭐ Conclusion

Sikshya Setu demonstrates how AI can be made accessible beyond urban infrastructure, ensuring that quality education reaches every student regardless of connectivity.
