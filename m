From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 2/6] clear hi bits if not used after loading metadata from
 disk
Date: Thu, 29 Mar 2012 12:43:05 +0000
Message-ID: <3F8F31A3BFD1664EAB894D1BD6AF32B918A205D6@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Functions retrieving sizes from metadata do not need to check
2TB attribute only when we can guarantee the hi bits are always
clear when the MPB_ATTR_2TB_DISK attribute is not set.

Therefore the following fields are cleared on metadata load
when not in use according to attribute:
struct imsm_disk.total_blocks_hi
struct imsm_map.pba_of_lba0_hi
struct imsm_map.blocks_per_member_hi
struct imsm_map.num_data_stripes_hi

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 super-intel.c |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 9147016..36e8878 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3590,6 +3590,32 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 
 static int read_imsm_migr_rec(int fd, struct intel_super *super);
 
+/* clears hi bits in metadata if MPB_ATTRIB_2TB_DISK not set */
+static void clear_hi(struct intel_super *super)
+{
+	struct imsm_super *mpb = super->anchor;
+	int i, n;
+	if (mpb->attributes & MPB_ATTRIB_2TB_DISK)
+		return;
+	for (i = 0; i < mpb->num_disks; ++i) {
+		struct imsm_disk *disk = &mpb->disk[i];
+		disk->total_blocks_hi = 0;
+	}
+	for (i = 0; i < mpb->num_raid_devs; ++i) {
+		struct imsm_dev *dev = get_imsm_dev(super, i);
+		if (!dev) 
+			return;
+		for (n = 0; n < 2; ++n) {
+			struct imsm_map *map = get_imsm_map(dev, n);
+			if (!map)
+				continue;
+			map->pba_of_lba0_hi = 0;
+			map->blocks_per_member_hi = 0;
+			map->num_data_stripes_hi = 0;
+		}
+	}
+}
+
 static int
 load_and_parse_mpb(int fd, struct intel_super *super, char *devname, int keep_fd)
 {
@@ -3602,7 +3628,7 @@ load_and_parse_mpb(int fd, struct intel_super *super, char *devname, int keep_fd
 	if (err)
 		return err;
 	err = parse_raid_devices(super);
-
+	clear_hi(super);
 	return err;
 }
 
-- 
1.6.4.2

