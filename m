From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 5/5] imsm: Add chunk size to metadata update
Date: Mon, 14 Feb 2011 14:13:21 +0100
Message-ID: <20110214131321.8540.61141.stgit@gklab-128-013.igk.intel.com>
References: <20110214130213.8540.57401.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110214130213.8540.57401.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Put information about chunk size change in to migration metadata update.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 0f402bb..b04d209 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -346,6 +346,7 @@ struct imsm_update_reshape {
 	int subdev;
 	int new_level;
 	int new_layout;
+	int new_chunksize;
 
 	int new_disks[1]; /* new_raid_disks - old_raid_disks makedev number */
 };
@@ -5943,6 +5944,12 @@ static int apply_reshape_migration_update(struct imsm_update_reshape *u,
 			id->dev = new_dev;
 			tofree = (void **)dev;
 
+			/* update chunk size
+			 */
+			if (u->new_chunksize > 0)
+				map->blocks_per_strip =
+					__cpu_to_le16(u->new_chunksize * 2);
+
 			/* add disk
 			 */
 			if ((u->new_level != 5) ||
@@ -7153,14 +7160,25 @@ static int imsm_create_metadata_update_for_migration(
 	u->new_layout = geo->layout;
 	u->new_raid_disks = u->old_raid_disks = geo->raid_disks;
 	u->new_disks[0] = -1;
+	u->new_chunksize = -1;
 
 	dev = get_imsm_dev(super, u->subdev);
 	if (dev) {
 		struct imsm_map *map;
 
 		map = get_imsm_map(dev, 0);
-		if (map)
+		if (map) {
+			int current_chunk_size =
+				__le16_to_cpu(map->blocks_per_strip) / 2;
+
+			if (geo->chunksize != current_chunk_size) {
+				u->new_chunksize = geo->chunksize / 1024;
+				dprintf("imsm: "
+					"chunk size change from %i to %i\n",
+					current_chunk_size, u->new_chunksize);
+			}
 			previous_level = map->raid_level;
+		}
 	}
 	if ((geo->level == 5) && (previous_level == 0)) {
 		struct mdinfo *spares = NULL;

