From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 5] md: 'sync_action' in sysfs returns wrong value for readonly arrays
Date: Mon, 15 Oct 2007 14:34:31 +1000
Message-ID: <1071015043431.5463@suse.de>
References: <20071015143136.5200.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


When an array is started read-only, MD_RECOVERY_NEEDED can be set but
no recovery will be running.  This causes 'sync_action' to report the
wrong value.

We could remove the test for MD_RECOVERY_NEEDED, but doing so would
leave a small gap after requesting a sync action, where 'sync_action'
would still report the old value.

So make sure that for a read-only array, 'sync_action' always returns 'idle'.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-10-15 14:06:32.000000000 +1000
+++ ./drivers/md/md.c	2007-10-15 14:06:32.000000000 +1000
@@ -2714,7 +2714,7 @@ action_show(mddev_t *mddev, char *page)
 {
 	char *type = "idle";
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
-	    test_bit(MD_RECOVERY_NEEDED, &mddev->recovery)) {
+	    (!mddev->ro && test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))) {
 		if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 			type = "reshape";
 		else if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
