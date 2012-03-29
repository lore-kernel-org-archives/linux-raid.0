From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 4/6] show 2TB volumes/disks support in --detail-platform
Date: Thu, 29 Mar 2012 12:43:18 +0000
Message-ID: <3F8F31A3BFD1664EAB894D1BD6AF32B918A205E6@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 platform-intel.h |    1 +
 super-intel.c    |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/platform-intel.h b/platform-intel.h
index c997f1b..94f2e81 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -76,6 +76,7 @@ struct imsm_orom {
 	#define IMSM_OROM_ATTR_RAID1E IMSM_OROM_RLC_RAID1E
 	#define IMSM_OROM_ATTR_RAID5 IMSM_OROM_RLC_RAID5
 	#define IMSM_OROM_ATTR_RAID_CNG IMSM_OROM_RLC_RAID_CNG
+	#define IMSM_OROM_ATTR_2TB_DISK (1 << 26)
 	#define IMSM_OROM_ATTR_2TB (1 << 29)
 	#define IMSM_OROM_ATTR_PM (1 << 30)
 	#define IMSM_OROM_ATTR_ChecksumVerify (1 << 31)
diff --git a/super-intel.c b/super-intel.c
index c27badc..820ffd0 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1785,6 +1785,10 @@ static void print_imsm_capability(const struct imsm_orom *orom)
 	       imsm_orom_has_chunk(orom, 1024*64) ? " 64M" : "");
 	printf("      Max Disks : %d\n", orom->tds);
 	printf("    Max Volumes : %d\n", orom->vpa);
+	printf("    2TB volumes :%s supported\n",
+	       (orom->attr & IMSM_OROM_ATTR_2TB)?"":" not");
+	printf("      2TB disks :%s supported\n",
+	       (orom->attr & IMSM_OROM_ATTR_2TB_DISK)?"":" not");
 	return;
 }
 
-- 
1.6.4.2

