From: Nate Dailey <nate.dailey@stratus.com>
Subject: [md PATCH] md/raid1: round up to bdev_logical_block_size in narrow_write_error
Date: Thu, 12 Feb 2015 12:02:09 -0500
Message-ID: <54DCDC91.6010808@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This modifies raid1's narrow_write_error to round up block_sectors to the
device's logical block size.

This prevents sd complaining about "Bad block number requested" for non-512-byte
sector disks.

Signed-off-by: Nate Dailey <nate.dailey@stratus.com>
---

diff -Nupr a/drivers/md/raid1.c b/drivers/md/raid1.c
--- a/drivers/md/raid1.c        2015-02-10 15:29:02.000000000 -0500
+++ b/drivers/md/raid1.c        2015-02-10 15:29:45.000000000 -0500
@@ -2206,7 +2206,8 @@ static int narrow_write_error(struct r1b
        if (rdev->badblocks.shift < 0)
                return 0;

-       block_sectors = 1 << rdev->badblocks.shift;
+       block_sectors = roundup(1 << rdev->badblocks.shift,
+                               bdev_logical_block_size(rdev->bdev) >> 9);
        sector = r1_bio->sector;
        sectors = ((sector + block_sectors)
                   & ~(sector_t)(block_sectors - 1))
