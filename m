From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 04/21] imsm: FIX: Detect migration end during migration record
	saving
Date: Wed, 08 Jun 2011 18:10:06 +0200
Message-ID: <20110608161006.24327.32399.stgit@gklab-128-013.igk.intel.com>
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

Checkpoint should be saved when migration is in progress only.
End of reshape (based on passes status) should be detected and it should
not cause abort of reshape/check-pointing/ operation.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 269cb0a..3afa913 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7760,6 +7760,8 @@ abort:
  * Returns:
  *	0: success
  *	1: failure
+ *	2: failure, means no valid migration record
+ *		   / no general migration in progress /
  ******************************************************************************/
 int save_checkpoint_imsm(struct supertype *st, struct mdinfo *info, int state)
 {
@@ -7771,8 +7773,8 @@ int save_checkpoint_imsm(struct supertype *st, struct mdinfo *info, int state)
 	}
 
 	if (__le32_to_cpu(super->migr_rec->blocks_per_unit) == 0) {
-		dprintf("ERROR: blocks_per_unit = 0!!!\n");
-		return 1;
+		dprintf("imsm: no migration in progress.\n");
+		return 2;
 	}
 
 	super->migr_rec->curr_migr_unit =
@@ -8842,7 +8844,9 @@ static int imsm_manage_reshape(
 
 		sra->reshape_progress = next_step;
 
-		if (save_checkpoint_imsm(st, sra, UNIT_SRC_NORMAL)) {
+		if (save_checkpoint_imsm(st, sra, UNIT_SRC_NORMAL) == 1) {
+			/* ignore error == 2, this can mean end of reshape here
+			 */
 			dprintf("imsm: Cannot write checkpoint to "
 				"migration record (UNIT_SRC_NORMAL)\n");
 			goto abort;

