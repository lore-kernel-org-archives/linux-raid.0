From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH] imsm: display maximum volumes per controller and array
Date: Wed, 11 Apr 2012 14:25:41 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D41861C0FB@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Display maximum volumes per array and per controller
in --detail-platform command.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index dad4c4d..1e6df30 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1783,12 +1783,13 @@ static void print_imsm_capability(const struct imsm_orom *orom)
 	       imsm_orom_has_chunk(orom, 1024*16) ? " 16M" : "",
 	       imsm_orom_has_chunk(orom, 1024*32) ? " 32M" : "",
 	       imsm_orom_has_chunk(orom, 1024*64) ? " 64M" : "");
-	printf("      Max Disks : %d\n", orom->tds);
-	printf("    Max Volumes : %d\n", orom->vpa);
 	printf("    2TB volumes :%s supported\n",
 	       (orom->attr & IMSM_OROM_ATTR_2TB)?"":" not");
 	printf("      2TB disks :%s supported\n",
 	       (orom->attr & IMSM_OROM_ATTR_2TB_DISK)?"":" not");
+	printf("    Max Disks                 : %d\n", orom->tds);
+	printf("    Max Volumes per array     : %d\n", orom->vpa);
+	printf("    Max Volumes per controller: %d\n", orom->vphba);
 	return;
 }
 
-- 
1.7.4
