From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: [PATCH] raid6check.c: remove legacy code
Date: Thu, 23 Jan 2014 19:43:33 +0100
Message-ID: <20140123184332.GA9468@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

this patch will remove some legacy code.
It is part of the verbosity "cleanup".
In any case, if information about the P
and Q parity mismatches is required, it
should go inside the code handling page
size blocks, not full stripe size.

Signed off: piergiorgio.sartor@nexgo.de
diff -uNrp a/raid6check.c b/raid6check.c
--- a/raid6check.c	2014-01-20 19:48:10.435721613 +0100
+++ b/raid6check.c	2014-01-23 19:36:23.151837870 +0100
@@ -231,15 +231,7 @@ int check_stripes(struct mdinfo *info, i
 		block_index_for_slot[diskP] = data_disks;
 		blocks[data_disks+1] = stripes[diskQ];
 		block_index_for_slot[diskQ] = data_disks+1;
-/* Do we really need the code below? */
-#if 0
-		if (memcmp(p, stripes[diskP], chunk_size) != 0) {
-			printf("P(%d) wrong at %llu\n", diskP, start);
-		}
-		if (memcmp(q, stripes[diskQ], chunk_size) != 0) {
-			printf("Q(%d) wrong at %llu\n", diskQ, start);
-		}
-#endif
+
 		raid6_collect(chunk_size, p, q, stripes[diskP], stripes[diskQ], results);
 		raid6_stats(disk, results, raid_disks, chunk_size);
 

-- 

piergiorgio
