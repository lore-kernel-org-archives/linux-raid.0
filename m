From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 004 of 20] Helper function to match commands written to sysfs files.
Date: Mon, 12 Dec 2005 14:13:35 +1100
Message-ID: <1051212031335.4946@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Commands written to sysfs files may, or my not, be \n terminated.
We want to accept with case. For this we use cmd_match.
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-12 10:45:16.000000000 +1100
+++ ./drivers/md/md.c	2005-12-12 10:45:30.000000000 +1100
@@ -1525,6 +1525,26 @@ repeat:
 
 }
 
+/* words written to sysfs files may, or my not, be \n terminated.
+ * We want to accept with case. For this we use cmd_match.
+ */
+static int cmd_match(const char *cmd, const char *str)
+{
+	/* See if cmd, written into a sysfs file, matches
+	 * str.  They must either be the same, or cmd can
+	 * have a trailing newline
+	 */
+	while (*cmd && *str && *cmd == *str) {
+		cmd++;
+		str++;
+	}
+	if (*cmd == '\n')
+		cmd++;
+	if (*str || *cmd)
+		return 0;
+	return 1;
+}
+
 struct rdev_sysfs_entry {
 	struct attribute attr;
 	ssize_t (*show)(mdk_rdev_t *, char *);
@@ -1799,7 +1819,7 @@ action_store(mddev_t *mddev, const char 
 	if (!mddev->pers || !mddev->pers->sync_request)
 		return -EINVAL;
 
-	if (strcmp(page, "idle")==0 || strcmp(page, "idle\n")==0) {
+	if (cmd_match(page, "idle")) {
 		if (mddev->sync_thread) {
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			md_unregister_thread(mddev->sync_thread);
@@ -1812,13 +1832,12 @@ action_store(mddev_t *mddev, const char 
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
 	    test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
 		return -EBUSY;
-	if (strcmp(page, "resync")==0 || strcmp(page, "resync\n")==0 ||
-	    strcmp(page, "recover")==0 || strcmp(page, "recover\n")==0)
+	if (cmd_match(page, "resync") || cmd_match(page, "recover"))
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	else {
-		if (strcmp(page, "check")==0 || strcmp(page, "check\n")==0)
+		if (cmd_match(page, "check"))
 			set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
-		else if (strcmp(page, "repair")!=0 && strcmp(page, "repair\n")!=0)
+		else if (cmd_match(page, "repair"))
 			return -EINVAL;
 		set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
 		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
