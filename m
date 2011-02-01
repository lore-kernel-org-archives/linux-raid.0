From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 5/8] imsm: fix: imsm_num_data_members() can return error
Date: Tue, 01 Feb 2011 14:49:36 +0100
Message-ID: <20110201134936.13398.60522.stgit@gklab-128-013.igk.intel.com>
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

imsm_num_data_members() can indicate error by returning 0 value
In such case size cannot be set based on 0 value.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index d6c2756..f604589 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5178,15 +5178,22 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 				struct mdinfo *mdi;
 
 				used_disks = imsm_num_data_members(dev, -1);
-				array_blocks = map->blocks_per_member * used_disks;
-				/* round array size down to closest MB */
-				array_blocks = (array_blocks >> SECT_PER_MB_SHIFT)
-					<< SECT_PER_MB_SHIFT;
-				a->info.custom_array_size = array_blocks/2;
-				a->check_reshape = 1; /* encourage manager to update
-						       * array size
-						       */
-
+				if (used_disks > 0) {
+					array_blocks =
+						map->blocks_per_member *
+						used_disks;
+					/* round array size down to closest MB
+					*/
+					array_blocks = (array_blocks
+							>> SECT_PER_MB_SHIFT)
+							<< SECT_PER_MB_SHIFT;
+					a->info.custom_array_size =
+						array_blocks/2;
+					/* encourage manager to update array
+					 * size
+					 */
+					a->check_reshape = 1;
+				}
 				/* finalize online capacity expansion/reshape */
 				for (mdi = a->info.devs; mdi; mdi = mdi->next)
 					imsm_set_disk(a,

