From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 3 - Fix small bug in md.c
Date: Thu, 13 Mar 2003 12:00:10 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18tH4s-0008I6-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



We cannot de-reference rdev->sb if rdev->faulty....

 ----------- Diffstat output ------------
 ./drivers/md/md.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-03-12 11:54:51.000000000 +1100
+++ ./drivers/md/md.c	2003-03-12 11:54:51.000000000 +1100
@@ -1048,7 +1048,7 @@ repeat:
 			printk("(skipping faulty ");
 		if (rdev->alias_device)
 			printk("(skipping alias ");
-		if (disk_faulty(&rdev->sb->this_disk)) {
+		if (!rdev->faulty && disk_faulty(&rdev->sb->this_disk)) {
 			printk("(skipping new-faulty %s )\n",
 			       partition_name(rdev->dev));
 			continue;
