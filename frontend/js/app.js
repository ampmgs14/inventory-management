const API = "http://localhost:8000/api";

let currentType = null;
let currentSchema = [];

async function loadAssetTypes() {
  const res = await fetch(`${API}/asset-types`);
  const types = await res.json();

  const tabs = document.getElementById("tabs");
  tabs.innerHTML = "";

  types.forEach((t, i) => {
    const btn = document.createElement("button");
    btn.textContent = t.label;
    btn.onclick = () => selectType(t.name, btn);
    tabs.appendChild(btn);

    if (i === 0) btn.click();
  });
}

async function selectType(type, btn) {
  document.querySelectorAll(".tabs button")
    .forEach(b => b.classList.remove("active"));
  btn.classList.add("active");

  currentType = type;

  const schemaRes = await fetch(`${API}/schema/${type}`);
  currentSchema = await schemaRes.json();

  renderControls();
  renderTableHeader();
  loadAssets();
}

function renderControls() {
  const div = document.getElementById("controls");
  div.innerHTML = "";

  currentSchema
    .filter(f => f.filterable)
    .forEach(f => {
      const input = document.createElement("input");
      input.placeholder = f.label;
      input.dataset.field = f.name;
      div.appendChild(input);
    });

  const addBtn = document.createElement("button");
  addBtn.textContent = "Add";
  addBtn.className = "primary";
  addBtn.onclick = addAsset;
  div.appendChild(addBtn);
}

function renderTableHeader() {
  const thead = document.querySelector("#table thead");
  thead.innerHTML = "";

  const tr = document.createElement("tr");
  tr.innerHTML = "<th>ID</th>";

  currentSchema.forEach(f => {
    tr.innerHTML += `<th>${f.label}</th>`;
  });

  tr.innerHTML += "<th></th>";
  thead.appendChild(tr);
}

async function loadAssets() {
  const res = await fetch(`${API}/assets/${currentType}`);
  const rows = await res.json();

  // rows come as: { id, name, value }
  const grouped = {};
  rows.forEach(r => {
    if (!grouped[r.id]) grouped[r.id] = {};
    grouped[r.id][r.name] = r.value;
  });

  const tbody = document.querySelector("#table tbody");
  tbody.innerHTML = "";

  Object.entries(grouped).forEach(([id, values]) => {
    const tr = document.createElement("tr");
    tr.innerHTML = `<td>${id}</td>`;

    currentSchema.forEach(f => {
      tr.innerHTML += `<td>${values[f.name] ?? ""}</td>`;
    });

    const delBtn = document.createElement("button");
    delBtn.textContent = "Delete";
    delBtn.onclick = async () => {
      await fetch(`${API}/assets/${currentType}/${id}`, {
        method: "DELETE"
      });
      loadAssets();
    };

    const td = document.createElement("td");
    td.appendChild(delBtn);
    tr.appendChild(td);

    tbody.appendChild(tr);
  });
}

async function addAsset() {
  const payload = {};

  for (const f of currentSchema) {
    const v = prompt(`Enter ${f.label}`);
    if (v === null) return;
    payload[f.name] = v;
  }

  await fetch(`${API}/assets/${currentType}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload)
  });

  loadAssets();
}

loadAssetTypes();
