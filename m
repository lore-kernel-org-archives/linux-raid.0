From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 26/33] added --path <path_id> to give the information on the
 'path-id' of removed device
Date: Mon, 5 Jul 2010 11:49:58 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC426@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C4F@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C4F@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:40 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 26/33] added --path <path_id> to give the information o=
n the 'path-id' of removed device

=46rom: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.=
com>

<path-id> allows to identify the port to which given device is plugged =
in. In case of hot-removal, udev can pass this information for future u=
se (eg. write this name as 'cookie' allowing to detect the fact of rein=
serting device to the same port).
--path <path-id> parameter has been added to device removal handle (and=
 char *path has been added to IncrementalRemove() to pass this value) i=
n order to pass path-id to this handler.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski=
@intel.com>
---
=A0Incremental.c |=A0=A0=A0 8 +++++++-
=A0ReadMe.c=A0=A0=A0=A0=A0 |=A0=A0=A0 2 ++
=A0mdadm.c=A0=A0=A0=A0=A0=A0 |=A0=A0 15 ++++++++++++---
=A0mdadm.h=A0=A0=A0=A0=A0=A0 |=A0=A0=A0 6 +++++-
=A04 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/Incremental.c b/Incremental.c index 4f52e3b..20e3445 10064=
4
--- a/Incremental.c
+++ b/Incremental.c
@@ -941,13 +941,19 @@ int Incremental_container(struct supertype *st, c=
har *devname, int verbose,
=A0 * Note: the device name must be a kernel name like "sda", so
=A0 * that we can find it in /proc/mdstat
=A0 */
-int IncrementalRemove(char *devname, int verbose)
+int IncrementalRemove(char *devname, char *path, int verbose)
=A0{
=A0=A0=A0=A0=A0 int mdfd;
=A0=A0=A0=A0=A0 int rv;
=A0=A0=A0=A0=A0 struct mdstat_ent *ent;
=A0=A0=A0=A0=A0 struct mddev_dev_s devlist;
=A0
+=A0=A0=A0=A0 if (!path) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ": incremental rem=
oval without --path <path_id> lacks "
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "the possibility to r=
e-add new device in this port\n");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
+=A0=A0=A0=A0 }
+
=A0=A0=A0=A0=A0 if (strchr(devname, '/')) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ": incremental r=
emoval requires a "
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "kernel device name=
, not a file: %s\n", devname); diff --git a/ReadMe.c b/ReadMe.c index 5=
b59369..f1b11fb 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -191,6 +191,8 @@ struct option long_options[] =3D {
=A0=A0=A0=A0 /* For Incremental */
=A0=A0=A0=A0 {"rebuild-map", 0, 0, 'r'},
=A0=A0=A0=A0 {"grab", 0, 0, 'g'}, /* grab devices for hot spare use */
+=A0=A0=A0 {"path", 1, 0, IncrementalPath},
+
=A0=A0=A0=A0 {0, 0, 0, 0}
=A0};
=A0
diff --git a/mdadm.c b/mdadm.c
index a111b47..60b4e3b 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -104,6 +104,7 @@ int main(int argc, char *argv[])
=A0=A0=A0=A0=A0 int dosyslog =3D 0;
=A0=A0=A0=A0=A0 int rebuild_map =3D 0;
=A0=A0=A0=A0=A0 int auto_update_home =3D 0;
+=A0=A0=A0=A0 char *remove_path =3D NULL;
=A0
=A0=A0=A0=A0=A0 int print_help =3D 0;
=A0=A0=A0=A0=A0 FILE *outf;
@@ -913,6 +914,13 @@ int main(int argc, char *argv[])
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 case O(INCREMENTAL, 'g'):
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 new_disk =3D 1;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 case O(INCREMENTAL, IncrementalPath):
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!optarg) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fpr=
intf(stderr, Name ":option --path needs obligatory argument\n");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 exi=
t(2);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 remove_path =3D strdu=
p(optarg);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* We have now processed all the vali=
d options. Anything else is
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0* an error
@@ -1559,9 +1567,10 @@ int main(int argc, char *argv[])
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D 1;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (devmode =3D=3D 'f')
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D IncrementalRem=
ove(devlist->devname, verbose-quiet);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else if (new_disk > 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (devmode =3D=3D 'f') {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D IncrementalRem=
ove(devlist->devname, remove_path, verbose-quiet);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(remove_path);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else if (new_disk > 0)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D IncrementalN=
ew(devlist->devname, verbose-quiet,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 =A0=A0=A0 export);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else
diff --git a/mdadm.h b/mdadm.h
index 86f5370..79eed16 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -275,6 +275,9 @@ enum special_options {
=A0=A0=A0=A0=A0 AutoDetect,
=A0=A0=A0=A0=A0 Waitclean,
=A0=A0=A0=A0=A0 DetailPlatform,
+=A0=A0=A0=A0 HotPlug,
+=A0=A0=A0=A0 HotUnplug,
+=A0=A0=A0=A0 IncrementalPath
=A0};
=A0
=A0enum disk_status {
@@ -907,7 +910,7 @@ extern int Incremental_container(struct supertype *=
st, char *devname,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
int trustworthy);
=A0extern void RebuildMap(void);
=A0extern int IncrementalScan(int verbose); -extern int IncrementalRemo=
ve(char *devname, int verbose);
+extern int IncrementalRemove(char *devname, char *path, int verbose);
=A0extern int IncrementalNew(char *devname, int verbose, int export);=A0=
 extern int CreateBitmap(char *filename, int force, char uuid[16],
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned long chunk=
size, unsigned long daemon_sleep, @@ -1024,6 +1027,7 @@ extern char *de=
vnum2devname(int num);=A0 extern int devname2devnum(char *name);=A0 ext=
ern int stat2devnum(struct stat *st);=A0 extern int fd2devnum(int fd);
+extern void free_mddev_dev(mddev_dev_t devlist);
=A0extern char *get_devpath_from_devname(char *devname);=A0 extern char=
 *get_array_devname(char *array);=A0 extern char *get_array_devname_by_=
uuid(int (*uuid)[4]);
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
