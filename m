From: y b <ycbzzjlby@gmail.com>
Subject: [PATCH] When hit a read error, retry request with R5_ReadNoMerge flag.
Date: Fri, 23 Aug 2013 10:47:33 +0800
Message-ID: <CAPoh-nYH8gF5T1xNWBmgPaBLJmk2EgGWG+pV-utwuMfahkMbfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From 7a3031f86cfc70e1c102045c410640645c298b8c Mon Sep 17 00:00:00 2001
From: Bian Yu <bianyu@kedacom.com>
Date: Fri, 23 Aug 2013 10:43:28 -0400
Subject: [PATCH] When hit a read error, retry request with R5_ReadNoMerge flag.

Because of block layer merge, one bio fails will cause other bios
which belongs to the same request fails, so raid5_end_read_request
will record all these bios as badblocks.
If retry request with R5_ReadNoMerge flag to avoid bios merge,
badblocks can only record sector which is bad exactly.

test:
hdparm --yes-i-know-what-i-am-doing --make-bad-sector 300000 /dev/sdb
mdadm -C /dev/md0 -l5 -n3 /dev/sd[bcd] --assume-clean
mdadm /dev/md0 -f /dev/sdd
mdadm /dev/md0 -r /dev/sdd
mdadm --zero-superblock /dev/sdd
mdadm /dev/md0 -a /dev/sdd

1. Without this patch:
cat /sys/block/md0/md/rd*/bad_blocks
299776 256
299776 256

2. With this patch:
cat /sys/block/md0/md/rd*/bad_blocks
300000 8
300000 8

Signed-off-by: Bian Yu <bianyu@kedacom.com>
---
 drivers/md/raid5.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 840d0dd..796ad52 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1875,21 +1875,21 @@ static void raid5_end_read_request(struct bio
* bi, int error)
                    mdname(conf->mddev), bdn);
         else
             retry = 1;
-        if (retry)
-            if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags)) {
+        if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags)) {
+            if (retry) {
                 set_bit(R5_ReadError, &sh->dev[i].flags);
                 clear_bit(R5_ReadNoMerge, &sh->dev[i].flags);
-            } else
-                set_bit(R5_ReadNoMerge, &sh->dev[i].flags);
-        else {
-            clear_bit(R5_ReadError, &sh->dev[i].flags);
-            clear_bit(R5_ReWrite, &sh->dev[i].flags);
-            if (!(set_bad
-                  && test_bit(In_sync, &rdev->flags)
-                  && rdev_set_badblocks(
-                      rdev, sh->sector, STRIPE_SECTORS, 0)))
-                md_error(conf->mddev, rdev);
-        }
+            } else {
+                clear_bit(R5_ReadError, &sh->dev[i].flags);
+                clear_bit(R5_ReWrite, &sh->dev[i].flags);
+                if (!(set_bad
+                      && test_bit(In_sync, &rdev->flags)
+                      && rdev_set_badblocks(rdev,
+                           sh->sector, STRIPE_SECTORS, 0)))
+                    md_error(conf->mddev, rdev);
+            }
+        } else
+            set_bit(R5_ReadNoMerge, &sh->dev[i].flags);
     }
     rdev_dec_pending(rdev, conf->mddev);
     clear_bit(R5_LOCKED, &sh->dev[i].flags);
-- 
1.7.1
