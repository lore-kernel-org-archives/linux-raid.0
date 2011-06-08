From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 18/21] imsm: FIX: wait_for_reshape_imsm() cleanup
Date: Wed, 08 Jun 2011 18:11:58 +0200
Message-ID: <20110608161158.24327.85677.stgit@gklab-128-013.igk.intel.com>
References: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

This function needs to be corrected.
It should check sysfs operations status and it should not interpret
0 reshape position special meaning.

Unused input parameter is removed also.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   54 +++++++++++++++++++++++++++++++++---------------------
 1 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 25e706f..8806339 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8560,39 +8560,50 @@ exit_imsm_reshape_super:
  *		reshape process reach new position
  * Parameters:
  *	sra		: general array info
- *	to_complete	: new sync_max position
  *	ndata		: number of disks in new array's layout
  * Returns:
  *	 0 : success,
  *	 1 : there is no reshape in progress,
  *	-1 : fail
  ******************************************************************************/
-int wait_for_reshape_imsm(struct mdinfo *sra, unsigned long long to_complete,
-			  int ndata)
+int wait_for_reshape_imsm(struct mdinfo *sra, int ndata)
 {
 	int fd = sysfs_get_fd(sra, NULL, "reshape_position");
 	unsigned long long completed;
+	/* to_complete : new sync_max position */
+	unsigned long long to_complete = sra->reshape_progress;
+	unsigned long long position_to_set = to_complete / ndata;
 
 	struct timeval timeout;
 
-	if (fd < 0)
+	if (fd < 0) {
+		dprintf("imsm: wait_for_reshape_imsm() "
+			"cannot open reshape_position\n");
 		return 1;
+	}
 
-	sysfs_fd_get_ll(fd, &completed);
+	if (sysfs_fd_get_ll(fd, &completed) < 0) {
+		dprintf("imsm: wait_for_reshape_imsm() "
+			"cannot read reshape_position (no reshape in progres)\n");
+		close(fd);
+		return 0;
+	}
 
-	if (to_complete == 0) {/* reshape till the end of array */
-		sysfs_set_str(sra, NULL, "sync_max", "max");
-		to_complete = MaxSector;
-	} else {
-		if (completed > to_complete) {
-			close(fd);
-			return -1;
-		}
-		if (sysfs_set_num(sra, NULL, "sync_max",
-				  to_complete / ndata) != 0) {
-			close(fd);
-			return -1;
-		}
+	if (completed > to_complete) {
+		dprintf("imsm: wait_for_reshape_imsm() "
+			"wrong next position to set %llu (%llu)\n",
+			to_complete, completed);
+		close(fd);
+		return -1;
+	}
+	dprintf("Position set: %llu\n", position_to_set);
+	if (sysfs_set_num(sra, NULL, "sync_max",
+			  position_to_set) != 0) {
+		dprintf("imsm: wait_for_reshape_imsm() "
+			"cannot set reshape position to %llu\n",
+			position_to_set);
+		close(fd);
+		return -1;
 	}
 
 	/* FIXME should not need a timeout at all */
@@ -8605,6 +8616,8 @@ int wait_for_reshape_imsm(struct mdinfo *sra, unsigned long long to_complete,
 		FD_SET(fd, &rfds);
 		select(fd+1, NULL, NULL, &rfds, &timeout);
 		if (sysfs_fd_get_ll(fd, &completed) < 0) {
+			dprintf("imsm: wait_for_reshape_imsm() "
+				"cannot read reshape_position (in loop)\n");
 			close(fd);
 			return 1;
 		}
@@ -8854,15 +8867,14 @@ static int imsm_manage_reshape(
 		next_step = next_step + sra->reshape_progress;
 		sysfs_set_num(sra, NULL, "suspend_lo", sra->reshape_progress);
 		sysfs_set_num(sra, NULL, "suspend_hi", next_step);
+		sra->reshape_progress = next_step;
 
 		/* wait until reshape finish */
-		if (wait_for_reshape_imsm(sra, next_step, ndata) < 0) {
+		if (wait_for_reshape_imsm(sra, ndata) < 0) {
 			dprintf("wait_for_reshape_imsm returned error!\n");
 			goto abort;
 		}
 
-		sra->reshape_progress = next_step;
-
 		if (save_checkpoint_imsm(st, sra, UNIT_SRC_NORMAL) == 1) {
 			/* ignore error == 2, this can mean end of reshape here
 			 */

