From: Tkaczyk Mariusz <mariusz.tkaczyk@intel.com>
Subject: [PATCH] Assemble.c: respect force flag.
Date: Tue,  5 May 2020 12:17:17 +0200
Message-ID: <20200505101717.29553-1-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>

If the array is dirty handler will set resync_start to 0 to inform kernel
that resync is needed. RWH affects only raid456 module, for other
levels array will be started even array is degraded and resync cannot be
performed.

Force is really meaningful for raid456. If array is degraded and resync
is requested, kernel will reject an attempt to start the array. To
respect force, it has to be marked as clean (this will be done for each
array without PPL) and remove the resync request (only for raid 456).
Data corruption may occur so proper warning is added.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
---
 Assemble.c | 51 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 13 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 6b5a7c8e..1206fb06 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -2030,6 +2030,15 @@ int assemble_container_content(struct supertype *st, int mdfd,
 			free(avail);
 			return err;
 		}
+	} else if (c->force) {
+		/* Set the array as 'clean' so that we can proceed with starting
+		 * it even if we don't have all devices. Mdmon doesn't care
+		 * if the dirty flag is set in metadata, it will start managing
+		 * it anyway.
+		 * This is really important for raid456 (RWH case), other levels
+		 * are started anyway.
+		 */
+		content->array.state |= 1;
 	}
 
 	if (enough(content->array.level, content->array.raid_disks,
@@ -2049,20 +2058,36 @@ int assemble_container_content(struct supertype *st, int mdfd,
 	}
 	free(avail);
 
-	if (c->runstop <= 0 &&
-	    (working + preexist + expansion) <
-	    content->array.working_disks) {
-		if (c->export && result)
-			*result |= INCR_UNSAFE;
-		else if (c->verbose >= 0) {
-			pr_err("%s assembled with %d device%s",
-			       chosen_name, preexist + working,
-			       preexist + working == 1 ? "":"s");
-			if (preexist)
-				fprintf(stderr, " (%d new)", working);
-			fprintf(stderr, " but not safe to start\n");
+	if ((working + preexist + expansion) < content->array.working_disks) {
+		if (c->runstop <= 0) {
+			if (c->export && result)
+				*result |= INCR_UNSAFE;
+			else if (c->verbose >= 0) {
+				pr_err("%s assembled with %d device%s",
+					chosen_name, preexist + working,
+					preexist + working == 1 ? "":"s");
+				if (preexist)
+					fprintf(stderr, " (%d new)", working);
+				fprintf(stderr, " but not safe to start\n");
+				if (c->force)
+					pr_err("Consider --run to start array as degraded.\n");
+			}
+			return 1;
+		} else if (content->array.level >= 4 &&
+			   content->array.level <= 6 &&
+			   content->resync_start != MaxSector &&
+			   c->force) {
+			/* Don't inform the kernel that the array is not
+			 * clean and requires resync.
+			 */
+			content->resync_start = MaxSector;
+			err = sysfs_set_num(content, NULL, "resync_start",
+					    MaxSector);
+			if (err)
+				return 1;
+			pr_err("%s array state forced to clean. It may cause data corruption.\n",
+				chosen_name);
 		}
-		return 1;
 	}
 
 
-- 
2.25.0
