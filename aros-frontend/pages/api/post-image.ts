import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export default async function handler(req: any, res: any) {
  const success = await prisma.images.create({
    data: {
        hash: req.body.hash,
        signature: req.body.signature,
        pubKey: req.body.pubKey,
    }
  })

  if (success) {
    res.status(200).json({ success: true });
  } else {
    res.status(400).json({ sucess: false });
  }
}
