import { Hono } from "hono";
import pc from "picocolors";

const app = new Hono();

app.get("/", (c) => {
  console.log(pc.green(`Starting the ${pc.italic(`server`)}`));
  return c.text("AI start!");
});

export default app;
