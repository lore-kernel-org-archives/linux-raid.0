From: Chris Pearson <kermit4@gmail.com>
Subject: set sector or minimum write size?
Date: Sun, 28 Aug 2011 14:43:17 -0500
Message-ID: <CAGtzr3c5+BVB4qB7X2zVh-mRkitHwM+PLJqgadpBbX6S2AnHYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 4k sector size drive claiming to be a 512 sector size drive.
 Is there a way to tell MD to never write less than 4k at a time?

From block dump:

md0_raid1(9007): WRITE block 8 on sdd1 (2 sectors)

happens frequently and probably requires a full revolution of the disk
unnecessarily.
