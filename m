From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 08/13] mdmon: cleanup resync_start
Date: Tue, 22 Dec 2009 17:00:00 -0700
Message-ID: <20091223000000.31628.20014.stgit@dwillia2-linux.ch.intel.com>
References: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

We don't need to sprinkle reads of this attribute all over the place,
just once at the entry of read_and_act().  Also, the mdinfo structure
for the array already has a 'resync_start' member, so just reuse that.
Finally, rename get_resync_start() to read_resync_start to make it
consistent with the other sysfs accessors in monitor.c.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 managemon.c   |    1 -
 mdmon.h       |    7 ++-----
 monitor.c     |   19 ++++++-------------
 super-ddf.c   |    8 ++++----
 super-intel.c |    9 ++++-----
 5 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/managemon.c b/managemon.c
index 19effe4..e77f045 100644
--- a/managemon.c
+++ b/managemon.c
@@ -541,7 +541,6 @@ static void manage_new(struct mdstat_ent *mdstat,
 	new->info.state_fd = sysfs_open(new->devnum, NULL, "array_state");
 	new->resync_start_fd = sysfs_open(new->devnum, NULL, "resync_start");
 	new->metadata_fd = sysfs_open(new->devnum, NULL, "metadata_version");
-	get_resync_start(new);
 	dprintf("%s: inst: %d action: %d state: %d\n", __func__, atoi(inst),
 		new->action_fd, new->info.state_fd);
 
diff --git a/mdmon.h b/mdmon.h
index 7cfee35..4494085 100644
--- a/mdmon.h
+++ b/mdmon.h
@@ -39,8 +39,6 @@ struct active_array {
 	int check_degraded; /* flag set by mon, read by manage */
 
 	int devnum;
-
-	unsigned long long resync_start;
 };
 
 /*
@@ -73,7 +71,6 @@ extern int socket_hup_requested;
 extern int sigterm;
 
 int read_dev_state(int fd);
-int get_resync_start(struct active_array *a);
 int is_container_member(struct mdstat_ent *mdstat, char *container);
 
 struct mdstat_ent *mdstat_read(int hold, int start);
@@ -85,9 +82,9 @@ extern int monitor_loop_cnt;
 /* helper routine to determine resync completion since MaxSector is a
  * moving target
  */
-static inline int is_resync_complete(struct active_array *a)
+static inline int is_resync_complete(struct mdinfo *array)
 {
-	if (a->resync_start >= a->info.component_size)
+	if (array->resync_start >= array->component_size)
 		return 1;
 	return 0;
 }
diff --git a/monitor.c b/monitor.c
index 0cafc3a..a8e0af3 100644
--- a/monitor.c
+++ b/monitor.c
@@ -66,23 +66,20 @@ static int read_attr(char *buf, int len, int fd)
 	return n;
 }
 
-int get_resync_start(struct active_array *a)
+static unsigned long long read_resync_start(int fd)
 {
 	char buf[30];
 	int n;
 
-	n = read_attr(buf, 30, a->resync_start_fd);
+	n = read_attr(buf, 30, fd);
 	if (n <= 0)
-		return n;
+		return 0;
 	if (strncmp(buf, "none", 4) == 0)
-		a->resync_start = ~0ULL;
+		return ~0ULL;
 	else
-		a->resync_start = strtoull(buf, NULL, 10);
-
-	return 1;
+		return strtoull(buf, NULL, 10);
 }
 
-
 static enum array_state read_state(int fd)
 {
 	char buf[20];
@@ -208,6 +205,7 @@ static int read_and_act(struct active_array *a)
 
 	a->curr_state = read_state(a->info.state_fd);
 	a->curr_action = read_action(a->action_fd);
+	a->info.resync_start = read_resync_start(a->resync_start_fd);
 	for (mdi = a->info.devs; mdi ; mdi = mdi->next) {
 		mdi->next_state = 0;
 		if (mdi->state_fd >= 0)
@@ -217,13 +215,11 @@ static int read_and_act(struct active_array *a)
 	if (a->curr_state <= inactive &&
 	    a->prev_state > inactive) {
 		/* array has been stopped */
-		get_resync_start(a);
 		a->container->ss->set_array_state(a, 1);
 		a->next_state = clear;
 		deactivate = 1;
 	}
 	if (a->curr_state == write_pending) {
-		get_resync_start(a);
 		a->container->ss->set_array_state(a, 0);
 		a->next_state = active;
 		dirty = 1;
@@ -236,7 +232,6 @@ static int read_and_act(struct active_array *a)
 		dirty = 1;
 	}
 	if (a->curr_state == clean) {
-		get_resync_start(a);
 		a->container->ss->set_array_state(a, 1);
 	}
 	if (a->curr_state == active ||
@@ -253,7 +248,6 @@ static int read_and_act(struct active_array *a)
 			/* explicit request for readonly array.  Leave it alone */
 			;
 		} else {
-			get_resync_start(a);
 			if (a->container->ss->set_array_state(a, 2))
 				a->next_state = read_auto; /* array is clean */
 			else {
@@ -271,7 +265,6 @@ static int read_and_act(struct active_array *a)
 		 * until the array goes inactive or readonly though.
 		 * Just check if we need to fiddle spares.
 		 */
-		get_resync_start(a);
 		a->container->ss->set_array_state(a, a->curr_state <= clean);
 		check_degraded = 1;
 	}
diff --git a/super-ddf.c b/super-ddf.c
index fe83642..f5eb816 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3066,7 +3066,7 @@ static int ddf_set_array_state(struct active_array *a, int consistent)
 	if (consistent == 2) {
 		/* Should check if a recovery should be started FIXME */
 		consistent = 1;
-		if (!is_resync_complete(a))
+		if (!is_resync_complete(&a->info))
 			consistent = 0;
 	}
 	if (consistent)
@@ -3078,9 +3078,9 @@ static int ddf_set_array_state(struct active_array *a, int consistent)
 
 	old = ddf->virt->entries[inst].init_state;
 	ddf->virt->entries[inst].init_state &= ~DDF_initstate_mask;
-	if (is_resync_complete(a))
+	if (is_resync_complete(&a->info))
 		ddf->virt->entries[inst].init_state |= DDF_init_full;
-	else if (a->resync_start == 0)
+	else if (a->info.resync_start == 0)
 		ddf->virt->entries[inst].init_state |= DDF_init_not;
 	else
 		ddf->virt->entries[inst].init_state |= DDF_init_quick;
@@ -3088,7 +3088,7 @@ static int ddf_set_array_state(struct active_array *a, int consistent)
 		ddf->updates_pending = 1;
 
 	dprintf("ddf mark %d %s %llu\n", inst, consistent?"clean":"dirty",
-		a->resync_start);
+		a->info.resync_start);
 	return consistent;
 }
 
diff --git a/super-intel.c b/super-intel.c
index ab8172d..4072fc8 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4108,12 +4108,12 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 	}
 		
 	if (consistent == 2 &&
-	    (!is_resync_complete(a) ||
+	    (!is_resync_complete(&a->info) ||
 	     map_state != IMSM_T_STATE_NORMAL ||
 	     dev->vol.migr_state))
 		consistent = 0;
 
-	if (is_resync_complete(a)) {
+	if (is_resync_complete(&a->info)) {
 		/* complete intialization / resync,
 		 * recovery and interrupted recovery is completed in
 		 * ->set_disk
@@ -4125,7 +4125,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 		}
 	} else if (!is_resyncing(dev) && !failed) {
 		/* mark the start of the init process if nothing is failed */
-		dprintf("imsm: mark resync start (%llu)\n", a->resync_start);
+		dprintf("imsm: mark resync start\n");
 		if (map->map_state == IMSM_T_STATE_UNINITIALIZED)
 			migrate(dev, IMSM_T_STATE_NORMAL, MIGR_INIT);
 		else
@@ -4137,8 +4137,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 
 	/* mark dirty / clean */
 	if (dev->vol.dirty != !consistent) {
-		dprintf("imsm: mark '%s' (%llu)\n",
-			consistent ? "clean" : "dirty", a->resync_start);
+		dprintf("imsm: mark '%s'\n", consistent ? "clean" : "dirty");
 		if (consistent)
 			dev->vol.dirty = 0;
 		else

