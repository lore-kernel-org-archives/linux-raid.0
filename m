From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] fix: imsm: mdmon should reread component_size on wakeup
Date: Mon, 17 Sep 2012 10:37:55 +0200
Message-ID: <20120917083755.26592.53269.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

Mdmon has not read component_size (in read_and_act()) on wakeup so far.
In case of size's expansion component_size has been changed but
mdmon has not updated it. As a result the metadata was incorrect
during the size's expansion. It has contained no information
that resync was in progress (there has been no checkpoint too).
The metadata has been as if resync has already been finished
but it has not.

Updating of component_size has been added to read_and_act().
Now mdmon uses the correct value of component_size and the correct
metadata (containing information about resync and checkpoint) is written.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 managemon.c |    6 +++++-
 mdmon.h     |    1 +
 monitor.c   |   12 ++++++++++++
 3 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/managemon.c b/managemon.c
index ef351b3..fd41463 100644
--- a/managemon.c
+++ b/managemon.c
@@ -123,6 +123,8 @@ static void close_aa(struct active_array *aa)
 		close(aa->info.state_fd);
 	if (aa->resync_start_fd >= 0)
 		close(aa->resync_start_fd);
+	if (aa->component_size_fd >= 0)
+		close(aa->component_size_fd);
 	if (aa->metadata_fd >= 0)
 		close(aa->metadata_fd);
 	if (aa->sync_completed_fd >= 0)
@@ -598,7 +600,8 @@ static int aa_ready(struct active_array *aa)
 	if (aa->info.state_fd < 0)
 		return 0;
 
-	if (level > 0 && (aa->action_fd < 0 || aa->resync_start_fd < 0))
+	if (level > 0 && (aa->action_fd < 0 || aa->resync_start_fd < 0 \
+					    || aa->component_size_fd < 0))
 		return 0;
 
 	if (!aa->container)
@@ -676,6 +679,7 @@ static void manage_new(struct mdstat_ent *mdstat,
 	new->action_fd = sysfs_open(new->devnum, NULL, "sync_action");
 	new->info.state_fd = sysfs_open(new->devnum, NULL, "array_state");
 	new->resync_start_fd = sysfs_open(new->devnum, NULL, "resync_start");
+	new->component_size_fd = sysfs_open(new->devnum, NULL, "component_size");
 	new->metadata_fd = sysfs_open(new->devnum, NULL, "metadata_version");
 	new->sync_completed_fd = sysfs_open(new->devnum, NULL, "sync_completed");
 	dprintf("%s: inst: %d action: %d state: %d\n", __func__, atoi(inst),
diff --git a/mdmon.h b/mdmon.h
index 59e1b53..0b82598 100644
--- a/mdmon.h
+++ b/mdmon.h
@@ -32,6 +32,7 @@ struct active_array {
 
 	int action_fd;
 	int resync_start_fd;
+	int component_size_fd; /* in case of change of array's size */
 	int metadata_fd; /* for monitoring rw/ro status */
 	int sync_completed_fd; /* for checkpoint notification events */
 	unsigned long long last_checkpoint; /* sync_completed fires for many
diff --git a/monitor.c b/monitor.c
index c987d10..aa58384 100644
--- a/monitor.c
+++ b/monitor.c
@@ -80,6 +80,17 @@ static unsigned long long read_resync_start(int fd)
 		return strtoull(buf, NULL, 10);
 }
 
+static unsigned long long read_component_size(int fd)
+{
+	char buf[30];
+	int n;
+
+	n = read_attr(buf, 30, fd);
+	if (n <= 0)
+		return 0;
+	return strtoull(buf, NULL, 10);
+}
+
 static unsigned long long read_sync_completed(int fd)
 {
 	unsigned long long val;
@@ -229,6 +240,7 @@ static int read_and_act(struct active_array *a)
 	a->curr_state = read_state(a->info.state_fd);
 	a->curr_action = read_action(a->action_fd);
 	a->info.resync_start = read_resync_start(a->resync_start_fd);
+	a->info.component_size = read_component_size(a->component_size_fd) << 1;
 	sync_completed = read_sync_completed(a->sync_completed_fd);
 	for (mdi = a->info.devs; mdi ; mdi = mdi->next) {
 		mdi->next_state = 0;

