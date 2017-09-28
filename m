From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 12/12] imsm: write initial ppl on a disk added for rebuild
Date: Thu, 28 Sep 2017 14:41:18 +0200
Message-ID: <20170928124118.23361-13-pawel.baldysiak@intel.com>
References: <20170928124118.23361-1-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170928124118.23361-1-pawel.baldysiak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

When rebuild is initiated by the UEFI driver it is possible that the new
disk will not contain a valid ppl header. Just write the initial ppl
and don't abort assembly.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 super-intel.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/super-intel.c b/super-intel.c
index 8f89930a..53385018 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6227,7 +6227,10 @@ out:
 
 		if (map->map_state == IMSM_T_STATE_UNINITIALIZED ||
 		   (map->map_state == IMSM_T_STATE_NORMAL &&
-		   !(dev->vol.dirty & RAIDVOL_DIRTY)))
+		   !(dev->vol.dirty & RAIDVOL_DIRTY)) ||
+		   (dev->vol.migr_state == MIGR_REBUILD &&
+		    dev->vol.curr_migr_unit == 0 &&
+		    get_imsm_disk_idx(dev, disk->disk.raid_disk, MAP_1) != idx))
 			ret = st->ss->write_init_ppl(st, info, d->fd);
 		else
 			info->mismatch_cnt++;
-- 
2.13.5

