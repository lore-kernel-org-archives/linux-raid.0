From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 6/13] md/multipath: Delete 13 unwanted spaces behind function
 names
Date: Sun, 2 Oct 2016 14:02:09 +0200
Message-ID: <d9a69429-c73e-1e2e-d2cf-0129a7ef9206@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <4a31d7a7-f70c-12f7-202f-963bd8706066@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <4a31d7a7-f70c-12f7-202f-963bd8706066@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Jens Axboe <axboe@fb.com>, NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 2 Oct 2016 08:14:48 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: space prohibited between function name and open parenthesis '('

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/multipath.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 2e4ceb9..7e10603 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -31,7 +31,7 @@
 
 #define	NR_RESERVED_BUFS	32
 
-static int multipath_map (struct mpconf *conf)
+static int multipath_map(struct mpconf *conf)
 {
 	int i, disks = conf->raid_disks;
 
@@ -56,7 +56,7 @@ static int multipath_map (struct mpconf *conf)
 	return (-1);
 }
 
-static void multipath_reschedule_retry (struct multipath_bh *mp_bh)
+static void multipath_reschedule_retry(struct multipath_bh *mp_bh)
 {
 	unsigned long flags;
 	struct mddev *mddev = mp_bh->mddev;
@@ -73,7 +73,7 @@ static void multipath_reschedule_retry (struct multipath_bh *mp_bh)
  * operation and are ready to return a success/failure code to the buffer
  * cache layer.
  */
-static void multipath_end_bh_io (struct multipath_bh *mp_bh, int err)
+static void multipath_end_bh_io(struct multipath_bh *mp_bh, int err)
 {
 	struct bio *bio = mp_bh->master_bio;
 	struct mpconf *conf = mp_bh->mddev->private;
@@ -96,7 +96,7 @@ static void multipath_end_request(struct bio *bio)
 		 * oops, IO error:
 		 */
 		char b[BDEVNAME_SIZE];
-		md_error (mp_bh->mddev, rdev);
+		md_error(mp_bh->mddev, rdev);
 		printk(KERN_ERR "multipath: %s: rescheduling sector %llu\n",
 		       bdevname(rdev->bdev,b),
 		       (unsigned long long)bio->bi_iter.bi_sector);
@@ -147,12 +147,14 @@ static void multipath_status(struct seq_file *seq, struct mddev *mddev)
 	struct mpconf *conf = mddev->private;
 	int i;
 
-	seq_printf (seq, " [%d/%d] [", conf->raid_disks,
-		    conf->raid_disks - mddev->degraded);
+	seq_printf(seq, " [%d/%d] [", conf->raid_disks,
+		   conf->raid_disks - mddev->degraded);
 	rcu_read_lock();
 	for (i = 0; i < conf->raid_disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->multipaths[i].rdev);
-		seq_printf (seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
+		seq_printf(seq,
+			   "%s",
+			   rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
 	}
 	rcu_read_unlock();
 	seq_printf (seq, "]");
@@ -183,7 +185,7 @@ static int multipath_congested(struct mddev *mddev, int bits)
 /*
  * Careful, this can execute in IRQ contexts as well!
  */
-static void multipath_error (struct mddev *mddev, struct md_rdev *rdev)
+static void multipath_error(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct mpconf *conf = mddev->private;
 	char b[BDEVNAME_SIZE];
@@ -218,7 +220,7 @@ static void multipath_error (struct mddev *mddev, struct md_rdev *rdev)
 	       conf->raid_disks - mddev->degraded);
 }
 
-static void print_multipath_conf (struct mpconf *conf)
+static void print_multipath_conf(struct mpconf *conf)
 {
 	int i;
 	struct multipath_info *tmp;
@@ -377,7 +379,7 @@ static sector_t multipath_size(struct mddev *mddev, sector_t sectors, int raid_d
 	return mddev->dev_sectors;
 }
 
-static int multipath_run (struct mddev *mddev)
+static int multipath_run(struct mddev *mddev)
 {
 	struct mpconf *conf;
 	int disk_idx;
@@ -496,14 +498,14 @@ static struct md_personality multipath_personality =
 	.congested	= multipath_congested,
 };
 
-static int __init multipath_init (void)
+static int __init multipath_init(void)
 {
-	return register_md_personality (&multipath_personality);
+	return register_md_personality(&multipath_personality);
 }
 
-static void __exit multipath_exit (void)
+static void __exit multipath_exit(void)
 {
-	unregister_md_personality (&multipath_personality);
+	unregister_md_personality(&multipath_personality);
 }
 
 module_init(multipath_init);
-- 
2.10.0

