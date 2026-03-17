import ollama

class Phi3Service:
    def get_introduction(self):
        response = ollama.chat(
            model="phi3",
            messages=[
                {"role": "user", "content": "Introduce yourself in a short paragraph."}
            ]
        )
        return response


