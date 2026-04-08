import { db } from "./src/lib/db";

async function main() {
  // Clear existing
  await db.post.deleteMany();
  await db.user.deleteMany();

  const user1 = await db.user.create({
    data: {
      email: "hello@fruitful-stack.com",
      name: "Admin User",
    }
  });

  await db.post.createMany({
    data: [
      { title: "Welcome to NexusHub!", content: "This is a scalable, modern, full-stack website.", published: true, authorId: user1.id },
      { title: "Next.js + Prisma Built for Speed", content: "Enjoy server components, database ORMs, tailwind typography, and more.", published: true, authorId: user1.id },
      { title: "Dashboard Integrations", content: "Manage your database items entirely from the front-end.", published: false, authorId: user1.id }
    ]
  });
  console.log("Database seeded successfully!");
}

main().catch(console.error);
