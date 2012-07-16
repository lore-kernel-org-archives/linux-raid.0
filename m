From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: PATCH: md/raid1: sync_request_write() may complete r1_bio without rescheduling
Date: Mon, 16 Jul 2012 17:55:25 +0300
Message-ID: <CAGRgLy7Wtk1OByAGH4m19tyH+obMbaV=QD7cAv++HyojvK+C2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,
this is yet another issue I encounter, which is indirectly related to
bad-blocks code, but I think it can be hit when bad-blocks logging is
disabled too.

Scenario:
- RAID1 with one device A, one device missing
- mdadm --manage /dev/mdX --add /dev/B (fresh device B added)
- recovery of B starts

Now at some point, end_sync_write() on B returns with error. Now the
following can happen:
In sync_request_write() we do:
1/
	/*
	 * schedule writes
	 */
	atomic_set(&r1_bio->remaining, 1);

2/ then we schedule WRITEs, so for each WRITE scheduled we do:
atomic_inc(&r1_bio->remaining);

3/ then we do:
	if (atomic_dec_and_test(&r1_bio->remaining)) {
		/* if we're here, all write(s) have completed, so clean up */
		md_done_sync(mddev, r1_bio->sectors, 1);
		put_buf(r1_bio);
	}

So assume that end_sync_write() completed with error, before we got to
3/. Then in end_sync_write() we set R1BIO_WriteError, and the we
decrement r1_bio->remaining, so it becomes 1, so we bail out and don't
call reschedule_retry().
Then in 3/ we decrement r1_bio->remaining again, see that it is 0 now
and complete the bio....without marking bad block or failing the
device. So we think that this region is in-sync, while it's not,
because we hit IO error on B.

I checked vs 2.6 versions and such behavior makes sense there, because
R1BIO_WriteError or R1BIO_MadeGood cases are not present there (no
bad-blocks functionality). But now, we must call reschedule_retry() at
both places (if needed). Does this make sense?

I tested the following patch, which seems to work ok:

$ diff -U 20  c:/work/code_backups/psp13/bad_sectors/raid1.c
ubuntu-precise/source/drivers/md/raid1.c
--- c:/work/code_backups/psp13/bad_sectors/raid1.c      Mon Jul 16 17:10:24 2012
+++ ubuntu-precise/source/drivers/md/raid1.c    Mon Jul 16 17:45:13 2012
@@ -1793,42 +1793,47 @@
         */
        atomic_set(&r1_bio->remaining, 1);
        for (i = 0; i < disks ; i++) {
                wbio = r1_bio->bios[i];
                if (wbio->bi_end_io == NULL ||
                    (wbio->bi_end_io == end_sync_read &&
                     (i == r1_bio->read_disk ||
                      !test_bit(MD_RECOVERY_SYNC, &mddev->recovery))))
                        continue;

                wbio->bi_rw = WRITE;
                wbio->bi_end_io = end_sync_write;
                atomic_inc(&r1_bio->remaining);
                md_sync_acct(conf->mirrors[i].rdev->bdev, wbio->bi_size >> 9);

                generic_make_request(wbio);
        }

        if (atomic_dec_and_test(&r1_bio->remaining)) {
                /* if we're here, all write(s) have completed, so clean up */
-               md_done_sync(mddev, r1_bio->sectors, 1);
-               put_buf(r1_bio);
+               if (test_bit(R1BIO_MadeGood, &r1_bio->state) ||
+                   test_bit(R1BIO_WriteError, &r1_bio->state))
+                       reschedule_retry(r1_bio);
+               else {
+                       md_done_sync(mddev, r1_bio->sectors, 1);
+                       put_buf(r1_bio);
+               }
        }
 }

 /*
  * This is a kernel thread which:
  *
  *     1.      Retries failed read operations on working mirrors.
  *     2.      Updates the raid superblock when problems encounter.
  *     3.      Performs writes following reads for array synchronising.
  */

 static void fix_read_error(struct r1conf *conf, int read_disk,
                           sector_t sect, int sectors)
 {
        struct mddev *mddev = conf->mddev;
        while(sectors) {
                int s = sectors;
                int d = read_disk;
                int success = 0;
                int start;




Thanks,
Alex.
