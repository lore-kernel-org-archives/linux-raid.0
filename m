From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] imsm: FIX: Do not write check-point '0'
Date: Fri, 29 Apr 2011 16:29:21 +0200
Message-ID: <20110429142921.12605.54696.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When 2 arrays are configured in container and arrays are reassembled during
rebuild or initialization, checkpoint for one array can be reset. It depends
on arrays assembly order.

Scenario:
1. Create 2 arrays (e.g. raid5)
2. Add spare to container
3. Degrade arrays /rebuild starts on array #1 and continues to n%/
4. Reassembly arrays
5. Rebuild starts on array #2 /because of assembly order/ from 0%
6. On first checkpoint stored for array #2 (non 0 value), checkpoint
   for array #1 is cleared /it is delayed rebuild in md, so progress is 0/
7. Rebuild on #1 starts from n% /it was configured before checkpoint
   was cleared/.

Any next reassembly during rebuild of #2 array (after p.6) causes
checkpoint information lost for array #1.

Solution is not store checkpoint for progress == 0.
Checkpoint is set to 0 when rebuild/initialization starts.

Note: Please apply this patch on master branch.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 83135a6..0956c92 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5479,6 +5479,7 @@ mark_checkpoint:
 		 * curr_migr_unit needs updating
 		 */
 		if (units32 == units &&
+		    units32 != 0 &&
 		    __le32_to_cpu(dev->vol.curr_migr_unit) != units32) {
 			dprintf("imsm: mark checkpoint (%u)\n", units32);
 			dev->vol.curr_migr_unit = __cpu_to_le32(units32);

