From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [bug] 2.6.1 md multipathing
Date: Sat, 17 Jan 2004 13:16:09 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401171316.09051.heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I tried to get multipathing failover running and failed. It seems to be that
there are two bugs in multipath.c :

- If a path/request fails mp_bh->path doesn't get updated to the new path.
  Thus multipath_end_request will access a NULL pointer if a redirected
  request returns.
- After fixing this I experienced several other errors. First of all in
  bio->bi_flags the BIO_UPTODATE flag is not set when redirecting a request.
  Causing the md driver to think that every redirected request failed when
  it returns. Since that alone didn't fix the problems, I simply copied the
  master_bio again and it looks like everything seems to work.

See patch below. There are probably better ways to fix these things...

Heiko

diff -urN linux-2.6.1/drivers/md/multipath.c linux-2.6.1-md/drivers/md/multipath.c
--- linux-2.6.1/drivers/md/multipath.c	Fri Jan  9 07:59:27 2004
+++ linux-2.6.1-md/drivers/md/multipath.c	Sat Jan 17 12:58:07 2004
@@ -54,7 +54,7 @@
 	kfree(mpb);
 }
 
-static int multipath_map (mddev_t *mddev, mdk_rdev_t **rdevp)
+static int multipath_map (mddev_t *mddev, mdk_rdev_t **rdevp, int *path)
 {
 	multipath_conf_t *conf = mddev_to_conf(mddev);
 	int i, disks = conf->raid_disks;
@@ -68,6 +68,7 @@
 	for (i = 0; i < disks; i++) {
 		mdk_rdev_t *rdev = conf->multipaths[i].rdev;
 		if (rdev && rdev->in_sync) {
+			*path = i;
 			*rdevp = rdev;
 			atomic_inc(&rdev->nr_pending);
 			spin_unlock_irq(&conf->device_lock);
@@ -355,7 +356,7 @@
 		bio->bi_sector = mp_bh->master_bio->bi_sector;
 		
 		rdev = NULL;
-		if (multipath_map (mddev, &rdev)<0) {
+		if (multipath_map (mddev, &rdev, &mp_bh->path)<0) {
 			printk(KERN_ALERT "multipath: %s: unrecoverable IO read"
 				" error for block %llu\n",
 				bdevname(bio->bi_bdev,b),
@@ -366,7 +367,12 @@
 				" to another IO path\n",
 				bdevname(bio->bi_bdev,b),
 				(unsigned long long)bio->bi_sector);
+
+			*bio = *(mp_bh->master_bio);
 			bio->bi_bdev = rdev->bdev;
+			bio->bi_rw |= (1 << BIO_RW_FAILFAST);
+			bio->bi_end_io = multipath_end_request;
+			bio->bi_private = mp_bh;
 			generic_make_request(bio);
 		}
 	}

