From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/3] imsm: FIX: Report correct array size during reshape
Date: Tue, 22 Feb 2011 15:13:31 +0100
Message-ID: <20110222141331.7582.97241.stgit@gklab-128-013.igk.intel.com>
References: <20110222135440.7582.87319.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110222135440.7582.87319.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When reshape is started imsm stores new size in metadata.
mdadm requires "old" size to proper initialization restarted array.

When reshape is in progress getinfo_super_imsm_volume() should report
computed array size value instead array size stored in metatda.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 1b3407a..c101dca 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1806,6 +1806,19 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 			dprintf("IMSM: General Migration checkpoint : %llu "
 			       "(%llu) -> read reshape progress : %llu\n",
 				units, blocks_per_unit, info->reshape_progress);
+			unsigned long long array_blocks;
+			int used_disks;
+
+			used_disks = imsm_num_data_members(dev, 1);
+			if (used_disks > 0) {
+				array_blocks = map->blocks_per_member *
+					used_disks;
+				/* round array size down to closest MB
+				 */
+				info->custom_array_size = (array_blocks
+						>> SECT_PER_MB_SHIFT)
+						<< SECT_PER_MB_SHIFT;
+			}
 		}
 		case MIGR_VERIFY:
 			/* we could emulate the checkpointing of

