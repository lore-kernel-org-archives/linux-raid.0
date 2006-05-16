From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 3] md: Fix inverted test for 'repair' directive.
Date: Tue, 16 May 2006 11:13:07 +1000
Message-ID: <1060516011307.2723@suse.de>
References: <20060516111036.2649.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750961AbWEPBNx@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


We should be able to write 'repair' to /sys/block/mdX/md/sync_action,
however due to and inverted test, that always given EINVAL.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-05-16 11:09:25.000000000 +1000
+++ ./drivers/md/md.c	2006-05-16 11:09:41.000000000 +1000
@@ -2318,7 +2318,7 @@ action_store(mddev_t *mddev, const char 
 	} else {
 		if (cmd_match(page, "check"))
 			set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
-		else if (cmd_match(page, "repair"))
+		else if (!cmd_match(page, "repair"))
 			return -EINVAL;
 		set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
 		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
