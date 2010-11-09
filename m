From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 11/31] imsm: Verify slots in meta against slot numbers set
 by md
Date: Tue, 9 Nov 2010 17:01:09 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CA9B@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

To verify slots numbers stored in metadata against those chosen by md, update_reshape_set_slots_update is used.

Managemon calls reshape_array() vector and prepares slot verification metadata update there. It is sent when reshape is started successfully in md.
Then monitor updates/verifies slots.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/super-intel.c |  301 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 301 insertions(+), 0 deletions(-)

diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c index baf8ef4..f0b5bbe 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -297,6 +297,7 @@ enum imsm_update_type {
 	update_add_disk,
 	update_level,
 	update_reshape,
+	update_reshape_set_slots,
 };
 
 struct imsm_update_activate_spare {
@@ -5252,6 +5253,7 @@ static int disks_overlap(struct intel_super *super, int idx, struct imsm_update_  }
 
 static void imsm_delete(struct intel_super *super, struct dl **dlp, unsigned index);
+int imsm_reshape_array_set_slots(struct active_array *a);
 int imsm_get_new_device_name(struct dl *dl);
 
 static void imsm_process_update(struct supertype *st, @@ -5384,6 +5386,25 @@ update_reshape_exit:
 			free(u->devs_mem.dev);
 		break;
 	}
+	case update_reshape_set_slots: {
+		struct imsm_update_reshape *u = (void *)update->buf;
+		struct active_array *a;
+
+		dprintf("imsm: process_update() for update_reshape_set_slot for device %i\n", u->devnum);
+		for (a = st->arrays; a; a = a->next)
+			if (a->devnum == u->devnum) {
+				break;
+			}
+
+		if (a == NULL) {
+			dprintf(" - cannot locate requested array\n");
+			break;
+		}
+
+		if (imsm_reshape_array_set_slots(a) > -1)
+			super->updates_pending++;
+		break;
+	}
 	case update_level: {
 		struct imsm_update_level *u = (void *)update->buf;
 		struct imsm_dev *dev_new, *dev = NULL; @@ -5803,6 +5824,9 @@ static void imsm_prepare_update(struct supertype *st,
 		dprintf("New anchor length is %llu\n", (unsigned long long)len);
 		break;
 	}
+	case update_reshape_set_slots: {
+		break;
+	}
 	case update_level: {
 		struct imsm_update_level *u = (void *) update->buf;
 		struct active_array *a;
@@ -6657,6 +6681,282 @@ int imsm_get_new_device_name(struct dl *dl)
 	return rv;
 }
 
+int imsm_reshape_array_manage_new_slots(struct intel_super *super, int 
+inst, int devnum, int correct);
+
+int imsm_reshape_array_set_slots(struct active_array *a) {
+	struct intel_super *super = a->container->sb;
+	int inst = a->info.container_member;
+
+	return imsm_reshape_array_manage_new_slots(super, inst, a->devnum, 1); 
+}
+/* imsm_reshape_array_manage_new_slots()
+ * returns: number of corrected slots for correct == 1
+ *          counted number of different slots for correct == 0
+*/
+int imsm_reshape_array_manage_new_slots(struct intel_super *super, int 
+inst, int devnum, int correct) {
+
+	struct imsm_dev *dev = get_imsm_dev(super, inst);
+	struct imsm_map *map_1 = get_imsm_map(dev, 0);
+	struct imsm_map *map_2 = get_imsm_map(dev, 1);
+	struct dl *dl;
+	unsigned long long sysfs_slot;
+	char buf[PATH_MAX];
+	char *devname;
+	int fd;
+	struct mdinfo *sra = NULL;
+	int ret_val = 0;
+
+	if ((map_1 == NULL) || (map_2 == NULL)) {
+		dprintf("imsm_reshape_array_set_slots() no maps (map_1 =%p, map_2 = %p)\n", map_1, map_2);
+		dprintf("\t\tdev->vol.migr_state = %i\n", dev->vol.migr_state);
+		dprintf("\t\tdev->volume = %s\n", dev->volume);
+		return -1;
+	}
+
+	/* verify/correct slot configuration of added disks
+	 */
+	dprintf("\n\nStart map verification for %i added devices on device no %i\n",
+		map_1->num_members - map_2->num_members, devnum);
+	devname = devnum2devname(devnum);
+	if (devname == NULL) {
+		dprintf("imsm: ERROR: Cannot get device name.\n");
+		return -1;
+	}
+	sprintf(buf, "/dev/%s", devname);
+	free(devname);
+
+	fd = open(buf, O_RDONLY);
+	if (fd < 0) {
+		dprintf("imsm: ERROR: Cannot open device %s.\n", buf);
+		return -1;
+	}
+
+	sra = sysfs_read(fd, 0, GET_LEVEL|GET_VERSION|GET_DEVS|GET_STATE);
+	if (!sra) {
+		dprintf("imsm: ERROR: Device not found.\n");
+		close(fd);
+		return -1;
+	}
+
+	for (dl = super->disks; dl; dl = dl->next) {
+		int fd2;
+		int rv;
+
+		dprintf("\tLooking at device %s (index = %i).\n", dl->devname, dl->index);
+		if (dl->devname && (strlen(dl->devname) > 5))
+			sprintf(buf, "/sys/block/%s/md/dev-%s/slot",
+				sra->sys_name, dl->devname+5);
+		fd2 = open(buf, O_RDONLY);
+		if (fd2 < 0)
+			continue;
+		rv = sysfs_fd_get_ll(fd2, &sysfs_slot);
+		close(fd2);
+		if (rv < 0)
+			continue;
+		dprintf("\t\tLooking at slot %llu in sysfs.\n", sysfs_slot);
+		if ((int)sysfs_slot != dl->index) {
+			dprintf("Slots doesn't match sysfs->%i and imsm->%i\n", (int)sysfs_slot, dl->index);
+			ret_val++;
+			if (correct)
+				dl->index = sysfs_slot;
+		}
+	}
+	close(fd);
+	sysfs_free(sra);
+	dprintf("IMSM Map verification finished (found wrong slots : %i).\n", 
+ret_val);
+
+	return ret_val;
+}
+
+struct mdinfo *imsm_grow_array(struct active_array *a) {
+	int disk_count = 0;
+	struct intel_super *super = a->container->sb;
+	int inst = a->info.container_member;
+	struct imsm_dev *dev = get_imsm_dev(super, inst);
+	struct imsm_map *map = get_imsm_map(dev, 0);
+	struct mdinfo *di;
+	struct dl *dl;
+	int i;
+	int prev_raid_disks = a->info.array.raid_disks;
+	int new_raid_disks = prev_raid_disks + a->reshape_delta_disks;
+	struct mdinfo *vol = NULL;
+	char buf[PATH_MAX];
+	char *p;
+	int fd;
+	struct mdinfo *rv = NULL;
+
+	dprintf("imsm: grow array: inst=%d raid disks=%d(%d) level=%d\n",
+		inst, a->info.array.raid_disks, new_raid_disks, a->info.array.level);
+
+	/* get array sysfs entry
+	 */
+	p = devnum2devname(a->devnum);
+	if (p == NULL)
+		return rv;
+	sprintf(buf, "/dev/%s", p);
+	free(p);
+	fd = open(buf, O_RDONLY);
+	if (fd < 0)
+		return rv;
+	vol = sysfs_read(fd, 0, GET_LEVEL|GET_VERSION|GET_DEVS|GET_STATE);
+	if (vol == NULL) {
+		close(fd);
+		return rv;
+	}
+	/* Look for all disks beyond current configuration
+	 * To handle degradation after takeover
+	 * look also on last disk in configuration.
+	 */
+	for (i = prev_raid_disks; i < new_raid_disks; i++) {
+		/* OK, this device can be added.  Try to add.
+		 */
+		dl = imsm_add_spare(super, i, a, 0);
+		if (!dl)
+			continue;
+
+		if (dl->index < 0)
+			dl->index = i;
+		/* found a usable disk with enough space */
+		di = malloc(sizeof(*di));
+		if (!di)
+			continue;
+
+		memset(di, 0, sizeof(*di));
+		/* dl->index will be -1 in the case we are activating a
+		 * pristine spare.  imsm_process_update() will create a
+		 * new index in this case.  On disks=4(5)ce a disk is found to be
+		 * failed in all member arrays it is kicked from the
+		 * metadata
+		 */
+		di->disk.number = dl->index;
+
+		/* (ab)use di->devs to store a pointer to the device
+		 * we chose
+		 */
+		di->devs = (struct mdinfo *) dl;
+
+		di->disk.raid_disk = SYSFS_ADD_DISK_DO_NOT_SET_SLOT;
+		di->disk.major = dl->major;
+		di->disk.minor = dl->minor;
+		di->disk.state = (1<<MD_DISK_SYNC) |
+				 (1<<MD_DISK_ACTIVE);
+		di->next_state = 0;
+
+		di->recovery_start = MaxSector;
+		di->data_offset = __le32_to_cpu(map->pba_of_lba0);
+		di->component_size = a->info.component_size;
+		di->container_member = inst;
+		super->random = random32();
+
+		di->next = rv;
+		rv = di;
+		disk_count++;
+		dprintf("%x:%x to be %d at %llu\n", dl->major, dl->minor,
+			i, di->data_offset);
+	}
+
+	dprintf("imsm: imsm_grow_array() configures %i raid disks\n", disk_count);
+	close(fd);
+	sysfs_free(vol);
+	if (disk_count != a->reshape_delta_disks) {
+
+		dprintf("imsm: ERROR: but it should configure %i\n",
+			a->reshape_delta_disks);
+
+		while (rv) {
+			di = rv;
+			rv = rv->next;
+			free(di);
+		}
+	}
+
+	return rv;
+}
+
+struct mdinfo *imsm_reshape_array(struct active_array *a, int request_type,
+			struct metadata_update **updates)
+{
+	struct imsm_update_reshape *u = NULL;
+	struct metadata_update *mu;
+	struct mdinfo *disk_list = NULL;
+
+	dprintf("imsm: imsm_reshape_array(reshape_delta_disks = %i)\t", a->reshape_delta_disks);
+	if (request_type == RESHAPE_CANCEL_REQUEST) {
+		dprintf("prepare cancel message.\n");
+		goto imsm_reshape_array_exit;
+	}
+	if (a->reshape_delta_disks == RESHAPE_NOT_ACTIVE) {
+		dprintf("has nothing to do.\n");
+		return disk_list;
+	}
+	if (a->reshape_delta_disks < 0) {
+		dprintf("doesn't support shrinking.\n");
+		a->reshape_delta_disks = RESHAPE_NOT_ACTIVE;
+		return disk_list;
+	}
+
+	if (a->reshape_delta_disks == 0) {
+		dprintf("array parameters has to be changed\n");
+		/* TBD */
+	}
+	if (a->reshape_delta_disks > 0) {
+		dprintf("grow is detected.\n");
+		disk_list = imsm_grow_array(a);
+	}
+
+	if (disk_list) {
+		dprintf("imsm: send update update_reshape_set_slots\n");
+
+		u = (struct imsm_update_reshape *)calloc(1, sizeof(struct imsm_update_reshape));
+		if (u) {
+			u->type = update_reshape_set_slots;
+			a->reshape_delta_disks = RESHAPE_IN_PROGRESS;
+		}
+	} else
+		dprintf("error: cannot start reshape\n");
+
+imsm_reshape_array_exit:
+	if (u == NULL) {
+		dprintf("imsm: send update update_reshape_cancel\n");
+		sysfs_set_str(&a->info, NULL, "sync_action", "idle");
+	}
+
+	if (u) {
+		/* post any prepared update
+		 */
+		u->devnum = a->devnum;
+
+		u->update_memory_size = sizeof(struct imsm_update_reshape);
+		u->reshape_delta_disks = a->reshape_delta_disks;
+		u->update_prepared = 1;
+
+		mu = malloc(sizeof(struct metadata_update));
+		if (mu) {
+			mu->buf = (void *)u;
+			mu->space = NULL;
+			mu->len = u->update_memory_size;
+			mu->next = *updates;
+			*updates = mu;
+		} else {
+			free(u);
+			u = NULL;
+		}
+	}
+	a->reshape_delta_disks = RESHAPE_NOT_ACTIVE;
+
+	if ((disk_list) && (u == NULL)) {
+		while (disk_list) {
+			struct mdinfo *di = disk_list;
+			disk_list = disk_list->next;
+			free(di);
+		}
+	}
+	return disk_list;
+}
+
 struct superswitch super_imsm = {
 #ifndef	MDASSEMBLE
 	.examine_super	= examine_super_imsm,
@@ -6689,6 +6989,7 @@ struct superswitch super_imsm = {
 	.container_content = container_content_imsm,
 	.default_geometry = default_geometry_imsm,
 	.reshape_super  = imsm_reshape_super,
+	.reshape_array	= imsm_reshape_array,
 
 	.external	= 1,
 	.name = "imsm",

