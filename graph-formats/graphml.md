---
type: reference
title: GraphML
description: GraphML graph file format structure, key/data attributes, yFiles extensions and yFiles for Java I/O.
resource: "https://docs.yworks.com/yfiles/doc/developers-guide/graphml.html"
tags: [graphml, graph, xml, yfiles, file-format]
generated:
  by: ingestor/claude-sonnet-5-5
  at: 2026-10-05T12:55:00Z
status: draft
sources:
  - resource: inbox/archive/default/2026-09-30T055212-graphml.md
    title: Original capture
  - resource: inbox/archive/default/2026-10-05T125306-graphml.md
    id: yfiles
    title: yFiles Developer's Guide, GraphML (fetched)
---

# GraphML

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

## Key and data attributes

`<key>` declares a GraphML attribute and must appear before any `<graph>`
element. Values are supplied with `<data key="...">` elements nested in
`<graph>`, `<node>`, `<edge>` or `<port>`; the `key` value is looked up
against the `id` of a `<key>` declaration.[^yfiles]

| `<key>` attribute | Values | Meaning |
|---|---|---|
| `id` | NMTOKEN | Unique id of the declaration; target of `<data key>` look-up. |
| `for` | `graph`, `node`, `edge`, `port` | Scope of the attribute. |
| `attr.name` | NMTOKEN | Name an application can use to identify the attribute. |
| `attr.type` | `boolean`, `int`, `long`, `float`, `double`, `string` | Value type. |

```xml
<key id="d0" for="node" attr.name="boolean-value" attr.type="boolean"/>
<graph id="G" edgedefault="directed">
  <node id="n0"><data key="d0">true</data></node>
</graph>
```

Complex data is stored by nesting user-defined XML elements inside `<data>`
(this is how the yFiles `y:` elements work); reading and writing structured
types requires registering a (de)serializer.[^yfiles]

## Reading and writing with yFiles for Java (2.13)

- `GraphMLIOHandler` (package `y.io`, subclass of `IOHandler`) reads and
  writes GraphML via `read(Graph2D, ...)` and `write(Graph2D, ...)`
  overloads taking a stream, file name or URL.
- `ZipGraphMLIOHandler` writes Zip-compressed GraphML, reported as up to 50
  times smaller than uncompressed files.
- Most configuration lives on the core handler, obtained with
  `getGraphMLHandler()`, not on `GraphMLIOHandler`.
- Simple-typed data held in `DataProvider`/`DataAcceptor` maps can be
  registered with `GraphMLHandler.addInputDataAcceptor(name, acceptor,
  KeyScope, KeyType)`; `name` must match the key's `attr.name`.
- The yFiles data accessors have no support for `long` or `float` types.

```java
IOHandler ioh = new GraphMLIOHandler();
ioh.write(graph, "MyGraphML.graphml");
```

The source page is from the outdated yFiles for Java 2.13 documentation;
the yFiles-specific API details may differ in current products.

## See also

- [GraphML Primer](http://graphml.graphdrawing.org/primer/graphml-primer.html)
- [yFiles GraphML XML schema documentation](http://www.yworks.com/xml/schema/graphml/1.1/doc/index.html)

- [yFiles Developer's Guide: GraphML](https://docs.yworks.com/yfiles/doc/developers-guide/graphml.html) — original source.

[^yfiles]: yFiles Developer's Guide, GraphML chapter.
