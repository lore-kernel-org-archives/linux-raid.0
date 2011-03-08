From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 14/14] platform_intel: support for OROM OEM capabilities
Date: Tue, 8 Mar 2011 15:21:38 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A8AEC98@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From 8851572a406e938f50466a98405b10529048e766 Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Mon, 7 Mar 2011 16:17:54 +0100
Subject: [PATCH 14/14] platform_intel: support for OROM OEM capabilities

Scan memory to match $VER and $OEM.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 platform-intel.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 2742305..b83a0b2 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -205,7 +205,8 @@ static int scan(const void *start, const void *end, const void *data)
 	
 	for (offset = 0; offset < len; offset += 4) {
 		imsm_mem = start + offset;
-		if (memcmp(imsm_mem->signature, "$VER", 4) == 0) {
+		if ((memcmp(imsm_mem->signature, "$VER", 4) == 0) ||
+		    (memcmp(imsm_mem->signature, "$OEM", 4) == 0)) {
 			imsm_orom[dev] = *imsm_mem;
 			populated_orom[dev] = 1;
 			return populated_orom[SYS_DEV_SATA] && populated_orom[SYS_DEV_SAS];
-- 
1.6.4.2

