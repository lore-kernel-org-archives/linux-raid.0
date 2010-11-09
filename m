From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 17/31] imsm: FIX: Fill delta_disks field in getinfo_super()
Date: Tue, 9 Nov 2010 17:01:16 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CAA0@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

delta_disks field is not always filled during getinfo_super() call.
---

 mdadm/mdadm/super-intel.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c index 4e4e256..e35c6dc 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -1487,6 +1487,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 	struct intel_super *super = st->sb;
 	struct imsm_dev *dev = get_imsm_dev(super, super->current_vol);
 	struct imsm_map *map = get_imsm_map(dev, 0);
+	struct imsm_map *map2 = get_imsm_map(dev, 1);
 	struct dl *dl;
 	char *devname;
 	int minor;
@@ -1566,6 +1567,12 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 	 */
 	if (find_array_minor2(info->text_version, 1, &minor) == 0)
 		sprintf(info->sys_name, "md%i", minor);
+
+	/* fill delta_disks field
+	 */
+	info->delta_disks = 0;
+	if (map2)
+		info->delta_disks = map->num_members - map2->num_members;
 }
 
 /* check the config file to see if we can return a real uuid for this spare */

