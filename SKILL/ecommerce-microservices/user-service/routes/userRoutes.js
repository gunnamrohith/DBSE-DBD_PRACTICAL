const express = require("express");
const controller = require("../controllers/userController");

const router = express.Router();

router.post("/users", controller.register);
router.post("/login", controller.login);
router.get("/users/:id", controller.getUser);

module.exports = router;