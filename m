From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] imsm: FIX: Migration Raid0->Raid5 cannot be restarted
	correctly
Date: Fri, 10 Jun 2011 16:44:07 +0200
Message-ID: <20110610144407.12333.58283.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When array raid0 is migrated to raid5, reshape cannot be continued
correctly due to wrong array parameters settings.
Raid disks number is set too big.

There is no need, during raid0->raid5 migration to increase
info->array.raid_disks, it is already set to final value using
designation map information.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 075385a..40fd940 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2133,7 +2133,6 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 				/* conversion is happening as RAID5 */
 				info->array.level = 5;
 				info->array.layout = ALGORITHM_PARITY_N;
-				info->array.raid_disks += 1;
 				info->delta_disks -= 1;
 				break;
 			default:

