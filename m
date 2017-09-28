From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 11/12] imsm: use correct map when validating ppl
Date: Thu, 28 Sep 2017 14:41:17 +0200
Message-ID: <20170928124118.23361-12-pawel.baldysiak@intel.com>
References: <20170928124118.23361-1-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170928124118.23361-1-pawel.baldysiak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

Use the first map to get the correct disk when rebuilding and not the
failed disk from the second map.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 super-intel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 56c60423..8f89930a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6119,7 +6119,6 @@ static int validate_ppl_imsm(struct supertype *st, struct mdinfo *info,
 	struct ppl_header *ppl_hdr;
 	__u32 crc;
 	struct imsm_dev *dev;
-	struct imsm_map *map;
 	__u32 idx;
 	unsigned int i;
 	unsigned long long ppl_offset = 0;
@@ -6134,8 +6133,7 @@ static int validate_ppl_imsm(struct supertype *st, struct mdinfo *info,
 	}
 
 	dev = get_imsm_dev(super, info->container_member);
-	map = get_imsm_map(dev, MAP_X);
-	idx = get_imsm_disk_idx(dev, disk->disk.raid_disk, MAP_X);
+	idx = get_imsm_disk_idx(dev, disk->disk.raid_disk, MAP_0);
 	d = get_imsm_dl_disk(super, idx);
 
 	if (!d || d->index < 0 || is_failed(&d->disk))
@@ -6225,6 +6223,8 @@ out:
 	}
 
 	if (ret == 1) {
+		struct imsm_map *map = get_imsm_map(dev, MAP_X);
+
 		if (map->map_state == IMSM_T_STATE_UNINITIALIZED ||
 		   (map->map_state == IMSM_T_STATE_NORMAL &&
 		   !(dev->vol.dirty & RAIDVOL_DIRTY)))
-- 
2.13.5

