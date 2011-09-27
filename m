From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/8] Set correct reshape restart position
Date: Tue, 27 Sep 2011 14:05:05 +0200
Message-ID: <20110927120505.4890.95696.stgit@gklab-128-013.igk.intel.com>
References: <20110927115845.4890.49289.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110927115845.4890.49289.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

During initrd stage when, when array is assembled with '--freeze-reshape'
option and before stopping reshape, reshape position has to be set to read
from metadata checkpoint.
This will allow later for restart point verification and user will be able
to see in mdstat information about reshape process instead resync when
reshape position is set to 0.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/Grow.c b/Grow.c
index d9c2817..afe4c72 100644
--- a/Grow.c
+++ b/Grow.c
@@ -696,21 +696,24 @@ static int subarray_set_num(char *container, struct mdinfo *sra, char *name, int
 	return rc;
 }
 
-int start_reshape(struct mdinfo *sra, int already_running, int freeze_reshape)
+int start_reshape(struct mdinfo *sra, int already_running,
+		  int freeze_reshape, int data_disks)
 {
 	int err;
+	unsigned long long position_to_set = 0;
+	unsigned long long sync_max_to_set;
 
 	/* do not block array as we not continue reshape this time
 	 */
-	if (freeze_reshape == FREEZE_RESHAPE_NONE)
-		sysfs_set_num(sra, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
-	else
-		sysfs_set_num(sra, NULL, "suspend_lo", 0);
-	err = sysfs_set_num(sra, NULL, "suspend_hi", 0);
-	err = err ?: sysfs_set_num(sra, NULL, "suspend_lo", 0);
+	if (freeze_reshape != FREEZE_RESHAPE_NONE)
+		position_to_set = sra->reshape_progress;
+	sysfs_set_num(sra, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
+	err = sysfs_set_num(sra, NULL, "suspend_hi", position_to_set);
+	err = err ?: sysfs_set_num(sra, NULL, "suspend_lo", position_to_set);
+	sync_max_to_set = position_to_set / data_disks;
 	if (!already_running)
-		sysfs_set_num(sra, NULL, "sync_min", 0);
-	err = err ?: sysfs_set_num(sra, NULL, "sync_max", 0);
+		sysfs_set_num(sra, NULL, "sync_min", sync_max_to_set);
+	err = err ?: sysfs_set_num(sra, NULL, "sync_max", sync_max_to_set);
 	if (!already_running)
 		err = err ?: sysfs_set_str(sra, NULL, "sync_action", "reshape");
 
@@ -2247,7 +2250,8 @@ started:
 		}
 	}
 
-	err = start_reshape(sra, restart, freeze_reshape);
+	err = start_reshape(sra, restart, freeze_reshape,
+			   info->array.raid_disks - reshape.parity);
 	if (err) {
 		fprintf(stderr, 
 			Name ": Cannot %s reshape for %s\n",
@@ -3753,7 +3757,7 @@ int Grow_continue_command(char *devname, int fd,
 	/* continue reshape
 	 */
 	ret_val = Grow_continue(fd, st, content, backup_file,
-				FREEZE_RESHAPE_NONE);
+				FREEZE_RESHAPE_CONTINUE);
 
 Grow_continue_command_exit:
 	if (fd2 > -1)

