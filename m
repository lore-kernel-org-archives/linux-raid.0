From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 17/22] md/raid10: print more useful messages on device
	failure.
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.18352.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Robert Becker <Rob.Becker@riverbed.com>
List-Id: linux-raid.ids

From: Robert Becker <Rob.Becker@riverbed.com>

When we get a read error on a device in a RAID10, and attempting to
repair the error fails, print more useful messages about why it
failed.

Signed-off-by: Robert Becker <Rob.Becker@riverbed.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid10.c |   32 +++++++++++++++++++++++++++++---
 1 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d9e28a6..670449f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1488,6 +1488,7 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 		/* write it back and re-read */
 		rcu_read_lock();
 		while (sl != r10_bio->read_slot) {
+			char b[BDEVNAME_SIZE];
 			int d;
 			if (sl==0)
 				sl = conf->copies;
@@ -1503,9 +1504,21 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 						 r10_bio->devs[sl].addr +
 						 sect + rdev->data_offset,
 						 s<<9, conf->tmppage, WRITE)
-				    == 0)
+				    == 0) {
 					/* Well, this device is dead */
+					printk(KERN_NOTICE
+					       "raid10:%s: read correction "
+					       "write failed"
+					       " (%d sectors at %llu on %s)\n",
+					       mdname(mddev), s,
+					       (unsigned long long)(sect+
+					       rdev->data_offset),
+					       bdevname(rdev->bdev, b));
+					printk(KERN_NOTICE "raid10:%s: failing "
+					       "drive\n",
+					       bdevname(rdev->bdev, b));
 					md_error(mddev, rdev);
+				}
 				rdev_dec_pending(rdev, mddev);
 				rcu_read_lock();
 			}
@@ -1526,10 +1539,22 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 				if (sync_page_io(rdev->bdev,
 						 r10_bio->devs[sl].addr +
 						 sect + rdev->data_offset,
-						 s<<9, conf->tmppage, READ) == 0)
+						 s<<9, conf->tmppage,
+						 READ) == 0) {
 					/* Well, this device is dead */
+					printk(KERN_NOTICE
+					       "raid10:%s: unable to read back "
+					       "corrected sectors"
+					       " (%d sectors at %llu on %s)\n",
+					       mdname(mddev), s,
+					       (unsigned long long)(sect+
+						    rdev->data_offset),
+					       bdevname(rdev->bdev, b));
+					printk(KERN_NOTICE "raid10:%s: failing drive\n",
+					       bdevname(rdev->bdev, b));
+
 					md_error(mddev, rdev);
-				else
+				} else {
 					printk(KERN_INFO
 					       "raid10:%s: read error corrected"
 					       " (%d sectors at %llu on %s)\n",
@@ -1537,6 +1562,7 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 					       (unsigned long long)(sect+
 					            rdev->data_offset),
 					       bdevname(rdev->bdev, b));
+				}
 
 				rdev_dec_pending(rdev, mddev);
 				rcu_read_lock();


