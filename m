From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 22/36] md/raid10: simplify/reindent some loops.
Date: Thu, 21 Jul 2011 12:58:49 +1000
Message-ID: <20110721025849.8422.66614.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When a loop ends with a large if, it can be neater to change the
if to invert the condition and just 'continue'.
Then the body of the if can be indented to a lower level.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |  127 ++++++++++++++++++++++++++-------------------------
 1 files changed, 65 insertions(+), 62 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index fe6692e..c489b5c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1533,80 +1533,83 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 			sl--;
 			d = r10_bio->devs[sl].devnum;
 			rdev = rcu_dereference(conf->mirrors[d].rdev);
-			if (rdev &&
-			    test_bit(In_sync, &rdev->flags)) {
-				atomic_inc(&rdev->nr_pending);
-				rcu_read_unlock();
-				if (sync_page_io(rdev,
-						 r10_bio->devs[sl].addr +
-						 sect,
-						 s<<9, conf->tmppage, WRITE, false)
-				    == 0) {
-					/* Well, this device is dead */
-					printk(KERN_NOTICE
-					       "md/raid10:%s: read correction "
-					       "write failed"
-					       " (%d sectors at %llu on %s)\n",
-					       mdname(mddev), s,
-					       (unsigned long long)(
-						       sect + rdev->data_offset),
-					       bdevname(rdev->bdev, b));
-					printk(KERN_NOTICE "md/raid10:%s: %s: failing "
-					       "drive\n",
-					       mdname(mddev),
-					       bdevname(rdev->bdev, b));
-					md_error(mddev, rdev);
-				}
-				rdev_dec_pending(rdev, mddev);
-				rcu_read_lock();
+			if (!rdev ||
+			    !test_bit(In_sync, &rdev->flags))
+				continue;
+
+			atomic_inc(&rdev->nr_pending);
+			rcu_read_unlock();
+			if (sync_page_io(rdev,
+					 r10_bio->devs[sl].addr +
+					 sect,
+					 s<<9, conf->tmppage, WRITE, false)
+			    == 0) {
+				/* Well, this device is dead */
+				printk(KERN_NOTICE
+				       "md/raid10:%s: read correction "
+				       "write failed"
+				       " (%d sectors at %llu on %s)\n",
+				       mdname(mddev), s,
+				       (unsigned long long)(
+					       sect + rdev->data_offset),
+				       bdevname(rdev->bdev, b));
+				printk(KERN_NOTICE "md/raid10:%s: %s: failing "
+				       "drive\n",
+				       mdname(mddev),
+				       bdevname(rdev->bdev, b));
+				md_error(mddev, rdev);
 			}
+			rdev_dec_pending(rdev, mddev);
+			rcu_read_lock();
 		}
 		sl = start;
 		while (sl != r10_bio->read_slot) {
+			char b[BDEVNAME_SIZE];
 
 			if (sl==0)
 				sl = conf->copies;
 			sl--;
 			d = r10_bio->devs[sl].devnum;
 			rdev = rcu_dereference(conf->mirrors[d].rdev);
-			if (rdev &&
-			    test_bit(In_sync, &rdev->flags)) {
-				char b[BDEVNAME_SIZE];
-				atomic_inc(&rdev->nr_pending);
-				rcu_read_unlock();
-				if (sync_page_io(rdev,
-						 r10_bio->devs[sl].addr +
-						 sect,
-						 s<<9, conf->tmppage,
-						 READ, false) == 0) {
-					/* Well, this device is dead */
-					printk(KERN_NOTICE
-					       "md/raid10:%s: unable to read back "
-					       "corrected sectors"
-					       " (%d sectors at %llu on %s)\n",
-					       mdname(mddev), s,
-					       (unsigned long long)(
-						       sect + rdev->data_offset),
-					       bdevname(rdev->bdev, b));
-					printk(KERN_NOTICE "md/raid10:%s: %s: failing drive\n",
-					       mdname(mddev),
-					       bdevname(rdev->bdev, b));
-
-					md_error(mddev, rdev);
-				} else {
-					printk(KERN_INFO
-					       "md/raid10:%s: read error corrected"
-					       " (%d sectors at %llu on %s)\n",
-					       mdname(mddev), s,
-					       (unsigned long long)(
-						       sect + rdev->data_offset),
-					       bdevname(rdev->bdev, b));
-					atomic_add(s, &rdev->corrected_errors);
-				}
+			if (!rdev ||
+			    !test_bit(In_sync, &rdev->flags))
+				continue;
 
-				rdev_dec_pending(rdev, mddev);
-				rcu_read_lock();
+			atomic_inc(&rdev->nr_pending);
+			rcu_read_unlock();
+			if (sync_page_io(rdev,
+					 r10_bio->devs[sl].addr +
+					 sect,
+					 s<<9, conf->tmppage,
+					 READ, false) == 0) {
+				/* Well, this device is dead */
+				printk(KERN_NOTICE
+				       "md/raid10:%s: unable to read back "
+				       "corrected sectors"
+				       " (%d sectors at %llu on %s)\n",
+				       mdname(mddev), s,
+				       (unsigned long long)(
+					       sect + rdev->data_offset),
+				       bdevname(rdev->bdev, b));
+				printk(KERN_NOTICE "md/raid10:%s: %s: failing "
+				       "drive\n",
+				       mdname(mddev),
+				       bdevname(rdev->bdev, b));
+
+				md_error(mddev, rdev);
+			} else {
+				printk(KERN_INFO
+				       "md/raid10:%s: read error corrected"
+				       " (%d sectors at %llu on %s)\n",
+				       mdname(mddev), s,
+				       (unsigned long long)(
+					       sect + rdev->data_offset),
+				       bdevname(rdev->bdev, b));
+				atomic_add(s, &rdev->corrected_errors);
 			}
+
+			rdev_dec_pending(rdev, mddev);
+			rcu_read_lock();
 		}
 		rcu_read_unlock();
 


