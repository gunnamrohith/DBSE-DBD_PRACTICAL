const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
require("dotenv").config();
const userRoutes = require("./routes/userRoutes");

const app = express();
app.use(cors());
app.use(express.json());
app.use(userRoutes);

app.get("/health", (req, res) =>
  res.json({ service: "user-service", status: "UP" })
);

mongoose.connect(process.env.MONGO_URI)
  .then(() => {
    console.log("MongoDB connected");
    app.listen(process.env.PORT, () =>
      console.log(`User Service running on ${process.env.PORT}`)
    );
  })
  .catch(err => console.error("MongoDB error:", err.message));