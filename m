From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 19/31] Prepare and free fdlist in functions
Date: Tue, 9 Nov 2010 17:01:18 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CAA2@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

fd handles table creation is put in to function for code reuse.

In manage_reshape(), child_grow() function from Grow.c will be reused.
To prepare parameters for this function, code from Grow.c can be reused also.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/Grow.c  |  135 +++++++++++++++++++++++++++++++++++++++------------
 mdadm/mdadm/mdadm.h |   11 ++++
 2 files changed, 114 insertions(+), 32 deletions(-)

diff --git a/mdadm/mdadm/Grow.c b/mdadm/mdadm/Grow.c index d97480a..93f091a 100644
--- a/mdadm/mdadm/Grow.c
+++ b/mdadm/mdadm/Grow.c
@@ -699,6 +699,102 @@ static void revert_container_raid_disks(struct supertype *st, int fd, char *cont
 	free_mdstat(ent);
 }
 
+void reshape_free_fdlist(int **fdlist_in,
+			 unsigned long long **offsets_in,
+			 int size)
+{
+	int i;
+	int *fdlist;
+	unsigned long long *offsets;
+	if ((offsets_in == NULL) || (offsets_in == NULL)) {
+		dprintf(Name " Error: Parameters verification error #1.\n");
+		return;
+	}
+
+	fdlist = *fdlist_in;
+	offsets = *offsets_in;
+	if ((fdlist == NULL) || (offsets == NULL)) {
+		dprintf(Name " Error: Parameters verification error #2.\n");
+		return;
+	}
+
+	for (i = 0; i < size; i++) {
+		if (fdlist[i] > 0)
+			close(fdlist[i]);
+	}
+
+	free(fdlist);
+	free(offsets);
+	*fdlist_in = NULL;
+	*offsets_in = NULL;
+}
+int reshape_prepare_fdlist(char *devname,
+			   struct mdinfo *sra,
+			   int raid_disks,
+			   int nrdisks,
+			   unsigned long blocks,
+			   char *backup_file,
+			   int **fdlist_in,
+			   unsigned long long **offsets_in)
+{
+	int d = 0;
+	int *fdlist;
+	unsigned long long *offsets;
+	struct mdinfo *sd;
+
+	if ((devname == NULL) || (sra == NULL) ||
+	    (fdlist_in == NULL) || (offsets_in == NULL)) {
+		dprintf(Name " Error: Parameters verification error #1.\n");
+		d = -1;
+		goto release;
+	}
+
+	fdlist = *fdlist_in;
+	offsets = *offsets_in;
+
+	if ((fdlist == NULL) || (offsets == NULL)) {
+		dprintf(Name " Error: Parameters verification error #2.\n");
+		d = -1;
+		goto release;
+	}
+
+	for (d = 0; d <= nrdisks; d++)
+		fdlist[d] = -1;
+	d = raid_disks;
+	for (sd = sra->devs; sd; sd = sd->next) {
+		if (sd->disk.state & (1<<MD_DISK_FAULTY))
+			continue;
+		if (sd->disk.state & (1<<MD_DISK_SYNC)) {
+			char *dn = map_dev(sd->disk.major,
+					   sd->disk.minor, 1);
+			fdlist[sd->disk.raid_disk]
+				= dev_open(dn, O_RDONLY);
+			offsets[sd->disk.raid_disk] = sd->data_offset*512;
+			if (fdlist[sd->disk.raid_disk] < 0) {
+				fprintf(stderr, Name ": %s: cannot open component %s\n",
+					devname, dn ? dn : "-unknown-");
+				d = -1;
+				goto release;
+			}
+		} else if (backup_file == NULL) {
+			/* spare */
+			char *dn = map_dev(sd->disk.major,
+					   sd->disk.minor, 1);
+				fdlist[d] = dev_open(dn, O_RDWR);
+				offsets[d] = (sd->data_offset + sra->component_size - blocks - 8)*512;
+				if (fdlist[d] < 0) {
+					fprintf(stderr, Name ": %s: cannot open component %s\n",
+						devname, dn ? dn : "-unknown-");
+					d = -1;
+					goto release;
+				}
+				d++;
+			}
+		}
+release:
+	return d;
+}
+
 int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		 long long size,
 		 int level, char *layout_str, int chunksize, int raid_disks) @@ -1435,38 +1531,13 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			rv = 1;
 			break;
 		}
-		for (d=0; d <= nrdisks; d++)
-			fdlist[d] = -1;
-		d = array.raid_disks;
-		for (sd = sra->devs; sd; sd=sd->next) {
-			if (sd->disk.state & (1<<MD_DISK_FAULTY))
-				continue;
-			if (sd->disk.state & (1<<MD_DISK_SYNC)) {
-				char *dn = map_dev(sd->disk.major,
-						   sd->disk.minor, 1);
-				fdlist[sd->disk.raid_disk]
-					= dev_open(dn, O_RDONLY);
-				offsets[sd->disk.raid_disk] = sd->data_offset*512;
-				if (fdlist[sd->disk.raid_disk] < 0) {
-					fprintf(stderr, Name ": %s: cannot open component %s\n",
-						devname, dn?dn:"-unknown-");
-					rv = 1;
-					goto release;
-				}
-			} else if (backup_file == NULL) {
-				/* spare */
-				char *dn = map_dev(sd->disk.major,
-						   sd->disk.minor, 1);
-				fdlist[d] = dev_open(dn, O_RDWR);
-				offsets[d] = (sd->data_offset + sra->component_size - blocks - 8)*512;
-				if (fdlist[d]<0) {
-					fprintf(stderr, Name ": %s: cannot open component %s\n",
-						devname, dn?dn:"-unknown");
-					rv = 1;
-					goto release;
-				}
-				d++;
-			}
+
+		d = reshape_prepare_fdlist(devname, sra, array.raid_disks,
+					nrdisks, blocks, backup_file,
+					&fdlist, &offsets);
+		if (d < 0) {
+			rv = 1;
+			goto release;
 		}
 		if (backup_file == NULL) {
 			if (st->ss->external && !st->ss->manage_reshape) { diff --git a/mdadm/mdadm/mdadm.h b/mdadm/mdadm/mdadm.h index d967057..3b5553a 100644
--- a/mdadm/mdadm/mdadm.h
+++ b/mdadm/mdadm/mdadm.h
@@ -450,6 +450,17 @@ extern int sysfs_unique_holder(int devnum, long rdev);  extern int sysfs_freeze_array(struct mdinfo *sra);  extern int load_sys(char *path, char *buf);  extern struct mdinfo *sysfs_get_unused_spares(int container_fd, int fd);
+extern int reshape_prepare_fdlist(char *devname,
+				  struct mdinfo *sra,
+				  int raid_disks,
+				  int nrdisks,
+				  unsigned long blocks,
+				  char *backup_file,
+				  int **fdlist_in,
+				  unsigned long long **offsets_in); extern void 
+reshape_free_fdlist(int **fdlist_in,
+				unsigned long long **offsets_in,
+				int size);
 
 
 extern int save_stripes(int *source, unsigned long long *offsets,

