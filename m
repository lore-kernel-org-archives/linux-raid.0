From: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: [PATCH] imsm: New disk controller domains
Date: Thu,  7 Sep 2017 16:05:09 +0200
Message-ID: <1504793109-16291-1-git-send-email-mariusz.tkaczyk@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
List-Id: linux-raid.ids

Add disk controller domain for nvme and vmd devices to prevent moving 
spares between different domains.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
---
 super-intel.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index 125c3a9..bbe7bc7 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -10749,6 +10749,10 @@ static const char *imsm_get_disk_controller_domain(const char *path)
 			drv = "isci";
 		else if (hba && hba->type == SYS_DEV_SATA)
 			drv = "ahci";
+		else if (hba && hba->type == SYS_DEV_VMD)
+			drv = "vmd";
+		else if (hba && hba->type == SYS_DEV_NVME)
+			drv = "nvme";
 		else
 			drv = "unknown";
 		dprintf("path: %s hba: %s attached: %s\n",
-- 
1.8.3.1

