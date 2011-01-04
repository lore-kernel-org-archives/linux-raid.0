From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 07/34] imsm: FIX: Perform first metadata update for container
	operation
Date: Tue, 04 Jan 2011 15:36:33 +0100
Message-ID: <20110104143633.6697.68443.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Meta data was not updated due to the following problems:
1.disk index < 0 was treated as invalid, but this is spare device
2. disk index greater than currently used disks is correct also
3. newmap pointer has to be refreshed for second map copy operation
4. size calculation has to be guarded for shrinking operation

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index ffbf741..7c73b67 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5602,7 +5602,13 @@ static void imsm_process_update(struct supertype *st,
 			new_disk = get_disk_super(super,
 						  major(u->new_disks[i]),
 						  minor(u->new_disks[i]));
-			if (new_disk == NULL || new_disk->index < 0)
+			dprintf("imsm: imsm_process_update(): new disk "\
+				"for reshape is: %i:%i (%p, index = %i)\n",
+				major(u->new_disks[i]), minor(u->new_disks[i]),
+				new_disk, new_disk->index);
+			if ((new_disk == NULL) ||
+			    ((new_disk->index >= 0) &&
+			     (new_disk->index < u->old_raid_disks)))
 				goto update_reshape_exit;
 
 			new_disk->index = mpb->num_disks++;
@@ -5642,7 +5648,7 @@ static void imsm_process_update(struct supertype *st,
 						     u->old_raid_disks + i);
 			}
 			/* New map is correct, now need to save old map */
-			oldmap = get_imsm_map(newdev, 1);
+			newmap = get_imsm_map(newdev, 1);
 			memcpy(newmap, oldmap, sizeof_imsm_map(oldmap));
 
 			sp = (void **)id->dev;
@@ -5987,8 +5993,9 @@ static void imsm_prepare_update(struct supertype *st,
 		for (dl = super->devlist; dl; dl = dl->next) {
 			int size = sizeof_imsm_dev(dl->dev, 1);
 			void *s;
-			size += sizeof(__u32) * 2 * 
-				(u->new_raid_disks - u->old_raid_disks);
+			if (u->new_raid_disks > u->old_raid_disks)
+				size += sizeof(__u32)*2*
+					(u->new_raid_disks - u->old_raid_disks);
 			s = malloc(size);
 			if (!s)
 				break;
@@ -6395,11 +6402,14 @@ abort:
 	 */
 	sysfs_free(spares);
 
+	dprintf("imsm: reshape update preparation :");
 	if (i == delta_disks) {
+		dprintf(" OK\n");
 		*updatep = u;
 		return update_memory_size;
 	}
 	free(u);
+	dprintf(" Error\n");
 
 	return 0;
 }

