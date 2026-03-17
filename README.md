# 🚀 Sikshya Setu – Offline AI-Powered Learning Platform

## 📌 Overview

**Sikshya Setu** is an offline-first AI-powered education platform built to bridge the digital divide in remote and low-connectivity regions. Unlike traditional ed-tech systems that depend on continuous internet access, this platform enables uninterrupted learning by running AI models locally.

It acts as a **24/7 intelligent academic assistant**, allowing students to:
- Ask doubts and receive instant AI-generated explanations  
- Access study materials without internet dependency  
- Continue learning seamlessly in low or no connectivity environments  

---

## ❗ Problem Statement

Students in rural and underserved areas face critical challenges:

- Unstable or no internet connectivity  
- Limited access to quality teachers  
- Inability to use modern AI-powered learning tools  

Most existing solutions are **cloud-dependent**, making them unusable in such regions and widening the educational gap.

---

## 💡 Proposed Solution

Sikshya Setu addresses these challenges by:

- Running a **lightweight offline AI model (Phi-3 via Ollama)** locally  
- Providing **real-time doubt-solving without internet**  
- Enabling **offline storage and access to learning resources**  
- Offering a scalable, low-infrastructure solution for institutions  

---

## 🏗️ Tech Stack

### 🎨 Frontend
- Flutter  
- Riverpod (State Management)

### ⚙️ Backend
- FastAPI  
- Ollama (Phi-3 Mini)

### 💾 Storage
- Local File System  
- (Optional) FAISS for semantic search  

---

## 📱 Flutter Architecture

### 🔹 Why Flutter?

Flutter is chosen for:

- Single codebase for Web and Mobile  
- Fast and responsive UI rendering  
- Seamless integration with REST APIs  
- Rapid development and prototyping  

---

## 🔄 State Management using Riverpod

The application uses **Riverpod** for efficient and scalable state management.

---

### 📌 1. Chat Provider

Handles chatbot interactions and message state.

final chatProvider = StateNotifierProvider<ChatNotifier, List<Message>>((ref) {
  return ChatNotifier();
});

### 📌 2. API Service Provider

Handles backend communication.

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});


#### Responsibilities:

  Send HTTP POST requests
  
  Process JSON responses
  
  Handle API errors

### 📌 3. Upload Provider

Manages file uploads and related state.

final uploadProvider = StateNotifierProvider<UploadNotifier, UploadState>((ref) {
  return UploadNotifier();
});


#### Responsibilities:

Handle file selection

Upload materials via multipart requests

Track upload status and response

## 🔁 Riverpod Data Flow
        User Interface (Input)
                ↓
        Chat Provider (StateNotifier)
                ↓
        API Service Provider
                ↓
        FastAPI Backend
                ↓
        Ollama (Phi-3 Model)
                ↓
        Response Generated
                ↓
        State Updated
                ↓
        UI Rebuilds Automatically

---

## 🧠 AI Integration Flow

User enters a query in the Flutter interface

Request is sent to the FastAPI /ask endpoint

Backend processes the request using:

ollama.chat(model="phi3:mini", ...)


AI generates response locally (offline)

Response is returned to the frontend

UI updates dynamically via Riverpod

---

## 📂 File Upload Flow

Teacher uploads study material via Flutter UI

Data is sent as multipart/form-data

FastAPI stores the file in /uploads directory

Metadata is returned and managed in the app

---

## 🔥 Key Features

      ✅ Fully Offline AI Chat
      
      ✅ Cross-platform (Web + Mobile)
      
      ✅ Real-time UI updates using Riverpod
      
      ✅ Study material upload and management

---

## 🚧 Future Enhancements
    
    🔍 Semantic Search using FAISS
    
    🌐 Hybrid Mode (Offline + Cloud Sync)
    
    🗣️ Voice-enabled AI assistant
    
    📊 Student performance tracking
    
    📚 Personalized learning recommendations
      
    ✅ Lightweight and scalable architecture

---

## 📸 Demo

#### 🎥 Demo Video:

      https://drive.google.com/file/d/12IhiPGROt4bX-DlSIdd1l5WE2CpzSRHb/view?usp=sharing
  
