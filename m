From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/2] imsm: FIX: Mark checkpoint and array state clean during
	reshape
Date: Tue, 08 Mar 2011 08:37:47 +0100
Message-ID: <20110308073747.8142.26184.stgit@gklab-128-013.igk.intel.com>
References: <20110308073739.8142.87741.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110308073739.8142.87741.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Array state has to be managed during reshape based on consistent flag.
To achieve this existing code will be reused. Currently existing code for
blocks_per_unit calculation can be removed
and existing code can be reused also.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index c5e459f..c0bff98 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5210,19 +5210,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 		 */
 		if (a->curr_action == reshape) {
 			/* still reshaping, maybe update curr_migr_unit */
-			long long blocks_per_unit = blocks_per_migr_unit(dev);
-			long long unit = a->last_checkpoint;
-			if (blocks_per_unit) {
-				unit /= blocks_per_unit;
-				if (unit >
-				    __le32_to_cpu(dev->vol.curr_migr_unit)) {
-					dev->vol.curr_migr_unit =
-						__cpu_to_le32(unit);
-					dev->vol.dirty = 0;
-					super->updates_pending++;
-				}
-			}
-			return 0;
+			goto mark_checkpoint;
 		} else {
 			if (a->last_checkpoint == 0 && a->prev_action == reshape) {
 				/* for some reason we aborted the reshape.
@@ -5299,6 +5287,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 		super->updates_pending++;
 	}
 
+mark_checkpoint:
 	/* check if we can update curr_migr_unit from resync_start, recovery_start */
 	blocks_per_unit = blocks_per_migr_unit(dev);
 	if (blocks_per_unit) {

