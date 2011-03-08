From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 08/14] imsm: do not publish OROM/EFI unsupported arrays
Date: Tue, 8 Mar 2011 15:21:06 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A8AEC91@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From 539ad60606fdc8c19b7b7caf6d89b87a7656daaf Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Thu, 3 Mar 2011 15:01:53 +0100
Subject: [PATCH 08/14] imsm: do not publish OROM/EFI unsupported arrays

Container_content_imsm calls validate_goemtry_imsm_orom to verify that
the array parameters are supported by controller's OROM/EFI.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 02952a4..e65a46c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4844,7 +4844,21 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 				dev->volume);
 			continue;
 		}
+		/* do not publish arrays that are not support by controller's
+		 * OROM/EFI
+		 */
 
+		int chunk = __le16_to_cpu(map->blocks_per_strip) >> 1;
+		if (!validate_geometry_imsm_orom(super,
+						 get_imsm_raid_level(map), /* RAID level */
+						 imsm_level_to_layout(get_imsm_raid_level(map)),
+						 map->num_members, /* raid disks */
+						 chunk,
+						 1 /* verbose */)) {
+			fprintf(stderr, Name ": RAID gemetry validation failed. "
+				"Cannot proceed with the action(s).\n");
+			continue;
+		}
 		this = malloc(sizeof(*this));
 		if (!this) {
 			fprintf(stderr, Name ": failed to allocate %zu bytes\n",
-- 
1.6.4.2

