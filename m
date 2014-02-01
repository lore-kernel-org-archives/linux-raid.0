From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: [PATCH] raid6check.c: reduce verbosity
Date: Sat, 1 Feb 2014 17:03:34 +0100
Message-ID: <20140201160334.GA9378@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This patch removes some printouts, which
are not really useful here.
These could be re-added later, in case a
verbosity parameter will be provided.

Signed off: piergiorgio.sartor@nexgo.de

diff -uNrp a/raid6check.c b/raid6check.c
--- a/raid6check.c	2014-01-23 19:36:23.151837870 +0100
+++ b/raid6check.c	2014-02-01 16:56:14.123771170 +0100
@@ -188,8 +188,6 @@ int check_stripes(struct mdinfo *info, i
 	while (length > 0) {
 		int disk[chunk_size >> CHECK_PAGE_BITS];
 
-		printf("pos --> %llu\n", start);
-
 		err = lock_stripe(info, start, chunk_size, data_disks, sig);
 		if(err != 0) {
 			if (err != 2)
@@ -221,7 +219,6 @@ int check_stripes(struct mdinfo *info, i
 			int disk = geo_map(i, start, raid_disks, level, layout);
 			blocks[i] = stripes[disk];
 			block_index_for_slot[disk] = i;
-			printf("%d->%d\n", i, disk);
 		}
 
 		qsyndrome(p, q, (uint8_t**)blocks, data_disks, chunk_size);


-- 

piergiorgio
