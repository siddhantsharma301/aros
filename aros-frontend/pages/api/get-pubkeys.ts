import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export default async function handler(req: any, res: any) {
  const pubKeys = await prisma.pubkeys.findMany({
  });

  if (pubKeys) {
    res.status(200).json({ pubKeys: pubKeys });
  } else {
    res.status(200).json({ pubKeys: pubKeys });
  }
}
