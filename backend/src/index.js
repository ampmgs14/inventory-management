const express = require("express");
const cors = require("cors");

const assetsRoutes = require("./routes/assets");

const app = express();
app.use(cors());
app.use(express.json());

app.use("/api", assetsRoutes);

app.listen(8000, () => {
  console.log("Backend running on port 8000");
});
