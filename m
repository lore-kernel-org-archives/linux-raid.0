From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 9/9] imsm : FIX: Assemble dirty array when reshape is in
	progress
Date: Wed, 09 Mar 2011 14:46:42 +0100
Message-ID: <20110309134642.8939.6587.stgit@gklab-128-013.igk.intel.com>
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

During reshape for dirty volumes reshape_progress has to be calculated also.
To keep the same logic for array creation:
not setting info->resync_start = MaxSector when first condition is true,
resync_start is initialized by MaxSector to allow proper array initialization.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 4e3de8a..38756e2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1820,10 +1820,12 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	info->recovery_start = MaxSector;
 
 	info->reshape_progress = 0;
+	info->resync_start = MaxSector;
 	if (map_to_analyse->map_state == IMSM_T_STATE_UNINITIALIZED ||
 	    dev->vol.dirty) {
 		info->resync_start = 0;
-	} else if (dev->vol.migr_state) {
+	}
+	if (dev->vol.migr_state) {
 		switch (migr_type(dev)) {
 		case MIGR_REPAIR:
 		case MIGR_INIT: {
@@ -1868,8 +1870,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 			/* we are not dirty, so... */
 			info->resync_start = MaxSector;
 		}
-	} else
-		info->resync_start = MaxSector;
+	}
 
 	strncpy(info->name, (char *) dev->volume, MAX_RAID_SERIAL_LEN);
 	info->name[MAX_RAID_SERIAL_LEN] = 0;

