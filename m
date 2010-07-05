From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 20/33] Added disk util functions
Date: Mon, 5 Jul 2010 11:47:49 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC40F@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C3E@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C3E@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:34 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 20/33] Added disk util functions

Needed for checking suitability of a disk to use for rebuild.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
=A0mdadm.h=A0=A0=A0=A0=A0=A0 |=A0=A0 11 +++++++++++
=A0super-ddf.c=A0=A0 |=A0=A0 36 ++++++++++++++++++++++++++++++++++++
=A0super-intel.c |=A0=A0 31 +++++++++++++++++++++++++++++++
=A0util.c=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 55 +++++++++++++++++++++++++++++=
++++++++++++++++++++++++++
=A04 files changed, 133 insertions(+), 0 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index b6d7933..86f5370 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -277,6 +277,12 @@ enum special_options {
=A0=A0=A0=A0=A0 DetailPlatform,
=A0};
=A0
+enum disk_status {
+=A0=A0=A0=A0 unknown,
+=A0=A0=A0=A0 spare_disk,
+=A0=A0=A0=A0 failed_disk,
+};
+
=A0enum domain_actions {
=A0=A0=A0=A0=A0 ignore,
=A0=A0=A0=A0=A0 incremental,
@@ -656,6 +662,8 @@ extern struct superswitch {
=A0=A0=A0=A0=A0 int (*load_super)(struct supertype *st, int fd, char *d=
evname);
=A0=A0=A0=A0=A0 struct supertype * (*match_metadata_desc)(char *arg);
=A0=A0=A0=A0=A0 __u64 (*avail_size)(struct supertype *st, __u64 size);
+
+=A0=A0=A0=A0 enum disk_status (*get_disk_status)(struct supertype *st,=
 int major,=20
+int minor);
=A0=A0=A0=A0=A0 int (*add_internal_bitmap)(struct supertype *st, int *c=
hunkp,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0 int delay, int write_behind,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0 unsigned long long size, int may_change, int major); @@ -795,6 +803=
,7 @@ extern struct supertype *super_by_fd(int fd);=A0 extern struct su=
pertype *guess_super(int fd);=A0 extern struct supertype *dup_super(str=
uct supertype *st);=A0 extern int get_dev_size(int fd, char *dname, uns=
igned long long *sizep);
+extern int dev_size_from_id(int id, unsigned long long *ssize);
=A0extern void get_one_disk(int mdfd, mdu_array_info_t *ainf,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0mdu_disk_info_t =
*disk);
=A0void wait_for(char *dev, int fd);
@@ -1023,6 +1032,8 @@ extern int get_active_array_domain(char *array_na=
me, int fd,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0 struct domain_ent **domain,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0 struct subset **subset);
=A0extern int is_external(char *metadata_verison);
+extern int disk_faulty(struct supertype *sty, int major, int minor);=20
+extern int disk_faulty_from_id(int devid);
=A0
=A0static inline int dev2major(int d)
=A0{
diff --git a/super-ddf.c b/super-ddf.c
index b01c68d..aa5dc89 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2436,6 +2436,41 @@ static __u64 avail_size_ddf(struct supertype *st=
, __u64 devsize)
=A0=A0=A0=A0=A0 return devsize - 32*1024*2;
=A0}
=A0
+/* Get the disk status from metadata. 1 for spare, 2 for failed disk, =
0=20
+otherwise */ static enum disk_status get_disk_status_ddf(struct=20
+supertype *st, int major, int minor) {
+=A0=A0=A0=A0 if (!st)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return unknown;
+
+=A0=A0=A0=A0 struct ddf_super *super =3D st->sb;
+=A0=A0=A0=A0 struct phys_disk_entry disk;
+=A0=A0=A0=A0 struct dl *list;
+=A0=A0=A0=A0 int i;
+
+=A0=A0=A0=A0 if (!super)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return unknown;
+=A0=A0=A0=A0 list =3D super->dlist;
+
+=A0=A0=A0=A0 i =3D -1;
+=A0=A0=A0=A0 while (list) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (list->major =3D=3D major && list->m=
inor =3D=3D minor) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i =3D list->pdnum;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 list =3D list->next;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 if (i =3D=3D -1)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return unknown;
+
+=A0=A0=A0=A0 disk =3D super->phys->entries[i];
+=A0=A0=A0=A0 if (__be16_to_cpu(disk.state) & DDF_Failed)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return failed_disk;
+=A0=A0=A0=A0 if ((__be16_to_cpu(disk.type) & DDF_Global_Spare) ||
+=A0=A0=A0=A0 =A0=A0=A0 (__be16_to_cpu(disk.type) & DDF_Spare))
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return spare_disk;
+=A0=A0=A0=A0 return unknown;
+}
+
=A0#ifndef MDASSEMBLE
=A0
=A0static int reserve_space(struct supertype *st, int raiddisks, @@ -36=
58,6 +3693,7 @@ struct superswitch super_ddf =3D {
=A0=A0=A0=A0=A0 .update_super=A0=A0=A0=A0 =3D update_super_ddf,
=A0
=A0=A0=A0=A0=A0 .avail_size =3D avail_size_ddf,
+=A0=A0=A0=A0 .get_disk_status =3D get_disk_status_ddf,
=A0
=A0=A0=A0=A0=A0 .compare_super=A0=A0=A0 =3D compare_super_ddf,
=A0
diff --git a/super-intel.c b/super-intel.c index 4dcc654..6762129 10064=
4
--- a/super-intel.c
+++ b/super-intel.c
@@ -1710,6 +1710,36 @@ static __u64 avail_size_imsm(struct supertype *s=
t, __u64 devsize)
=A0=A0=A0=A0=A0 return devsize - (MPB_SECTOR_CNT + IMSM_RESERVED_SECTOR=
S);=A0 }
=A0
+static int serialcmp(__u8 *s1, __u8 *s2);
+
+/* Get the disk status from metadata. 1 for spare, 2 for failed disk, =
0=20
+otherwise */ static enum disk_status get_disk_status_imsm(struct=20
+supertype *st, int major, int minor) {
+=A0=A0=A0=A0 if (!st)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return unknown;
+
+=A0=A0=A0=A0 struct intel_super *super =3D st->sb;
+=A0=A0=A0=A0 struct imsm_disk *disk;
+=A0=A0=A0=A0 struct dl *dlist;
+
+=A0=A0=A0=A0 if (!super)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return unknown;
+=A0=A0=A0=A0 dlist =3D super->disks;
+
+=A0=A0=A0=A0 while (dlist) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 disk =3D &dlist->disk;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (major =3D=3D dlist->major && minor =
=3D=3D dlist->minor) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (disk->status & FA=
ILED_DISK)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret=
urn failed_disk;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (disk->status & SP=
ARE_DISK)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret=
urn spare_disk;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return unknown;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dlist =3D dlist->next;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 return unknown;
+}
+
=A0static void free_devlist(struct intel_super *super)=A0 {
=A0=A0=A0=A0=A0 struct intel_dev *dv;
@@ -5336,6 +5366,7 @@ struct superswitch super_imsm =3D {
=A0=A0=A0=A0=A0 .update_super=A0=A0=A0=A0 =3D update_super_imsm,
=A0
=A0=A0=A0=A0=A0 .avail_size =3D avail_size_imsm,
+=A0=A0=A0=A0 .get_disk_status =3D get_disk_status_imsm,
=A0
=A0=A0=A0=A0=A0 .compare_super=A0=A0=A0 =3D compare_super_imsm,
=A0
diff --git a/util.c b/util.c
index a746b83..fcc9e69 100644
--- a/util.c
+++ b/util.c
@@ -1246,6 +1246,24 @@ int get_dev_size(int fd, char *dname, unsigned l=
ong long *sizep)
=A0=A0=A0=A0=A0 return 1;
=A0}
=A0
+int dev_size_from_id(int id, unsigned long long *ssize) {
+=A0=A0=A0=A0 char *dv;
+=A0=A0=A0=A0 int fd;
+
+=A0=A0=A0=A0 dv =3D map_dev(major(id), minor(id), 1);
+=A0=A0=A0=A0 if (!dv)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 fd =3D open(dv, O_RDONLY);
+=A0=A0=A0=A0 if (fd < 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 if (get_dev_size(fd, dv, ssize)) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(fd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 close(fd);
+=A0=A0=A0=A0 return 0;
+}
=A0
=A0/* Sets endofpart parameter to the last block used by the last GPT p=
artition on the device.
=A0 * Returns: 1 if successful
@@ -1776,6 +1794,43 @@ char *get_devpath_from_devname(char *devname)
=A0=A0=A0=A0=A0 return NULL;
=A0}
=A0
+/* Check if disk has failed status in metadata*/ int disk_faulty(struc=
t=20
+supertype *sty, int major, int minor) {
+=A0=A0=A0=A0 enum disk_status status;
+=A0=A0=A0=A0 if (!sty)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
+=A0=A0=A0=A0 status =3D sty->ss->get_disk_status(sty, major, minor);
+=A0=A0=A0=A0 return status =3D=3D failed_disk;
+}
+
+int disk_faulty_from_id(int devid)
+{
+=A0=A0=A0=A0 struct supertype *sty;
+=A0=A0=A0=A0 int fd, rv =3D 1;
+=A0=A0=A0=A0 char *devname;
+=A0=A0=A0=A0 if (devid <=3D 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return rv;
+=A0=A0=A0=A0 devname =3D map_dev(major(devid), minor(devid), 1);
+=A0=A0=A0=A0 if (!devname)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return rv;
+=A0=A0=A0=A0 fd =3D open(devname, O_RDONLY);
+=A0=A0=A0=A0 if (fd < 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return rv;
+=A0=A0=A0=A0 sty =3D guess_super(fd);
+=A0=A0=A0=A0 if (!sty) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(fd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return rv;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 rv =3D sty->ss->load_super(sty, fd, devname);
+=A0=A0=A0=A0 if (!rv)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D disk_faulty(sty, major(devid), m=
inor(devid));
+=A0=A0=A0=A0 close(fd);
+=A0=A0=A0=A0 sty->ss->free_super(sty);
+=A0=A0=A0=A0 free(sty);
+=A0=A0=A0=A0 return rv;
+}
+
=A0static int sfdisk_validate(struct domain_ent *domain)=A0 {
=A0=A0=A0=A0=A0 return 0;
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
