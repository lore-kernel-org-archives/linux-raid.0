From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 5/7] Check write cache in incremental
Date: Wed, 13 May 2015 23:43:54 -0700
Message-ID: <1431585836-4103033-6-git-send-email-songliubraving@fb.com>
References: <1431585836-4103033-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1431585836-4103033-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, dan.j.williams@intel.com, neilb@suse.de, hch@infradead.org, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

If cache device is missing, do not start the array, and shows:

./mdadm -I /dev/sdf
mdadm: Cache device is missing, not safe to start yet.

The array will be started when the cache device is attached with -I

./mdadm -I /dev/sdb1
mdadm: /dev/sdb1 attached to /dev/md/0_0, which has been started.

To force start without cache device:

./mdadm -I /dev/sdf --run
mdadm: Trying to run with missing cache device
mdadm: /dev/sdf attached to /dev/md/0_0, which has been started.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Incremental.c | 37 +++++++++++++++++++++++++++++++++----
 super1.c      |  2 ++
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 0c9a9a4..500fd9e 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -35,7 +35,7 @@
 
 static int count_active(struct supertype *st, struct mdinfo *sra,
 			int mdfd, char **availp,
-			struct mdinfo *info);
+			struct mdinfo *info, int *cache_device_missing);
 static void find_reject(int mdfd, struct supertype *st, struct mdinfo *sra,
 			int number, __u64 events, int verbose,
 			char *array_name);
@@ -104,6 +104,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 	struct map_ent target_array;
 	int have_target;
 	char *devname = devlist->devname;
+	int cache_device_missing = 0;
 
 	struct createinfo *ci = conf_get_create_info();
 
@@ -216,6 +217,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 		free(st);
 		goto out;
 	}
+
 	close (dfd); dfd = -1;
 
 	st->ss->getinfo_super(st, &info, NULL);
@@ -470,6 +472,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 			info.array.working_disks ++;
 
 	}
+
 	if (strncmp(chosen_name, "/dev/md/", 8) == 0)
 		md_devname = chosen_name+8;
 	else
@@ -511,10 +514,13 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 	 * state.  Eventually this state should be kept up-to-date as
 	 * things change.
 	 */
+
 	sysfs_free(sra);
 	sra = sysfs_read(mdfd, NULL, (GET_DEVS | GET_STATE |
 				    GET_OFFSET | GET_SIZE));
-	active_disks = count_active(st, sra, mdfd, &avail, &info);
+
+	active_disks = count_active(st, sra, mdfd, &avail, &info, &cache_device_missing);
+
 	if (enough(info.array.level, info.array.raid_disks,
 		   info.array.layout, info.array.state & 1,
 		   avail) == 0) {
@@ -544,10 +550,13 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 	}
 
 	map_unlock(&map);
-	if (c->runstop > 0 || active_disks >= info.array.working_disks) {
+	if (c->runstop > 0 || (!cache_device_missing && active_disks >= info.array.working_disks)) {
 		struct mdinfo *dsk;
 		/* Let's try to start it */
 
+		if (cache_device_missing)
+			pr_err("Trying to run with missing cache device\n");
+
 		if (info.reshape_active && !(info.reshape_active & RESHAPE_NO_BACKUP)) {
 			pr_err("%s: This array is being reshaped and cannot be started\n",
 			       chosen_name);
@@ -614,6 +623,8 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 	} else {
 		if (c->export) {
 			printf("MD_STARTED=unsafe\n");
+		} else if (cache_device_missing) {
+			pr_err("Cache device is missing, not safe to start yet.\n");
 		} else if (c->verbose >= 0)
 			pr_err("%s attached to %s, not enough to start safely.\n",
 			       devname, chosen_name);
@@ -680,7 +691,8 @@ static void find_reject(int mdfd, struct supertype *st, struct mdinfo *sra,
 
 static int count_active(struct supertype *st, struct mdinfo *sra,
 			int mdfd, char **availp,
-			struct mdinfo *bestinfo)
+			struct mdinfo *bestinfo,
+			int *cache_device_missing)
 {
 	/* count how many devices in sra think they are active */
 	struct mdinfo *d;
@@ -694,6 +706,8 @@ static int count_active(struct supertype *st, struct mdinfo *sra,
 	int devnum;
 	int b, i;
 	int raid_disks = 0;
+	int require_cache_dev = 0;
+	int has_cache_dev = 0;
 
 	if (!sra)
 		return 0;
@@ -714,8 +728,19 @@ static int count_active(struct supertype *st, struct mdinfo *sra,
 		close(dfd);
 		if (ok != 0)
 			continue;
+
+		if (st->ss->require_cache) {
+			require_cache_dev = st->ss->require_cache(st);
+			if (require_cache_dev == 2) {
+				pr_err("BUG: Superblock not loaded in Incremental.c:count_active\n");
+				return 0;
+			}
+		}
+
 		info.array.raid_disks = raid_disks;
 		st->ss->getinfo_super(st, &info, devmap + raid_disks * devnum);
+		if (info.disk.raid_disk == 0xFFFD)
+			has_cache_dev = 1;
 		if (!avail) {
 			raid_disks = info.array.raid_disks;
 			avail = xcalloc(raid_disks, 1);
@@ -765,6 +790,10 @@ static int count_active(struct supertype *st, struct mdinfo *sra,
 			replcnt++;
 		st->ss->free_super(st);
 	}
+
+	if (require_cache_dev && !has_cache_dev)
+		*cache_device_missing = 1;
+
 	if (!avail)
 		return 0;
 	/* We need to reject any device that thinks the best device is
diff --git a/super1.c b/super1.c
index c345a40..e229efe 100644
--- a/super1.c
+++ b/super1.c
@@ -144,6 +144,7 @@ static int require_cache1(struct supertype *st)
 {
 	struct mdp_superblock_1 *sb = st->sb;
 	int i;
+
 	if (sb)
 		for (i=0; i<MAX_DEVS; i++) {
 			if (0xFFFD == sb->dev_roles[i])
@@ -151,6 +152,7 @@ static int require_cache1(struct supertype *st)
 		}
 	else
 		return 2;  /* no sb loaded */
+
 	return 0;
 }
 
-- 
1.8.1

