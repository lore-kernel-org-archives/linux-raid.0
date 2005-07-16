From: Michael Tokarev <mjt@tls.msk.ru>
Subject: [patch] linear does not need chunksize
Date: Sun, 17 Jul 2005 03:12:36 +0400 (MSD)
Message-ID: <20050716231236.1851A8DC9@gandalf.tls.msk.ru>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When debugging some weird raid failure case, we come
across a problem when kernel disallows assembling a
linear array with zero chunksize, printing
'no chunksize specified' in dmesg and mdadm failing
with EINVAL.  The following patch fixes the problem
(the patch is with large context to show why the change).

Note chunk size is never used on linear array.  The
only usage of chunk_size member is in /proc/mdstat,
as "rounding" parameter (linear.c) - looks like it
should be removed too.

Signed-Off-By: Michael Tokarev <mjt@tls.msk.ru>

--- linux-2.6.12/drivers/md/md.c.orig	2005-06-17 23:48:29.000000000 +0400
+++ linux-2.6.12/drivers/md/md.c	2005-07-17 03:07:05.000000000 +0400
@@ -1516,21 +1516,21 @@ static int do_md_run(mddev_t * mddev)
 
 	/*
 	 * Analyze all RAID superblock(s)
 	 */
 	if (!mddev->raid_disks)
 		analyze_sbs(mddev);
 
 	chunk_size = mddev->chunk_size;
 	pnum = level_to_pers(mddev->level);
 
-	if ((pnum != MULTIPATH) && (pnum != RAID1)) {
+	if ((pnum != MULTIPATH) && (pnum != RAID1) && (pnum != LINEAR)) {
 		if (!chunk_size) {
 			/*
 			 * 'default chunksize' in the old md code used to
 			 * be PAGE_SIZE, baaad.
 			 * we abort here to be on the safe side. We don't
 			 * want to continue the bad practice.
 			 */
 			printk(KERN_ERR 
 				"no chunksize specified, see 'man raidtab'\n");
 			return -EINVAL;
