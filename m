From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 4 of 10 - Fix typo in comment
Date: Fri, 16 Jan 2004 12:19:38 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1AhIeA-0002UK-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thanks dann frazier <dannf@hp.com>

 ----------- Diffstat output ------------
 ./include/linux/raid/raid5.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff ./include/linux/raid/raid5.h~current~ ./include/linux/raid/raid5.h
--- ./include/linux/raid/raid5.h~current~	2004-01-16 11:58:50.000000000 +1100
+++ ./include/linux/raid/raid5.h	2004-01-16 12:00:00.000000000 +1100
@@ -70,7 +70,7 @@
  * that the Uptodate bit is set.  Once they have checked that they may
  * take buffers off the read queue.
  *
- * When a buffer on the write list is committed for write is it copied
+ * When a buffer on the write list is committed for write it is copied
  * into the cache buffer, which is then marked dirty, and moved onto a
  * third list, the written list (bh_written).  Once both the parity
  * block and the cached buffer are successfully written, any buffer on
