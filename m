From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 5/5] imsm: add new chunk size to metadata update
Date: Fri, 29 Apr 2011 00:02:22 +0200
Message-ID: <20110428220222.19632.90319.stgit@gklab-128-081.igk.intel.com>
References: <20110428215751.19632.5381.stgit@gklab-128-081.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110428215751.19632.5381.stgit@gklab-128-081.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Put information about new chunk size change in to migration metadata
update allowing simultaneous level change and re-striping.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 super-intel.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index d4a45d7..e3f3f19 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -354,6 +354,7 @@ struct imsm_update_reshape_migration {
 	int subdev;
 	int new_level;
 	int new_layout;
+	int new_chunksize;
 
 	int new_disks[1]; /* new_raid_disks - old_raid_disks makedev number */
 };
@@ -6156,6 +6157,12 @@ static int apply_reshape_migration_update(struct imsm_update_reshape_migration *
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
@@ -7367,14 +7374,25 @@ static int imsm_create_metadata_update_for_migration(
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

