From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 05/13] msm: FIX: when mdadm reloads anchor not need for local
	modyfication
Date: Mon, 10 Jan 2011 12:28:07 +0100
Message-ID: <20110110112806.10776.74388.stgit@gklab-128-013.igk.intel.com>
References: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

imsm part to patch: "FIX: load anchor to get all information"
mdadm should not update anchor but reload metadata.
For details look previous patch.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 8644c39..9687993 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6483,19 +6483,6 @@ static int imsm_create_metadata_update_for_reshape(
 		dl = get_disk_super(super, dev->disk.major, dev->disk.minor);
 		dl->index = mpb->num_disks++;
 	}
-	/* Now update the metadata so that container_content will find
-	 * the new devices
-	 */
-	for (i = 0; i < mpb->num_raid_devs; i++) {
-		int d;
-		struct imsm_dev *dev = get_imsm_dev(super, i);
-		struct imsm_map *map = get_imsm_map(dev, 0);
-		map->num_members = geo->raid_disks;
-		for (d = 0; d < delta_disks; d++) {
-			set_imsm_ord_tbl_ent(map, old_raid_disks + d,
-					     mpb->num_disks - delta_disks + d);
-		}
-	}
 
 abort:
 	/* free spares

