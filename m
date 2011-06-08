From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 12/21] imsm: FIX: Use metadata information for
	restore_stripes() and save_stripes()
Date: Wed, 08 Jun 2011 18:11:10 +0200
Message-ID: <20110608161110.24327.51096.stgit@gklab-128-013.igk.intel.com>
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

For raid0 reshape imsm uses degraded raid4 for this operation.
Using real raid level (raid0) for stripe calculation causes no need
for parity calculation and can speed up reshape process.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 708b51d..26083c3 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7698,6 +7698,8 @@ int save_backup_imsm(struct supertype *st,
 	int i;
 	struct imsm_map *map_dest = get_imsm_map(dev, 0);
 	int new_disks = map_dest->num_members;
+	int dest_layout = 0;
+	int dest_chunk;
 
 	targets = malloc(new_disks * sizeof(int));
 	if (!targets)
@@ -7716,15 +7718,19 @@ int save_backup_imsm(struct supertype *st,
 	if (open_backup_targets(info, new_disks, targets))
 		goto abort;
 
+	if (map_dest->raid_level != 0)
+		dest_layout = ALGORITHM_LEFT_ASYMMETRIC;
+	dest_chunk = __le16_to_cpu(map_dest->blocks_per_strip) * 512;
+
 	if (restore_stripes(targets, /* list of dest devices */
 			    target_offsets, /* migration record offsets */
 			    new_disks,
-			    info->new_chunk,
-			    info->new_level,
-			    info->new_layout,
-			    -1,		/* source backup file descriptor */
-			    0,		/* input buf offset
-					 * always 0 buf is already offset */
+			    dest_chunk,
+			    map_dest->raid_level,
+			    dest_layout,
+			    -1,    /* source backup file descriptor */
+			    0,     /* input buf offset
+				    * always 0 buf is already offseted */
 			    0,
 			    length,
 			    buf) != 0) {
@@ -8687,6 +8693,7 @@ static int imsm_manage_reshape(
 	unsigned long long start; /* [bytes] */
 	unsigned long long start_buf_shift; /* [bytes] */
 	int degraded = 0;
+	int source_layout = 0;
 
 	if (!fds || !offsets || !sra)
 		goto abort;
@@ -8741,6 +8748,8 @@ static int imsm_manage_reshape(
 	}
 
 	max_position = sra->component_size * ndata;
+	if (map_src->raid_level != 0)
+		source_layout = ALGORITHM_LEFT_ASYMMETRIC;
 
 	while (__le32_to_cpu(migr_rec->curr_migr_unit) <
 	       __le32_to_cpu(migr_rec->num_migr_units)) {
@@ -8797,8 +8806,8 @@ static int imsm_manage_reshape(
 				start_buf_shift, next_step_filler);
 
 			if (save_stripes(fds, offsets, map_src->num_members,
-					 chunk, sra->array.level,
-					 sra->array.layout, 0, NULL, start_src,
+					 chunk, map_src->raid_level,
+					 source_layout, 0, NULL, start_src,
 					 copy_length +
 					 next_step_filler + start_buf_shift,
 					 buf)) {

