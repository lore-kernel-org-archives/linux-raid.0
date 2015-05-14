From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 4/7] Assemble array with writecache
Date: Wed, 13 May 2015 23:43:53 -0700
Message-ID: <1431585836-4103033-5-git-send-email-songliubraving@fb.com>
References: <1431585836-4103033-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1431585836-4103033-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, dan.j.williams@intel.com, neilb@suse.de, hch@infradead.org, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Example output:

./mdadm --assemble /dev/md0 /dev/sd[c-f] /dev/sdb1
mdadm: /dev/md0 has been started with 4 drives and 1 cache.

mdadm checks superblock for cache devices. If the
array appears to have a cache device, but it is not given,
it will complain as

./mdadm --assemble /dev/md0 /dev/sd[c-f]
mdadm: Not safe to assemble with cache device missing, consider --force.

This can be overwritten with --force

./mdadm --assemble /dev/md0 /dev/sd[c-f] --force
mdadm: Force start with missing cache device...
mdadm: /dev/md0 has been started with 4 drives.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Assemble.c | 52 ++++++++++++++++++++++++++++++++++++++++++----------
 mdadm.h    |  2 ++
 super1.c   | 22 ++++++++++++++++++++++
 util.c     |  3 ++-
 4 files changed, 68 insertions(+), 11 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 25a103d..ccf142e 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -718,7 +718,8 @@ static int load_devices(struct devs *devices, char *devmap,
 			i = devcnt;
 		else
 			i = devices[devcnt].i.disk.raid_disk;
-		if (i+1 == 0) {
+
+		if (i+1 == 0 || i == 0xfffd) {
 			if (nextspare < content->array.raid_disks*2)
 				nextspare = content->array.raid_disks*2;
 			i = nextspare++;
@@ -772,8 +773,9 @@ static int load_devices(struct devs *devices, char *devmap,
 			}
 			if (best[i] == -1
 			    || (devices[best[i]].i.events
-				< devices[devcnt].i.events))
+				< devices[devcnt].i.events)) {
 				best[i] = devcnt;
+			}
 		}
 		devcnt++;
 	}
@@ -927,6 +929,7 @@ static int start_array(int mdfd,
 		       unsigned int okcnt,
 		       unsigned int sparecnt,
 		       unsigned int rebuilding_cnt,
+		       unsigned int cachecnt,
 		       struct context *c,
 		       int clean, char *avail,
 		       int start_partial_ok,
@@ -938,6 +941,22 @@ static int start_array(int mdfd,
 	int i;
 	unsigned int req_cnt;
 
+	if (st->ss->require_cache) {
+		rv = st->ss->require_cache(st);
+		if (rv == 2) {
+			pr_err("BUG: Superblock not loaded in Assemble.c:start_array\n");
+			return 1;
+		}
+
+		if (cachecnt == 0 && rv == 1) {
+			if (!(c->force)) {
+				pr_err("Not safe to assemble with cache device missing, consider --force.\n");
+				return 1;
+			} else
+				pr_err("Force start with missing cache device...\n");
+		}
+	}
+
 	rv = set_array_info(mdfd, st, content);
 	if (rv && !err_ok) {
 		pr_err("failed to set array info for %s: %s\n",
@@ -1015,7 +1034,8 @@ static int start_array(int mdfd,
 	if (content->array.level == LEVEL_CONTAINER) {
 		if (c->verbose >= 0) {
 			pr_err("Container %s has been assembled with %d drive%s",
-			       mddev, okcnt+sparecnt, okcnt+sparecnt==1?"":"s");
+			       mddev, okcnt+sparecnt+cachecnt,
+			       okcnt+sparecnt+cachecnt==1?"":"s");
 			if (okcnt < (unsigned)content->array.raid_disks)
 				fprintf(stderr, " (out of %d)",
 					content->array.raid_disks);
@@ -1101,6 +1121,8 @@ static int start_array(int mdfd,
 					fprintf(stderr, "%s %d rebuilding", sparecnt?",":" and", rebuilding_cnt);
 				if (sparecnt)
 					fprintf(stderr, " and %d spare%s", sparecnt, sparecnt==1?"":"s");
+				if (cachecnt == 1)
+					fprintf(stderr, " and 1 cache");
 				fprintf(stderr, ".\n");
 			}
 			if (content->reshape_active &&
@@ -1268,7 +1290,7 @@ int Assemble(struct supertype *st, char *mddev,
 	int *best = NULL; /* indexed by raid_disk */
 	int bestcnt = 0;
 	int devcnt;
-	unsigned int okcnt, sparecnt, rebuilding_cnt, replcnt;
+	unsigned int okcnt, sparecnt, rebuilding_cnt, replcnt, cachecnt;
 	int i;
 	int was_forced = 0;
 	int most_recent = 0;
@@ -1479,6 +1501,7 @@ try_again:
 	devcnt = load_devices(devices, devmap, ident, &st, devlist,
 			      c, content, mdfd, mddev,
 			      &most_recent, &bestcnt, &best, inargv);
+
 	if (devcnt < 0)
 		return 1;
 
@@ -1506,7 +1529,9 @@ try_again:
 	okcnt = 0;
 	replcnt = 0;
 	sparecnt=0;
+	cachecnt=0;
 	rebuilding_cnt=0;
+
 	for (i=0; i< bestcnt; i++) {
 		int j = best[i];
 		int event_margin = 1; /* always allow a difference of '1'
@@ -1516,8 +1541,10 @@ try_again:
 		/* note: we ignore error flags in multipath arrays
 		 * as they don't make sense
 		 */
-		if (content->array.level != LEVEL_MULTIPATH)
-			if (!(devices[j].i.disk.state & (1<<MD_DISK_ACTIVE))) {
+		if (content->array.level != LEVEL_MULTIPATH) {
+			if (devices[j].i.disk.state & (1<<MD_DISK_WRITECACHE)) {
+				cachecnt++;
+			} else if (!(devices[j].i.disk.state & (1<<MD_DISK_ACTIVE))) {
 				if (!(devices[j].i.disk.state
 				      & (1<<MD_DISK_FAULTY))) {
 					devices[j].uptodate = 1;
@@ -1525,6 +1552,7 @@ try_again:
 				}
 				continue;
 			}
+		}
 		/* If this device thinks that 'most_recent' has failed, then
 		 * we must reject this device.
 		 */
@@ -1559,10 +1587,11 @@ try_again:
 						replcnt++;
 				} else
 					rebuilding_cnt++;
-			} else
+			} else if (devices[j].i.disk.raid_disk != 0xfffd)
 				sparecnt++;
 		}
 	}
+
 	free(devmap);
 	if (c->force) {
 		int force_ok = force_array(content, devices, best, bestcnt,
@@ -1583,8 +1612,9 @@ try_again:
 		int j = best[i];
 		int fd;
 
-		if (j<0)
+		if (j<0) {
 			continue;
+		}
 		if (!devices[j].uptodate)
 			continue;
 		if (devices[j].i.events < devices[most_recent].i.events)
@@ -1623,7 +1653,9 @@ try_again:
 		int j = best[i];
 		unsigned int desired_state;
 
-		if (i >= content->array.raid_disks * 2)
+		if (devices[j].i.disk.raid_disk == 0xfffd)
+			desired_state = (1<<MD_DISK_WRITECACHE);
+		else if (i >= content->array.raid_disks * 2)
 			desired_state = 0;
 		else if (i & 1)
 			desired_state = (1<<MD_DISK_ACTIVE) | (1<<MD_DISK_REPLACEMENT);
@@ -1770,7 +1802,7 @@ try_again:
 	rv = start_array(mdfd, mddev, content,
 			 st, ident, best, bestcnt,
 			 chosen_drive, devices, okcnt, sparecnt,
-			 rebuilding_cnt,
+			 rebuilding_cnt, cachecnt,
 			 c,
 			 clean, avail, start_partial_ok,
 			 pre_exist != NULL,
diff --git a/mdadm.h b/mdadm.h
index d7a205c..62a0293 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -971,6 +971,8 @@ extern struct superswitch {
 
 	/* write super block of raid5-cache*/
 	int (*write_r5l_super)(struct supertype *st, int fd);
+	/* whether the array require a cache device */
+	int (*require_cache)(struct supertype *st);
 	int swapuuid; /* true if uuid is bigending rather than hostendian */
 	int external;
 	const char *name; /* canonical metadata name */
diff --git a/super1.c b/super1.c
index f2697a8..c345a40 100644
--- a/super1.c
+++ b/super1.c
@@ -135,6 +135,27 @@ struct misc_dev_info {
 					)
 static int write_r5l_super1(struct supertype *st, int fd);
 
+/* return value:
+ *    0, cache not required
+ *    1, cache required
+ *    2, no superblock loated (st->sb == NULL)
+ */
+static int require_cache1(struct supertype *st)
+{
+	struct mdp_superblock_1 *sb = st->sb;
+	int i;
+	if (sb)
+		for (i=0; i<MAX_DEVS; i++) {
+			if (0xFFFD == sb->dev_roles[i])
+				return 1;
+		}
+	else
+		return 2;  /* no sb loaded */
+	return 0;
+}
+
+static int write_r5l_super1(struct supertype *st, int fd);
+
 static int role_from_sb(struct mdp_superblock_1 *sb)
 {
 	unsigned int d;
@@ -2556,6 +2577,7 @@ struct superswitch super1 = {
 	.write_bitmap = write_bitmap1,
 	.free_super = free_super1,
 	.write_r5l_super = write_r5l_super1,
+	.require_cache = require_cache1,
 #if __BYTE_ORDER == BIG_ENDIAN
 	.swapuuid = 0,
 #else
diff --git a/util.c b/util.c
index cc98d3b..f314748 100644
--- a/util.c
+++ b/util.c
@@ -334,8 +334,9 @@ int enough(int level, int raid_disks, int layout, int clean, char *avail)
 	int i;
 	int avail_disks = 0;
 
-	for (i = 0; i < raid_disks; i++)
+	for (i = 0; i < raid_disks; i++) {
 		avail_disks += !!avail[i];
+	}
 
 	switch (level) {
 	case 10:
-- 
1.8.1

