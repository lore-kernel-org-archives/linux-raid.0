From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/9] imsm: FIX: Do not clean checkpoint for active reshape
Date: Wed, 09 Mar 2011 14:46:02 +0100
Message-ID: <20110309134602.8939.42234.stgit@gklab-128-013.igk.intel.com>
References: <20110309134019.8939.15438.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110309134019.8939.15438.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Smaller checkpoint can be stored when metadata is not in migration state
(this means when there is no second map).
Without this additional condition it can occur that during array start/stop
sequence checkpoint was roll back to 0.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index cd409e9..4e3de8a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5335,9 +5335,15 @@ mark_checkpoint:
 		 */
 		if (units32 == units &&
 		    __le32_to_cpu(dev->vol.curr_migr_unit) != units32) {
-			dprintf("imsm: mark checkpoint (%u)\n", units32);
-			dev->vol.curr_migr_unit = __cpu_to_le32(units32);
-			super->updates_pending++;
+			struct imsm_map *map2 = get_imsm_map(dev, 1);
+			if ((__le32_to_cpu(dev->vol.curr_migr_unit) < units32)
+			    || (map2 == NULL)) {
+				dprintf("imsm: mark checkpoint (%u)\n",
+					units32);
+				dev->vol.curr_migr_unit =
+					__cpu_to_le32(units32);
+				super->updates_pending++;
+			}
 		}
 	}
 

