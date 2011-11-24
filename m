From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 11/11] Disable BBM when it is not supported
Date: Thu, 24 Nov 2011 13:18:37 +0100
Message-ID: <20111124121837.5254.90340.stgit@gklab-128-013.igk.intel.com>
References: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

During reshape for external metadata any disk failure /e.g. disk removing/
is reported to user space via sysfs and requires to be confirmed by mdadm
to allow reshape to proceed. When mdadm for given external metadata doesn't
support BBM reshape continuation is not possible.

To resolve this situation external metadata can work as native metadata
v0.90 and direct md to ignore bad blocks management.

To achieve this, patch in md /provided separately/ for setting badblocks.shift
field to '-1' value per rdev device by storing in sysfs 'disable' word
is used.

To use this md ability bbm_enabled enabled field is added to super switch.
According to this field during disk add /in sysfs_add_disk()/ bad blocks
management is disabled in md.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c    |    2 +-
 Manage.c      |    3 ++-
 managemon.c   |    3 ++-
 mdadm.h       |    4 +++-
 super-intel.c |    1 +
 sysfs.c       |    7 ++++++-
 util.c        |    2 +-
 7 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 74708d1..88af585 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1542,7 +1542,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
 		sysfs_free(sra);
 	old_raid_disks = content->array.raid_disks - content->delta_disks;
 	for (dev = content->devs; dev; dev = dev->next)
-		if (sysfs_add_disk(content, dev, 1) == 0) {
+		if (sysfs_add_disk(content, dev, 1, st->ss->bbm_enabled) == 0) {
 			if (dev->disk.raid_disk >= old_raid_disks &&
 			    content->reshape_active)
 				expansion++;
diff --git a/Manage.c b/Manage.c
index d9775de..d3ea140 100644
--- a/Manage.c
+++ b/Manage.c
@@ -998,7 +998,8 @@ int Manage_subdevs(char *devname, int fd,
 				/* Make sure fds are closed as they are O_EXCL which
 				 * would block add_disk */
 				tst->ss->free_super(tst);
-				if (sysfs_add_disk(sra, &new_mdi, 0) != 0) {
+				if (sysfs_add_disk(sra, &new_mdi, 0,
+						   tst->ss->bbm_enabled) != 0) {
 					fprintf(stderr, Name ": add new device to external metadata"
 						" failed for %s\n", dv->devname);
 					close(container_fd);
diff --git a/managemon.c b/managemon.c
index cde0d8b..6d24bbc 100644
--- a/managemon.c
+++ b/managemon.c
@@ -522,7 +522,8 @@ static void manage_member(struct mdstat_ent *mdstat,
 			newd = malloc(sizeof(*newd));
 			if (!newd)
 				continue;
-			if (sysfs_add_disk(&newa->info, d, 0) < 0) {
+			if (sysfs_add_disk(&newa->info, d, 0,
+					   container->ss->bbm_enabled) < 0) {
 				free(newd);
 				continue;
 			}
diff --git a/mdadm.h b/mdadm.h
index 1351d42..5e6b9a7 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -486,7 +486,8 @@ extern int sysfs_get_str(struct mdinfo *sra, struct mdinfo *dev,
 			 char *name, char *val, int size);
 extern int sysfs_set_safemode(struct mdinfo *sra, unsigned long ms);
 extern int sysfs_set_array(struct mdinfo *info, int vers);
-extern int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume);
+extern int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd,
+			  int resume, int bbm_enabled);
 extern int sysfs_disk_to_scsi_id(int fd, __u32 *id);
 extern int sysfs_unique_holder(int devnum, long rdev);
 extern int sysfs_freeze_array(struct mdinfo *sra);
@@ -812,6 +813,7 @@ extern struct superswitch {
 
 	int swapuuid; /* true if uuid is bigending rather than hostendian */
 	int external;
+	int bbm_enabled;
 	const char *name; /* canonical metadata name */
 } *superlist[];
 
diff --git a/super-intel.c b/super-intel.c
index 208af80..f17347f 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -9511,6 +9511,7 @@ struct superswitch super_imsm = {
 
 	.external	= 1,
 	.name = "imsm",
+	.bbm_enabled = 0,
 
 #ifndef MDASSEMBLE
 /* for mdmon */
diff --git a/sysfs.c b/sysfs.c
index d923f7f..06f1c16 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -605,7 +605,8 @@ int sysfs_set_array(struct mdinfo *info, int vers)
 	return rv;
 }
 
-int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume)
+int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume,
+		  int bbm_enabled)
 {
 	char dv[PATH_MAX];
 	char nm[PATH_MAX];
@@ -648,6 +649,10 @@ int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume)
 		if (resume)
 			sysfs_set_num(sra, sd, "recovery_start", sd->recovery_start);
 	}
+	/* disable bad blocks managment in md
+	 */
+	if (bbm_enabled == 0)
+		rv = sysfs_set_str(sra, sd, "bad_blocks", "disable");
 	return rv;
 }
 
diff --git a/util.c b/util.c
index 6985a70..8645daf 100644
--- a/util.c
+++ b/util.c
@@ -1475,7 +1475,7 @@ int add_disk(int mdfd, struct supertype *st,
 			info->recovery_start = MaxSector;
 		else
 			info->recovery_start = 0;
-		rv = sysfs_add_disk(sra, info, 0);
+		rv = sysfs_add_disk(sra, info, 0, st->ss->bbm_enabled);
 		if (! rv) {
 			struct mdinfo *sd2;
 			for (sd2 = sra->devs; sd2; sd2=sd2->next)

