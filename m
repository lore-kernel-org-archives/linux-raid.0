From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 5/6] Check write journal in incremental
Date: Fri, 28 Aug 2015 16:27:05 -0700
Message-ID: <1440804426-1461372-6-git-send-email-songliubraving@fb.com>
References: <1440804426-1461372-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1440804426-1461372-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, dan.j.williams@intel.com, neilb@suse.de, hch@infradead.org, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

If journal device is missing, do not start the array, and shows:

./mdadm -I /dev/sdf
mdadm: journal device is missing, not safe to start yet.

The array will be started when the journal device is attached with -I

./mdadm -I /dev/sdb1
mdadm: /dev/sdb1 attached to /dev/md/0_0, which has been started.

To force start without journal device:

./mdadm -I /dev/sdf --run
mdadm: Trying to run with missing journal device
mdadm: /dev/sdf attached to /dev/md/0_0, which has been started.

Signed-off-by: Shaohua Li <shli@fb.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Incremental.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 304cc6d..74905e3 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -35,7 +35,7 @@
 
 static int count_active(struct supertype *st, struct mdinfo *sra,
 			int mdfd, char **availp,
-			struct mdinfo *info);
+			struct mdinfo *info, int *journal_device_missing);
 static void find_reject(int mdfd, struct supertype *st, struct mdinfo *sra,
 			int number, __u64 events, int verbose,
 			char *array_name);
@@ -104,6 +104,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 	struct map_ent target_array;
 	int have_target;
 	char *devname = devlist->devname;
+	int journal_device_missing = 0;
 
 	struct createinfo *ci = conf_get_create_info();
 
@@ -518,7 +519,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 	sysfs_free(sra);
 	sra = sysfs_read(mdfd, NULL, (GET_DEVS | GET_STATE |
 				    GET_OFFSET | GET_SIZE));
-	active_disks = count_active(st, sra, mdfd, &avail, &info);
+	active_disks = count_active(st, sra, mdfd, &avail, &info, &journal_device_missing);
 	if (enough(info.array.level, info.array.raid_disks,
 		   info.array.layout, info.array.state & 1,
 		   avail) == 0) {
@@ -548,10 +549,12 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 	}
 
 	map_unlock(&map);
-	if (c->runstop > 0 || active_disks >= info.array.working_disks) {
+	if (c->runstop > 0 || (!journal_device_missing && active_disks >= info.array.working_disks)) {
 		struct mdinfo *dsk;
 		/* Let's try to start it */
 
+		if (journal_device_missing)
+			pr_err("Trying to run with missing journal device\n");
 		if (info.reshape_active && !(info.reshape_active & RESHAPE_NO_BACKUP)) {
 			pr_err("%s: This array is being reshaped and cannot be started\n",
 			       chosen_name);
@@ -618,6 +621,8 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 	} else {
 		if (c->export) {
 			printf("MD_STARTED=unsafe\n");
+		} else if (journal_device_missing) {
+			pr_err("Journal device is missing, not safe to start yet.\n");
 		} else if (c->verbose >= 0)
 			pr_err("%s attached to %s, not enough to start safely.\n",
 			       devname, chosen_name);
@@ -684,7 +689,8 @@ static void find_reject(int mdfd, struct supertype *st, struct mdinfo *sra,
 
 static int count_active(struct supertype *st, struct mdinfo *sra,
 			int mdfd, char **availp,
-			struct mdinfo *bestinfo)
+			struct mdinfo *bestinfo,
+			int *journal_device_missing)
 {
 	/* count how many devices in sra think they are active */
 	struct mdinfo *d;
@@ -698,6 +704,8 @@ static int count_active(struct supertype *st, struct mdinfo *sra,
 	int devnum;
 	int b, i;
 	int raid_disks = 0;
+	int require_journal_dev = 0;
+	int has_journal_dev = 0;
 
 	if (!sra)
 		return 0;
@@ -718,8 +726,19 @@ static int count_active(struct supertype *st, struct mdinfo *sra,
 		close(dfd);
 		if (ok != 0)
 			continue;
+
+		if (st->ss->require_journal) {
+			require_journal_dev = st->ss->require_journal(st);
+			if (require_journal_dev == 2) {
+				pr_err("BUG: Superblock not loaded in Incremental.c:count_active\n");
+				return 0;
+			}
+		}
+
 		info.array.raid_disks = raid_disks;
 		st->ss->getinfo_super(st, &info, devmap + raid_disks * devnum);
+		if (info.disk.raid_disk == MD_DISK_ROLE_JOURNAL)
+			has_journal_dev = 1;
 		if (!avail) {
 			raid_disks = info.array.raid_disks;
 			avail = xcalloc(raid_disks, 1);
@@ -769,6 +788,10 @@ static int count_active(struct supertype *st, struct mdinfo *sra,
 			replcnt++;
 		st->ss->free_super(st);
 	}
+
+	if (require_journal_dev && !has_journal_dev)
+		*journal_device_missing = 1;
+
 	if (!avail)
 		return 0;
 	/* We need to reject any device that thinks the best device is
-- 
1.8.1

