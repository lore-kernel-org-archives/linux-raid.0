From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 3 - MODULE_ALIAS for md
Date: Tue, 23 Sep 2003 09:26:59 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1A1a55-0004CB-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

From: Rusty Russell <rusty@rustcorp.com.au>
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .12741-linux-2.6.0-test4-bk4/drivers/md/linear.c .12741-linux-2.6.0-test4-bk4.updated/drivers/md/linear.c

 ----------- Diffstat output ------------
 ./drivers/md/linear.c    |    1 +
 ./drivers/md/multipath.c |    1 +
 ./drivers/md/raid0.c     |    1 +
 ./drivers/md/raid1.c     |    1 +
 ./drivers/md/raid5.c     |    1 +
 5 files changed, 5 insertions(+)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2003-09-23 09:08:09.000000000 +1000
+++ ./drivers/md/linear.c	2003-09-23 09:10:56.000000000 +1000
@@ -295,3 +295,4 @@ static void linear_exit (void)
 module_init(linear_init);
 module_exit(linear_exit);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("md-personality-1"); /* LINEAR */

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2003-09-23 09:08:09.000000000 +1000
+++ ./drivers/md/multipath.c	2003-09-23 09:10:56.000000000 +1000
@@ -508,3 +508,4 @@ static void __exit multipath_exit (void)
 module_init(multipath_init);
 module_exit(multipath_exit);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("md-personality-7"); /* MULTIPATH */

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2003-09-23 09:08:09.000000000 +1000
+++ ./drivers/md/raid0.c	2003-09-23 09:10:56.000000000 +1000
@@ -460,3 +460,4 @@ static void raid0_exit (void)
 module_init(raid0_init);
 module_exit(raid0_exit);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("md-personality-2"); /* RAID0 */

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-09-23 09:08:09.000000000 +1000
+++ ./drivers/md/raid1.c	2003-09-23 09:10:56.000000000 +1000
@@ -1196,3 +1196,4 @@ static void raid_exit(void)
 module_init(raid_init);
 module_exit(raid_exit);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("md-personality-3"); /* RAID1 */

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-09-23 09:08:09.000000000 +1000
+++ ./drivers/md/raid5.c	2003-09-23 09:10:56.000000000 +1000
@@ -1780,3 +1780,4 @@ static void raid5_exit (void)
 module_init(raid5_init);
 module_exit(raid5_exit);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("md-personality-4"); /* RAID5 */
