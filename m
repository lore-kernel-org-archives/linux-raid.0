From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 9/9] imsm: FIX: Variables declaration cleanup
Date: Wed, 02 Mar 2011 14:30:07 +0100
Message-ID: <20110302133007.24771.40353.stgit@gklab-128-013.igk.intel.com>
References: <20110302132426.24771.99191.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110302132426.24771.99191.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Variables declaration moved a little bit up,
to not mix declaration and code.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 04e32ae..c5e459f 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1803,13 +1803,13 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 		case MIGR_GEN_MIGR: {
 			__u64 blocks_per_unit = blocks_per_migr_unit(dev);
 			__u64 units = __le32_to_cpu(dev->vol.curr_migr_unit);
+			unsigned long long array_blocks;
+			int used_disks;
 
 			info->reshape_progress = blocks_per_unit * units;
 			dprintf("IMSM: General Migration checkpoint : %llu "
 			       "(%llu) -> read reshape progress : %llu\n",
 				units, blocks_per_unit, info->reshape_progress);
-			unsigned long long array_blocks;
-			int used_disks;
 
 			used_disks = imsm_num_data_members(dev, 1);
 			if (used_disks > 0) {

