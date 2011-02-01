From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/8] imsm: FIX: array size is wrong
Date: Tue, 01 Feb 2011 14:49:12 +0100
Message-ID: <20110201134912.13398.64773.stgit@gklab-128-013.igk.intel.com>
References: <20110201134226.13398.4071.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110201134226.13398.4071.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Calculation of size is almost ok, except concept of blocks.
Size for setting in md has to be divided by 2 to be correct.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index ee0d9c4..42f7065 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5187,7 +5187,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 					<< SECT_PER_MB_SHIFT;
 				dev->size_low = __cpu_to_le32((__u32) array_blocks);
 				dev->size_high = __cpu_to_le32((__u32) (array_blocks >> 32));
-				a->info.custom_array_size = array_blocks;
+				a->info.custom_array_size = array_blocks/2;
 				a->check_reshape = 1; /* encourage manager to update
 						       * array size
 						       */

