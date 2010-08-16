From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 02/35] Few fixes and sample udev rules file to capture block
 devices
Date: Mon, 16 Aug 2010 10:41:19 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8F9B5@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 477cc3749316a205328a30bb9dc4c389fea7708a Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Wed, 16 Jun 2010 16:42:57 +0200
Subject: [PATCH 02/35] Few fixes and sample udev rules file to capture block devices
 very early in the udev hot plug sequence, allowing us to make
 them our own if they match a proper DOMAIN entry in the mdadm
 conf file

---
 Manage.c           |   13 ++++++++-----
 ReadMe.c           |   13 +++++++++----
 udev-md-raid.rules |    4 +++-
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/Manage.c b/Manage.c
index 5b9c052..67bef11 100644
--- a/Manage.c
+++ b/Manage.c
@@ -384,6 +384,7 @@ int Manage_subdevs(char *devname, int fd,
 
 		next = dv->next;
 		jnext = 0;
+		tfd = sysfd = -1;
 
 		if (strcmp(dv->devname, "failed")==0 ||
 		    strcmp(dv->devname, "faulty")==0) {
@@ -404,6 +405,7 @@ int Manage_subdevs(char *devname, int fd,
 				stb.st_rdev = makedev(disc.major, disc.minor);
 				next = dv;
 				jnext = j+1;
+				tfd = 0;
 				sprintf(dvname,"%d:%d", disc.major, disc.minor);
 				dnprintable = dvname;
 				break;
@@ -438,6 +440,7 @@ int Manage_subdevs(char *devname, int fd,
 				stb.st_rdev = makedev(disc.major, disc.minor);
 				next = dv;
 				jnext = j+1;
+				tfd = 0;
 				dnprintable = dvname;
 				break;
 			}
@@ -456,17 +459,16 @@ int Manage_subdevs(char *devname, int fd,
 			}
 
 			sprintf(dname, "dev-%s", dv->devname);
-			sysfd = sysfs_open(fd2devnum(fd), dname, "block/dev");
-			if (sysfd >= 0) {
+			tfd = sysfs_open(fd2devnum(fd), dname, "block/dev");
+			if (tfd >= 0) {
 				char dn[20];
 				int mj,mn;
-				if (sysfs_fd_get_str(sysfd, dn, 20) > 0 &&
+				if (sysfs_fd_get_str(tfd, dn, 20) > 0 &&
 				    sscanf(dn, "%d:%d", &mj,&mn) == 2) {
 					stb.st_rdev = makedev(mj,mn);
 					found = 1;
 				}
-				close(sysfd);
-				sysfd = -1;
+				close(tfd);
 			}
 			if (!found) {
 				sysfd = sysfs_open(fd2devnum(fd), dname, "state");
@@ -476,6 +478,7 @@ int Manage_subdevs(char *devname, int fd,
 						dv->devname, devname);
 					return 1;
 				}
+				tfd = -1;
 			}
 		} else {
 			j = 0;
diff --git a/ReadMe.c b/ReadMe.c
index b43d1a0..355aa64 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -86,11 +86,12 @@ char Version[] = Name " - v3.1.2 - 10th March 2010\n";
  *     At the time if writing, there is only minimal support.
  */
 
-char short_options[]="-ABCDEFGIQhVXWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:";
+char short_options[]=
+	"-ABCDEFGIQhVXWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tyge:";
 char short_bitmap_options[]=
-                   "-ABCDEFGIQhVXWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:";
+	"-ABCDEFGIQhVXWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tyge:";
 char short_bitmap_auto_options[]=
-                   "-ABCDEFGIQhVXWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1tye:";
+	"-ABCDEFGIQhVXWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1tyge:";
 
 struct option long_options[] = {
     {"manage",    0, 0, '@'},
@@ -189,6 +190,7 @@ struct option long_options[] = {
 
     /* For Incremental */
     {"rebuild-map", 0, 0, 'r'},
+    {"grab", 0, 0, 'g'}, /* grab devices for hot spare use */
     {0, 0, 0, 0}
 };
 
@@ -535,7 +537,7 @@ char Help_grow[] =
 ;
 
 char Help_incr[] =
-"Usage: mdadm --incremental [-Rqrsf] device\n"
+"Usage: mdadm --incremental [-Rqrsgf] device\n"
 "\n"
 "This usage allows for incremental assembly of md arrays.  Devices can be\n"
 "added one at a time as they are discovered.  Once an array has all expected\n"
@@ -553,6 +555,9 @@ char Help_incr[] =
 "                  : partial arrays.\n"
 "  --scan      -s  : Use with -R to start any arrays that have the minimal\n"
 "                  : required number of devices, but are not yet started.\n"
+"  --grab      -g  : Check if the device belongs to a path we own via\n"
+"                  : any DOMAIN entry lines in mdadm.conf, and if so,\n"
+"                  : take it for the purpose listed in said DOMAIN line.\n"
 "  --fail      -f  : First fail (if needed) and then remove device from\n"
 "                  : any array that it is a member of.\n"
 ;
diff --git a/udev-md-raid.rules b/udev-md-raid.rules
index da52058..712c5e5 100644
--- a/udev-md-raid.rules
+++ b/udev-md-raid.rules
@@ -4,7 +4,9 @@ SUBSYSTEM!="block", GOTO="md_end"
 
 # handle potential components of arrays
 ENV{ID_FS_TYPE}=="linux_raid_member", ACTION=="remove", RUN+="/sbin/mdadm -If $name"
-ENV{ID_FS_TYPE}=="linux_raid_member", ACTION=="add", RUN+="/sbin/mdadm --incremental $env{DEVNAME}"
+ENV{ID_FS_TYPE}=="linux_raid_member", ACTION=="add", RUN+="/sbin/mdadm -I $tempnode"
+ENV{ID_FS_TYPE}=="isw_raid_member", ENV{rd_NO_MDIMSM}!="?*", ACTION=="remove", RUN+="/sbin/mdadm -If $name"
+ENV{ID_FS_TYPE}=="isw_raid_member", ENV{rd_NO_MDIMSM}!="?*", ACTION=="add", RUN+="/sbin/mdadm -I $tempnode"
 
 # handle md arrays
 ACTION!="add|change", GOTO="md_end"
-- 
1.6.4.2

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

