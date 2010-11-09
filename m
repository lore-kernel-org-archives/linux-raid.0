From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 05/31] imsm: Add support for general migration
Date: Tue, 9 Nov 2010 17:00:50 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CA94@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Internal IMSM procedures need to support the General Migration.
It is used during operations like:
- Online Capacity Expansion,
- migration initialization,
- finishing migration,
- apply changes to raid disks etc.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/mdadm.h       |    2 +
 mdadm/mdadm/monitor.c     |   50 ------------------------------------
 mdadm/mdadm/super-intel.c |   62 ++++++++++++++++++++++++++++++++++++++++-----
 mdadm/mdadm/util.c        |   49 ++++++++++++++++++++++++++++++++++++
 4 files changed, 106 insertions(+), 57 deletions(-)

diff --git a/mdadm/mdadm/mdadm.h b/mdadm/mdadm/mdadm.h index fa800f9..74c7316 100644
--- a/mdadm/mdadm/mdadm.h
+++ b/mdadm/mdadm/mdadm.h
@@ -891,6 +891,8 @@ extern char *conf_word(FILE *file, int allow_key);  extern int conf_name_is_free(char *name);  extern int devname_matches(char *name, char *match);  extern struct mddev_ident_s *conf_match(struct mdinfo *info, struct supertype *st);
+extern int read_attr(char *buf, int len, int fd); extern int 
+read_dev_state(int fd);
 
 extern void free_line(char *line);
 extern int match_oneof(char *devices, char *devname); diff --git a/mdadm/mdadm/monitor.c b/mdadm/mdadm/monitor.c index 46c044e..313c8af 100644
--- a/mdadm/mdadm/monitor.c
+++ b/mdadm/mdadm/monitor.c
@@ -45,27 +45,6 @@ static void add_fd(fd_set *fds, int *maxfd, int fd)
 	FD_SET(fd, fds);
 }
 
-static int read_attr(char *buf, int len, int fd) -{
-	int n;
-
-	if (fd < 0) {
-		buf[0] = 0;
-		return 0;
-	}
-	lseek(fd, 0, 0);
-	n = read(fd, buf, len - 1);
-
-	if (n <= 0) {
-		buf[0] = 0;
-		return 0;
-	}
-	buf[n] = 0;
-	if (buf[n-1] == '\n')
-		buf[n-1] = 0;
-	return n;
-}
-
 static unsigned long long read_resync_start(int fd)  {
 	char buf[30];
@@ -118,35 +97,6 @@ static enum sync_action read_action( int fd)
 	return (enum sync_action) sysfs_match_word(buf, sync_actions);  }
 
-int read_dev_state(int fd)
-{
-	char buf[60];
-	int n = read_attr(buf, 60, fd);
-	char *cp;
-	int rv = 0;
-
-	if (n <= 0)
-		return 0;
-
-	cp = buf;
-	while (cp) {
-		if (sysfs_attr_match(cp, "faulty"))
-			rv |= DS_FAULTY;
-		if (sysfs_attr_match(cp, "in_sync"))
-			rv |= DS_INSYNC;
-		if (sysfs_attr_match(cp, "write_mostly"))
-			rv |= DS_WRITE_MOSTLY;
-		if (sysfs_attr_match(cp, "spare"))
-			rv |= DS_SPARE;
-		if (sysfs_attr_match(cp, "blocked"))
-			rv |= DS_BLOCKED;
-		cp = strchr(cp, ',');
-		if (cp)
-			cp++;
-	}
-	return rv;
-}
-
 static void signal_manager(void)
 {
 	/* tgkill(getpid(), mon_tid, SIGUSR1); */ diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c index 279eef2..d50c04a 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -2149,7 +2149,8 @@ static void migrate(struct imsm_dev *dev, __u8 to_state, int migr_type)
 
 	/* duplicate and then set the target end state in map[0] */
 	memcpy(dest, src, sizeof_imsm_map(src));
-	if (migr_type == MIGR_REBUILD) {
+	if ((migr_type == MIGR_REBUILD) ||
+	    (migr_type ==  MIGR_GEN_MIGR)) {
 		__u32 ord;
 		int i;
 
@@ -2166,18 +2167,26 @@ static void end_migration(struct imsm_dev *dev, __u8 map_state)  {
 	struct imsm_map *map = get_imsm_map(dev, 0);
 	struct imsm_map *prev = get_imsm_map(dev, dev->vol.migr_state);
-	int i;
+	int i, j;
 
 	/* merge any IMSM_ORD_REBUILD bits that were not successfully
 	 * completed in the last migration.
 	 *
-	 * FIXME add support for online capacity expansion and
-	 * raid-level-migration
+	 * FIXME add support for raid-level-migration
 	 */
 	for (i = 0; i < prev->num_members; i++)
-		map->disk_ord_tbl[i] |= prev->disk_ord_tbl[i];
+		for (j = 0; j < map->num_members; j++)
+			/* during online capacity expansion
+			 * disks position can be changed if takeover is used
+			 */
+			if (ord_to_idx(map->disk_ord_tbl[j]) ==
+			    ord_to_idx(prev->disk_ord_tbl[i])) {
+				map->disk_ord_tbl[j] |= prev->disk_ord_tbl[i];
+				break;
+			}
 
 	dev->vol.migr_state = 0;
+	dev->vol.migr_type = 0;
 	dev->vol.curr_migr_unit = 0;
 	map->map_state = map_state;
 }
@@ -4317,6 +4326,17 @@ static int update_subarray_imsm(struct supertype *st, char *update, mddev_ident_  }  #endif /* MDASSEMBLE */
 
+static int is_gen_migration(struct imsm_dev *dev) {
+	if (!dev->vol.migr_state)
+		return 0;
+
+	if (migr_type(dev) == MIGR_GEN_MIGR)
+		return 1;
+
+	return 0;
+}
+
 static int is_rebuilding(struct imsm_dev *dev)  {
 	struct imsm_map *migr_map;
@@ -4398,8 +4418,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
 		 * unsupported migration
 		 */
 		if (dev->vol.migr_state &&
-		    (migr_type(dev) == MIGR_GEN_MIGR ||
-		     migr_type(dev) == MIGR_STATE_CHANGE)) {
+		    (migr_type(dev) == MIGR_STATE_CHANGE)) {
 			fprintf(stderr, Name ": cannot assemble volume '%.16s':"
 				" unsupported migration in progress\n",
 				dev->volume);
@@ -4682,6 +4701,8 @@ static void handle_missing(struct intel_super *super, struct imsm_dev *dev)
 	super->updates_pending++;
 }
 
+static void imsm_set_disk(struct active_array *a, int n, int state);
+
 /* Handle dirty -> clean transititions and resync.  Degraded and rebuild
  * states are handled in imsm_set_disk() with one exception, when a
  * resync is stopped due to a new failure this routine will set the @@ -4757,6 +4778,16 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 			dev->vol.dirty = 1;
 		super->updates_pending++;
 	}
+
+	/* finalize online capacity expansion/reshape */
+	if ((a->curr_action != reshape) &&
+	    (a->prev_action == reshape)) {
+		struct mdinfo *mdi;
+
+		for (mdi = a->info.devs; mdi; mdi = mdi->next)
+			imsm_set_disk(a, mdi->disk.raid_disk, mdi->curr_state);
+	}
+
 	return consistent;
 }
 
@@ -4820,6 +4851,23 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 		end_migration(dev, map_state);
 		super->updates_pending++;
 		a->last_checkpoint = 0;
+	} else if (is_gen_migration(dev)) {
+		dprintf("imsm: Detected General Migration in state: ");
+		if (map_state == IMSM_T_STATE_NORMAL) {
+			end_migration(dev, map_state);
+			map = get_imsm_map(dev, 0);
+			map->failed_disk_num = ~0;
+			dprintf("normal\n");
+		} else {
+			if (map_state == IMSM_T_STATE_DEGRADED) {
+				printf("degraded\n");
+				end_migration(dev, map_state);
+			} else {
+				dprintf("failed\n");
+			}
+			map->map_state = map_state;
+		}
+		super->updates_pending++;
 	}
 }
 
diff --git a/mdadm/mdadm/util.c b/mdadm/mdadm/util.c index 5023f42..591dce1 100644
--- a/mdadm/mdadm/util.c
+++ b/mdadm/mdadm/util.c
@@ -1857,3 +1857,52 @@ void append_metadata_update(struct supertype *st, void *buf, int len)  unsigned int __invalid_size_argument_for_IOC = 0;  #endif
 
+int read_attr(char *buf, int len, int fd) {
+	int n;
+
+	if (fd < 0) {
+		buf[0] = 0;
+		return 0;
+	}
+	lseek(fd, 0, 0);
+	n = read(fd, buf, len - 1);
+
+	if (n <= 0) {
+		buf[0] = 0;
+		return 0;
+	}
+	buf[n] = 0;
+	if (buf[n-1] == '\n')
+		buf[n-1] = 0;
+	return n;
+}
+
+int read_dev_state(int fd)
+{
+	char buf[60];
+	int n = read_attr(buf, 60, fd);
+	char *cp;
+	int rv = 0;
+
+	if (n <= 0)
+		return 0;
+
+	cp = buf;
+	while (cp) {
+		if (sysfs_attr_match(cp, "faulty"))
+			rv |= DS_FAULTY;
+		if (sysfs_attr_match(cp, "in_sync"))
+			rv |= DS_INSYNC;
+		if (sysfs_attr_match(cp, "write_mostly"))
+			rv |= DS_WRITE_MOSTLY;
+		if (sysfs_attr_match(cp, "spare"))
+			rv |= DS_SPARE;
+		if (sysfs_attr_match(cp, "blocked"))
+			rv |= DS_BLOCKED;
+		cp = strchr(cp, ',');
+		if (cp)
+			cp++;
+	}
+	return rv;
+}

