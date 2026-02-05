const express = require("express");
const pool = require("../db");

const router = express.Router();

router.get("/asset-types", async (req, res) => {
  const result = await pool.query("SELECT * FROM asset_types ORDER BY id");
  res.json(result.rows);
});

router.get("/schema/:type", async (req, res) => {
  const { type } = req.params;

  const result = await pool.query(
    `
    SELECT f.*
    FROM asset_fields f
    JOIN asset_types t ON f.asset_type_id = t.id
    WHERE t.name = $1
    ORDER BY f.id
    `,
    [type]
  );

  res.json(result.rows);
});

router.get("/assets/:type", async (req, res) => {
  const { type } = req.params;

  const assets = await pool.query(
    `
    SELECT a.id, f.name, v.value
    FROM assets a
    JOIN asset_types t ON a.asset_type_id = t.id
    JOIN asset_values v ON a.id = v.asset_id
    JOIN asset_fields f ON v.field_id = f.id
    WHERE t.name = $1
    `,
    [type]
  );

  res.json(assets.rows);
});

router.post("/assets/:type", async (req, res) => {
  const { type } = req.params;
  const data = req.body;

  const typeResult = await pool.query(
    "SELECT id FROM asset_types WHERE name=$1",
    [type]
  );

  const assetTypeId = typeResult.rows[0].id;

  const assetResult = await pool.query(
    "INSERT INTO assets (asset_type_id) VALUES ($1) RETURNING id",
    [assetTypeId]
  );

  const assetId = assetResult.rows[0].id;

  for (const field in data) {
    await pool.query(
      `
      INSERT INTO asset_values (asset_id, field_id, value)
      SELECT $1, id, $2
      FROM asset_fields
      WHERE name=$3 AND asset_type_id=$4
      `,
      [assetId, data[field], field, assetTypeId]
    );
  }

  res.json({ success: true, assetId });
});

router.delete("/assets/:id", async (req, res) => {
  const { id } = req.params;
  await pool.query("DELETE FROM assets WHERE id=$1", [id]);
  res.json({ success: true });
});

module.exports = router;
