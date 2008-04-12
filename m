From: Bernd Schubert <bernd-schubert@gmx.de>
Subject: [patch] limit error rate
Date: Sat, 12 Apr 2008 20:16:44 +0200
Message-ID: <ftquac$82m$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

last night we had scsi problems and a hardware raid 
unit was offlined during heavy i/o. While this happened we got for 
about 3 minutes a huge number messages like these

Apr 12 03:36:07 pfs1n14 kernel: [197510.696595] raid5:md7: read error not correctable (sector 2993096568 on sdj2).

I guess the high error rate is responsible for not scheduling other 
events - during this time the system was not pingable and in the end 
also other devices run into scsi command timeouts causing problems on 
these unrelated devices as well.


Signed-off-by: Bernd Schubert <bernd-schubert@gmx.de>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b162b83..3c82dfb 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1141,10 +1141,12 @@ static void raid5_end_read_request(struct bio * bi, int error)
                set_bit(R5_UPTODATE, &sh->dev[i].flags);
                if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
                        rdev = conf->disks[i].rdev;
-                       printk(KERN_INFO "raid5:%s: read error corrected (%lu sectors at %llu on %s)\n",
-                              mdname(conf->mddev), STRIPE_SECTORS,
-                              (unsigned long long)(sh->sector + rdev->data_offset),
-                              bdevname(rdev->bdev, b));
+                       if (printk_ratelimit())
+                               printk(KERN_INFO "raid5:%s: read error corrected"
+                                      " (%lu sectors at %llu on %s)\n",
+                                      mdname(conf->mddev), STRIPE_SECTORS,
+                                      (unsigned long long)(sh->sector + rdev->data_offset),
+                                      bdevname(rdev->bdev, b));
                        clear_bit(R5_ReadError, &sh->dev[i].flags);
                        clear_bit(R5_ReWrite, &sh->dev[i].flags);
                }
@@ -1157,12 +1159,13 @@ static void raid5_end_read_request(struct bio * bi, int error)
 
                clear_bit(R5_UPTODATE, &sh->dev[i].flags);
                atomic_inc(&rdev->read_errors);
-               if (conf->mddev->degraded)
+               if (conf->mddev->degraded && printk_ratelimit())
                        printk(KERN_WARNING "raid5:%s: read error not correctable (sector %llu on %s).\n",
                               mdname(conf->mddev),
                               (unsigned long long)(sh->sector + rdev->data_offset),
                               bdn);
-               else if (test_bit(R5_ReWrite, &sh->dev[i].flags))
+               else if (test_bit(R5_ReWrite, &sh->dev[i].flags) && 
+                        printk_ratelimit())
                        /* Oh, no!!! */
                        printk(KERN_WARNING "raid5:%s: read error NOT corrected!! (sector %llu on %s).\n",
                               mdname(conf->mddev),



