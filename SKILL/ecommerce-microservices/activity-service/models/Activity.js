const mongoose = require("mongoose");

const activitySchema = new mongoose.Schema({
  userId: String,
  action: { type: String, required: true },
  metadata: mongoose.Schema.Types.Mixed
}, { timestamps: true });

module.exports = mongoose.model("Activity", activitySchema);