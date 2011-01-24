From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 2/5] Add raid1->raid0 takeover support
Date: Mon, 24 Jan 2011 15:17:12 +0100
Message-ID: <20110124141712.16405.50338.stgit@gklab-128-111.igk.intel.com>
References: <20110124141704.16405.6081.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110124141704.16405.6081.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Add support for raid1 to raid0 takeover operation in user space.
This patch includes support for native and imsm metadata.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 Grow.c        |   39 ++++++++++++++++++++++++++++-----------
 super-intel.c |    6 ++++++
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/Grow.c b/Grow.c
index 7c5edae..a8da20a 100644
--- a/Grow.c
+++ b/Grow.c
@@ -650,15 +650,20 @@ void abort_reshape(struct mdinfo *sra)
 	sysfs_set_str(sra, NULL, "sync_max", "max");
 }
 
-int remove_disks_on_raid10_to_raid0_takeover(struct supertype *st,
-					     struct mdinfo *sra,
-					     int layout)
+int remove_disks_for_takeover(struct supertype *st,
+			     struct mdinfo *sra,
+			     int layout)
 {
 	int nr_of_copies;
 	struct mdinfo *remaining;
 	int slot;
 
-	nr_of_copies = layout & 0xff;
+	if (sra->array.level == 10)
+		nr_of_copies = layout & 0xff;
+	else if (sra->array/level == 1)
+		nr_of_copies = sra->array.raid_disks;
+	else
+		return 1;
 
 	remaining = sra->devs;
 	sra->devs = NULL;
@@ -911,8 +916,18 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 	switch (info->array.level) {
 	case 1:
 		/* RAID1 can convert to RAID1 with different disks, or
-		 * raid5 with 2 disks
+		 * raid5 with 2 disks, or
+		 * raid0 with 1 disk
 		 */
+		if (info->new_level == 0) {
+			re->level = 0;
+			re->before.data_disks = info->array.raid_disks / 2;
+			re->after.data_disks = re->before.data_disks;
+			re->before.layout = 0;
+			re->backup_blocks = 0;
+			re->parity = 0;
+			return NULL;
+		}
 		if (info->new_level == 1) {
 			if (info->delta_disks == UnSet)
 				/* Don't know what to do */
@@ -1449,15 +1464,17 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			size = array.size;
 	}
 
-	/* ========= check for Raid10 -> Raid0 conversion ===============
+	/* ========= check for Raid10/Raid1 -> Raid0 conversion ===============
 	 * current implementation assumes that following conditions must be met:
-	 * - far_copies == 1
-	 * - near_copies == 2
+	 * - RAID10:
+	 * 	- far_copies == 1
+	 * 	- near_copies == 2
 	 */
-	if (level == 0 && array.level == 10 && sra &&
-	    array.layout == ((1 << 8) + 2) && !(array.raid_disks & 1)) {
+	if ((level == 0 && array.level == 10 && sra &&
+	    array.layout == ((1 << 8) + 2) && !(array.raid_disks & 1)) ||
+	    (level == 0 && array.level == 1 && sra)) {
 		int err;
-		err = remove_disks_on_raid10_to_raid0_takeover(st, sra, array.layout);
+		err = remove_disks_for_takeover(st, sra, array.layout);
 		if (err) {
 			dprintf(Name": Array cannot be reshaped\n");
 			if (cfd > -1)
diff --git a/super-intel.c b/super-intel.c
index b25d4fb..461fb0c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6785,6 +6785,12 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 				check_devs = 1;
 			}
 			break;
+		case 1:
+			if (geo->level == 0) {
+				change = CH_TAKEOVER;
+				check_devs = 1;
+			}
+			break;
 		case 5:
 			if (geo->level != 0)
 				change = CH_LEVEL_MIGRATION;

