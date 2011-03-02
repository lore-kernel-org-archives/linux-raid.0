From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/9] imsm: FIX: Return blocks_per unit for general migration
Date: Wed, 02 Mar 2011 14:29:20 +0100
Message-ID: <20110302132920.24771.49777.stgit@gklab-128-013.igk.intel.com>
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

For general migration, blocks per unit are required for all disks,
not for per-member.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 1a7be71..11972f3 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1690,6 +1690,8 @@ static __u64 blocks_per_migr_unit(struct imsm_dev *dev)
 		migr_chunk = migr_strip_blocks_resync(dev);
 		disks = imsm_num_data_members(dev, 0);
 		blocks_per_unit = stripes_per_unit * migr_chunk * disks;
+		if (migr_type(dev) == MIGR_GEN_MIGR)
+			return blocks_per_unit;
 		stripe = __le32_to_cpu(map->blocks_per_strip) * disks;
 		segment = blocks_per_unit / stripe;
 		block_rel = blocks_per_unit - segment * stripe;

