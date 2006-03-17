From: NeilBrown <neilb@suse.de>
Subject: [PATCH 012 of 13] md: Make 'reshape' a possible sync_action action.
Date: Fri, 17 Mar 2006 15:48:25 +1100
Message-ID: <1060317044825.16232@suse.de>
References: <20060317154017.15880.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752516AbWCQEvW@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


This allows reshape to be triggerred via sysfs (which is the
only way to start it happening).

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-03-17 11:48:59.000000000 +1100
+++ ./drivers/md/md.c	2006-03-17 11:48:59.000000000 +1100
@@ -2242,7 +2242,14 @@ action_store(mddev_t *mddev, const char 
 		return -EBUSY;
 	else if (cmd_match(page, "resync") || cmd_match(page, "recover"))
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	else {
+	else if (cmd_match(page, "reshape")) {
+		int err;
+		if (mddev->pers->start_reshape == NULL)
+			return -EINVAL;
+		err = mddev->pers->start_reshape(mddev);
+		if (err)
+			return err;
+	} else {
 		if (cmd_match(page, "check"))
 			set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 		else if (cmd_match(page, "repair"))
