From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 4 of 5] Fix typos in md and raid10
Date: Wed, 20 Oct 2004 13:26:21 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1CK77F-0008IV-BE@notabene.cse.unsw.edu.au>
References: <20041020132354.31830.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c     |    4 ++--
 ./drivers/md/raid10.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-10-20 13:21:26.000000000 +1000
+++ ./drivers/md/md.c	2004-10-20 13:21:27.000000000 +1000
@@ -1833,7 +1833,7 @@ static void autorun_array(mddev_t *mddev
 
 	err = do_md_run (mddev);
 	if (err) {
-		printk(KERN_WARNING "md :do_md_run() returned %d\n", err);
+		printk(KERN_WARNING "md: do_md_run() returned %d\n", err);
 		do_md_stop (mddev, 0);
 	}
 }
@@ -2424,7 +2424,7 @@ static int update_array_info(mddev_t *md
 		/* The "size" is the amount of each device that is used.
 		 * This can only make sense for arrays with redundancy.
 		 * linear and raid0 always use whatever space is available
-		 * We can only consider changing the size of no resync
+		 * We can only consider changing the size if no resync
 		 * or reconstruction is happening, and if the new size
 		 * is acceptable. It must fit before the sb_offset or,
 		 * if that is <data_offset, it must fit before the

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2004-10-20 13:21:25.000000000 +1000
+++ ./drivers/md/raid10.c	2004-10-20 13:21:27.000000000 +1000
@@ -36,7 +36,7 @@
  * device of the previous section.
  * Thus there are (near_copies*far_copies) of each chunk, and each is on a different
  * drive.
- * near_copies and far_copies must be at least one, and there product is at most
+ * near_copies and far_copies must be at least one, and their product is at most
  * raid_disks.
  */
 
