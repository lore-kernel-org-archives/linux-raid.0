From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 004 of 8] Make sure bitmap_daemon_work actually does work.
Date: Mon, 22 Aug 2005 11:59:13 +1000
Message-ID: <E1E71aj-0001IB-I3@notabene.cse.unsw.edu.au>
References: <20050822115252.4868.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The 'lastrun' time wasn't being initialised, so it could be
half a jiffie-cycle before it seemed to be time to do work again.



Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c |    1 +
 1 files changed, 1 insertion(+)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-08-22 11:48:18.000000000 +1000
+++ ./drivers/md/bitmap.c	2005-08-22 11:49:43.000000000 +1000
@@ -522,6 +522,7 @@ success:
 	/* assign fields using values from superblock */
 	bitmap->chunksize = chunksize;
 	bitmap->daemon_sleep = daemon_sleep;
+	bitmap->daemon_lastrun = jiffies;
 	bitmap->max_write_behind = write_behind;
 	bitmap->flags |= sb->state;
 	bitmap->events_cleared = le64_to_cpu(sb->events_cleared);
