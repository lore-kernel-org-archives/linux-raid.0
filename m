From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 10/21] imsm: FIX: Do not use pba_of_lba0 for copy position
	calculation
Date: Wed, 08 Jun 2011 18:10:54 +0200
Message-ID: <20110608161054.24327.30419.stgit@gklab-128-013.igk.intel.com>
References: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

imsm_manage_reshape() should not shift start copy position.
This offset is passed to manage reshape function /and it is used/
as input parameter in offsets table already.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 437975f..b22c7df 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8765,9 +8765,7 @@ static int imsm_manage_reshape(
 		if ((current_position + next_step) > max_position)
 			next_step = max_position - current_position;
 
-		start = (__le32_to_cpu(map_src->pba_of_lba0) +
-			 __le32_to_cpu(dev->reserved_blocks) +
-			 current_position) * 512;
+		start = current_position * 512;
 
 		/* allign reading start to old geometry */
 		start_buf_shift = start % old_data_stripe_length;

