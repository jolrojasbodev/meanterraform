// express-app.js

const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors'); // Importa el paquete cors

const app = express();
const port = 3000;

// Middleware para habilitar CORS
// Esto es crucial para que tu frontend Angular (servido por Nginx en el puerto 80)
// pueda hacer solicitudes a tu backend Express (en el puerto 3000).
app.use(cors());

// Middleware para parsear JSON
app.use(express.json());

// **IMPORTANTE**: Este 'MONGODB_IP_PLACEHOLDER' será reemplazado por Packer
// con la IP privada real de tu instancia de MongoDB.
const mongoUri = 'mongodb://MONGODB_IP_PLACEHOLDER:27017/eandb';

mongoose.connect(mongoUri)
  .then(() => console.log('Conectado a MongoDB con éxito.'))
  .catch(err => console.error('Error al conectar a MongoDB:', err));

// Definir un esquema y modelo para un ejemplo (por ejemplo, items)
const itemSchema = new mongoose.Schema({
  name: String,
  description: String,
  quantity: Number
});

const Item = mongoose.model('Item', itemSchema);

// Rutas de la API
app.get('/', (req, res) => {
  res.send('API de Express funcionando. Visita /api/items para ver los datos.');
});

// Obtener todos los ítems
app.get('/api/items', async (req, res) => {
  try {
    const items = await Item.find();
    res.json(items);
  } catch (err) {
    res.status(500).send(err);
  }
});

// Añadir un nuevo ítem
app.post('/api/items', async (req, res) => {
  try {
    const newItem = new Item(req.body);
    await newItem.save();
    res.status(201).json(newItem);
  } catch (err) {
    res.status(500).send(err);
  }
});

// Actualizar un ítem
app.put('/api/items/:id', async (req, res) => {
    try {
        const updatedItem = await Item.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (!updatedItem) return res.status(404).send('Item not found.');
        res.json(updatedItem);
    } catch (err) {
        res.status(500).send(err);
    }
});

// Eliminar un ítem
app.delete('/api/items/:id', async (req, res) => {
    try {
        const deletedItem = await Item.findByIdAndDelete(req.params.id);
        if (!deletedItem) return res.status(404).send('Item not found.');
        res.status(204).send(); // No content
    } catch (err) {
        res.status(500).send(err);
    }
});

app.listen(port, () => {
  console.log(`Servidor Express escuchando en http://localhost:${port}`);
});