From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 20/34] imsm: FIX: Division by 0
Date: Tue, 04 Jan 2011 15:38:16 +0100
Message-ID: <20110104143816.6697.27047.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

For general migration function blocks_per_migr_unit() has to return valid value.
If there is no valid return, 0 is returned instead and causes division by 0 error.
Additionally guard in function was added for such case.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 58ed702..dc4f308 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1498,6 +1498,7 @@ static __u64 blocks_per_migr_unit(struct imsm_dev *dev)
 		return 0;
 
 	switch (migr_type(dev)) {
+	case MIGR_GEN_MIGR:
 	case MIGR_VERIFY:
 	case MIGR_REPAIR:
 	case MIGR_INIT: {
@@ -1534,8 +1535,6 @@ static __u64 blocks_per_migr_unit(struct imsm_dev *dev)
 		migr_chunk = migr_strip_blocks_rebuild(dev);
 		return migr_chunk * stripes_per_unit;
 	}
-	case MIGR_GEN_MIGR:
-		/* FIXME I need a number here */
 	case MIGR_STATE_CHANGE:
 	default:
 		return 0;
@@ -4889,10 +4888,14 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 			/* still reshaping, maybe update curr_migr_unit */
 			long long blocks_per_unit = blocks_per_migr_unit(dev);
 			long long unit = a->last_checkpoint;
-			unit /= blocks_per_unit;
-			if (unit > __le32_to_cpu(dev->vol.curr_migr_unit)) {
-				dev->vol.curr_migr_unit = __cpu_to_le32(unit);
-				super->updates_pending++;
+			if (blocks_per_unit) {
+				unit /= blocks_per_unit;
+				if (unit >
+				    __le32_to_cpu(dev->vol.curr_migr_unit)) {
+					dev->vol.curr_migr_unit =
+						__cpu_to_le32(unit);
+					super->updates_pending++;
+				}
 			}
 			return 0;
 		} else {

