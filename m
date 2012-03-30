From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH] imsm: set 2tb disk attribute for spare
Date: Fri, 30 Mar 2012 21:34:40 +0000
Message-ID: <3F8F31A3BFD1664EAB894D1BD6AF32B918A20A23@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>
List-Id: linux-raid.ids

Hi Neil,
missed one patch from the series. This one ensures metadata attribute is set correctly also for spares.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 super-intel.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 393a657..ed13542 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5048,6 +5048,10 @@ static int write_super_imsm_spares(struct intel_super *super, int doclose)
 			continue;
 
 		spare->disk[0] = d->disk;
+		if (__le32_to_cpu(d->disk.total_blocks_hi) > 0) {
+			spare->attributes |= MPB_ATTRIB_2TB_DISK;
+		}
+
 		sum = __gen_imsm_checksum(spare);
 		spare->family_num = __cpu_to_le32(sum);
 		spare->orig_family_num = 0;
-- 
1.6.4.2

