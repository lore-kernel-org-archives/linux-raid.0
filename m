From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 11] md: Remove useless ioctl warning.
Date: Mon, 1 May 2006 15:30:14 +1000
Message-ID: <1060501053014.22937@suse.de>
References: <20060501152229.18367.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750871AbWEAFbJ@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


This warning was slightly useful back in 2.2 days, but is more
an annoyance now.  It makes it awkward to add new ioctls (that we we are
likely to do that in the current climate, but it is possible).

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    5 -----
 1 file changed, 5 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-05-01 15:09:20.000000000 +1000
+++ ./drivers/md/md.c	2006-05-01 15:10:17.000000000 +1000
@@ -3964,11 +3964,6 @@ static int md_ioctl(struct inode *inode,
 			goto done_unlock;
 
 		default:
-			if (_IOC_TYPE(cmd) == MD_MAJOR)
-				printk(KERN_WARNING "md: %s(pid %d) used"
-					" obsolete MD ioctl, upgrade your"
-					" software to use new ictls.\n",
-					current->comm, current->pid);
 			err = -EINVAL;
 			goto abort_unlock;
 	}
