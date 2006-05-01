From: NeilBrown <neilb@suse.de>
Subject: [PATCH 006 of 11] md: Remove nuisance message at shutdown
Date: Mon, 1 May 2006 15:30:36 +1000
Message-ID: <1060501053036.22973@suse.de>
References: <20060501152229.18367.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750885AbWEAFaq@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


At shutdown, we switch all arrays to read-only, which creates
a message for every instantiated array, even those which aren't
actually active.

So remove the message for non-active arrays.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-05-01 15:10:18.000000000 +1000
+++ ./drivers/md/md.c	2006-05-01 15:10:18.000000000 +1000
@@ -2898,7 +2898,7 @@ static int do_md_stop(mddev_t * mddev, i
 		if (disk)
 			set_capacity(disk, 0);
 		mddev->changed = 1;
-	} else
+	} else if (mddev->pers)
 		printk(KERN_INFO "md: %s switched to read-only mode.\n",
 			mdname(mddev));
 	err = 0;
