From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md in 2.5.27 - Fix to bugs that would cause sync_sbs to Oops
Date: Wed, 24 Jul 2002 22:39:46 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15678.40978.90408.726442@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Sync_sbs tries to access the ->sb for the first rdev of an mddev.
This can oops as the wrong arg is given to list_entry, and also
if a define was faound to be failed, as failed devices have their ->sb
removed.  But that removal isn't necessary, so now an rdev will always
have an ->sb.



 ----------- Diffstat output ------------
 ./drivers/md/md.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

--- ./drivers/md/md.c	2002/07/24 11:16:39	1.1
+++ ./drivers/md/md.c	2002/07/24 11:18:32	1.2
@@ -847,7 +847,7 @@ static void sync_sbs(mddev_t * mddev)
 		MD_BUG();
 		return;
 	}
-	rdev = list_entry(&mddev->disks.next, mdk_rdev_t, same_set);
+	rdev = list_entry(mddev->disks.next, mdk_rdev_t, same_set);
 	sb = rdev->sb;
 
 	memset(sb, 0, sizeof(*sb));
@@ -1044,8 +1044,6 @@ static mdk_rdev_t *md_import_device(dev_
 	}
 	INIT_LIST_HEAD(&rdev->same_set);
 
-	if (rdev->faulty && rdev->sb)
-		free_disk_sb(rdev);
 	return rdev;
 
 abort_free:
