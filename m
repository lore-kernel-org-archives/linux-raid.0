From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 5 of 6 - Always allow a half-built md array to be stopped.
Date: Thu, 08 May 2003 11:39:44 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19DaNs-0004uu-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

When starting an array fails, we have to tear it down, but
in some circumstances (particularly autostart_array) the
reference count will be 3, so do_md_stop will fail.

With this patch we only worry about the number of users
is the array has been fully started.


 ----------- Diffstat output ------------
 ./drivers/md/md.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-05-02 16:41:28.000000000 +1000
+++ ./drivers/md/md.c	2003-05-07 15:52:27.000000000 +1000
@@ -1668,13 +1668,12 @@ static int do_md_stop(mddev_t * mddev, i
 	int err = 0;
 	struct gendisk *disk = disks[mdidx(mddev)];
 
-	if (atomic_read(&mddev->active)>2) {
-		printk("md: md%d still in use.\n",mdidx(mddev));
-		err = -EBUSY;
-		goto out;
-	}
-
 	if (mddev->pers) {
+		if (atomic_read(&mddev->active)>2) {
+			printk("md: md%d still in use.\n",mdidx(mddev));
+			return -EBUSY;
+		}
+
 		if (mddev->sync_thread) {
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			md_unregister_thread(mddev->sync_thread);
