From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 004 of 5] Allow a manual resync with md
Date: Tue, 4 Oct 2005 15:23:47 +1000
Message-ID: <1051004052347.28827@suse.de>
References: <20051004151922.28715.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


You can trigger a 'check' with
  echo check > /sys/block/mdX/md/scan_mode
or a check-and-repair errors with
  echo repair > /sys/block/mdX/md/scan_mode

and read the current state from the same file.

Note: personalities need to know the different between 'check' and 'repair',
but don't yet.  Until they do, 'check' will be the same as 'repair' and
will just do a normal resync pass.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c           |   77 ++++++++++++++++++++++++++++++++++++++------
 ./include/linux/raid/md_k.h |    4 ++
 2 files changed, 72 insertions(+), 9 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-10-04 12:25:36.000000000 +1000
+++ ./drivers/md/md.c	2005-10-04 14:19:35.000000000 +1000
@@ -1714,9 +1714,60 @@ static struct md_sysfs_entry md_raid_dis
 	.show = md_show_rdisks,
 };
 
+static ssize_t
+md_show_scan(mddev_t *mddev, char *page)
+{
+	char *type = "none";
+	if (mddev->recovery &
+	    ((1<<MD_RECOVERY_RUNNING) || (1<<MD_RECOVERY_NEEDED))) {
+		if (mddev->recovery & (1<<MD_RECOVERY_SYNC)) {
+			if (!test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+				type = "resync";
+			else if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
+				type = "check";
+			else
+				type = "repair";
+		} else
+			type = "recover";
+	}
+	return sprintf(page, "%s\n", type);
+}
+
+static ssize_t
+md_store_scan(mddev_t *mddev, const char *page, size_t len)
+{
+	int canscan=0;
+	if (mddev->recovery &
+	    ((1<<MD_RECOVERY_RUNNING) || (1<<MD_RECOVERY_NEEDED)))
+		return -EBUSY;
+	down(&mddev->reconfig_sem);
+	if (mddev->pers && mddev->pers->sync_request)
+		canscan=1;
+	up(&mddev->reconfig_sem);
+	if (!canscan)
+		return -EINVAL;
+
+	if (strcmp(page, "check")==0 || strcmp(page, "check\n")==0)
+		set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
+	else if (strcmp(page, "repair")!=0 && strcmp(page, "repair\n")!=0)
+		return -EINVAL;
+	set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
+	set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	md_wakeup_thread(mddev->thread);
+	return len;
+}
+
+static struct md_sysfs_entry md_scan_mode = {
+	.attr = {.name = "scan_mode", .mode = S_IRUGO|S_IWUSR },
+	.show = md_show_scan,
+	.store = md_store_scan,
+};
+
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
 	&md_raid_disks.attr,
+	&md_scan_mode.attr,
 	NULL,
 };
 
@@ -3851,7 +3902,8 @@ static void md_do_sync(mddev_t *mddev)
 
 	is_mddev_idle(mddev); /* this also initializes IO event counters */
 	/* we don't use the checkpoint if there's a bitmap */
-	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) && !mddev->bitmap)
+	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) && !mddev->bitmap
+	    && ! test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
 		j = mddev->recovery_cp;
 	else
 		j = 0;
@@ -4089,9 +4141,13 @@ void md_check_recovery(mddev_t *mddev)
 			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			goto unlock;
 		}
-		if (mddev->recovery)
-			/* probably just the RECOVERY_NEEDED flag */
-			mddev->recovery = 0;
+		/* Clear some bits that don't mean anything, but
+		 * might be left set
+		 */
+		clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		clear_bit(MD_RECOVERY_ERR, &mddev->recovery);
+		clear_bit(MD_RECOVERY_INTR, &mddev->recovery);
+		clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 
 		/* no recovery is running.
 		 * remove any failed drives, then
@@ -4125,14 +4181,17 @@ void md_check_recovery(mddev_t *mddev)
 				}
 		}
 
-		if (!spares && (mddev->recovery_cp == MaxSector )) {
-			/* nothing we can do ... */
+		if (spares) {
+			clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+			clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
+		} else if (mddev->recovery_cp < MaxSector) {
+			set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+		} else if (!test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
+			/* nothing to be done ... */
 			goto unlock;
-		}
+
 		if (mddev->pers->sync_request) {
 			set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
-			if (!spares)
-				set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 			if (spares && mddev->bitmap && ! mddev->bitmap->file) {
 				/* We are adding a device or devices to an array
 				 * which has the bitmap stored on all devices.

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-10-04 12:19:17.000000000 +1000
+++ ./include/linux/raid/md_k.h	2005-10-04 14:15:54.000000000 +1000
@@ -182,6 +182,8 @@ struct mddev_s
 	 * ERR:      and IO error was detected - abort the resync/recovery
 	 * INTR:     someone requested a (clean) early abort.
 	 * DONE:     thread is done and is waiting to be reaped
+	 * REQUEST:  user-space has requested a sync (used with SYNC)
+	 * CHECK:    user-space request for for check-only, no repair
 	 */
 #define	MD_RECOVERY_RUNNING	0
 #define	MD_RECOVERY_SYNC	1
@@ -189,6 +191,8 @@ struct mddev_s
 #define	MD_RECOVERY_INTR	3
 #define	MD_RECOVERY_DONE	4
 #define	MD_RECOVERY_NEEDED	5
+#define	MD_RECOVERY_REQUESTED	6
+#define	MD_RECOVERY_CHECK	7
 	unsigned long			recovery;
 
 	int				in_sync;	/* know to not need resync */
