From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: [PATCH] raid6check.c: fix Q parity generation
Date: Sat, 1 Feb 2014 22:16:52 +0100
Message-ID: <20140201211652.GA12614@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In the transition to 4K page processing,
the Q parity generation had a wrong offset
in the buffer.
This patche fix this.

Signed off: piergiorgio.sartor@nexgo.de
diff -uNrp a/raid6check.c b/raid6check.c
--- a/raid6check.c	2014-02-01 17:36:05.685667361 +0100
+++ b/raid6check.c	2014-02-01 22:12:15.069189406 +0100
@@ -346,7 +346,7 @@ int check_stripes(struct mdinfo *info, i
 					blocks_page[i] = blocks[i] + j * CHECK_PAGE_SIZE;
 				}
 				if (disk[j] == diskQ) {
-					qsyndrome(p, (uint8_t*)stripes[diskQ], (uint8_t**)blocks_page, data_disks, CHECK_PAGE_SIZE);
+					qsyndrome(p, (uint8_t*)stripes[diskQ] + j * CHECK_PAGE_SIZE, (uint8_t**)blocks_page, data_disks, CHECK_PAGE_SIZE);
 				} else {
 					char *all_but_failed_blocks[data_disks];
 					int failed_block_index = block_index_for_slot[disk[j]];

-- 

piergiorgio
