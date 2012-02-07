From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 07/12] imsm: FIX: Chunk size migration problem
Date: Tue, 07 Feb 2012 15:03:51 +0100
Message-ID: <20120207140351.20627.65698.stgit@gklab-128-013.igk.intel.com>
References: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com, lukasz.dorau@intel.com
List-Id: linux-raid.ids

When chunk size migration occurs (e.g. 128k->4k) first checkpoint cannot
be set in md due to too small step. Correct migration record initialization
to allow whole copy area usage and increase migration checkpoint step.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 19a2c84..f5762d8 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8913,7 +8913,8 @@ void init_migr_record_imsm(struct supertype *st, struct imsm_dev *dev,
 
 	migr_rec->dest_depth_per_unit = GEN_MIGR_AREA_SIZE /
 		max(map_dest->blocks_per_strip, map_src->blocks_per_strip);
-	migr_rec->dest_depth_per_unit *= map_dest->blocks_per_strip;
+	migr_rec->dest_depth_per_unit *=
+		max(map_dest->blocks_per_strip, map_src->blocks_per_strip);
 	new_data_disks = imsm_num_data_members(dev, MAP_0);
 	migr_rec->blocks_per_unit =
 		__cpu_to_le32(migr_rec->dest_depth_per_unit * new_data_disks);

