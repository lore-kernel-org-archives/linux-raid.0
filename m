From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 14/31] imsm: Do not indicate resync during reshape
Date: Tue, 9 Nov 2010 17:01:14 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CAA4@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

If reshape is started resync is not allowed in parallel. This would break reshape.
If array is in General Migration state do not indicate resync and allow for reshape continuation.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/super-intel.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c index 3d14f1f..9c6bf38 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -4677,9 +4677,13 @@ static int is_resyncing(struct imsm_dev *dev)
 	    migr_type(dev) == MIGR_REPAIR)
 		return 1;
 
+	if (migr_type(dev) == MIGR_GEN_MIGR)
+		return 0;
+
 	migr_map = get_imsm_map(dev, 1);
 
-	if (migr_map->map_state == IMSM_T_STATE_NORMAL)
+	if ((migr_map->map_state == IMSM_T_STATE_NORMAL) &&
+	    (dev->vol.migr_type != MIGR_GEN_MIGR))
 		return 1;
 	else
 		return 0;

