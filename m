From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 03/14] update of imsm_orom structure
Date: Tue, 8 Mar 2011 15:20:39 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A8AEC8C@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

From 62e00fa0b05958a0fd62d23105f0f755daa206c4 Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Mon, 7 Mar 2011 16:08:37 +0100
Subject: [PATCH 03/14] update of imsm_orom structure

The structure is update according to current specification. These values
are not used right now, but they are not "reserved" anymore.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 platform-intel.h |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/platform-intel.h b/platform-intel.h
index 18f1ea2..549ced5 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -79,8 +79,20 @@ struct imsm_orom {
 	#define IMSM_OROM_ATTR_2TB (1 << 29)
 	#define IMSM_OROM_ATTR_PM (1 << 30)
 	#define IMSM_OROM_ATTR_ChecksumVerify (1 << 31)
-	__u32 reserved1;
-	__u32 reserved2;
+	__u32 capabilities;
+	#define IMSM_OROM_CAPABILITIES_Ext_SATA (1 << 0)
+	#define IMSM_OROM_CAPABILITIES_TurboMemory (1 << 1)
+	#define IMSM_OROM_CAPABILITIES_HddPassword (1 << 2)
+	#define IMSM_OROM_CAPABILITIES_DiskCoercion (1 << 3)
+	__u32 driver_features;
+	#define IMSM_OROM_CAPABILITIES_HDDUnlock (1 << 0)
+	#define IMSM_OROM_CAPABILITIES_LEDLoc (1 << 1)
+	#define IMSM_OROM_CAPABILITIES_EnterpriseSystem (1 << 2)
+	#define IMSM_OROM_CAPABILITIES_Zpodd (1 << 3)
+	#define IMSM_OROM_CAPABILITIES_LargeDramCache (1 << 4)
+	#define IMSM_OROM_CAPABILITIES_Rohi (1 << 5)
+	#define IMSM_OROM_CAPABILITIES_ReadPatrol (1 << 6)
+	#define IMSM_OROM_CAPABILITIES_XorHw (1 << 7)
 } __attribute__((packed));
 
 static inline int imsm_orom_has_raid0(const struct imsm_orom *orom)
-- 
1.6.4.2

