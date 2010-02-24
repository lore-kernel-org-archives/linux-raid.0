From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [mdadm PATCH 4/11] Enable OLCE for external IMSM metadata
Date: Wed, 24 Feb 2010 07:46:15 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1016F65C8@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From 18fdca0e6ffbedab216f82952b5109826f4235fe Mon Sep 17 00:00:00 2001
From: Adam Kwolek <adam.kwolek@intel.com>
Date: Thu, 18 Feb 2010 11:07:06 +0100
Subject: [PATCH] OLCE: Use takeover for add spare to Raid0

Changes to be committed:
	modified:   Manage.c

Use takeover for add spare to Raid0

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 Manage.c |  114 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 113 insertions(+), 1 deletions(-)

diff --git a/Manage.c b/Manage.c
index 0b991d0..5ae4967 100644
--- a/Manage.c
+++ b/Manage.c
@@ -31,6 +31,110 @@
 #define START_MD     		_IO (MD_MAJOR, 2)
 #define STOP_MD      		_IO (MD_MAJOR, 3)
 
+
+struct mdinfo * takeover5to0(struct mdinfo * sra)
+{
+	if (sra) {
+		char *c;
+		c = map_num(pers, 0);
+		if (c != NULL) {
+			int err;
+			err = sysfs_set_str(sra, NULL, "level", c);
+			if (err) {
+				fprintf(stderr, Name ": %s: could not set level "
+					"to %s for external super.\n",
+					sra->sys_name, c);
+				sysfs_free(sra);
+				sra = NULL;
+			}
+		}
+		sysfs_free(sra);
+		sra = NULL;
+	}
+	return sra;
+}
+
+
+struct mdinfo * takeover0to5(int fd)
+{
+	struct mdinfo * retVal = NULL;
+	int devnum;
+	struct mdinfo *sra = NULL;;
+	struct supertype *st = NULL;
+	int dev_fd = -1;
+
+	devnum = fd2devnum(fd);
+	
+	if (fd > -1) {
+		sra = sysfs_read(fd, 0, GET_VERSION);
+		if (sra) {
+			st = super_by_fd(fd);
+			
+			if ((sra->array.major_version == -1) &&
+			    (strncmp(sra->text_version, "imsm", 4) == 0) &&
+			    st && st->ss->external) {
+				struct mdinfo *info;
+				dprintf("OLCE: IMSM external meta detected\n");
+
+				st->ss->load_super(st, fd, NULL);
+				for (info = st->ss->container_content(st); info; info = info->next) {
+					if (info->array.level == 0) {
+						char devName[1024];
+
+						sprintf( devName, "/dev/md/%s",info->name);
+						dev_fd = open_mddev(devName , 1);
+
+						if (dev_fd > -1) {
+							sysfs_free(sra);
+							sra = sysfs_read(dev_fd, 0, GET_VERSION);
+							if (sra) {
+								char *c;
+								int err;
+
+								c = map_num(pers, 5 );
+								if (c == NULL)
+									break;
+
+								err = sysfs_set_str(sra, NULL,
+									"level", c);
+								if (err) {
+									fprintf(stderr, Name 
+										": %s: could not set level to "
+										"%s for external super.\n",
+										sra->sys_name, c);
+									break;
+								}
+								retVal = sra; /* return to this raid level */
+								sra = NULL;   /* do not release */
+								
+								/* send update with return level
+								 * return lelel tells monitor to:
+								 * - after reshape return automatically to this level
+								 * - if return level is set do not activate spares
+								 */
+
+								/* start mdmon after takeover */
+								if (!mdmon_running(devnum)) {
+									/* if mdmon is not running, start it */
+									start_mdmon(devnum);
+									ping_monitor(devnum2devname(devnum));
+									sleep(1);
+								}
+								break;
+							}
+						}
+					}
+				}
+			}
+			if (sra) sysfs_free(sra);
+			sra = NULL;
+			if (dev_fd >= 0) close (dev_fd);
+		}
+	}
+	return retVal;
+
+}
+
 int Manage_ro(char *devname, int fd, int readonly)
 {
 	/* switch to readonly or rw
@@ -685,10 +789,15 @@ int Manage_subdevs(char *devname, int fd,
 						dv->devname);
 					return 1;
 				}
+				/* OLCE: Raid 0 add spare via takeover */
+				struct mdinfo *return_raid0_sra = NULL;
+				/* try to perform takeover if needed */
+				return_raid0_sra = takeover0to5(container_fd);
 
 				if (!mdmon_running(devnum)) {
 					fprintf(stderr, Name ": add failed for %s: mdmon not running\n",
 						dv->devname);
+					return_raid0_sra = takeover5to0(return_raid0_sra);
 					close(container_fd);
 					return 1;
 				}
@@ -697,6 +806,7 @@ int Manage_subdevs(char *devname, int fd,
 				if (!sra) {
 					fprintf(stderr, Name ": add failed for %s: sysfs_read failed\n",
 						dv->devname);
+					return_raid0_sra = takeover5to0(return_raid0_sra);
 					close(container_fd);
 					return 1;
 				}
@@ -709,10 +819,12 @@ int Manage_subdevs(char *devname, int fd,
 				if (sysfs_add_disk(sra, &new_mdi, 0) != 0) {
 					fprintf(stderr, Name ": add new device to external metadata"
 						" failed for %s\n", dv->devname);
+					return_raid0_sra = takeover5to0(return_raid0_sra);
 					close(container_fd);
 					return 1;
 				}
-				
+				return_raid0_sra = takeover5to0(return_raid0_sra);
+
 				ping_monitor(devnum2devname(devnum));
 				sysfs_free(sra);
 				sra = NULL;
-- 
1.6.0.2

