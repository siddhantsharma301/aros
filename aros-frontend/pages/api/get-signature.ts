import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export default async function handler(req: any, res: any) {
  const image = await prisma.images.findUnique({
    where: {
        hash: req.body.hash
    }
  });

  if (image) {
    res.status(200).json({ signature: image.signature, pubKey: image.pubKey });
  } else {
    res.status(400).json({ signature: "", pubKey: "" });
  }
}
