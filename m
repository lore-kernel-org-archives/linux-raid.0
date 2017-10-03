From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] mdmon: get safe mode delay file descriptor early
Date: Tue,  3 Oct 2017 12:34:29 +0200
Message-ID: <1507026869-6415-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

After switch root new mdmon is started. It sends initrd mdmon a signal
to terminate. initrd mdmon receives it and switches the safe mode delay
to 1 ms in order to get array to clean state and flush last version of
metadata. The problem is sysfs filesystem is not available to initrd mdmon
after switch root so the original safe mode delay is unchanged. The delay
is set to few seconds - if there is a lot of traffic on the filesystem,
initrd mdmon doesn't terminate for a long time (no clean state). There
are 2 instances of mdmon. initrd mdmon flushes metadata when array goes
to clean state but this metadata might be already outdated.

Use file descriptor obtained on mdmon start to change safe mode delay.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 managemon.c | 15 ++++++++++++---
 mdmon.h     |  1 +
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/managemon.c b/managemon.c
index 222e9ad..1c80510 100644
--- a/managemon.c
+++ b/managemon.c
@@ -129,6 +129,8 @@ static void close_aa(struct active_array *aa)
 		close(aa->metadata_fd);
 	if (aa->sync_completed_fd >= 0)
 		close(aa->sync_completed_fd);
+	if (aa->safe_mode_delay_fd >= 0)
+		close(aa->safe_mode_delay_fd);
 }
 
 static void free_aa(struct active_array *aa)
@@ -532,9 +534,14 @@ static void manage_member(struct mdstat_ent *mdstat,
 	if (a->container == NULL)
 		return;
 
-	if (sigterm && a->info.safe_mode_delay != 1) {
-		sysfs_set_safemode(&a->info, 1);
-		a->info.safe_mode_delay = 1;
+	if (sigterm && a->info.safe_mode_delay != 1 &&
+	    a->safe_mode_delay_fd >= 0) {
+		long int new_delay = 1;
+		char delay[10];
+
+		snprintf(delay, sizeof(delay), "0.%03ld\n", new_delay);
+		if (write(a->safe_mode_delay_fd, delay, strlen(delay)))
+			a->info.safe_mode_delay = new_delay;
 	}
 
 	/* We don't check the array while any update is pending, as it
@@ -734,6 +741,8 @@ static void manage_new(struct mdstat_ent *mdstat,
 	new->resync_start_fd = sysfs_open2(new->info.sys_name, NULL, "resync_start");
 	new->metadata_fd = sysfs_open2(new->info.sys_name, NULL, "metadata_version");
 	new->sync_completed_fd = sysfs_open2(new->info.sys_name, NULL, "sync_completed");
+	new->safe_mode_delay_fd = sysfs_open2(new->info.sys_name, NULL,
+					      "safe_mode_delay");
 
 	dprintf("inst: %s action: %d state: %d\n", inst,
 		new->action_fd, new->info.state_fd);
diff --git a/mdmon.h b/mdmon.h
index 0b08c3d..818367c 100644
--- a/mdmon.h
+++ b/mdmon.h
@@ -35,6 +35,7 @@ struct active_array {
 	int resync_start_fd;
 	int metadata_fd; /* for monitoring rw/ro status */
 	int sync_completed_fd; /* for checkpoint notification events */
+	int safe_mode_delay_fd;
 	unsigned long long last_checkpoint; /* sync_completed fires for many
 					     * reasons this field makes sure the
 					     * kernel has made progress before
-- 
1.8.3.1

