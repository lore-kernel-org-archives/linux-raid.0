From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: [PATCH 2.6.0-test3] avoid raid1 resync abort
Date: Wed, 20 Aug 2003 12:24:36 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F43A0C4.E215B858@SteelEye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------87CE1A9FD3235360FD925B05"
Return-path: <linux-raid-owner@vger.kernel.org>
To: NeilBrown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------87CE1A9FD3235360FD925B05
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Neil,

I don't know if you've noticed this one yet, but it looks like we need
to set the master_bio->bi_bdev field at the beginning of every resync
request. We use this value later on in sync_request_write() to determine
whether a write should take place on a particular device. Without the
field being properly set, we will end up aborting the resync process.
This happens because the master_bios are pulled from a pool, so we
eventually end up getting a master_bio that already has our destination
disk set in its bi_bdev field. This causes sync_request_write() to fail
since it thinks there is nowhere to write the data to. 

The other minor bits in the patch are just some extra stuff that I found
useful in debugging this problem, but are completely optional...

Thanks,
Paul
--------------87CE1A9FD3235360FD925B05
Content-Type: text/x-diff; charset=us-ascii;
 name="raid1_resync_abort_2_6_0_test3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="raid1_resync_abort_2_6_0_test3.diff"

Index: drivers/md/raid1.c
===================================================================
RCS file: /home/cvs/CVSROOT/kernel/linux-2.6.0-test3/drivers/md/raid1.c,v
retrieving revision 1.2
diff -p -u -r1.2 raid1.c
--- drivers/md/raid1.c	2003/08/13 18:26:17	1.2
+++ drivers/md/raid1.c	2003/08/20 15:41:52
@@ -771,8 +770,8 @@ static void print_conf(conf_t *conf)
 		char b[BDEVNAME_SIZE];
 		tmp = conf->mirrors + i;
 		if (tmp->rdev)
-			printk(" disk %d, wo:%d, o:%d, dev:%s\n",
-				i, !tmp->rdev->in_sync, !tmp->rdev->faulty,
+			printk(" disk %d, s:%d, f:%d, dev:%s\n",
+				i, tmp->rdev->in_sync, tmp->rdev->faulty,
 				bdevname(tmp->rdev->bdev,b));
 	}
 }
@@ -992,6 +991,8 @@ static void sync_request_write(mddev_t *
 	}
 
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
+		PRINTK(KERN_DEBUG "raid1: sync write failed, no destination\n");
+		print_conf(conf);
 		md_done_sync(mddev, r1_bio->sector, bio->bi_size >> 9, 0);
 		put_buf(r1_bio);
 	}
@@ -1156,6 +1157,7 @@ static int sync_request(mddev_t *mddev, 
 	if (partial)
 		bio->bi_io_vec[bio->bi_vcnt-1].bv_len = partial;
 
+	bio->bi_bdev = mirror->rdev->bdev; /* we'd better set this */
 
 	read_bio = bio_clone(r1_bio->master_bio, GFP_NOIO);
 

--------------87CE1A9FD3235360FD925B05--

