From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 7/8] imsm: FIX: Debug strings cleanup
Date: Tue, 01 Feb 2011 14:49:52 +0100
Message-ID: <20110201134952.13398.40751.stgit@gklab-128-013.igk.intel.com>
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

Some debug strings remains as they were introduced,
before code was moved to separate function.
Information displayed by debug information in not all cases
was correct.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index f604589..e523313 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5858,15 +5858,15 @@ static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
 	int ret_val = 0;
 	unsigned int dev_id;
 
-	dprintf("imsm: imsm_process_update() for update_reshape\n");
+	dprintf("imsm: apply_reshape_container_disks_update()\n");
 
 	/* enable spares to use in array */
 	for (i = 0; i < delta_disks; i++) {
 		new_disk = get_disk_super(super,
 					  major(u->new_disks[i]),
 					  minor(u->new_disks[i]));
-		dprintf("imsm: imsm_process_update(): new disk "
-			"for reshape is: %i:%i (%p, index = %i)\n",
+		dprintf("imsm: new disk for reshape is: %i:%i "
+			"(%p, index = %i)\n",
 			major(u->new_disks[i]), minor(u->new_disks[i]),
 			new_disk, new_disk->index);
 		if ((new_disk == NULL) ||
@@ -5882,8 +5882,8 @@ static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
 		new_disk->disk.status &= ~SPARE_DISK;
 	}
 
-	dprintf("imsm: process_update(): update_reshape: volume set"
-		" mpb->num_raid_devs = %i\n", mpb->num_raid_devs);
+	dprintf("imsm: volume set mpb->num_raid_devs = %i\n",
+		mpb->num_raid_devs);
 	/* manage changes in volume
 	 */
 	for (dev_id = 0; dev_id < mpb->num_raid_devs; dev_id++) {
@@ -5912,8 +5912,8 @@ static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
 		if (devices_to_reshape) {
 			int used_disks;
 
-			dprintf("process_update(): modifying "
-				"subdev: %i\n", id->index);
+			dprintf("imsm: modifying subdev: %i\n",
+				id->index);
 			devices_to_reshape--;
 			newdev->vol.migr_state = 1;
 			newdev->vol.curr_migr_unit = 0;

