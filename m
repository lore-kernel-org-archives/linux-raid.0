From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] imsm: FIX: Sometimes reshape cannot be finished
Date: Tue, 14 Jun 2011 14:56:22 +0200
Message-ID: <20110614125622.12762.4928.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When array size is not aligned to copy area, number of migration unit
is increased in init_migr_record_imsm():7665 to reshape whole array.
During calculation of last migration unit, this should be in mind also,
otherwise checkpoint (max-1) is always written and reshape
is never finished in mdadm.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 5dc8ca8..d525295 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7788,20 +7788,30 @@ abort:
 int save_checkpoint_imsm(struct supertype *st, struct mdinfo *info, int state)
 {
 	struct intel_super *super = st->sb;
+	unsigned long long blocks_per_unit;
+
 	if (load_imsm_migr_rec(super, info) != 0) {
 		dprintf("imsm: ERROR: Cannot read migration record "
 			"for checkpoint save.\n");
 		return 1;
 	}
 
-	if (__le32_to_cpu(super->migr_rec->blocks_per_unit) == 0) {
+	blocks_per_unit = __le32_to_cpu(super->migr_rec->blocks_per_unit);
+	if (blocks_per_unit == 0) {
 		dprintf("imsm: no migration in progress.\n");
 		return 2;
 	}
-
 	super->migr_rec->curr_migr_unit =
-	  __cpu_to_le32(info->reshape_progress /
-			__le32_to_cpu(super->migr_rec->blocks_per_unit));
+		info->reshape_progress / blocks_per_unit;
+	/* check if array is alligned to copy area
+	 * if it is not alligned, add one to current migration unit value
+	 * this can happend on array reshape finish only
+	 */
+	if (info->reshape_progress % blocks_per_unit)
+		super->migr_rec->curr_migr_unit++;
+	super->migr_rec->curr_migr_unit =
+		__cpu_to_le32(super->migr_rec->curr_migr_unit);
+
 	super->migr_rec->rec_status = __cpu_to_le32(state);
 	super->migr_rec->dest_1st_member_lba =
 	  __cpu_to_le32((__le32_to_cpu(super->migr_rec->curr_migr_unit))

