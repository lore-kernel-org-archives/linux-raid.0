From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 11 of 13 - Make the old-ioctl warning in md only complain about MD ioctls.
Date: Thu, 22 Aug 2002 10:34:21 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E17hfvZ-00050d-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

..as some standard ioctls expect the per-device ioctl routine
to return EINVAL and then fall back on a standard implementation.

 ----------- Diffstat output ------------
 ./drivers/md/md.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

--- ./drivers/md/md.c	2002/08/21 23:14:39	1.10
+++ ./drivers/md/md.c	2002/08/21 23:18:17	1.11
@@ -2408,9 +2408,10 @@ static int md_ioctl(struct inode *inode,
 		}
 
 		default:
-			printk(KERN_WARNING "md: %s(pid %d) used obsolete MD ioctl, "
-			       "upgrade your software to use new ictls.\n",
-			       current->comm, current->pid);
+			if (_IOC_TYPE(cmd) == MD_MAJOR)
+				printk(KERN_WARNING "md: %s(pid %d) used obsolete MD ioctl, "
+				       "upgrade your software to use new ictls.\n",
+				       current->comm, current->pid);
 			err = -EINVAL;
 			goto abort_unlock;
 	}
