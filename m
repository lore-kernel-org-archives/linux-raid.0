From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 2/2] fix: imsm: assemble doesn't restart recovery
Date: Thu, 10 Feb 2011 08:35:05 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0111498562@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From 0dac844675a298df6c7d05445edac815db7e4419 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Wed, 9 Feb 2011 09:52:00 +0100
Subject: [PATCH 2/2] fix: imsm: assemble doesn't restart recovery
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

Because IMSM_ORD_REBUILD is set in second map not first.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 super-intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 5c16137..29f8fc4 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4780,7 +4780,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 
 			skip = 0;
 			idx = get_imsm_disk_idx(dev, slot, 0);
-			ord = get_imsm_ord_tbl_ent(dev, slot, 0);
+			ord = get_imsm_ord_tbl_ent(dev, slot, -1);
 			for (d = super->disks; d ; d = d->next)
 				if (d->index == idx)
 					break;
-- 
1.7.1

