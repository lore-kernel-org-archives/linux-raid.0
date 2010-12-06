From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 04/27] imsm: Process reshape_update in mdmon
Date: Mon, 06 Dec 2010 14:21:17 +0100
Message-ID: <20101206132116.21125.10631.stgit@gklab-170-024.igk.intel.com>
References: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

For this update prepare_update() allocates memory to relink imsm (bigger) device
imsm structures. It calculates new /bigger/ anchor size.

Process update applies update in to imsm structures. If necessary for first array in container
it turns spares in to raid disks in metadata.

active_array receives information about number of added devices (reshape_delta_disks)
state_of_array is turned in to reshape_is_starting (this triggers managemon action)

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |  140 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 140 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index ae2f567..402cc30 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5311,6 +5311,99 @@ static void imsm_process_update(struct supertype *st,
 
 	switch (type) {
 	case update_reshape: {
+		struct imsm_update_reshape *u = (void *)update->buf;
+		struct dl *new_disk;
+		struct active_array *a;
+		int i;
+		__u32 new_mpb_size;
+		int new_disk_num;
+		struct intel_dev *current_dev;
+
+		dprintf("imsm: imsm_process_update() for update_reshape [u->update_prepared  = %i]\n", u->update_prepared);
+		if ((u->update_prepared == -1) ||
+		    (u->devnum < 0)) {
+			dprintf("imsm: Error: update_reshape not prepared\n");
+			goto update_reshape_exit;
+		}
+
+		if (u->spares_in_update) {
+			new_disk_num = mpb->num_disks + u->reshape_delta_disks;
+			new_mpb_size = disks_to_mpb_size(new_disk_num);
+			if (mpb->mpb_size < new_mpb_size)
+				mpb->mpb_size = new_mpb_size;
+
+			/* enable spares to use in array
+			*/
+			for (i = 0; i < u->reshape_delta_disks; i++) {
+				char buf[PATH_MAX];
+
+				new_disk = super->disks;
+				while (new_disk) {
+					if ((new_disk->major == u->upd_disks[i].major) &&
+					    (new_disk->minor == u->upd_disks[i].minor))
+							break;
+					new_disk = new_disk->next;
+				}
+				if (new_disk == NULL) {
+					u->update_prepared = -1;
+					goto update_reshape_exit;
+				}
+				if (new_disk->index < 0) {
+					new_disk->index = i + mpb->num_disks;
+					new_disk->raiddisk = new_disk->index; /* slot to fill in autolayout */
+					new_disk->disk.status |= CONFIGURED_DISK;
+					new_disk->disk.status &= ~SPARE_DISK;
+				}
+				sprintf(buf, "%d:%d", new_disk->major, new_disk->minor);
+				if (new_disk->fd < 0)
+					new_disk->fd = dev_open(buf, O_RDWR);
+				imsm_get_new_device_name(new_disk);
+			}
+		}
+
+		dprintf("imsm: process_update(): update_reshape: volume set mpb->num_raid_devs = %i\n", mpb->num_raid_devs);
+		/* manage changes in volumes
+		 */
+		/* check if array is in RESHAPE_NOT_ACTIVE reshape state
+		*/
+		for (a = st->arrays; a; a = a->next)
+			if (a->devnum == u->devnum)
+				break;
+		if ((a == NULL) || (a->reshape_state != reshape_not_active)) {
+			u->update_prepared = -1;
+			goto update_reshape_exit;
+		}
+		/* find current dev in intel_super
+		 */
+		dprintf("\t\tLooking  for volume %s\n", (char *)u->devs_mem.dev->volume);
+		current_dev = super->devlist;
+		while (current_dev) {
+			if (strcmp((char *)current_dev->dev->volume,
+				   (char *)u->devs_mem.dev->volume) == 0)
+				break;
+			current_dev = current_dev->next;
+		}
+		if (current_dev == NULL) {
+			u->update_prepared = -1;
+			goto update_reshape_exit;
+		}
+
+		dprintf("Found volume %s\n", (char *)current_dev->dev->volume);
+		/* replace current device with provided in update
+		 */
+		free(current_dev->dev);
+		current_dev->dev = u->devs_mem.dev;
+		u->devs_mem.dev = NULL;
+
+		/* set reshape_delta_disks
+		 */
+		a->reshape_delta_disks = u->reshape_delta_disks;
+		a->reshape_state = reshape_is_starting;
+
+		super->updates_pending++;
+update_reshape_exit:
+		if (u->devs_mem.dev)
+			free(u->devs_mem.dev);
 		break;
 	}
 	case update_activate_spare: {
@@ -5633,6 +5726,53 @@ static void imsm_prepare_update(struct supertype *st,
 
 	switch (type) {
 	case update_reshape: {
+		struct imsm_update_reshape *u = (void *)update->buf;
+		struct dl *dl = NULL;
+		void *upd_devs;
+
+		u->update_prepared = -1;
+		u->devs_mem.dev = NULL;
+		dprintf("imsm: imsm_prepare_update() for update_reshape\n");
+		if (u->devnum < 0) {
+			dprintf("imsm: No passed device.\n");
+			break;
+		}
+		dprintf("imsm: reshape delta disks is = %i\n", u->reshape_delta_disks);
+		if (u->reshape_delta_disks < 0)
+			break;
+		u->update_prepared = 1;
+		if (u->reshape_delta_disks == 0) {
+			/* for non growing reshape buffers sizes are not affected
+			 * but check some parameters
+			 */
+			break;
+		}
+		/* count HDDs
+		 */
+		u->disks_count = 0;
+		for (dl = super->disks; dl; dl = dl->next)
+			if (dl->index >= 0)
+				u->disks_count++;
+
+		/* set pointer in monitor address space
+		*/
+		upd_devs = (struct imsm_dev *)((void *)u + u->upd_devs_offset);
+		/* allocate memory for new volumes */
+		if (((struct imsm_dev *)(upd_devs))->vol.migr_type != MIGR_GEN_MIGR) {
+			dprintf("imsm: Error.Device is not in migration state.\n");
+			u->update_prepared = -1;
+			break;
+		}
+		dprintf("passed device : %s\n", ((struct imsm_dev *)(upd_devs))->volume);
+		u->devs_mem.dev = calloc(1, u->device_size);
+		if (u->devs_mem.dev == NULL) {
+			u->update_prepared = -1;
+			break;
+		}
+		dprintf("METADATA Copy - using it.\n");
+		memcpy(u->devs_mem.dev, upd_devs, u->device_size);
+		len = disks_to_mpb_size(u->spares_in_update + mpb->num_disks);
+		dprintf("New anchor length is %llu\n", (unsigned long long)len);
 		break;
 	}
 	case update_create_array: {

