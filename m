From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 6/9] FIX: Cannot continue reshape if mdmon is not run
Date: Wed, 09 Mar 2011 14:46:18 +0100
Message-ID: <20110309134618.8939.46747.stgit@gklab-128-013.igk.intel.com>
References: <20110309134019.8939.15438.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110309134019.8939.15438.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Grow_continue() call was moved down in assemble_container_content()
because it needs running mdmon. Mdmon is running at the end of this function.

Due to mdmon is required to run setting array_state was disabled for reshaped array.
This causes that md will keep stable reshape in sync_action.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 0ffbbc9..3771ee1 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1544,7 +1544,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
 	if (runstop > 0 ||
 		 (working + preexist + expansion) >=
 			content->array.working_disks) {
-		int err;
+		int err = 0;
 
 		if (content->reshape_active) {
 			int spare = content->array.raid_disks + expansion;
@@ -1577,18 +1577,19 @@ int assemble_container_content(struct supertype *st, int mdfd,
 						" to specify a --backup-file\n");
 				return 1;
 			}
-
-			err = Grow_continue(mdfd, st, content, backup_file);
-		} else switch(content->array.level) {
+		}
+		switch (content->array.level) {
 		case LEVEL_LINEAR:
 		case LEVEL_MULTIPATH:
 		case 0:
-			err = sysfs_set_str(content, NULL, "array_state",
-					    "active");
+			if (!content->reshape_active)
+				err = sysfs_set_str(content, NULL,
+						    "array_state", "active");
 			break;
 		default:
-			err = sysfs_set_str(content, NULL, "array_state",
-				      "readonly");
+			if (!content->reshape_active)
+				err = sysfs_set_str(content, NULL,
+						    "array_state", "readonly");
 			/* start mdmon if needed. */
 			if (!err) {
 				if (!mdmon_running(st->container_dev))
@@ -1615,8 +1616,12 @@ int assemble_container_content(struct supertype *st, int mdfd,
 					expansion);
 			fprintf(stderr, "\n");
 		}
-		if (!err)
+		if (!err) {
 			wait_for(chosen_name, mdfd);
+			if (content->reshape_active)
+				err = Grow_continue(mdfd, st, content,
+						    backup_file);
+		}
 		return err;
 		/* FIXME should have an O_EXCL and wait for read-auto */
 	} else {

