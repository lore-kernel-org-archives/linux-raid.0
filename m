From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 02/33] Few fixes and sample udev rules file to capture block
 devices very early in the udev hot plug sequence, allowing us to make them
 our own if they match a proper DOMAIN entry in the mdadm conf file
Date: Mon, 5 Jul 2010 11:40:28 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC3CC@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893BFE@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893BFE@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:22 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 02/33] Few fixes and sample udev rules file to capture =
block devices very early in the udev hot plug sequence, allowing us to =
make them our own if they match a proper DOMAIN entry in the mdadm conf=
 file

=46rom: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.=
com>

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski=
@intel.com>
---
=A0Manage.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 13 ++++++++-----
=A0ReadMe.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 13 +++++++++----
=A0udev-md-raid.rules |=A0=A0=A0 4 +++-
=A03 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/Manage.c b/Manage.c
index 5b9c052..67bef11 100644
--- a/Manage.c
+++ b/Manage.c
@@ -384,6 +384,7 @@ int Manage_subdevs(char *devname, int fd,
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 next =3D dv->next;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 jnext =3D 0;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tfd =3D sysfd =3D -1;
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (strcmp(dv->devname, "failed")=3D=3D=
0 ||
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 strcmp(dv->devname, "faulty=
")=3D=3D0) { @@ -404,6 +405,7 @@ int Manage_subdevs(char *devname, int =
fd,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
tb.st_rdev =3D makedev(disc.major, disc.minor);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 n=
ext =3D dv;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 j=
next =3D j+1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tfd=
 =3D 0;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
printf(dvname,"%d:%d", disc.major, disc.minor);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 d=
nprintable =3D dvname;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 b=
reak;
@@ -438,6 +440,7 @@ int Manage_subdevs(char *devname, int fd,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
tb.st_rdev =3D makedev(disc.major, disc.minor);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 n=
ext =3D dv;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 j=
next =3D j+1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tfd=
 =3D 0;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 d=
nprintable =3D dvname;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 b=
reak;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
@@ -456,17 +459,16 @@ int Manage_subdevs(char *devname, int fd,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sprintf(dname, "dev=
-%s", dv->devname);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sysfd =3D sysfs_open(=
fd2devnum(fd), dname, "block/dev");
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (sysfd >=3D 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tfd =3D sysfs_open(fd=
2devnum(fd), dname, "block/dev");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (tfd >=3D 0) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 c=
har dn[20];
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
nt mj,mn;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(sysfs_fd_get_str(sysfd, dn, 20) > 0 &&
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(sysfs_fd_get_str(tfd, dn, 20) > 0 &&
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0=A0 sscanf(dn, "%d:%d", &mj,&mn) =3D=3D 2) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 stb.st_rdev =3D makedev(mj,mn);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 found =3D 1;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
-=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close=
(sysfd);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sys=
fd =3D -1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 clo=
se(tfd);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!found) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
ysfd =3D sysfs_open(fd2devnum(fd), dname, "state"); @@ -476,6 +478,7 @@=
 int Manage_subdevs(char *devname, int fd,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dv->devname, devname);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 return 1;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tfd=
 =3D -1;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 j =3D 0;
diff --git a/ReadMe.c b/ReadMe.c
index b43d1a0..355aa64 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -86,11 +86,12 @@ char Version[] =3D Name " - v3.1.2 - 10th March 201=
0\n";
=A0 *=A0=A0=A0=A0 At the time if writing, there is only minimal support=
=2E
=A0 */
=A0
-char short_options[]=3D"-ABCDEFGIQhVXWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:s=
arfRSow1tye:";
+char short_options[]=3D
+=A0=A0=A0=A0 "-ABCDEFGIQhVXWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1ty=
ge:";
=A0char short_bitmap_options[]=3D
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "-ABCDEFGIQhVXW=
Z:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:";
+=A0=A0=A0=A0 "-ABCDEFGIQhVXWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1t=
yge:";
=A0char short_bitmap_auto_options[]=3D
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "-ABCDEFGIQhVXW=
Z:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1tye:";
+=A0=A0=A0=A0 "-ABCDEFGIQhVXWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1=
tyge:";
=A0
=A0struct option long_options[] =3D {
=A0=A0=A0=A0 {"manage",=A0=A0=A0 0, 0, '@'},
@@ -189,6 +190,7 @@ struct option long_options[] =3D {
=A0
=A0=A0=A0=A0 /* For Incremental */
=A0=A0=A0=A0 {"rebuild-map", 0, 0, 'r'},
+=A0=A0=A0 {"grab", 0, 0, 'g'}, /* grab devices for hot spare use */
=A0=A0=A0=A0 {0, 0, 0, 0}
=A0};
=A0
@@ -535,7 +537,7 @@ char Help_grow[] =3D
=A0;
=A0
=A0char Help_incr[] =3D
-"Usage: mdadm --incremental [-Rqrsf] device\n"
+"Usage: mdadm --incremental [-Rqrsgf] device\n"
=A0"\n"
=A0"This usage allows for incremental assembly of md arrays.=A0 Devices=
 can be\n"
=A0"added one at a time as they are discovered.=A0 Once an array has al=
l expected\n"
@@ -553,6 +555,9 @@ char Help_incr[] =3D
=A0"=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 : partial array=
s.\n"
=A0"=A0 --scan=A0=A0=A0=A0=A0 -s=A0 : Use with -R to start any arrays t=
hat have the minimal\n"
=A0"=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 : required numb=
er of devices, but are not yet started.\n"
+"=A0 --grab=A0=A0=A0=A0=A0 -g=A0 : Check if the device belongs to a pa=
th we own via\n"
+"=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 : any DOMAIN entr=
y lines in mdadm.conf, and if so,\n"
+"=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 : take it for the=
 purpose listed in said DOMAIN line.\n"
=A0"=A0 --fail=A0=A0=A0=A0=A0 -f=A0 : First fail (if needed) and then r=
emove device from\n"
=A0"=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 : any array tha=
t it is a member of.\n"
=A0;
diff --git a/udev-md-raid.rules b/udev-md-raid.rules index da52058..712=
c5e5 100644
--- a/udev-md-raid.rules
+++ b/udev-md-raid.rules
@@ -4,7 +4,9 @@ SUBSYSTEM!=3D"block", GOTO=3D"md_end"
=A0
=A0# handle potential components of arrays=A0 ENV{ID_FS_TYPE}=3D=3D"lin=
ux_raid_member", ACTION=3D=3D"remove", RUN+=3D"/sbin/mdadm -If $name"
-ENV{ID_FS_TYPE}=3D=3D"linux_raid_member", ACTION=3D=3D"add", RUN+=3D"/=
sbin/mdadm --incremental $env{DEVNAME}"
+ENV{ID_FS_TYPE}=3D=3D"linux_raid_member", ACTION=3D=3D"add", RUN+=3D"/=
sbin/mdadm -I $tempnode"
+ENV{ID_FS_TYPE}=3D=3D"isw_raid_member", ENV{rd_NO_MDIMSM}!=3D"?*", ACT=
ION=3D=3D"remove", RUN+=3D"/sbin/mdadm -If $name"
+ENV{ID_FS_TYPE}=3D=3D"isw_raid_member", ENV{rd_NO_MDIMSM}!=3D"?*", ACT=
ION=3D=3D"add", RUN+=3D"/sbin/mdadm -I $tempnode"
=A0
=A0# handle md arrays
=A0ACTION!=3D"add|change", GOTO=3D"md_end"
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
