From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 01/21] imsm: Remove unnecessary code
Date: Tue, 23 Nov 2010 13:39:46 +0100
Message-ID: <20101123123946.17770.33181.stgit@gklab-170-024.igk.intel.com>
References: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Remove unused or not necessary/not used/redundant code

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/super-intel.c |   40 ++++++++++++----------------------------
 1 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c
index 5cd3ba1..1248612 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -6997,7 +6997,6 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
 	struct mdinfo *spares = NULL;
 	int i;
 	unsigned long long array_blocks;
-	unsigned long long array_blocks_current;
 	int used_disks;
 	int delta_disks = 0;
 	struct dl *new_disks;
@@ -7056,7 +7055,6 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
 			struct imsm_map *new_map2;
 			int idx;
 
-			u->devnum = -1;
 			new_map = NULL;
 			imsm_copy_dev(upd_devs, old_dev);
 			new_map = get_imsm_map(upd_devs, 0);
@@ -7165,11 +7163,8 @@ calculate_size_only:
 		/* round array size down to closest MB
 		 */
 		array_blocks = (array_blocks >> SECT_PER_MB_SHIFT) << SECT_PER_MB_SHIFT;
-		array_blocks_current = (((unsigned long long)((struct imsm_dev *)upd_devs)->size_high) << 32)
-				+ ((struct imsm_dev *)upd_devs)->size_low;
 		((struct imsm_dev *)(upd_devs))->size_low = __cpu_to_le32((__u32)array_blocks);
 		((struct imsm_dev *)(upd_devs))->size_high = __cpu_to_le32((__u32)(array_blocks >> 32));
-
 		/* finalize update */
 		ret_val = u;
 	}
@@ -7247,13 +7242,12 @@ exit_get_volume_for_olce:
 
 int imsm_reshape_super(struct supertype *st, long long size, int level,
 		       int layout, int chunksize, int raid_disks,
-		       char *backup, char*dev, int verbouse)
+		       char *backup, char *dev, int verbouse)
 {
 	int ret_val = 1;
 	struct mdinfo *sra = NULL;
 	int fd = -1;
 	char buf[PATH_MAX];
-	char *devname = NULL;
 
 	dprintf("imsm: reshape_super called().\n");
 	dprintf("\tfor level      : %i\n", level);
@@ -7264,13 +7258,7 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 		return ret_val;
 	}
 
-	devname = devnum2devname(st->devnum);
-	if (devname == NULL) {
-		dprintf("imsm: Error: imsm_reshape_super(): cannot get device name.\n");
-		return ret_val;
-	}
-
-	snprintf(buf, PATH_MAX, "/dev/%s", devname);
+	snprintf(buf, PATH_MAX, "/dev/md%i", st->devnum);
 	fd = open(buf , O_RDONLY | O_DIRECT);
 	if (fd < 0) {
 		dprintf("imsm: cannot open device\n");
@@ -7371,9 +7359,6 @@ imsm_reshape_super_exit:
 	sysfs_free(sra);
 	if (fd >= 0)
 		close(fd);
-	if (devname)
-		free(devname);
-
 	dprintf("imsm: reshape_super Exit code = %i\n", ret_val);
 	return ret_val;
 }
@@ -7725,28 +7710,29 @@ int imsm_grow_manage_size(struct supertype *st, struct mdinfo *sra)
 	struct mdinfo *info = NULL;
 	unsigned long long size;
 	int container_fd;
-	int dn;
 
 	/* finalize current volume reshape
 	 * for external meta size has to be managed by mdadm
 	 * read size set in meta and put it to md when
 	 * reshape is finished.
-	 *
-	 * for takeovered array, return to original raid level
 	 */
 
-	if (sra == NULL)
+	if (sra == NULL) {
+		dprintf("Error: imsm_grow_manage_size(): sra == NULL\n");
 		goto exit_grow_manage_size_ext_meta;
+	}
 	wait_reshape(sra);
 
 	/* reshape has finished, update md size
 	 * get per-device size and multiply by data disks
 	 */
-	dn = devname2devnum(sra->text_version + 1);
-	container_fd = open_dev(dn);
-	if (container_fd < 0)
+	container_fd = open_dev(st->devnum);
+	if (container_fd < 0) {
+		dprintf("Error: imsm_grow_manage_size(): container_fd == 0\n");
 		goto exit_grow_manage_size_ext_meta;
-	st->ss->load_super(st, container_fd, NULL);
+	}
+	if (st->loaded_container)
+		st->ss->load_super(st, container_fd, NULL);
 	info = sysfs_read(container_fd, 0, GET_LEVEL|GET_VERSION|GET_DEVS|GET_STATE);
 	close(container_fd);
 	if (info == NULL) {
@@ -7756,8 +7742,6 @@ int imsm_grow_manage_size(struct supertype *st, struct mdinfo *sra)
 	st->ss->getinfo_super(st, info);
 	size = info->custom_array_size/2;
 	sysfs_set_num(sra, NULL, "array_size", size);
-
-	/* for takeovered array return to original raid level */
 	ret_val = 1;
 
 exit_grow_manage_size_ext_meta:
@@ -8116,7 +8100,7 @@ int imsm_manage_container_reshape(struct supertype *st)
 					continue;
 				}
 			} else {
-			dprintf("Reshape is broken (cannot read sync_complete)\n");
+				dprintf("Reshape is broken (cannot read sync_complete)\n");
 				dprintf("Array level is: %i\n", info->array.level);
 				ret_val = 1;
 				close(fd2);

