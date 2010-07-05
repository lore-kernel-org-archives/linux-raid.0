From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 31/33] Fix problem in mdmon monitor of using removed disk
 from in imsm container.
Date: Mon, 5 Jul 2010 11:51:05 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC434@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C64@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C64@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:45 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 31/33] Fix problem in mdmon monitor of using removed di=
sk from in imsm container.

=46rom: Marcin Labun <marcin.labun@intel.com>

Manager thread shall pass the information to monitor thread (mdmon) tha=
t some devices are removed from container. Otherwise, monitor (mdmon) m=
igth use such devices (spares) to rebuild the array that has gone degra=
ded.

This problem happens for imsm containers, since a list of the container=
 disks is maintained in intel_super structure. When array goes degraded=
, the list is searched to find eligable spare disks to start rebuild.
Without this fix the rebuild could be stared on the spare device that w=
as a member of the contaiter, but has been removed from it.

New super type function handler has been introduced to prepare metadata=
 format specific information about removed devices.
int (*remove_from_super)(struct supertype *st, mdu_disk_info_t *dinfo,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 int fd);
The message prepared in remove_from_super is later procecessed by proce=
ess_update handler in monitor thread.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
=A0managemon.c=A0=A0 |=A0=A0 38 ++++++++++++++++
=A0mdadm.h=A0=A0=A0=A0=A0=A0 |=A0=A0=A0 7 +++-
=A0super-intel.c |=A0 138 +++++++++++++++++++++++++++++++++++++++++++++=
+-----------
=A03 files changed, 156 insertions(+), 27 deletions(-)

diff --git a/managemon.c b/managemon.c
index 454c39d..d1de78e 100644
--- a/managemon.c
+++ b/managemon.c
@@ -297,6 +297,43 @@ static void add_disk_to_container(struct supertype=
 *st, struct mdinfo *sd)
=A0=A0=A0=A0=A0 st->update_tail =3D NULL;
=A0}
=A0
+/*
+ * Create and queue update structure about the removed disks.
+ * The update is prepared by super type handler and passed to the=20
+monitor
+ * thread.
+ */
+static void remove_disk_from_container(struct supertype *st, struct=20
+mdinfo *sd) {
+=A0=A0=A0=A0 int dfd;
+=A0=A0=A0=A0 char nm[20];
+=A0=A0=A0=A0 struct metadata_update *update =3D NULL;
+=A0=A0=A0=A0 mdu_disk_info_t dk =3D {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .number =3D -1,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .major =3D sd->disk.major,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .minor =3D sd->disk.minor,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .raid_disk =3D -1,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .state =3D 0,
+=A0=A0=A0=A0 };
+=A0=A0=A0=A0 /* nothing to do if super type handler does not support
+=A0=A0=A0=A0 * remove disk primitive
+=A0=A0=A0=A0 */
+=A0=A0=A0=A0 if (!st->ss->remove_from_super)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return;
+=A0=A0=A0=A0 dprintf("%s: remove %d:%d to container\n",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __func__, sd->disk.major, sd->disk.mino=
r);
+
+=A0=A0=A0=A0 sprintf(nm, "%d:%d", sd->disk.major, sd->disk.minor);
+=A0=A0=A0=A0 dfd =3D dev_open(nm, O_RDWR);
+=A0=A0=A0=A0 if (dfd < 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return;
+
+=A0=A0=A0=A0 st->update_tail =3D &update;
+=A0=A0=A0=A0 st->ss->remove_from_super(st, &dk, dfd);
+=A0=A0=A0=A0 st->ss->write_init_super(st);
+=A0=A0=A0=A0 queue_metadata_update(update);
+=A0=A0=A0=A0 st->update_tail =3D NULL;
+}
+
=A0static void manage_container(struct mdstat_ent *mdstat,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 =A0=A0=A0=A0 struct s=
upertype *container)
=A0{
@@ -334,6 +371,7 @@ static void manage_container(struct mdstat_ent *mds=
tat,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!found) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 c=
d =3D *cdp;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *=
cdp =3D (*cdp)->next;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rem=
ove_disk_from_container(container, cd);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 f=
ree(cd);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 c=
dp =3D &(*cdp)->next;
diff --git a/mdadm.h b/mdadm.h
index a1ec751..47ad852 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -660,7 +660,12 @@ extern struct superswitch {
=A0=A0=A0=A0=A0 =A0* when hot-adding a spare.
=A0=A0=A0=A0=A0 =A0*/
=A0=A0=A0=A0=A0 int (*add_to_super)(struct supertype *st, mdu_disk_info=
_t *dinfo,
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0 int fd, =
char *devname);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 int fd, cha=
r *devname);
+=A0=A0=A0=A0 /* update the metadata to delete a device,
+=A0=A0=A0=A0 * when hot-removing a spare.
+=A0=A0=A0=A0 */
+=A0=A0=A0=A0 int (*remove_from_super)(struct supertype *st, mdu_disk_i=
nfo_t *dinfo,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int=
 fd);
=A0
=A0=A0=A0=A0=A0 /* Write metadata to one device when fixing problems or=
 adding
=A0=A0=A0=A0=A0 =A0* a new device.
diff --git a/super-intel.c b/super-intel.c index 6762129..b1529d4 10064=
4
--- a/super-intel.c
+++ b/super-intel.c
@@ -233,6 +233,10 @@ struct intel_dev {
=A0=A0=A0=A0=A0 int index;
=A0};
=A0
+enum action {
+=A0 DISK_REMOVE=3D0,
+=A0 DISK_ADD
+};
=A0/* internal representation of IMSM metadata */=A0 struct intel_super=
 {
=A0=A0=A0=A0=A0 union {
@@ -258,8 +262,9 @@ struct intel_super {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int extent_cnt;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct extent *e; /* for determining =
freespace @ create */
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int raiddisk; /* slot to fill in auto=
layout */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 enum action action;
=A0=A0=A0=A0=A0 } *disks;
-=A0=A0=A0=A0 struct dl *add; /* list of disks to add while mdmon activ=
e */
+=A0=A0=A0=A0 struct dl *disk_mgmt_list; /* list of disks to add/remove=
 while mdmon=20
+active */
=A0=A0=A0=A0=A0 struct dl *missing; /* disks removed while we weren't l=
ooking */
=A0=A0=A0=A0=A0 struct bbm_log *bbm_log;
=A0=A0=A0=A0=A0 const char *hba; /* device path of the raid controller =
for this metadata */ @@ -282,7 +287,7 @@ struct extent {=A0 enum imsm_u=
pdate_type {
=A0=A0=A0=A0=A0 update_activate_spare,
=A0=A0=A0=A0=A0 update_create_array,
-=A0=A0=A0=A0 update_add_disk,
+=A0=A0=A0=A0 update_add_remove_disk,
=A0};
=A0
=A0struct imsm_update_activate_spare {
@@ -303,7 +308,7 @@ struct imsm_update_create_array {
=A0=A0=A0=A0=A0 struct imsm_dev dev;
=A0};
=A0
-struct imsm_update_add_disk {
+struct imsm_update_add_remove_disk {
=A0=A0=A0=A0=A0 enum imsm_update_type type;
=A0};
=A0
@@ -2303,6 +2308,7 @@ static void __free_imsm_disk(struct dl *d)
=A0=A0=A0=A0=A0 free(d);
=A0
=A0}
+
=A0static void free_imsm_disks(struct intel_super *super)=A0 {
=A0=A0=A0=A0=A0 struct dl *d;
@@ -3278,6 +3284,7 @@ static int add_to_super_imsm(struct supertype *st=
, mdu_disk_info_t *dk,
=A0=A0=A0=A0=A0 dd->devname =3D devname ? strdup(devname) : NULL;
=A0=A0=A0=A0=A0 dd->fd =3D fd;
=A0=A0=A0=A0=A0 dd->e =3D NULL;
+=A0=A0=A0=A0 dd->action =3D DISK_ADD;
=A0=A0=A0=A0=A0 rv =3D imsm_read_serial(fd, devname, dd->serial);
=A0=A0=A0=A0=A0 if (rv) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr,
@@ -3297,8 +3304,8 @@ static int add_to_super_imsm(struct supertype *st=
, mdu_disk_info_t *dk,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dd->disk.scsi_id =3D __cpu_to_le32(0)=
;
=A0
=A0=A0=A0=A0=A0 if (st->update_tail) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dd->next =3D super->add;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 super->add =3D dd;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dd->next =3D super->disk_mgmt_list;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 super->disk_mgmt_list =3D dd;
=A0=A0=A0=A0=A0 } else {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dd->next =3D super->disks;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 super->disks =3D dd;
@@ -3307,6 +3314,44 @@ static int add_to_super_imsm(struct supertype *s=
t, mdu_disk_info_t *dk,
=A0=A0=A0=A0=A0 return 0;
=A0}
=A0
+
+static int remove_from_super_imsm(struct supertype *st, mdu_disk_info_=
t *dk,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
 int fd)
+{
+=A0=A0=A0=A0 struct intel_super *super =3D st->sb;
+=A0=A0=A0=A0 struct dl *dd;
+
+=A0=A0=A0=A0 /* remove from super works only in mdmon - for communicat=
ion
+=A0=A0=A0=A0 * manager - monitor. Check if communication memory buffer
+=A0=A0=A0=A0 * is prepared.
+=A0=A0=A0=A0 */
+=A0=A0=A0=A0 if (!st->update_tail) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name ": %s shall be u=
sed in mdmon context only (line %d).\n", __func__, __LINE__);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 dd =3D malloc(sizeof(*dd));
+=A0=A0=A0=A0 if (!dd) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr,
+=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name ": malloc failed %=
s:%d.\n", __func__, __LINE__);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 memset(dd, 0, sizeof(*dd));
+=A0=A0=A0=A0 dd->major =3D dk->major;
+=A0=A0=A0=A0 dd->minor =3D dk->minor;
+=A0=A0=A0=A0 dd->index =3D -1;
+=A0=A0=A0=A0 dd->fd =3D fd;
+=A0=A0=A0=A0 dd->disk.status =3D SPARE_DISK;
+=A0=A0=A0=A0 dd->action =3D DISK_REMOVE;
+
+=A0=A0=A0=A0 if (st->update_tail) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dd->next =3D super->disk_mgmt_list;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 super->disk_mgmt_list =3D dd;
+=A0=A0=A0=A0 }
+
+=A0=A0=A0=A0 return 0;
+}
+
=A0static int store_imsm_mpb(int fd, struct imsm_super *mpb);
=A0
=A0static union {
@@ -3459,13 +3504,13 @@ static int create_array(struct supertype *st, i=
nt dev_idx)
=A0=A0=A0=A0=A0 return 0;
=A0}
=A0
-static int _add_disk(struct supertype *st)
+static int mgmt_disk(struct supertype *st)
=A0{
=A0=A0=A0=A0=A0 struct intel_super *super =3D st->sb;
=A0=A0=A0=A0=A0 size_t len;
-=A0=A0=A0=A0 struct imsm_update_add_disk *u;
+=A0=A0=A0=A0 struct imsm_update_add_remove_disk *u;
=A0
-=A0=A0=A0=A0 if (!super->add)
+=A0=A0=A0=A0 if (!super->disk_mgmt_list)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
=A0
=A0=A0=A0=A0=A0 len =3D sizeof(*u);
@@ -3476,7 +3521,7 @@ static int _add_disk(struct supertype *st)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
=A0=A0=A0=A0=A0 }
=A0
-=A0=A0=A0=A0 u->type =3D update_add_disk;
+=A0=A0=A0=A0 u->type =3D update_add_remove_disk;
=A0=A0=A0=A0=A0 append_metadata_update(st, u, len);
=A0
=A0=A0=A0=A0=A0 return 0;
@@ -3498,10 +3543,10 @@ static int write_init_super_imsm(struct superty=
pe *st)
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* determine if we are creating a vol=
ume or adding a disk */
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (current_vol < 0) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* in the add disk ca=
se we are running in mdmon
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* in the mgmt (add/r=
emove) disk case we are running in mdmon
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0* context, so do=
n't close fd's
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0*/
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return _add_disk(st);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return mgmt_disk(st);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D create_array=
(st, current_vol);
=A0
@@ -4594,10 +4639,9 @@ static int store_imsm_mpb(int fd, struct imsm_su=
per *mpb)=A0 static void imsm_sync_metadata(struct supertype *container=
)=A0 {
=A0=A0=A0=A0=A0 struct intel_super *super =3D container->sb;
-
+=A0=A0=A0=A0 dprintf("sync metadata: %d\n", super->updates_pending);
=A0=A0=A0=A0=A0 if (!super->updates_pending)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return;
-
=A0=A0=A0=A0=A0 write_super_imsm(super, 0);
=A0
=A0=A0=A0=A0=A0 super->updates_pending =3D 0;
@@ -4886,6 +4930,31 @@ static int disks_overlap(struct intel_super *sup=
er, int idx, struct imsm_update_
=A0=A0=A0=A0=A0 return 0;
=A0}
=A0
+static int remove_disk_super(struct intel_super *super,=A0 int major, =
int=20
+minor) {
+=A0=A0=A0=A0 struct dl *prev =3D NULL;
+=A0=A0=A0=A0 struct dl *dl;
+
+=A0=A0=A0=A0 prev =3D NULL;
+=A0=A0=A0=A0 for (dl =3D super->disks; dl; dl =3D dl->next) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if ((dl->major =3D=3D major) &&
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 (dl->minor =3D=3D minor)) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 /* remove */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (prev)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pre=
v->next =3D dl->next;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sup=
er->disks =3D dl->next;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dl->next =3D NULL;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __free_imsm_disk(dl);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dprintf("%s: removed =
%x:%x\n",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __f=
unc__, major, minor);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 prev =3D dl;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 return 0;
+}
+
=A0static void imsm_delete(struct intel_super *super, struct dl **dlp, =
int index);
=A0
=A0static void imsm_process_update(struct supertype *st, @@ -5133,31 +5=
202,47 @@ static void imsm_process_update(struct supertype *st,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
=A0=A0=A0=A0=A0 }
-=A0=A0=A0=A0 case update_add_disk:
+=A0=A0=A0=A0 case update_add_remove_disk: {
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* we may be able to repair some arra=
ys if disks are
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0* being added */
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (super->add) {
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* add/remove some spares to/from the m=
etadata/contrainer */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int check_degraded =3D 0;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 while (super->disk_mgmt_list) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct dl *disk_cfg;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 disk_cfg =3D super->d=
isk_mgmt_list;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 super->disk_mgmt_list=
 =3D disk_cfg->next;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 disk_cfg->next =3D NU=
LL;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (disk_cfg->action =
=3D=3D DISK_ADD) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dis=
k_cfg->next =3D super->disks;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sup=
er->disks =3D disk_cfg;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 che=
ck_degraded =3D 1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dpr=
intf("%s: added %x:%x\n",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 __func__, disk_cfg->major, disk_cfg->minor);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else if (disk_cfg->=
action =3D=3D DISK_REMOVE) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dpr=
intf("Disk remove action processed: %x.%x\n",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 disk_cfg->major, disk_cfg->minor);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rem=
ove_disk_super(super,=A0 disk_cfg->major, disk_cfg->minor);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __f=
ree_imsm_disk(disk_cfg);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (check_degraded) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct active_array=
 *a;
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 super->updates_pend=
ing++;
=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for (a =3D st->arrays=
; a; a =3D a->next)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 a=
->check_degraded =3D 1;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* add some spares to the metadata */
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 while (super->add) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct dl *al;
-
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 al =3D super->add;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 super->add =3D al->ne=
xt;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 al->next =3D super->d=
isks;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 super->disks =3D al;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dprintf("%s: added %x=
:%x\n",
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __f=
unc__, al->major, al->minor);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0 default:
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, "error: unsuported proc=
ess update type: (type: %d)\n",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 type);
+=A0=A0=A0=A0 }
=A0}
=A0
=A0static void imsm_prepare_update(struct supertype *st, @@ -5358,6 +54=
43,7 @@ struct superswitch super_imsm =3D {
=A0=A0=A0=A0=A0 .write_init_super =3D write_init_super_imsm,
=A0=A0=A0=A0=A0 .validate_geometry =3D validate_geometry_imsm,
=A0=A0=A0=A0=A0 .add_to_super=A0=A0=A0=A0 =3D add_to_super_imsm,
+=A0=A0=A0=A0 .remove_from_super=A0=A0=A0=A0=A0 =3D remove_from_super_i=
msm,
=A0=A0=A0=A0=A0 .detail_platform =3D detail_platform_imsm,=A0 #endif
=A0=A0=A0=A0=A0 .match_home =3D match_home_imsm,
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
