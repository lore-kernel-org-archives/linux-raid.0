From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] md: Remove risk of overflow via sprintf) by using snprintf()
 in md_check_recovery()
Date: Fri, 11 Feb 2011 22:30:59 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1102112227040.16994@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>, Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

sprintf() is dangerous - given the wrong source string it will overflow 
the destination. snprintf() is safer in that at least we'll never overflow 
the destination. Even if overflow will never happen today, code changes 
over time and snprintf() is just safer in the long run.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

 just compile tested

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0cc30ec..6283658 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7164,7 +7164,7 @@ void md_check_recovery(mddev_t *mddev)
 					if (mddev->pers->hot_remove_disk(
 						    mddev, rdev->raid_disk)==0) {
 						char nm[20];
-						sprintf(nm,"rd%d", rdev->raid_disk);
+						snprintf(nm, sizeof(nm), "rd%d", rdev->raid_disk);
 						sysfs_remove_link(&mddev->kobj, nm);
 						rdev->raid_disk = -1;
 					}


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

