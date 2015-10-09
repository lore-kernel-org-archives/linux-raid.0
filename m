From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 4/6] Assemble array with write journal
Date: Thu, 8 Oct 2015 22:51:44 -0700
Message-ID: <1444369906-1804157-5-git-send-email-songliubraving@fb.com>
References: <1444369906-1804157-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444369906-1804157-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, shli@fb.com, hch@infradead.org, dan.j.williams@intel.com, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Example output:

./mdadm --assemble /dev/md0 /dev/sd[c-f] /dev/sdb1
mdadm: /dev/md0 has been started with 4 drives and 1 journal.

mdadm checks superblock for journal devices. If the journal device
is missing or faulty, mdadm will show warning

./mdadm --assemble /dev/md0 /dev/sd[c-q] /dev/sdb1
mdadm: Not safe to assemble with missing or stale journal device, consider --force.

User can insist to start the array (read only) with --force

./mdadm --assemble /dev/md0 /dev/sd[c-q] /dev/sdb1 --force
mdadm: Journal is missing or stale, starting array read only.
mdadm: /dev/md0 has been started with 15 drives.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 Assemble.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++-----------
 mdadm.h    |  3 +++
 super1.c   | 37 ++++++++++++++++++++++++++++++++-----
 3 files changed, 81 insertions(+), 16 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index d9e9001..0661e8d 100644
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
@@ -913,7 +913,6 @@ static int force_array(struct mdinfo *content,
 		avail[chosen_drive] = 1;
 		okcnt++;
 		tst->ss->free_super(tst);
-
 		/* If there are any other drives of the same vintage,
 		 * add them in as well.  We can't lose and we might gain
 		 */
@@ -944,17 +943,29 @@ static int start_array(int mdfd,
 		       unsigned int okcnt,
 		       unsigned int sparecnt,
 		       unsigned int rebuilding_cnt,
+		       unsigned int journalcnt,
 		       struct context *c,
 		       int clean, char *avail,
 		       int start_partial_ok,
 		       int err_ok,
-		       int was_forced
+		       int was_forced,
+		       int expect_journal,
+		       int journal_clean
 	)
 {
 	int rv;
 	int i;
 	unsigned int req_cnt;
 
+	if (expect_journal && (journal_clean == 0)) {
+		if (!c->force) {
+			pr_err("Not safe to assemble with missing or stale journal device, consider --force.\n");
+			return 1;
+		}
+		pr_err("Journal is missing or stale, starting array read only.\n");
+		c->readonly = 1;
+	}
+
 	rv = set_array_info(mdfd, st, content);
 	if (rv && !err_ok) {
 		pr_err("failed to set array info for %s: %s\n",
@@ -1032,7 +1043,8 @@ static int start_array(int mdfd,
 	if (content->array.level == LEVEL_CONTAINER) {
 		if (c->verbose >= 0) {
 			pr_err("Container %s has been assembled with %d drive%s",
-			       mddev, okcnt+sparecnt, okcnt+sparecnt==1?"":"s");
+			       mddev, okcnt+sparecnt+journalcnt,
+			       okcnt+sparecnt+journalcnt==1?"":"s");
 			if (okcnt < (unsigned)content->array.raid_disks)
 				fprintf(stderr, " (out of %d)",
 					content->array.raid_disks);
@@ -1118,6 +1130,8 @@ static int start_array(int mdfd,
 					fprintf(stderr, "%s %d rebuilding", sparecnt?",":" and", rebuilding_cnt);
 				if (sparecnt)
 					fprintf(stderr, " and %d spare%s", sparecnt, sparecnt==1?"":"s");
+				if (journal_clean)
+					fprintf(stderr, " and %d journal", journalcnt);
 				fprintf(stderr, ".\n");
 			}
 			if (content->reshape_active &&
@@ -1289,10 +1303,12 @@ int Assemble(struct supertype *st, char *mddev,
 	int *best = NULL; /* indexed by raid_disk */
 	int bestcnt = 0;
 	int devcnt;
-	unsigned int okcnt, sparecnt, rebuilding_cnt, replcnt;
+	unsigned int okcnt, sparecnt, rebuilding_cnt, replcnt, journalcnt;
 	int i;
 	int was_forced = 0;
 	int most_recent = 0;
+	int expect_journal = 0;
+	int journal_clean = 0;
 	int chosen_drive;
 	int change = 0;
 	int inargv = 0;
@@ -1355,6 +1371,14 @@ try_again:
 	if (!st || !st->sb || !content)
 		return 2;
 
+	if (st->ss->require_journal) {
+		expect_journal = st->ss->require_journal(st);
+		if (expect_journal == 2) {
+			pr_err("BUG: Superblock not loaded in Assemble.c:Assemble\n");
+			return 1;
+		}
+	}
+
 	/* We have a full set of devices - we now need to find the
 	 * array device.
 	 * However there is a risk that we are racing with "mdadm -I"
@@ -1530,6 +1554,7 @@ try_again:
 	okcnt = 0;
 	replcnt = 0;
 	sparecnt=0;
+	journalcnt=0;
 	rebuilding_cnt=0;
 	for (i=0; i< bestcnt; i++) {
 		int j = best[i];
@@ -1540,8 +1565,13 @@ try_again:
 		/* note: we ignore error flags in multipath arrays
 		 * as they don't make sense
 		 */
-		if (content->array.level != LEVEL_MULTIPATH)
-			if (!(devices[j].i.disk.state & (1<<MD_DISK_ACTIVE))) {
+		if (content->array.level != LEVEL_MULTIPATH) {
+			if (devices[j].i.disk.state & (1<<MD_DISK_JOURNAL)) {
+				if (expect_journal)
+					journalcnt++;
+				else	/* unexpected journal, mark as faulty */
+					devices[j].i.disk.state |= (1<<MD_DISK_FAULTY);
+			} else if (!(devices[j].i.disk.state & (1<<MD_DISK_ACTIVE))) {
 				if (!(devices[j].i.disk.state
 				      & (1<<MD_DISK_FAULTY))) {
 					devices[j].uptodate = 1;
@@ -1549,6 +1579,7 @@ try_again:
 				}
 				continue;
 			}
+		}
 		/* If this device thinks that 'most_recent' has failed, then
 		 * we must reject this device.
 		 */
@@ -1572,6 +1603,8 @@ try_again:
 		    devices[most_recent].i.events
 			) {
 			devices[j].uptodate = 1;
+			if (devices[j].i.disk.state & (1<<MD_DISK_JOURNAL))
+				journal_clean = 1;
 			if (i < content->array.raid_disks * 2) {
 				if (devices[j].i.recovery_start == MaxSector ||
 				    (content->reshape_active &&
@@ -1583,7 +1616,7 @@ try_again:
 						replcnt++;
 				} else
 					rebuilding_cnt++;
-			} else
+			} else if (devices[j].i.disk.raid_disk != MD_DISK_ROLE_JOURNAL)
 				sparecnt++;
 		}
 	}
@@ -1647,7 +1680,9 @@ try_again:
 		int j = best[i];
 		unsigned int desired_state;
 
-		if (i >= content->array.raid_disks * 2)
+		if (devices[j].i.disk.raid_disk == MD_DISK_ROLE_JOURNAL)
+			desired_state = (1<<MD_DISK_JOURNAL);
+		else if (i >= content->array.raid_disks * 2)
 			desired_state = 0;
 		else if (i & 1)
 			desired_state = (1<<MD_DISK_ACTIVE) | (1<<MD_DISK_REPLACEMENT);
@@ -1794,11 +1829,11 @@ try_again:
 	rv = start_array(mdfd, mddev, content,
 			 st, ident, best, bestcnt,
 			 chosen_drive, devices, okcnt, sparecnt,
-			 rebuilding_cnt,
+			 rebuilding_cnt, journalcnt,
 			 c,
 			 clean, avail, start_partial_ok,
 			 pre_exist != NULL,
-			 was_forced);
+			 was_forced, expect_journal, journal_clean);
 	if (rv == 1 && !pre_exist)
 		ioctl(mdfd, STOP_ARRAY, NULL);
 	free(devices);
diff --git a/mdadm.h b/mdadm.h
index 0b27b43..b1028be 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -970,6 +970,9 @@ extern struct superswitch {
 	/* validate container after assemble */
 	int (*validate_container)(struct mdinfo *info);
 
+	/* whether the array require a journal device */
+	int (*require_journal)(struct supertype *st);
+
 	int swapuuid; /* true if uuid is bigending rather than hostendian */
 	int external;
 	const char *name; /* canonical metadata name */
diff --git a/super1.c b/super1.c
index 85e3b28..47acdec 100644
--- a/super1.c
+++ b/super1.c
@@ -140,6 +140,34 @@ struct misc_dev_info {
 					|MD_FEATURE_BITMAP_VERSIONED	\
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
+
+	if (sb->feature_map & MD_FEATURE_JOURNAL)
+		return 1;
+	else if (!sb)
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
@@ -482,11 +510,7 @@ static void examine_super1(struct supertype *st, char *homehost)
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
@@ -1126,6 +1150,8 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		int want;
 		if (info->disk.state & (1<<MD_DISK_ACTIVE))
 			want = info->disk.raid_disk;
+		else if (info->disk.state & (1<<MD_DISK_JOURNAL))
+			want = MD_DISK_ROLE_JOURNAL;
 		else
 			want = MD_DISK_ROLE_SPARE;
 		if (sb->dev_roles[d] != __cpu_to_le16(want)) {
@@ -2560,6 +2586,7 @@ struct superswitch super1 = {
 	.locate_bitmap = locate_bitmap1,
 	.write_bitmap = write_bitmap1,
 	.free_super = free_super1,
+	.require_journal = require_journal1,
 #if __BYTE_ORDER == BIG_ENDIAN
 	.swapuuid = 0,
 #else
-- 
2.4.6

