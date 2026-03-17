@app.post("/ask")
async def ask(data: dict):
    response = ollama.chat(
        model="phi3",
        messages=[{"role": "user", "content": data["question"]}]
    )
    return {"answer": response["message"]["content"]}
