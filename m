From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 27/33] extension of IncrementalRemove to store location
 (port) of removed device
Date: Mon, 5 Jul 2010 11:50:08 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC42B@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C55@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C55@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:41 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 27/33] extension of IncrementalRemove to store location=
 (port) of removed device

=46rom: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.=
com>

If the disk is taken out from its port this port information is lost. O=
nly udev rule can provide us with this information, and then we have to=
 store it somehow. This patch adds writing 'cookie' file in /var/run/md=
adm directory in form of file named with value of <path-id>, containing=
 the names of arrays holding this device before it was removed.
=46AILED_SLOTS constant has been added to hold the location of cookie f=
iles.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski=
@intel.com>
---
=A0Incremental.c |=A0=A0 63 +++++++++++++++++++++++++++++++++++++++++++=
+++++++++----
=A0Makefile=A0=A0=A0=A0=A0 |=A0=A0=A0 6 +++-
=A0mdadm.h=A0=A0=A0=A0=A0=A0 |=A0=A0=A0 8 +++++++
=A03 files changed, 70 insertions(+), 7 deletions(-)

diff --git a/Incremental.c b/Incremental.c index 20e3445..adaefb9 10064=
4
--- a/Incremental.c
+++ b/Incremental.c
@@ -937,19 +937,22 @@ int Incremental_container(struct supertype *st, c=
har *devname, int verbose,
=A0 * raid arrays, and if so first fail (if needed) and then remove the=
 device.
=A0 *
=A0 * @devname - The device we want to remove
+ * @id_path - name as found in /dev/disk/by-path for this device
=A0 *
=A0 * Note: the device name must be a kernel name like "sda", so
=A0 * that we can find it in /proc/mdstat
=A0 */
-int IncrementalRemove(char *devname, char *path, int verbose)
+int IncrementalRemove(char *devname, char *id_path, int verbose)
=A0{
=A0=A0=A0=A0=A0 int mdfd;
=A0=A0=A0=A0=A0 int rv;
-=A0=A0=A0=A0 struct mdstat_ent *ent;
+=A0=A0=A0=A0 struct mdstat_ent *ent, *mds, *mi;
=A0=A0=A0=A0=A0 struct mddev_dev_s devlist;
+=A0=A0=A0=A0 char path[PATH_MAX];
+=A0=A0=A0=A0 FILE *id_fd;
=A0
-=A0=A0=A0=A0 if (!path) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ": incremental rem=
oval without --path <path_id> lacks "
+=A0=A0=A0=A0 if (!id_path) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ": incremental rem=
oval without --path <id_path> lacks "
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "the possibility to=
 re-add new device in this port\n");
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
=A0=A0=A0=A0=A0 }
@@ -965,15 +968,65 @@ int IncrementalRemove(char *devname, char *path, =
int verbose)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "of any array\n", d=
evname);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0 strncpy(path, FAILED_SLOTS, PATH_MAX);
+=A0=A0=A0=A0 if (mkdir(path, O_CREAT) < 0 && errno !=3D EEXIST) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ": can't create fi=
le to save path to old disk\n");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 snprintf(path, PATH_MAX, FAILED_SLOTS "/%s", id_path);
+
+=A0=A0=A0=A0 if ((id_fd =3D fopen(path, "w")) =3D=3D NULL) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ": can't create fi=
le to save path to old disk\n");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
+=A0=A0=A0=A0 }
+
=A0=A0=A0=A0=A0 mdfd =3D open_dev(ent->devnum);
=A0=A0=A0=A0=A0 if (mdfd < 0) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ": Cannot open a=
rray %s!!\n", ent->dev);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
=A0=A0=A0=A0=A0 }
+
=A0=A0=A0=A0=A0 memset(&devlist, 0, sizeof(devlist));
=A0=A0=A0=A0=A0 devlist.devname =3D devname;
=A0=A0=A0=A0=A0 devlist.disposition =3D 'f';
-=A0=A0=A0=A0 Manage_subdevs(ent->dev, mdfd, &devlist, verbose);
+
+=A0=A0=A0=A0 /* slightly different behavior for native and external */
+=A0=A0=A0=A0 if (!is_external(ent->metadata_version)) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* just write array device */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (fprintf(id_fd, "%s\n", ent->dev) < =
0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name =
": Failed to write to <id_path> cookie\n");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fclose(id_fd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unlink(path);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Manage_subdevs(ent->dev, mdfd, &devlist=
, verbose);
+=A0=A0=A0=A0 } else {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int subfd;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* write device for all array members *=
/
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mds =3D mdstat_read(0, 0);
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for (mi =3D mds; mi; mi =3D mi->next)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (is_external(mi->m=
etadata_version) &&
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 is_subarray=
(mi->metadata_version + 9) &&
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 devname2dev=
num(mi->metadata_version + 10) =3D=3D ent->devnum) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* =
found member, so */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* =
create file with names of arrays containing old disk */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(fprintf(id_fd, "%s\n", mi->dev) < 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 fprintf(stderr, Name ": Failed to write to <id_path> cooki=
e\n");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 fclose(id_fd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 unlink(path);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sub=
fd =3D open_dev(mi->devnum);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(subfd < 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 fprintf(stderr, Name ": Cannot open array %s!!\n", mi->dev=
);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 return 1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Man=
age_subdevs(mi->dev, subfd, &devlist, verbose);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 clo=
se(subfd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fclose(id_fd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free_mdstat(mds);
+=A0=A0=A0=A0 }
+
=A0=A0=A0=A0=A0 devlist.disposition =3D 'r';
=A0=A0=A0=A0=A0 rv =3D Manage_subdevs(ent->dev, mdfd, &devlist, verbose=
);
=A0=A0=A0=A0=A0 close(mdfd);
diff --git a/Makefile b/Makefile
index 354554c..1e999e8 100644
--- a/Makefile
+++ b/Makefile
@@ -71,8 +71,10 @@ CONFFILEFLAGS =3D -DCONFFILE=3D\"$(CONFFILE)\" -DCON=
=46FILE2=3D\"$(CONFFILE2)\"
=A0ALT_RUN =3D /lib/init/rw/mdadm
=A0ALT_MAPFILE =3D map
=A0VAR_RUN =3D /var/run/mdadm
-ALTFLAGS =3D -DALT_RUN=3D\"$(ALT_RUN)\" -DALT_MAPFILE=3D\"$(ALT_MAPFIL=
E)\"
-VARFLAGS =3D -DVAR_RUN=3D\"$(VAR_RUN)\"
+# place for autoreplace cookies
+FAILED_SLOTS =3D /var/run/failed-slots
+ALTFLAGS =3D -DALT_RUN=3D\"$(ALT_RUN)\" -DALT_MAPFILE=3D\"$(ALT_MAPFIL=
E)\" -DFAILED_SLOTS=3D\"$(FAILED_SLOTS)\"
+VARFLAGS =3D -DVAR_RUN=3D\"$(VAR_RUN)\" -DFAILED_SLOTS=3D\"$(FAILED_SL=
OTS)\"
=A0CFLAGS =3D $(CWFLAGS) $(CXFLAGS) -DSendmail=3D\""$(MAILCMD)"\" $(CON=
=46FILEFLAGS) $(ALTFLAGS) $(VARFLAGS)
=A0
=A0# If you want a static binary, you might uncomment these diff --git =
a/mdadm.h b/mdadm.h index 79eed16..6eeebd5 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -91,6 +91,14 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t _=
_offset, int __whence));=A0 #define ALT_MAPFILE "map"
=A0#endif /* ALT_MAPFILE */
=A0
+/* FAILED_SLOTS is where to save files storing recent removal of array
+ * member in order to allow future reuse of disk inserted in the same
+ * slot for array recovery
+ */
+#ifndef FAILED_SLOTS
+#define FAILED_SLOTS "/var/run/failed-slots"
+#endif /* FAILED_SLOTS */
+
=A0#include=A0=A0 "md_u.h"
=A0#include=A0=A0 "md_p.h"
=A0#include=A0=A0 "bitmap.h"
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
