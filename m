From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 14/14] FIX: Assembled second array is in read only state during reshape
Date: Fri, 13 Apr 2012 16:52:08 +0200
Message-ID: <1334328728-12544-15-git-send-email-adam.kwolek@intel.com>
References: <1334328728-12544-1-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-2-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-3-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-4-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-5-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-6-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-7-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-8-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-9-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-10-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-11-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-12-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-13-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-14-git-send-email-adam.kwolek@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334328728-12544-14-git-send-email-adam.kwolek@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, grzegorz.grabowski@intel.com, maciej.patelczyk@intel.com, anna.czarnowska@intel.com, Adam Kwolek <adam.kwolek@intel.com>
List-Id: linux-raid.ids

When arrays using external metadata are assembled, and one of array
in container is under reshape, second array will remain in read only
state (not auto read only). It is caused by array fact that array
is frozen and mdmon doesn't has opportunity to switch array in r/w mode.

Freezing not reshaped array just after it is being assembled allows mdmon
to enable it for writing.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 Assemble.c |   29 +++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 23695e7..080993d 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1558,6 +1558,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
 	int expansion = 0;
 	struct map_ent *map = NULL;
 	int old_raid_disks;
+	int start_reshape;
 
 	sysfs_init(content, mdfd, 0);
 
@@ -1569,7 +1570,17 @@ int assemble_container_content(struct supertype *st, int mdfd,
 			return 1;
 		}
 
-	if (st->ss->external && content->recovery_blocked)
+	/* There are two types of reshape: container wide or sub-array specific
+	 * Check if metadata requests blocking container wide reshapes
+	 */
+	start_reshape = (content->reshape_active &&
+		!((content->reshape_active == CONTAINER_RESHAPE) &&
+		(content->array.state & (1<<MD_SB_BLOCK_CONTAINER_RESHAPE))));
+
+	/* Block subarray here if it is under reshape now
+	 * Do not allow for any changes in this array
+	 */
+	if (st->ss->external && content->recovery_blocked && start_reshape)
 		block_subarray(content);
 
 	if (sra)
@@ -1595,14 +1606,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
 		 (working + preexist + expansion) >=
 			content->array.working_disks) {
 		int err;
-		int start_reshape;
 
-		/* There are two types of reshape: container wide or sub-array specific
-		 * Check if metadata requests blocking container wide reshapes
-		 */
-		start_reshape = (content->reshape_active &&
-				 !((content->reshape_active == CONTAINER_RESHAPE) &&
-				   (content->array.state & (1<<MD_SB_BLOCK_CONTAINER_RESHAPE))));
 		if (start_reshape) {
 			int spare = content->array.raid_disks + expansion;
 			if (restore_backup(st, content,
@@ -1646,6 +1650,15 @@ int assemble_container_content(struct supertype *st, int mdfd,
 		}
 		if (!err)
 			sysfs_set_safemode(content, content->safe_mode_delay);
+
+		/* Block subarray here if it is not reshaped now
+		 * It has be blocked a little later to allow mdmon to switch in
+		 * in to R/W state
+		 */
+		if (st->ss->external && content->recovery_blocked &&
+		    !start_reshape)
+			block_subarray(content);
+
 		if (verbose >= 0) {
 			if (err)
 				fprintf(stderr, Name
-- 
1.6.4.2

