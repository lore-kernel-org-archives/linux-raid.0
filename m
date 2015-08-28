From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 4/6] Assemble array with write journal
Date: Fri, 28 Aug 2015 16:27:04 -0700
Message-ID: <1440804426-1461372-5-git-send-email-songliubraving@fb.com>
References: <1440804426-1461372-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1440804426-1461372-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, dan.j.williams@intel.com, neilb@suse.de, hch@infradead.org, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Example output:

./mdadm --assemble /dev/md0 /dev/sd[c-f] /dev/sdb1
mdadm: /dev/md0 has been started with 4 drives and 1 journal.

mdadm checks superblock for journal devices. If the
array appears to have a journal device, but it is not given,
it will complain as

./mdadm --assemble /dev/md0 /dev/sd[c-f]
mdadm: Not safe to assemble with journal device missing, consider --force.

This can be overwritten with --force

./mdadm --assemble /dev/md0 /dev/sd[c-f] --force
mdadm: Force start with missing journal device...
mdadm: /dev/md0 has been started with 4 drives.

Signed-off-by: Shaohua Li <shli@fb.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Assemble.c | 42 ++++++++++++++++++++++++++++++++++--------
 mdadm.h    |  3 +++
 super1.c   | 38 +++++++++++++++++++++++++++++++++-----
 3 files changed, 70 insertions(+), 13 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index d9e9001..556a43b 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -735,7 +735,7 @@ static int load_devices(struct devs *devices, char *devmap,
 			i = devcnt;
 		else
 			i = devices[devcnt].i.disk.raid_disk;
-		if (i+1 == 0) {
+		if (i+1 == 0 || i == MD_DISK_ROLE_JOURNAL) {
 			if (nextspare < content->array.raid_disks*2)
 				nextspare = content->array.raid_disks*2;
 			i = nextspare++;
@@ -944,6 +944,7 @@ static int start_array(int mdfd,
 		       unsigned int okcnt,
 		       unsigned int sparecnt,
 		       unsigned int rebuilding_cnt,
+		       unsigned int journalcnt,
 		       struct context *c,
 		       int clean, char *avail,
 		       int start_partial_ok,
@@ -955,6 +956,22 @@ static int start_array(int mdfd,
 	int i;
 	unsigned int req_cnt;
 
+	if (st->ss->require_journal) {
+		rv = st->ss->require_journal(st);
+		if (rv == 2) {
+			pr_err("BUG: Superblock not loaded in Assemble.c:start_array\n");
+			return 1;
+		}
+
+		if (journalcnt == 0 && rv == 1) {
+			if (!(c->force)) {
+				pr_err("Not safe to assemble with journal device missing, consider --force.\n");
+				return 1;
+			} else
+				pr_err("Force start with missing journal device...\n");
+		}
+	}
+
 	rv = set_array_info(mdfd, st, content);
 	if (rv && !err_ok) {
 		pr_err("failed to set array info for %s: %s\n",
@@ -1032,7 +1049,8 @@ static int start_array(int mdfd,
 	if (content->array.level == LEVEL_CONTAINER) {
 		if (c->verbose >= 0) {
 			pr_err("Container %s has been assembled with %d drive%s",
-			       mddev, okcnt+sparecnt, okcnt+sparecnt==1?"":"s");
+			       mddev, okcnt+sparecnt+journalcnt,
+			       okcnt+sparecnt+journalcnt==1?"":"s");
 			if (okcnt < (unsigned)content->array.raid_disks)
 				fprintf(stderr, " (out of %d)",
 					content->array.raid_disks);
@@ -1118,6 +1136,8 @@ static int start_array(int mdfd,
 					fprintf(stderr, "%s %d rebuilding", sparecnt?",":" and", rebuilding_cnt);
 				if (sparecnt)
 					fprintf(stderr, " and %d spare%s", sparecnt, sparecnt==1?"":"s");
+				if (journalcnt == 1)
+					fprintf(stderr, " and 1 journal");
 				fprintf(stderr, ".\n");
 			}
 			if (content->reshape_active &&
@@ -1289,7 +1309,7 @@ int Assemble(struct supertype *st, char *mddev,
 	int *best = NULL; /* indexed by raid_disk */
 	int bestcnt = 0;
 	int devcnt;
-	unsigned int okcnt, sparecnt, rebuilding_cnt, replcnt;
+	unsigned int okcnt, sparecnt, rebuilding_cnt, replcnt, journalcnt;
 	int i;
 	int was_forced = 0;
 	int most_recent = 0;
@@ -1530,6 +1550,7 @@ try_again:
 	okcnt = 0;
 	replcnt = 0;
 	sparecnt=0;
+	journalcnt=0;
 	rebuilding_cnt=0;
 	for (i=0; i< bestcnt; i++) {
 		int j = best[i];
@@ -1540,8 +1561,10 @@ try_again:
 		/* note: we ignore error flags in multipath arrays
 		 * as they don't make sense
 		 */
-		if (content->array.level != LEVEL_MULTIPATH)
-			if (!(devices[j].i.disk.state & (1<<MD_DISK_ACTIVE))) {
+		if (content->array.level != LEVEL_MULTIPATH) {
+			if (devices[j].i.disk.state & (1<<MD_DISK_JOURNAL)) {
+				journalcnt++;
+			} else if (!(devices[j].i.disk.state & (1<<MD_DISK_ACTIVE))) {
 				if (!(devices[j].i.disk.state
 				      & (1<<MD_DISK_FAULTY))) {
 					devices[j].uptodate = 1;
@@ -1549,6 +1572,7 @@ try_again:
 				}
 				continue;
 			}
+		}
 		/* If this device thinks that 'most_recent' has failed, then
 		 * we must reject this device.
 		 */
@@ -1583,7 +1607,7 @@ try_again:
 						replcnt++;
 				} else
 					rebuilding_cnt++;
-			} else
+			} else if (devices[j].i.disk.raid_disk != MD_DISK_ROLE_JOURNAL)
 				sparecnt++;
 		}
 	}
@@ -1647,7 +1671,9 @@ try_again:
 		int j = best[i];
 		unsigned int desired_state;
 
-		if (i >= content->array.raid_disks * 2)
+		if (devices[j].i.disk.raid_disk == MD_DISK_ROLE_JOURNAL)
+			desired_state = (1<<MD_DISK_JOURNAL);
+		else if (i >= content->array.raid_disks * 2)
 			desired_state = 0;
 		else if (i & 1)
 			desired_state = (1<<MD_DISK_ACTIVE) | (1<<MD_DISK_REPLACEMENT);
@@ -1794,7 +1820,7 @@ try_again:
 	rv = start_array(mdfd, mddev, content,
 			 st, ident, best, bestcnt,
 			 chosen_drive, devices, okcnt, sparecnt,
-			 rebuilding_cnt,
+			 rebuilding_cnt, journalcnt,
 			 c,
 			 clean, avail, start_partial_ok,
 			 pre_exist != NULL,
diff --git a/mdadm.h b/mdadm.h
index 3cc1532..bc6680f 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -969,6 +969,9 @@ extern struct superswitch {
 	/* validate container after assemble */
 	int (*validate_container)(struct mdinfo *info);
 
+	/* whether the array require a journal device */
+	int (*require_journal)(struct supertype *st);
+
 	int swapuuid; /* true if uuid is bigending rather than hostendian */
 	int external;
 	const char *name; /* canonical metadata name */
diff --git a/super1.c b/super1.c
index 799c86c..810a323 100644
--- a/super1.c
+++ b/super1.c
@@ -138,6 +138,37 @@ struct misc_dev_info {
 					|MD_FEATURE_NEW_OFFSET		\
 					|MD_FEATURE_JOURNAL		\
 					)
+/* return value:
+ *    0, jouranl not required
+ *    1, journal required
+ *    2, no superblock loated (st->sb == NULL)
+ */
+static int require_journal1(struct supertype *st)
+{
+	struct mdp_superblock_1 *sb = st->sb;
+	int i;
+	if (sb)
+		for (i=0; i<MAX_DEVS; i++) {
+			if (MD_DISK_ROLE_JOURNAL == sb->dev_roles[i])
+				return 1;
+		}
+	else
+		return 2;  /* no sb loaded */
+	return 0;
+}
+
+static int role_from_sb(struct mdp_superblock_1 *sb)
+{
+	unsigned int d;
+	int role;
+
+	d = __le32_to_cpu(sb->dev_number);
+	if (d < __le32_to_cpu(sb->max_dev))
+		role = __le16_to_cpu(sb->dev_roles[d]);
+	else
+		role = MD_DISK_ROLE_SPARE;
+	return role;
+}
 
 /* return how many bytes are needed for bitmap, for cluster-md each node
  * should have it's own bitmap */
@@ -480,11 +511,7 @@ static void examine_super1(struct supertype *st, char *homehost)
 	printf(")\n");
 #endif
 	printf("   Device Role : ");
-	d = __le32_to_cpu(sb->dev_number);
-	if (d < __le32_to_cpu(sb->max_dev))
-		role = __le16_to_cpu(sb->dev_roles[d]);
-	else
-		role = MD_DISK_ROLE_SPARE;
+	role = role_from_sb(sb);
 	if (role >= MD_DISK_ROLE_FAULTY)
 		printf("spare\n");
 	else if (role == MD_DISK_ROLE_JOURNAL)
@@ -2556,6 +2583,7 @@ struct superswitch super1 = {
 	.locate_bitmap = locate_bitmap1,
 	.write_bitmap = write_bitmap1,
 	.free_super = free_super1,
+	.require_journal = require_journal1,
 #if __BYTE_ORDER == BIG_ENDIAN
 	.swapuuid = 0,
 #else
-- 
1.8.1

