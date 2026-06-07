const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Sample words data
const words = [
  {
    id: '1',
    word: 'Apple',
    meaning: 'A round fruit with red, green, or yellow skin',
    translation: 'Manzana',
  },
  {
    id: '2',
    word: 'Beautiful',
    meaning: 'Pleasing to the senses or mind aesthetically',
    translation: 'Hermosa',
  },
  {
    id: '3',
    word: 'House',
    meaning: 'A building for human habitation',
    translation: 'Casa',
  },
  {
    id: '4',
    word: 'Water',
    meaning: 'A clear liquid essential for life',
    translation: 'Agua',
  },
  {
    id: '5',
    word: 'Book',
    meaning: 'A written or printed work consisting of pages',
    translation: 'Libro',
  },
];

// GET /words - Retrieve all words
app.get('/words', (req, res) => {
  res.json({
    success: true,
    data: words,
    count: words.length,
  });
});

// Health check
app.get('/', (req, res) => {
  res.json({ message: 'LingoBreeze API is running!' });
});

app.listen(PORT, () => {
  console.log(`LingoBreeze API running on http://localhost:${PORT}`);
});
