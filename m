From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/3] imsm: FIX: initalize reshape progress as it is stored in
	metatdata
Date: Tue, 22 Feb 2011 15:13:23 +0100
Message-ID: <20110222141323.7582.7831.stgit@gklab-128-013.igk.intel.com>
References: <20110222135440.7582.87319.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110222135440.7582.87319.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

reshape prodess cannot be restarted due to no checkpoint information
in mdinfo.
When metadata is read during reshape process or reshape restart,
rehape_progress (mdinfo field) has to be initialized to value
stored in metadata. This allows start reshape from stored
in metadata checkpoint.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e8d2c6b..1b3407a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1784,6 +1784,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	else
 		info->delta_disks = 0;
 
+	info->reshape_progress = 0;
 	if (map_to_analyse->map_state == IMSM_T_STATE_UNINITIALIZED ||
 	    dev->vol.dirty) {
 		info->resync_start = 0;
@@ -1797,6 +1798,15 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 			info->resync_start = blocks_per_unit * units;
 			break;
 		}
+		case MIGR_GEN_MIGR: {
+			__u64 blocks_per_unit = blocks_per_migr_unit(dev);
+			__u64 units = __le32_to_cpu(dev->vol.curr_migr_unit);
+
+			info->reshape_progress = blocks_per_unit * units;
+			dprintf("IMSM: General Migration checkpoint : %llu "
+			       "(%llu) -> read reshape progress : %llu\n",
+				units, blocks_per_unit, info->reshape_progress);
+		}
 		case MIGR_VERIFY:
 			/* we could emulate the checkpointing of
 			 * 'sync_action=check' migrations, but for now
@@ -1804,7 +1814,6 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 			 */
 		case MIGR_REBUILD:
 			/* this is handled by container_content_imsm() */
-		case MIGR_GEN_MIGR:
 		case MIGR_STATE_CHANGE:
 			/* FIXME handle other migrations */
 		default:

