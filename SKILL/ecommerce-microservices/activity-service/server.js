const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
require("dotenv").config();
const Activity = require("./models/Activity");

const app = express();
app.use(cors());
app.use(express.json());

app.get("/health", (req, res) =>
  res.json({ service: "activity-service", status: "UP" })
);

app.post("/activities", async (req, res) => {
  try {
    const activity = await Activity.create(req.body);
    res.status(201).json(activity);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

app.get("/activities", async (req, res) => {
  const activities = await Activity.find().sort({ createdAt: -1 });
  res.json(activities);
});

mongoose.connect(process.env.MONGO_URI)
  .then(() => {
    console.log("MongoDB connected");
    app.listen(process.env.PORT, () =>
      console.log(`Activity Service running on ${process.env.PORT}`)
    );
  })
  .catch(err => console.error(err));