From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 12/13] Support external metadata recovery-resume
Date: Tue, 22 Dec 2009 17:00:20 -0700
Message-ID: <20091223000020.31628.46120.stgit@dwillia2-linux.ch.intel.com>
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

Minimal changes needed to permit reassembling partially recovered
external metadata arrays.  The biggest logical change is that
->container_content() can now surface partially rebuilt members rather
than omitting them from the disk list.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 Assemble.c  |    2 +-
 Manage.c    |    2 +-
 managemon.c |    2 +-
 mdadm.h     |    2 +-
 sysfs.c     |   11 ++++++++++-
 util.c      |    2 +-
 6 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 560e2fe..014d644 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1286,7 +1286,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
 		sysfs_free(sra);
 
 	for (dev = content->devs; dev; dev = dev->next)
-		if (sysfs_add_disk(content, dev) == 0)
+		if (sysfs_add_disk(content, dev, 1) == 0)
 			working++;
 		else if (errno == EEXIST)
 			preexist++;
diff --git a/Manage.c b/Manage.c
index 6f0a6a2..df6079b 100644
--- a/Manage.c
+++ b/Manage.c
@@ -697,7 +697,7 @@ int Manage_subdevs(char *devname, int fd,
 				new_mdi.disk.major = disc.major;
 				new_mdi.disk.minor = disc.minor;
 				new_mdi.recovery_start = 0;
-				if (sysfs_add_disk(sra, &new_mdi) != 0) {
+				if (sysfs_add_disk(sra, &new_mdi, 0) != 0) {
 					fprintf(stderr, Name ": add new device to external metadata"
 						" failed for %s\n", dv->devname);
 					close(container_fd);
diff --git a/managemon.c b/managemon.c
index 3a20e2b..e335077 100644
--- a/managemon.c
+++ b/managemon.c
@@ -410,7 +410,7 @@ static void manage_member(struct mdstat_ent *mdstat,
 			newd = malloc(sizeof(*newd));
 			if (!newd)
 				continue;
-			if (sysfs_add_disk(&newa->info, d) < 0) {
+			if (sysfs_add_disk(&newa->info, d, 0) < 0) {
 				free(newd);
 				continue;
 			}
diff --git a/mdadm.h b/mdadm.h
index af6d91b..27ef693 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -385,7 +385,7 @@ extern int sysfs_get_str(struct mdinfo *sra, struct mdinfo *dev,
 			 char *name, char *val, int size);
 extern int sysfs_set_safemode(struct mdinfo *sra, unsigned long ms);
 extern int sysfs_set_array(struct mdinfo *info, int vers);
-extern int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd);
+extern int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume);
 extern int sysfs_disk_to_scsi_id(int fd, __u32 *id);
 extern int sysfs_unique_holder(int devnum, long rdev);
 extern int load_sys(char *path, char *buf);
diff --git a/sysfs.c b/sysfs.c
index 8fdb529..c3bbbe3 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -572,7 +572,7 @@ int sysfs_set_array(struct mdinfo *info, int vers)
 	return rv;
 }
 
-int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd)
+int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume)
 {
 	char dv[100];
 	char nm[100];
@@ -595,6 +595,13 @@ int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd)
 	strcpy(sd->sys_name, "dev-");
 	strcpy(sd->sys_name+4, dname);
 
+	/* test write to see if 'recovery_start' is available */
+	if (resume && sd->recovery_start < MaxSector &&
+	    sysfs_set_num(sra, sd, "recovery_start", 0)) {
+		sysfs_set_str(sra, sd, "state", "remove");
+		return -1;
+	}
+
 	rv = sysfs_set_num(sra, sd, "offset", sd->data_offset);
 	rv |= sysfs_set_num(sra, sd, "size", (sd->component_size+1) / 2);
 	if (sra->array.level != LEVEL_CONTAINER) {
@@ -604,6 +611,8 @@ int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd)
 			 */
 			sysfs_set_str(sra, sd, "state", "insync");
 		rv |= sysfs_set_num(sra, sd, "slot", sd->disk.raid_disk);
+		if (resume)
+			sysfs_set_num(sra, sd, "recovery_start", sd->recovery_start);
 	}
 	return rv;
 }
diff --git a/util.c b/util.c
index 05be64c..927a0ee 100644
--- a/util.c
+++ b/util.c
@@ -1166,7 +1166,7 @@ int add_disk(int mdfd, struct supertype *st,
 			info->recovery_start = MaxSector;
 		else
 			info->recovery_start = 0;
-		rv = sysfs_add_disk(sra, info);
+		rv = sysfs_add_disk(sra, info, 0);
 		if (! rv) {
 			struct mdinfo *sd2;
 			for (sd2 = sra->devs; sd2; sd2=sd2->next)

