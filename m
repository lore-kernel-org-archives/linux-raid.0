From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 1 - Fix stupid oops in recent md.c module changes
Date: Fri, 28 Mar 2003 12:49:01 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18yizN-0006fR-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet


 drivers/md/md.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/md.c~md-module-fix-2 drivers/md/md.c

 ----------- Diffstat output ------------
 ./drivers/md/md.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-03-28 10:34:51.000000000 +1100
+++ ./drivers/md/md.c	2003-03-28 10:34:51.000000000 +1100
@@ -1714,8 +1714,8 @@ static int do_md_run(mddev_t * mddev)
 	err = mddev->pers->run(mddev);
 	if (err) {
 		printk(KERN_ERR "md: pers->run() failed ...\n");
-		mddev->pers = NULL;
 		module_put(mddev->pers->owner);
+		mddev->pers = NULL;
 		return -EINVAL;
 	}
  	atomic_set(&mddev->writes_pending,0);
