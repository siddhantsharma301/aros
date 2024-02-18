import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export default async function handler(req: any, res: any) {
  const images = await prisma.images.findMany({
  });

  if (images) {
    res.status(200).json({ images: images });
  } else {
    res.status(200).json({ images: images });
  }
}
