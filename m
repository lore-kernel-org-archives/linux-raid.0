From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 3 of 3 - Add some new lines to diagnostic printks.
Date: Fri, 04 Apr 2003 11:26:23 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E191FyJ-0001za-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

Stops <6> appearing in middles of line and improves output.

 ----------- Diffstat output ------------
 ./drivers/md/md.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-04-04 11:21:33.000000000 +1000
+++ ./drivers/md/md.c	2003-04-04 11:21:40.000000000 +1000
@@ -1155,7 +1155,7 @@ static void print_sb(mdp_super_t *sb)
 
 static void print_rdev(mdk_rdev_t *rdev)
 {
-	printk(KERN_INFO "md: rdev %s, SZ:%08llu F:%d S:%d DN:%d ",
+	printk(KERN_INFO "md: rdev %s, SZ:%08llu F:%d S:%d DN:%u\n",
 		bdev_partition_name(rdev->bdev), (unsigned long long)rdev->size,
 	       	rdev->faulty, rdev->in_sync, rdev->desc_nr);
 	if (rdev->sb_loaded) {
@@ -1180,6 +1180,7 @@ void md_print_devices(void)
 
 		ITERATE_RDEV(mddev,rdev,tmp2)
 			printk("<%s>", bdev_partition_name(rdev->bdev));
+		printk("\n");
 
 		ITERATE_RDEV(mddev,rdev,tmp2)
 			print_rdev(rdev);
