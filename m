From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 14/23] imsm: Add support for finalize expansion in
 end_migration()
Date: Wed, 9 Jun 2010 15:36:41 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11EECE8E0@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

(Online Capacity Expansion for IMSM)
To finalize migration, disk ord values have to be merged correctly during
end_migration() call. This is not guaranteed, that disk position in array cannot change. The added (new) disks ord cannot be merged as they not exists in old configuration also. We need merge rebuild flags based on matching disks indexes, not on current disk position in the map.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c index 7ec7ec5..6af79a8 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2342,16 +2342,23 @@ static void end_migration(struct imsm_dev *dev, __u8 map_state)  {
 	struct imsm_map *map = get_imsm_map(dev, 0);
 	struct imsm_map *prev = get_imsm_map(dev, dev->vol.migr_state);
-	int i;
+	int i, j;
 
 	/* merge any IMSM_ORD_REBUILD bits that were not successfully
 	 * completed in the last migration.
 	 *
-	 * FIXME add support for online capacity expansion and
-	 * raid-level-migration
+	 * FIXME add support for raid-level-migration
 	 */
 	for (i = 0; i < prev->num_members; i++)
-		map->disk_ord_tbl[i] |= prev->disk_ord_tbl[i];
+		for (j = 0; j < map->num_members; j++)
+			/* during online capacity expansion
+			 * disks position can be changed if takeover is used
+			 */
+			if (ord_to_idx(map->disk_ord_tbl[j]) ==
+			    ord_to_idx(prev->disk_ord_tbl[i])) {
+				map->disk_ord_tbl[j] |= prev->disk_ord_tbl[i];
+				break;
+			}
 
 	dev->vol.migr_state = 0;
 	dev->vol.curr_migr_unit = 0;

