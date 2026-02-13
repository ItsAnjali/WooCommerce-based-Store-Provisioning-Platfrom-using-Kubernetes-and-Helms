const mongoose = require('mongoose')

const StoreSchema = new mongoose.Schema({
  name: String,
  engine: String,
  status: String,
  url: String,
  createdAt: {
    type: Date,
    default: Date.now
  }
})

mongoose.model('store', StoreSchema)
