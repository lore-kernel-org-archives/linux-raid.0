From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 16/31] imsm: FIX: Fill sys_name field in getinfo_super()
Date: Tue, 9 Nov 2010 17:01:16 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CA9F@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

sys_name field is not filled during getinfo_super() call.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/super-intel.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c index 9c6bf38..4e4e256 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -1489,6 +1489,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 	struct imsm_map *map = get_imsm_map(dev, 0);
 	struct dl *dl;
 	char *devname;
+	int minor;
 
 	for (dl = super->disks; dl; dl = dl->next)
 		if (dl->raiddisk == info->disk.raid_disk) @@ -1560,6 +1561,11 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 	free(devname);
 	info->safe_mode_delay = 4000;  /* 4 secs like the Matrix driver */
 	uuid_from_super_imsm(st, info->uuid);
+
+	/* fill sys_name field
+	 */
+	if (find_array_minor2(info->text_version, 1, &minor) == 0)
+		sprintf(info->sys_name, "md%i", minor);
 }
 
 /* check the config file to see if we can return a real uuid for this spare */ @@ -1611,6 +1617,7 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info)  {
 	struct intel_super *super = st->sb;
 	struct imsm_disk *disk;
+	int minor;
 
 	if (super->current_vol >= 0) {
 		getinfo_super_imsm_volume(st, info);
@@ -1712,6 +1719,10 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info)
 		memcpy(info->uuid, uuid_match_any, sizeof(int[4]));
 		fixup_container_spare_uuid(info);
 	}
+	/* fill sys_name field
+	 */
+	if (find_array_minor2(info->text_version, 1, &minor) == 0)
+		sprintf(info->sys_name, "md%i", minor);
 }
 
 static int is_raid_level_supported(const struct imsm_orom *orom, int level, int raiddisks);

