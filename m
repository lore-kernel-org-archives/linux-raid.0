From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 04/13] fix: possible segfault if current_vol does not match
 subarray
Date: Thu, 22 Apr 2010 23:11:21 +0100
Message-ID: <66C59AD0932712458090B447266D638CD405E3B7@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

If super->current_vol points to index that does not exist, dev becomes NULL. It causes segfault during an attempt to read its contents (issue found by
Klocwork)

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 super-intel.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index a196ca3..1a536f9 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1421,10 +1421,14 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 {
 	struct intel_super *super = st->sb;
 	struct imsm_dev *dev = get_imsm_dev(super, super->current_vol);
-	struct imsm_map *map = get_imsm_map(dev, 0);
+	struct imsm_map *map;
 	struct dl *dl;
 	char *devname;
 
+	if (!dev)
+		return;
+	map = get_imsm_map(dev, 0);
+
 	for (dl = super->disks; dl; dl = dl->next)
 		if (dl->raiddisk == info->disk.raid_disk)
 			break;
-- 
1.6.4.2


--
Best Regards,
Przemyslaw Hawrylewicz-Czarnowski
Software Development Engineer


