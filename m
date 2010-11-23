From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 02/21] imsm: Change some debug output information
Date: Tue, 23 Nov 2010 13:39:54 +0100
Message-ID: <20101123123954.17770.36140.stgit@gklab-170-024.igk.intel.com>
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

Change debug information to more useful, correct spelling errors.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/super-intel.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c
index 1248612..f628c2c 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -6962,7 +6962,7 @@ struct mdinfo *get_spares_imsm(int devnum)
 		goto abort;
 	}
 	if (ret_val->array.spare_disks == 0) {
-		dprintf("imsm: ERROR: No available spares.\n");
+		fprintf(stderr, Name": imsm: ERROR: No available spares.\n");
 		free(ret_val);
 		ret_val = NULL;
 		goto abort;
@@ -7003,7 +7003,7 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
 	int device_size;
 	void *upd_devs;
 
-	dprintf("insm imsm_update_metadata_for_reshape(enter)\n");
+	dprintf("imsm imsm_update_metadata_for_reshape(enter)\n");
 
 	if ((raid_disks < super->anchor->num_disks) ||
 	    (raid_disks == UnSet))
@@ -7261,7 +7261,7 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 	snprintf(buf, PATH_MAX, "/dev/md%i", st->devnum);
 	fd = open(buf , O_RDONLY | O_DIRECT);
 	if (fd < 0) {
-		dprintf("imsm: cannot open device\n");
+		dprintf("imsm: cannot open device %s\n", buf);
 		goto imsm_reshape_super_exit;
 	}
 
@@ -7710,6 +7710,7 @@ int imsm_grow_manage_size(struct supertype *st, struct mdinfo *sra)
 	struct mdinfo *info = NULL;
 	unsigned long long size;
 	int container_fd;
+	unsigned long long current_size = 0;
 
 	/* finalize current volume reshape
 	 * for external meta size has to be managed by mdadm
@@ -7741,6 +7742,8 @@ int imsm_grow_manage_size(struct supertype *st, struct mdinfo *sra)
 	}
 	st->ss->getinfo_super(st, info);
 	size = info->custom_array_size/2;
+	sysfs_get_ll(sra, NULL, "array_size", &current_size);
+	dprintf("imsm_grow_manage_size(): current size is %llu, set size to %llu\n", current_size, size);
 	sysfs_set_num(sra, NULL, "array_size", size);
 	ret_val = 1;
 
@@ -7985,14 +7988,14 @@ int imsm_manage_container_reshape(struct supertype *st)
 	 * for single vlolume reshape exit only and reuse Grow_reshape() code
 	 */
 	if (st->subarray[0] != 0) {
-		dprintf("imsm: manage_reshape() current volume: %s\n", st->subarray);
-		dprintf("imsm: manage_reshape() detects volume reshape (devnum = %i), exit.\n", st->devnum);
+		dprintf("imsm: imsm_manage_container_reshape() current volume: %s\n", st->subarray);
+		dprintf("imsm: imsm_manage_container_reshape() detects volume reshape (devnum = %i), exit.\n", st->devnum);
 		return ret_val;
 	}
 
 	devname = devnum2devname(st->devnum);
 	if (devname == NULL) {
-		dprintf("imsm: Error: imsm_manage_reshape(): cannot get device name.\n");
+		dprintf("imsm: Error: imsm_manage_container_reshape(): cannot get device name.\n");
 		return ret_val;
 	}
 
@@ -8198,8 +8201,7 @@ int imsm_manage_reshape(struct supertype *st, char *backup)
 	 * for single vlolume reshape exit only and reuse Grow_reshape() code
 	 */
 	if (st->subarray[0] != 0) {
-		dprintf("imsm: manage_reshape() current volume: %s\n", st->subarray);
-		dprintf("imsm: manage_reshape() detects volume reshape (devnum = %i), exit.\n", st->devnum);
+		dprintf("imsm: manage_reshape() current volume: %s (devnum = %i)\n", st->subarray, st->devnum);
 		return ret_val;
 	}
 	ret_val = imsm_manage_container_reshape(st);

