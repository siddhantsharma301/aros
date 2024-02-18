import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export default async function handler(req: any, res: any) {
  const pubKey = await prisma.pubkeys.findUnique({
    where: {
        userId: req.body.userId
    }
  });

  if (pubKey) {
    res.status(200).json({ pubKey: pubKey });
  } else {
    res.status(400).json({ pubKey: "" });
  }
}
