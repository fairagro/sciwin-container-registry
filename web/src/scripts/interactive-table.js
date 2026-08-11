function initFilter(input) {
  const table = document.getElementById(input.dataset.filter);
  const countEl = input.dataset.countTarget
    ? document.getElementById(input.dataset.countTarget)
    : null;
  if (!table) return;

  const rows = Array.from(table.tBodies[0]?.rows ?? []);
  const total = rows.length;

  function apply() {
    const query = input.value.trim().toLowerCase();
    let visible = 0;
    for (const row of rows) {
      const matches = !query || (row.dataset.search ?? "").includes(query);
      row.hidden = !matches;
      if (matches) visible++;
    }
    if (countEl) countEl.textContent = `${visible} of ${total}`;
  }

  input.addEventListener("input", apply);
  apply();
}

function initSort(table) {
  const headers = Array.from(table.querySelectorAll("th[data-key]"));
  const tbody = table.tBodies[0];
  if (!tbody || headers.length === 0) return;

  let sortKey = null;
  let sortDir = "asc";

  headers.forEach((th) => {
    th.addEventListener("click", () => {
      const key = th.dataset.key;
      sortDir = sortKey === key && sortDir === "asc" ? "desc" : "asc";
      sortKey = key;

      headers.forEach((h) => h.removeAttribute("data-sort"));
      th.setAttribute("data-sort", sortDir);

      const rows = Array.from(tbody.rows);
      rows.sort((a, b) => {
        const av = a.dataset[key] ?? "";
        const bv = b.dataset[key] ?? "";
        const an = Number(av);
        const bn = Number(bv);
        const bothNumeric = av !== "" && bv !== "" && !Number.isNaN(an) && !Number.isNaN(bn);
        const cmp = bothNumeric ? an - bn : av.localeCompare(bv);
        return sortDir === "asc" ? cmp : -cmp;
      });
      rows.forEach((row) => tbody.appendChild(row));
    });
  });
}

document.addEventListener("DOMContentLoaded", () => {
  document
    .querySelectorAll("input[data-filter]")
    .forEach((input) => initFilter(input));
  document
    .querySelectorAll("table[data-sortable]")
    .forEach((table) => initSort(table));
});
