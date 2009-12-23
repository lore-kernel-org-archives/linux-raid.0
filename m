From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 11/13] Teach sysfs_add_disk() callers to use ->recovery_start
	versus 'insync' parameter
Date: Tue, 22 Dec 2009 17:00:15 -0700
Message-ID: <20091223000015.31628.55472.stgit@dwillia2-linux.ch.intel.com>
References: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

Also fixup 'in_sync' versus 'insync' typo.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 Assemble.c    |    2 +-
 Manage.c      |    3 ++-
 managemon.c   |    2 +-
 mdadm.h       |    3 +--
 super-ddf.c   |    2 ++
 super-intel.c |    2 ++
 sysfs.c       |    6 +++---
 util.c        |    7 +++++--
 8 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 014d644..560e2fe 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1286,7 +1286,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
 		sysfs_free(sra);
 
 	for (dev = content->devs; dev; dev = dev->next)
-		if (sysfs_add_disk(content, dev, 1) == 0)
+		if (sysfs_add_disk(content, dev) == 0)
 			working++;
 		else if (errno == EEXIST)
 			preexist++;
diff --git a/Manage.c b/Manage.c
index fb9b972..6f0a6a2 100644
--- a/Manage.c
+++ b/Manage.c
@@ -696,7 +696,8 @@ int Manage_subdevs(char *devname, int fd,
 				tst->ss->getinfo_super(tst, &new_mdi);
 				new_mdi.disk.major = disc.major;
 				new_mdi.disk.minor = disc.minor;
-				if (sysfs_add_disk(sra, &new_mdi, 0) != 0) {
+				new_mdi.recovery_start = 0;
+				if (sysfs_add_disk(sra, &new_mdi) != 0) {
 					fprintf(stderr, Name ": add new device to external metadata"
 						" failed for %s\n", dv->devname);
 					close(container_fd);
diff --git a/managemon.c b/managemon.c
index e335077..3a20e2b 100644
--- a/managemon.c
+++ b/managemon.c
@@ -410,7 +410,7 @@ static void manage_member(struct mdstat_ent *mdstat,
 			newd = malloc(sizeof(*newd));
 			if (!newd)
 				continue;
-			if (sysfs_add_disk(&newa->info, d, 0) < 0) {
+			if (sysfs_add_disk(&newa->info, d) < 0) {
 				free(newd);
 				continue;
 			}
diff --git a/mdadm.h b/mdadm.h
index 9cf15c4..af6d91b 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -385,8 +385,7 @@ extern int sysfs_get_str(struct mdinfo *sra, struct mdinfo *dev,
 			 char *name, char *val, int size);
 extern int sysfs_set_safemode(struct mdinfo *sra, unsigned long ms);
 extern int sysfs_set_array(struct mdinfo *info, int vers);
-extern int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd,
-			  int in_sync);
+extern int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd);
 extern int sysfs_disk_to_scsi_id(int fd, __u32 *id);
 extern int sysfs_unique_holder(int devnum, long rdev);
 extern int load_sys(char *path, char *buf);
diff --git a/super-ddf.c b/super-ddf.c
index 8c3f4be..14f8330 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2968,6 +2968,7 @@ static struct mdinfo *container_content_ddf(struct supertype *st)
 			dev->disk.minor = d->minor;
 			dev->disk.raid_disk = i;
 			dev->disk.state = (1<<MD_DISK_SYNC)|(1<<MD_DISK_ACTIVE);
+			dev->recovery_start = MaxSector;
 
 			dev->events = __be32_to_cpu(ddf->primary.seq);
 			dev->data_offset = __be64_to_cpu(vc->lba_offset[i]);
@@ -3547,6 +3548,7 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 			di->disk.major = dl->major;
 			di->disk.minor = dl->minor;
 			di->disk.state = 0;
+			di->recovery_start = 0;
 			di->data_offset = pos;
 			di->component_size = a->info.component_size;
 			di->container_member = dl->pdnum;
diff --git a/super-intel.c b/super-intel.c
index 4bb1990..9f879c5 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3876,6 +3876,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
 			info_d->disk.major = d->major;
 			info_d->disk.minor = d->minor;
 			info_d->disk.raid_disk = slot;
+			info_d->recovery_start = MaxSector;
 
 			this->array.working_disks++;
 
@@ -4454,6 +4455,7 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 		di->disk.major = dl->major;
 		di->disk.minor = dl->minor;
 		di->disk.state = 0;
+		di->recovery_start = 0;
 		di->data_offset = __le32_to_cpu(map->pba_of_lba0);
 		di->component_size = a->info.component_size;
 		di->container_member = inst;
diff --git a/sysfs.c b/sysfs.c
index 35dfbd4..8fdb529 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -572,7 +572,7 @@ int sysfs_set_array(struct mdinfo *info, int vers)
 	return rv;
 }
 
-int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int in_sync)
+int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd)
 {
 	char dv[100];
 	char nm[100];
@@ -598,11 +598,11 @@ int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int in_sync)
 	rv = sysfs_set_num(sra, sd, "offset", sd->data_offset);
 	rv |= sysfs_set_num(sra, sd, "size", (sd->component_size+1) / 2);
 	if (sra->array.level != LEVEL_CONTAINER) {
-		if (in_sync)
+		if (sd->recovery_start == MaxSector)
 			/* This can correctly fail if array isn't started,
 			 * yet, so just ignore status for now.
 			 */
-			sysfs_set_str(sra, sd, "state", "in_sync");
+			sysfs_set_str(sra, sd, "state", "insync");
 		rv |= sysfs_set_num(sra, sd, "slot", sd->disk.raid_disk);
 	}
 	return rv;
diff --git a/util.c b/util.c
index d49a4ed..05be64c 100644
--- a/util.c
+++ b/util.c
@@ -1162,8 +1162,11 @@ int add_disk(int mdfd, struct supertype *st,
 	int rv;
 #ifndef MDASSEMBLE
 	if (st->ss->external) {
-		rv = sysfs_add_disk(sra, info,
-				    info->disk.state & (1<<MD_DISK_SYNC));
+		if (info->disk.state & (1<<MD_DISK_SYNC))
+			info->recovery_start = MaxSector;
+		else
+			info->recovery_start = 0;
+		rv = sysfs_add_disk(sra, info);
 		if (! rv) {
 			struct mdinfo *sd2;
 			for (sd2 = sra->devs; sd2; sd2=sd2->next)

