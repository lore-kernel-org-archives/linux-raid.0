From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 1/3] mdadm: refactor write journal code in Assemble and Incremental
Date: Wed, 21 Oct 2015 11:35:14 -0700
Message-ID: <1445452516-2816184-2-git-send-email-songliubraving@fb.com>
References: <1445452516-2816184-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1445452516-2816184-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, hch@infradead.org, dan.j.williams@intel.com, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

As discussed, standalone require_journal() in struct superswitch
is not a very good idea. Instead, journal related information
fits well in struct mdinfo.

This patch simplifies journal support code in Assemble and
Incremental as:

- Add journal_device_required and journal_clean to struct mdinfo;
- Remove function require_journal from struct superswitch;
- Update Assemble and Incremental to use journal_device_required
and journal_clean from struct mdinfo (instead of separate var).

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 Assemble.c    | 24 ++++++------------------
 Incremental.c | 25 +++++++------------------
 mdadm.h       |  6 ++----
 super1.c      | 19 +++----------------
 4 files changed, 18 insertions(+), 56 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 0661e8d..90c9918 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -948,16 +948,14 @@ static int start_array(int mdfd,
 		       int clean, char *avail,
 		       int start_partial_ok,
 		       int err_ok,
-		       int was_forced,
-		       int expect_journal,
-		       int journal_clean
+		       int was_forced
 	)
 {
 	int rv;
 	int i;
 	unsigned int req_cnt;
 
-	if (expect_journal && (journal_clean == 0)) {
+	if (content->journal_device_required && (content->journal_clean == 0)) {
 		if (!c->force) {
 			pr_err("Not safe to assemble with missing or stale journal device, consider --force.\n");
 			return 1;
@@ -1130,7 +1128,7 @@ static int start_array(int mdfd,
 					fprintf(stderr, "%s %d rebuilding", sparecnt?",":" and", rebuilding_cnt);
 				if (sparecnt)
 					fprintf(stderr, " and %d spare%s", sparecnt, sparecnt==1?"":"s");
-				if (journal_clean)
+				if (content->journal_clean)
 					fprintf(stderr, " and %d journal", journalcnt);
 				fprintf(stderr, ".\n");
 			}
@@ -1307,8 +1305,6 @@ int Assemble(struct supertype *st, char *mddev,
 	int i;
 	int was_forced = 0;
 	int most_recent = 0;
-	int expect_journal = 0;
-	int journal_clean = 0;
 	int chosen_drive;
 	int change = 0;
 	int inargv = 0;
@@ -1371,14 +1367,6 @@ try_again:
 	if (!st || !st->sb || !content)
 		return 2;
 
-	if (st->ss->require_journal) {
-		expect_journal = st->ss->require_journal(st);
-		if (expect_journal == 2) {
-			pr_err("BUG: Superblock not loaded in Assemble.c:Assemble\n");
-			return 1;
-		}
-	}
-
 	/* We have a full set of devices - we now need to find the
 	 * array device.
 	 * However there is a risk that we are racing with "mdadm -I"
@@ -1567,7 +1555,7 @@ try_again:
 		 */
 		if (content->array.level != LEVEL_MULTIPATH) {
 			if (devices[j].i.disk.state & (1<<MD_DISK_JOURNAL)) {
-				if (expect_journal)
+				if (content->journal_device_required)
 					journalcnt++;
 				else	/* unexpected journal, mark as faulty */
 					devices[j].i.disk.state |= (1<<MD_DISK_FAULTY);
@@ -1604,7 +1592,7 @@ try_again:
 			) {
 			devices[j].uptodate = 1;
 			if (devices[j].i.disk.state & (1<<MD_DISK_JOURNAL))
-				journal_clean = 1;
+				content->journal_clean = 1;
 			if (i < content->array.raid_disks * 2) {
 				if (devices[j].i.recovery_start == MaxSector ||
 				    (content->reshape_active &&
@@ -1833,7 +1821,7 @@ try_again:
 			 c,
 			 clean, avail, start_partial_ok,
 			 pre_exist != NULL,
-			 was_forced, expect_journal, journal_clean);
+			 was_forced);
 	if (rv == 1 && !pre_exist)
 		ioctl(mdfd, STOP_ARRAY, NULL);
 	free(devices);
diff --git a/Incremental.c b/Incremental.c
index 5b2974c..781d27d 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -35,7 +35,7 @@
 
 static int count_active(struct supertype *st, struct mdinfo *sra,
 			int mdfd, char **availp,
-			struct mdinfo *info, int *journal_device_missing);
+			struct mdinfo *info);
 static void find_reject(int mdfd, struct supertype *st, struct mdinfo *sra,
 			int number, __u64 events, int verbose,
 			char *array_name);
@@ -520,7 +520,10 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 	sysfs_free(sra);
 	sra = sysfs_read(mdfd, NULL, (GET_DEVS | GET_STATE |
 				    GET_OFFSET | GET_SIZE));
-	active_disks = count_active(st, sra, mdfd, &avail, &info, &journal_device_missing);
+	active_disks = count_active(st, sra, mdfd, &avail, &info);
+
+	journal_device_missing = (info.journal_device_required) && (info.journal_clean == 0);
+
 	if (enough(info.array.level, info.array.raid_disks,
 		   info.array.layout, info.array.state & 1,
 		   avail) == 0) {
@@ -690,8 +693,7 @@ static void find_reject(int mdfd, struct supertype *st, struct mdinfo *sra,
 
 static int count_active(struct supertype *st, struct mdinfo *sra,
 			int mdfd, char **availp,
-			struct mdinfo *bestinfo,
-			int *journal_device_missing)
+			struct mdinfo *bestinfo)
 {
 	/* count how many devices in sra think they are active */
 	struct mdinfo *d;
@@ -705,8 +707,6 @@ static int count_active(struct supertype *st, struct mdinfo *sra,
 	int devnum;
 	int b, i;
 	int raid_disks = 0;
-	int require_journal_dev = 0;
-	int has_journal_dev = 0;
 
 	if (!sra)
 		return 0;
@@ -728,18 +728,10 @@ static int count_active(struct supertype *st, struct mdinfo *sra,
 		if (ok != 0)
 			continue;
 
-		if (st->ss->require_journal) {
-			require_journal_dev = st->ss->require_journal(st);
-			if (require_journal_dev == 2) {
-				pr_err("BUG: Superblock not loaded in Incremental.c:count_active\n");
-				return 0;
-			}
-		}
-
 		info.array.raid_disks = raid_disks;
 		st->ss->getinfo_super(st, &info, devmap + raid_disks * devnum);
 		if (info.disk.raid_disk == MD_DISK_ROLE_JOURNAL)
-			has_journal_dev = 1;
+			bestinfo->journal_clean = 1;
 		if (!avail) {
 			raid_disks = info.array.raid_disks;
 			avail = xcalloc(raid_disks, 1);
@@ -790,9 +782,6 @@ static int count_active(struct supertype *st, struct mdinfo *sra,
 		st->ss->free_super(st);
 	}
 
-	if (require_journal_dev && !has_journal_dev)
-		*journal_device_missing = 1;
-
 	if (!avail)
 		return 0;
 	/* We need to reject any device that thinks the best device is
diff --git a/mdadm.h b/mdadm.h
index b1028be..b4f2011 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -250,7 +250,8 @@ struct mdinfo {
 	#define	DS_REMOVE	1024
 	#define	DS_UNBLOCK	2048
 	int prev_state, curr_state, next_state;
-
+	int journal_device_required;
+	int journal_clean;
 };
 
 struct createinfo {
@@ -970,9 +971,6 @@ extern struct superswitch {
 	/* validate container after assemble */
 	int (*validate_container)(struct mdinfo *info);
 
-	/* whether the array require a journal device */
-	int (*require_journal)(struct supertype *st);
-
 	int swapuuid; /* true if uuid is bigending rather than hostendian */
 	int external;
 	const char *name; /* canonical metadata name */
diff --git a/super1.c b/super1.c
index 47acdec..2799529 100644
--- a/super1.c
+++ b/super1.c
@@ -140,21 +140,6 @@ struct misc_dev_info {
 					|MD_FEATURE_BITMAP_VERSIONED	\
 					|MD_FEATURE_JOURNAL		\
 					)
-/* return value:
- *    0, jouranl not required
- *    1, journal required
- *    2, no superblock loated (st->sb == NULL)
- */
-static int require_journal1(struct supertype *st)
-{
-	struct mdp_superblock_1 *sb = st->sb;
-
-	if (sb->feature_map & MD_FEATURE_JOURNAL)
-		return 1;
-	else if (!sb)
-		return 2;  /* no sb loaded */
-	return 0;
-}
 
 static int role_from_sb(struct mdp_superblock_1 *sb)
 {
@@ -1086,6 +1071,9 @@ static void getinfo_super1(struct supertype *st, struct mdinfo *info, char *map)
 	}
 
 	info->array.working_disks = working;
+	if (sb->feature_map & __le32_to_cpu(MD_FEATURE_JOURNAL))
+		info->journal_device_required = 1;
+	info->journal_clean = 0;
 }
 
 static struct mdinfo *container_content1(struct supertype *st, char *subarray)
@@ -2586,7 +2574,6 @@ struct superswitch super1 = {
 	.locate_bitmap = locate_bitmap1,
 	.write_bitmap = write_bitmap1,
 	.free_super = free_super1,
-	.require_journal = require_journal1,
 #if __BYTE_ORDER == BIG_ENDIAN
 	.swapuuid = 0,
 #else
-- 
2.4.6

