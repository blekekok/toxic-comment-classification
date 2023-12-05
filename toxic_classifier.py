import torch
import os
import wget
import zipfile
from transformers import BertTokenizer, BertForSequenceClassification
from torch.utils.data import DataLoader, TensorDataset

# Load Device
device = torch.device('cpu')
print(f'Currently using: {device}')

# Download Model
path = './toxic_comment_model'

print("Checking if model exists...")
if not os.path.exists(path):
  print("Model doesn't exist, downloading now!")
  # url = 'https://www.dropbox.com/scl/fi/cri822iazusc8pl1q6hnp/toxic_comment_model.zip?rlkey=efuhz5o82a13h7szvkgqz4bhj&dl=0'
  # file = wget.download(url, out='./')
  with zipfile.ZipFile('./toxic_comment_model.zip', 'r') as zip_ref:
    zip_ref.extractall()

# Load Model
model_name = path
Bert_Tokenizer = BertTokenizer.from_pretrained(model_name)
Bert_Model = BertForSequenceClassification.from_pretrained(model_name).to(device)

def predict(input_text, model = Bert_Model, tokenizer = Bert_Tokenizer, device = device):
  input = [input_text]

  encodings = tokenizer(
      input,
      truncation = True,
      padding = True,
      return_tensors = 'pt'
  )

  dataset = TensorDataset(
      encodings['input_ids'],
      encodings['attention_mask']
  )

  loader = DataLoader(
      dataset,
      batch_size = 1,
      shuffle = False
  )

  model.eval()

  with torch.no_grad():
    for batch in loader:
      input_ids, attention_mask = [t.to(device) for t in batch]
      outputs = model(input_ids, attention_mask = attention_mask)
      logits = outputs.logits
      predictions = torch.sigmoid(logits)

  predicted_labels = (predictions.cpu().numpy() > 0.5).astype(int)
  labels_list = ['toxic', 'severe_toxic', 'obscene', 'threat', 'insult', 'identity_hate']
  result = dict(zip(labels_list, predicted_labels[0]))
  return result

def is_toxic(input):
  prediction = predict(input_text = input)

  text = f'It predicted that "{input}" is '
  is_toxic = False
  for key, value in prediction.items():
    if value:
      is_toxic = True
      text += f'{key}, '

  if is_toxic:
    text = text[:-2]
    text = text.replace('_', ' ')
  else:
    text += 'non toxic'

  return text

print('Bert Model Loaded!')