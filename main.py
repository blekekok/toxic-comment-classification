import toxic_classifier
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

@app.get('/')
async def root():
  return {
    "message": "Hello"
  }

class Query(BaseModel):
  text: str

@app.post('/predict')
async def predict(query: Query):
  text = query.text
  data = toxic_classifier.predict(input_text = text)

  classes = [key for key, value in data.items() if value == 1]

  return {
    "status": 200,
    "data": classes
  }