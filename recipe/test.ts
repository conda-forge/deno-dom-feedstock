import { DOMParser, Element } from "jsr:@b-fuze/deno-dom/native";
import { assertEquals } from "jsr:@std/assert";

const doc = new DOMParser().parseFromString(
  `
  <h1>Hello World!</h1>
  <p>Hello from <a href="https://deno.land/">Deno!</a></p>
`,
  "text/html",
)!;

const p = doc.querySelector("p")!;

assertEquals(p.textContent, "Hello from Deno!");
assertEquals(p.childNodes[1].textContent, "Deno!");

p.innerHTML = "DOM in <b>Deno</b> is pretty cool";
assertEquals(p.children[0].outerHTML, "<b>Deno</b>");
