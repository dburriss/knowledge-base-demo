---
type: reference
resource: https://docs.yworks.com/yfiles/doc/developers-guide/graphml.html
tags: [graphml, graph, xml, yfiles, file-format]
generated: 2026-09-30
verified: false
status: draft
stale_after: null
sources: [inbox/archive/default/2026-09-30T055212-graphml.md]
---

# GraphML

> **Note:** the source page (yFiles Developer's Guide, "GraphML") could not
> be fetched in this environment (network access to `docs.yworks.com` was
> blocked). This note summarizes the generally documented structure of
> GraphML and yFiles' extensions to it; verify against the linked resource
> before relying on specifics.

GraphML is an XML-based file format for describing the structure of a
graph — nodes, edges, and arbitrary typed attributes on either — designed
for interchange between graph tools and libraries.

## Core structure

- A `<graphml>` root element wraps one or more `<graph>` elements.
- A `<graph>` element has an `edgedefault` attribute (`directed` or
  `undirected`) and contains `<node>` and `<edge>` child elements.
- `<node id="...">` declares a node; `<edge source="..." target="...">`
  declares an edge between two node IDs.
- `<key>` elements declared at the top level define typed attribute
  schemas (`id`, `for` — `node`/`edge`/`graph`, `attr.name`, `attr.type`),
  which `<data key="...">` elements on nodes/edges/graphs then populate.

## yFiles extensions

yFiles (the graph visualization library from yWorks) extends plain GraphML
with a custom namespace (conventionally aliased `y:`) to carry
visualization-specific data that isn't part of the graph's logical
structure, such as:

- Node geometry and styling (`y:ShapeNode`, `y:Geometry`, `y:Fill`,
  `y:BorderStyle`).
- Edge routing and arrow styles (`y:PolyLineEdge`, `y:Arrows`,
  `y:LineStyle`).
- Labels and their placement (`y:NodeLabel`, `y:EdgeLabel`).

These extension elements are attached via `<data>` elements whose `key`
refers to a `<key>` declaration with a yFiles-specific `yfiles.type`
(e.g. `nodegraphics`, `edgegraphics`), so a plain-GraphML-only reader can
still parse the graph's logical structure while ignoring the
visualization payload.

## See also

- [yFiles Developer's Guide: GraphML](https://docs.yworks.com/yfiles/doc/developers-guide/graphml.html) — original source (verify details here).
