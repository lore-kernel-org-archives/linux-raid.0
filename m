From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - cset 1.497.59.25 breaks MD autodetect
Date: Sat, 14 Sep 2002 19:49:14 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15747.1562.257819.793820@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>, Alexander Viro <viro@math.psu.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


cset 1.497.59.25 shifts a lot of indexes down one, but this one
shouldn't have been shifted...

NeilBrown


--- ./fs/partitions/check.c	2002/09/14 09:46:21	1.1
+++ ./fs/partitions/check.c	2002/09/14 09:46:27
@@ -251,7 +251,7 @@ static void check_partition(struct gendi
 			p[j-1].start_sect = state->parts[j].from;
 			p[j-1].nr_sects = state->parts[j].size;
 #if CONFIG_BLK_DEV_MD
-			if (!state->parts[j-1].flags)
+			if (!state->parts[j].flags)
 				continue;
 			md_autodetect_dev(bdev->bd_dev+j);
 #endif
