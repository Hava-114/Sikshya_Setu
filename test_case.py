import os
import requests
import json

# allow overriding host/port for remote testing on a local network
host = os.environ.get('HOST', '0.0.0.0')
port = os.environ.get('PORT', '8000')
base_url = f"http://{host}:{port}"  # match FastAPI default port

def test_health():
    response = requests.get(f"{base_url}/")
    print(f"Health: {response.json()}")

def test_ollama():
    response = requests.get(f"{base_url}/ollama-status")
    print(f"Ollama Status: {response.json()}")

def test_ask():
    data = {"question": "What is photosynthesis?"}
    response = requests.post(f"{base_url}/ask", json=data)
    print(f"AI Response: {response.json()['answer'][:100]}...")

if __name__ == "__main__":
    print("Testing Sikshya Setu API...")
    test_health()
    test_ollama()
    test_ask()