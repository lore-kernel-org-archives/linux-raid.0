From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH] imsm: incorrect incremental behavior because of wrong index
 used
Date: Wed, 23 Nov 2011 17:59:43 +0100
Message-ID: <20111123165943.25613.20161.stgit@gklab-154-231>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Incremental in some cases prematurely assembles degraded arrays due to
wrong index used in code which counts missing disks

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 super-intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 360c4cc..a0672bf 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2539,7 +2539,7 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 		 * (catches single-degraded vs double-degraded)
 		 */
 		for (j = 0; j < map->num_members; j++) {
-			__u32 ord = get_imsm_ord_tbl_ent(dev, i, 0);
+			__u32 ord = get_imsm_ord_tbl_ent(dev, j, 0);
 			__u32 idx = ord_to_idx(ord);
 
 			if (!(ord & IMSM_ORD_REBUILD) &&

