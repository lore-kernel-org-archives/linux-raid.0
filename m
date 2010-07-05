From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 23/33] Monitor: Spare sharing with domain/subset support
Date: Mon, 5 Jul 2010 11:49:17 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC41C@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C47@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C47@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:38 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 23/33] Monitor: Spare sharing with domain/subset suppor=
t

Works for both native and external metadata.
Moves spares between arrays/containers with matching domain and subset =
to use for rebuild.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
=A0Monitor.c |=A0 209 +++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++--
=A01 files changed, 202 insertions(+), 7 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index ed57af0..11f3758 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -49,6 +49,7 @@ struct state {
=A0=A0=A0=A0=A0 int devstate[MaxDisks];
=A0=A0=A0=A0=A0 int devid[MaxDisks];
=A0=A0=A0=A0=A0 int percent;
+=A0=A0=A0=A0 unsigned long long min_size;
=A0=A0=A0=A0=A0 char *metadata_version;
=A0=A0=A0=A0=A0 struct state *next;
=A0=A0=A0=A0=A0 struct state *volumes;
@@ -56,6 +57,9 @@ struct state {
=A0=A0=A0=A0=A0 struct state *missing;
=A0};
=A0
+static void spare_sharing(struct state *statelist, char *mailaddr,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 char *mailfrom, c=
har *alert_cmd, int dosyslog);
+
=A0int Monitor(mddev_dev_t devlist,
=A0=A0=A0=A0=A0 =A0=A0=A0 char *mailaddr, char *alert_cmd,
=A0=A0=A0=A0=A0 =A0=A0=A0 int period, int daemonise, int scan, int ones=
hot, @@ -92,11 +96,10 @@ int Monitor(mddev_dev_t devlist,
=A0=A0=A0=A0=A0 =A0*=A0=A0=A0 DeviceDisappeared
=A0=A0=A0=A0=A0 =A0*=A0=A0=A0=A0=A0 Couldn't access a device which was =
previously visible
=A0=A0=A0=A0=A0 =A0*
-=A0=A0=A0=A0 * if we detect an array with active<raid and spare=3D=3D0
-=A0=A0=A0=A0 * we look at other arrays that have same spare-group
-=A0=A0=A0=A0 * If we find one with active=3D=3Draid and spare>0,
-=A0=A0=A0=A0 *=A0 and if we can get_disk_info and find a name
-=A0=A0=A0=A0 *=A0 Then we hot-remove and hot-add to the other array
+=A0=A0=A0=A0 * If we detect an array with active<raid and spare=3D=3D0
+=A0=A0=A0=A0 * we look at other arrays that have a spare
+=A0=A0=A0=A0 * and are in the same domain and subset
+=A0=A0=A0=A0 * Then we hot-remove and hot-add to the other array
=A0=A0=A0=A0=A0 =A0*
=A0=A0=A0=A0=A0 =A0* If devlist is NULL, then we can monitor everything=
 because --scan
=A0=A0=A0=A0=A0 =A0* was given.=A0 We get an initial list from config f=
ile and add anything @@ -185,6 +188,9 @@ int Monitor(mddev_dev_t devlis=
t,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 st->parent =3D NULL=
;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 st->volumes =3D NUL=
L;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 st->total =3D 0;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 st->min_size =3D 0;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memset(st->devid, 0, =
MaxDisks*sizeof(int));
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memset(st->devstate, =
0, MaxDisks*sizeof(int));
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (mdlist->spare_g=
roup)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
t->spare_group =3D strdup(mdlist->spare_group);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else
@@ -211,6 +217,9 @@ int Monitor(mddev_dev_t devlist,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 st->parent =3D NULL=
;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 st->volumes =3D NUL=
L;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 st->total =3D 0;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 st->min_size =3D 0;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memset(st->devid, 0, =
MaxDisks*sizeof(int));
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memset(st->devstate, =
0, MaxDisks*sizeof(int));
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (mdlist) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
t->expected_spares =3D mdlist->spare_disks;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
f (mdlist->spare_group)
@@ -371,6 +380,7 @@ int Monitor(mddev_dev_t devlist,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
nt newstate=3D0;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
nt change;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 c=
har *dv =3D NULL;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uns=
igned long long dsize;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 d=
isc.number =3D i;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
f (i > array.raid_disks + array.nr_disks) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 newstate =3D 0;
@@ -415,6 +425,17 @@ int Monitor(mddev_dev_t devlist,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
t->devstate[i] =3D newstate;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
t->devid[i] =3D makedev(disc.major, disc.minor);
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* =
for volumes only we get minimum disk size
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * (=
only active disks) */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fd =
=3D open(dv, O_RDONLY);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(dv && newstate & (1<<MD_DISK_ACTIVE) &&
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0=A0 array.raid_disks && fd >=3D 0 &&
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0=A0 get_dev_size(fd, dv, &dsize) &&
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0=A0 (st->min_size =3D=3D 0 || dsize < st->min_size))
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 st->min_size =3D dsize;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(fd >=3D 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 close(fd);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 st->active =3D arra=
y.active_disks;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 st->working =3D arr=
ay.working_disks;
@@ -506,6 +527,7 @@ int Monitor(mddev_dev_t devlist,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 new_found =3D 1;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 spare_sharing(statelist, mailaddr, mail=
from, alert_cmd, dosyslog);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* If an array has active < raid && s=
pare =3D=3D 0 && spare_group !=3D NULL
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0* Look for another array with spar=
e > 0 and active =3D=3D raid and same spare_group
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0*=A0 if found, choose a device and=
 hotremove/hotadd @@ -577,8 +599,63 @@ int Monitor(mddev_dev_t devlist,
=A0=A0=A0=A0=A0 return 0;
=A0}
=A0
+static int move_spare(struct state *st2, struct state *st1, int i, cha=
r *mailaddr,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 char *mailfrom, char *a=
lert_cmd, int dosyslog)
+
+{
+=A0=A0=A0=A0 struct mddev_dev_s devlist;
+=A0=A0=A0=A0 char devname[20];
+=A0=A0=A0=A0 int from_fd, to_fd;
+
+=A0=A0=A0=A0 if (!st1 || !st2 || st2->devid[i] =3D=3D 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+
+=A0=A0=A0=A0 from_fd =3D open(st2->devname, O_RDONLY);
+=A0=A0=A0=A0 if (from_fd < 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+
+=A0=A0=A0=A0 to_fd =3D open(st1->devname, O_RDONLY);
+=A0=A0=A0=A0 if (to_fd < 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(from_fd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 }
+
+=A0=A0=A0=A0 devlist.next =3D NULL;
+=A0=A0=A0=A0 devlist.used =3D 0;
+=A0=A0=A0=A0 devlist.re_add =3D 0;
+=A0=A0=A0=A0 devlist.writemostly =3D 0;
+=A0=A0=A0=A0 devlist.devname =3D devname;
+=A0=A0=A0=A0 char *dv =3D map_dev(major(st2->devid[i]), minor(st2->dev=
id[i]), 1);
+=A0=A0=A0=A0 if (!dv) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(from_fd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(to_fd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 snprintf(devname, 20, "%s", dv);
+
+=A0=A0=A0=A0 devlist.disposition =3D 'r';
+=A0=A0=A0=A0 if (Manage_subdevs(st2->devname, from_fd, &devlist, -1) =3D=
=3D 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devlist.disposition =3D 'a';
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (Manage_subdevs(st1->devname, to_fd,=
 &devlist, -1) =3D=3D 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 st2->devid[i] =3D 0;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ping_manager(st2->dev=
name);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ping_manager(st1->dev=
name);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 alert("MoveSpare", st=
1->devname, st2->devname, mailaddr,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 mailf=
rom, alert_cmd, dosyslog);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(from_fd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(to_fd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Manage_subdevs(st2->d=
evname, from_fd, &devlist, -1);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 close(from_fd);
+=A0=A0=A0=A0 close(to_fd);
+=A0=A0=A0=A0 return 0;
+}
+
=A0/* check if disk is used in donor array (native) or any volume in do=
nor container (external)*/ -int check_disk_is_free(struct state *donor,=
 int disk_idx, int ext)
+static int check_disk_is_free(struct state *donor, int disk_idx, int=20
+ext)
=A0{
=A0=A0=A0=A0=A0 struct state *vol =3D NULL;
=A0=A0=A0=A0=A0 int vol_disk;
@@ -601,7 +678,7 @@ int check_disk_is_free(struct state *donor, int dis=
k_idx, int ext)
=A0=A0=A0=A0=A0 return disk_idx;
=A0}
=A0
-int get_disk_domain_and_subset(int devid, char *metadata_version, stru=
ct domain_ent **domain,
+static int get_disk_domain_and_subset(int devid, char=20
+*metadata_version, struct domain_ent **domain,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0=A0=A0=A0 struct subset **subset, int fcheck)=A0 {
=A0=A0=A0=A0=A0 struct supertype *sty;
@@ -650,6 +727,124 @@ fail:
=A0=A0=A0=A0=A0 return 0;
=A0}
=A0
+/* If an array has active < raid && spare =3D=3D 0
+ * Look for another array/container with unused, unfailed spare
+ * and the same domain and subset
+ * if found, hotremove/hotadd the spare (to parent container in=20
+external)=A0 */ static=A0 void spare_sharing(struct state *statelist, =
char=20
+*mailaddr,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0 char *mailfrom=
, char *alert_cmd, int dosyslog) {
+=A0=A0=A0=A0 struct state *st, *stp, *vol, *st2 =3D NULL;
+=A0=A0=A0=A0 struct domain_ent *domain, *spare_domain;
+=A0=A0=A0=A0 struct subset *subset, *spare_subset;
+=A0=A0=A0=A0 int i, ext, found;
+=A0=A0=A0=A0 unsigned long long ssize;
+
+=A0=A0=A0=A0 for (st =3D statelist; st; st =3D st->next) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (st->err || st->active =3D=3D st->ra=
id || st->spare > 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 found =3D 0;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ext =3D is_external(st->metadata_versio=
n);
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /*
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * for exernal metadata spare will be mo=
ved to parent container
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ext) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 stp =3D st->parent;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!stp)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 con=
tinue;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 stp =3D st;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* check if there is a spare in this ar=
ray/parent container */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for (i =3D 0; i < stp->total; i++)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if ((check_disk_is_fr=
ee(stp, i, ext) =3D=3D i) &&
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 (!ext || !d=
isk_faulty_from_id(stp->devid[i])))
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bre=
ak;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (i < stp->total)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* there is a spare i=
n array/parent container,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * if it is big enough=
 it was probably just added
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * but mdmon has not s=
tarted recovery yet
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * we will not add any=
 more spares for now */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (dev_size_from_id(=
stp->devid[i], &ssize) &&
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 ssize >=3D =
st->min_size)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 con=
tinue;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* get any good disk from array to chec=
k domain and subset */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for (i =3D 0; i < st->total; i++)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (st->devid[i] > 0 =
&&
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 (st->devsta=
te[i] &=A0 1<<MD_DISK_ACTIVE))
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bre=
ak;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (i =3D=3D st->total)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!get_disk_domain_and_subset(st->dev=
id[i],
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 stp=
->metadata_version, &domain, &subset, 0))
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* search for an array/container with u=
nused spare */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for (st2 =3D statelist; st2; st2 =3D st=
2->next) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (st2->err || st2 =3D=
=3D stp)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 con=
tinue;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if ((ext && st2->pare=
nt !=3D NULL) ||
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 (strcmp(stp=
->metadata_version, st2->metadata_version)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 !=3D 0))
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 con=
tinue;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ext) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* =
if container has degraded volume
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * w=
e can't remove spares */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for=
 (vol =3D st2->volumes; vol; vol =3D vol->volumes)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 if (vol->active < vol->raid)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(vol)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 continue;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(st2->active < st2->raid)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 continue;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for (i =3D 0; i < st2=
->total; i++) { /* find a spare */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(check_disk_is_free(st2, i, ext) =3D=3D INT_MAX)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 continue;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(!get_disk_domain_and_subset(st2->devid[i],
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 st2->metadata_version,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &spare_domain, &spare_subset, ext))
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 continue;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* =
check if domain and subset
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * a=
re the same as for st */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
((domain !=3D spare_domain) ||
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0=A0 (subset !=3D spare_subset)) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 /* no point looking
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 * in that array/container */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 break;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } e=
lse {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 if (!dev_size_from_id(st2->devid[i], &ssize) ||
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =A0=A0=A0 ssize < st->min_size)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 if (move_spare(st2, stp, i, mailaddr,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0 mailfrom, alert_cmd,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0 dosyslog)) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 found =3D 1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* stop searching disks */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (found)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bre=
ak; /* stop searching arrays */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 return;
+}
+
=A0static void alert(char *event, char *dev, char *disc, char *mailaddr=
, char *mailfrom, char *cmd,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 int dosyslog)
=A0{
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
