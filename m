From: NeilBrown <neilb@suse.de>
Subject: [PATCH 008 of 9] md: md: raid5 rate limit error printk
Date: Tue, 29 Apr 2008 13:35:34 +1000
Message-ID: <1080429033534.20399@suse.de>
References: <20080429133104.20146.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Bernd Schubert <bernd-schubert@gmx.de>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids


From: Bernd Schubert <bernd-schubert@gmx.de>

last night we had scsi problems and a hardware raid
unit was offlined during heavy i/o. While this happened we got for
about 3 minutes a huge number messages like these

Apr 12 03:36:07 pfs1n14 kernel: [197510.696595] raid5:md7: read error not correctable (sector 2993096568 on sdj2).

I guess the high error rate is responsible for not scheduling other
events - during this time the system was not pingable and in the end
also other devices run into scsi command timeouts causing problems on
these unrelated devices as well.

Signed-off-by: Bernd Schubert <bernd-schubert@gmx.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c        |   27 +++++++++++++++------------
 ./include/linux/raid/md_k.h |    3 +++
 2 files changed, 18 insertions(+), 12 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-04-29 12:27:50.000000000 +1000
+++ ./drivers/md/raid5.c	2008-04-29 12:27:58.000000000 +1000
@@ -1143,10 +1143,11 @@ static void raid5_end_read_request(struc
 		set_bit(R5_UPTODATE, &sh->dev[i].flags);
 		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
 			rdev = conf->disks[i].rdev;
-			printk(KERN_INFO "raid5:%s: read error corrected (%lu sectors at %llu on %s)\n",
-			       mdname(conf->mddev), STRIPE_SECTORS,
-			       (unsigned long long)(sh->sector + rdev->data_offset),
-			       bdevname(rdev->bdev, b));
+			printk_rl(KERN_INFO "raid5:%s: read error corrected"
+				  " (%lu sectors at %llu on %s)\n",
+				  mdname(conf->mddev), STRIPE_SECTORS,
+				  (unsigned long long)(sh->sector + rdev->data_offset),
+				  bdevname(rdev->bdev, b));
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
 		}
@@ -1160,16 +1161,18 @@ static void raid5_end_read_request(struc
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 		atomic_inc(&rdev->read_errors);
 		if (conf->mddev->degraded)
-			printk(KERN_WARNING "raid5:%s: read error not correctable (sector %llu on %s).\n",
-			       mdname(conf->mddev),
-			       (unsigned long long)(sh->sector + rdev->data_offset),
-			       bdn);
+			printk_rl(KERN_WARNING "raid5:%s: read error not correctable "
+				  "(sector %llu on %s).\n",
+				  mdname(conf->mddev),
+				  (unsigned long long)(sh->sector + rdev->data_offset),
+				  bdn);
 		else if (test_bit(R5_ReWrite, &sh->dev[i].flags))
 			/* Oh, no!!! */
-			printk(KERN_WARNING "raid5:%s: read error NOT corrected!! (sector %llu on %s).\n",
-			       mdname(conf->mddev),
-			       (unsigned long long)(sh->sector + rdev->data_offset),
-			       bdn);
+			printk_rl(KERN_WARNING "raid5:%s: read error NOT corrected!! "
+				  "(sector %llu on %s).\n",
+				  mdname(conf->mddev),
+				  (unsigned long long)(sh->sector + rdev->data_offset),
+				  bdn);
 		else if (atomic_read(&rdev->read_errors)
 			 > conf->max_nr_stripes)
 			printk(KERN_WARNING

diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
--- .prev/include/linux/raid/md_k.h	2008-04-29 12:25:24.000000000 +1000
+++ ./include/linux/raid/md_k.h	2008-04-29 12:27:58.000000000 +1000
@@ -368,6 +368,9 @@ static inline void safe_put_page(struct 
 	if (p) put_page(p);
 }
 
+#define printk_rl  printk_ratelimit() ?: printk
+
+
 #endif /* CONFIG_BLOCK */
 #endif
 
