From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Problem with raid1 read error patch
Date: Mon, 20 Sep 2004 17:16:19 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0409201700460.12286@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil

I'm having some trouble with your patch that "fixes" raid1 read error
handling that went into Linus tree. Backing it out fixes it again.
The latest kernel I've tried is 2.6.9-rc2-bk6

ChangeSet 1.1926, 2004/06/24 09:36:53-07:00, akpm@osdl.org

        [PATCH] md: Fix up handling for read error in raid1.

        From: NeilBrown <neilb@cse.unsw.edu.au>

        There is severe bit-rot in this code, which is to say that it doesn't work
        at all: an io error during read will do bad things.  It should work better
        with this patch.

diff -Nru a/drivers/md/raid1.c b/drivers/md/raid1.c
--- a/drivers/md/raid1.c	2004-06-24 10:35:44 -07:00
+++ b/drivers/md/raid1.c	2004-06-24 10:35:44 -07:00
@@ -206,7 +206,7 @@
 			*rdevp = rdev;
 			atomic_inc(&rdev->nr_pending);
 			spin_unlock_irq(&conf->device_lock);
-			return 0;
+			return i;
 		}
 	}
 	spin_unlock_irq(&conf->device_lock);
@@ -919,18 +919,22 @@

 		mddev = r1_bio->mddev;
 		conf = mddev_to_conf(mddev);
-		bio = r1_bio->master_bio;
 		if (test_bit(R1BIO_IsSync, &r1_bio->state)) {
 			sync_request_write(mddev, r1_bio);
 			unplug = 1;
 		} else {
-			if (map(mddev, &rdev) == -1) {
+			int disk;
+			bio = r1_bio->bios[r1_bio->read_disk];
+			if ((disk=map(mddev, &rdev)) == -1) {
 				printk(KERN_ALERT "raid1: %s: unrecoverable I/O"
 				       " read error for block %llu\n",
 				       bdevname(bio->bi_bdev,b),
 				       (unsigned long long)r1_bio->sector);
 				raid_end_bio_io(r1_bio);
 			} else {
+				r1_bio->bios[r1_bio->read_disk] = NULL;
+				r1_bio->read_disk = disk;
+				r1_bio->bios[r1_bio->read_disk] = bio;
 				printk(KERN_ERR "raid1: %s: redirecting sector %llu to"
 				       " another mirror\n",
 				       bdevname(rdev->bdev,b),

After this patch I get infinite loops in sector rescheduling when one disk
fails (I physically remove it). I have two disks (sda, sdb) with 4
partitions each. They make up 4 raid1 arrays. I'm removing sda from the
scsi-chain.

Example:

Sep 17 16:23:45 faioffer kernel: SCSI error : <0 0 1 0> return code = 0x10000
Sep 17 16:23:45 faioffer kernel: end_request: I/O error, dev sda, sector 4208897
Sep 17 16:23:45 faioffer kernel: md: write_disk_sb failed for device sda1
Sep 17 16:23:45 faioffer kernel: md: errors occurred during superblock update, repeating
Sep 17 16:23:46 faioffer kernel: SCSI error : <0 0 1 0> return code = 0x10000
Sep 17 16:23:46 faioffer kernel: end_request: I/O error, dev sda, sector 4208897
Sep 17 16:23:46 faioffer kernel: md: write_disk_sb failed for device sda1
Sep 17 16:23:46 faioffer kernel: md: errors occurred during superblock update, repeating
Sep 17 16:23:46 faioffer kernel: SCSI error : <0 0 1 0> return code = 0x10000
Sep 17 16:23:46 faioffer kernel: end_request: I/O error, dev sda, sector 4208897
Sep 17 16:23:46 faioffer kernel: md: write_disk_sb failed for device sda1
Sep 17 16:23:46 faioffer kernel: md: errors occurred during superblock update, repeating
Sep 17 16:23:46 faioffer kernel: SCSI error : <0 0 1 0> return code = 0x10000
Sep 17 16:23:46 faioffer kernel: end_request: I/O error, dev sda, sector 2887473
Sep 17 16:23:46 faioffer kernel: raid1: Disk failure on sda1, disabling device.
Sep 17 16:23:46 faioffer kernel: ^IOperation continuing on 1 devices
Sep 17 16:23:46 faioffer kernel: raid1: sda1: rescheduling sector 2887472
Sep 17 16:23:46 faioffer kernel: raid1: sdb1: redirecting sector 2887472 to another mirror
Sep 17 16:23:46 faioffer kernel: raid1: sdb1: rescheduling sector 2887472
Sep 17 16:23:46 faioffer kernel: SCSI error : <0 0 1 0> return code = 0x10000
Sep 17 16:23:46 faioffer kernel: end_request: I/O error, dev sda, sector 33
Sep 17 16:23:46 faioffer kernel: RAID1 conf printout:
Sep 17 16:23:46 faioffer kernel:  --- wd:1 rd:2
Sep 17 16:23:46 faioffer kernel:  disk 0, wo:1, o:0, dev:sda1
Sep 17 16:23:46 faioffer kernel:  disk 1, wo:0, o:1, dev:sdb1
Sep 17 16:23:46 faioffer kernel: RAID1 conf printout:
Sep 17 16:23:46 faioffer kernel:  --- wd:1 rd:2
Sep 17 16:23:46 faioffer kernel:  disk 1, wo:0, o:1, dev:sdb1
Sep 17 16:23:46 faioffer kernel: raid1: sdb1: redirecting sector 2887472 to another mirror
Sep 17 16:23:47 faioffer kernel: raid1: sdb1: rescheduling sector 2887472
Sep 17 16:23:47 faioffer kernel: raid1: sdb1: redirecting sector 2887472 to another mirror
Sep 17 16:23:47 faioffer kernel: raid1: sdb1: rescheduling sector 2887472
Sep 17 16:23:47 faioffer kernel: raid1: sdb1: redirecting sector 2887472 to another mirror
Sep 17 16:23:47 faioffer kernel: raid1: sdb1: rescheduling sector 2887472
Sep 17 16:23:47 faioffer kernel: raid1: sdb1: redirecting sector 2887472 to another mirror
Sep 17 16:23:47 faioffer kernel: raid1: sdb1: rescheduling sector 2887472
Sep 17 16:23:47 faioffer kernel: raid1: sdb1: redirecting sector 2887472 to another mirror
Sep 17 16:23:47 faioffer kernel: raid1: sdb1: rescheduling sector 2887472

It continues like that forever.

After backing that patch out, with some minor modifications because the
code has changed a little bit, I get a number of scsi-errors and after a
while the drive gets disabled like above but life continues like before
the patch went in. That is, no infinite loop and everything works :)

Any ideas to what went wrong?

/Martin
