From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 15/31] Add spares to raid0 array using takeover
Date: Tue, 9 Nov 2010 17:01:15 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CA9E@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Spares are used by Online Capacity Expansion to expand array.
To run expansion on raid0, spares have to be added to raid0 volume also.
Raid0 cannot have spares (no mdmon runs for raid0 array).
To do this, takeover to raid5 (and back) is used. mdmon runs temporary for raid5 and spare drives can be added to container.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/Manage.c |  157 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 152 insertions(+), 5 deletions(-)

diff --git a/mdadm/mdadm/Manage.c b/mdadm/mdadm/Manage.c index 6e9d4a0..e8ecce0 100644
--- a/mdadm/mdadm/Manage.c
+++ b/mdadm/mdadm/Manage.c
@@ -31,6 +31,137 @@
 #define START_MD     		_IO (MD_MAJOR, 2)
 #define STOP_MD      		_IO (MD_MAJOR, 3)
 
+
+void takeover5to0(struct mdinfo *sra)
+{
+	char *c;
+	int err;
+
+	dprintf("Takeover Raid5->Raid0.\n");
+
+	if (sra == NULL)
+		return;
+
+	c = map_num(pers, 0);
+	if (c == NULL)
+		return;
+
+	err = sysfs_set_str(sra, NULL, "level", c);
+
+	if (err)
+		fprintf(stderr,
+			Name ": %s: could not set level "
+			"to %s for external super.\n",
+			sra->sys_name, c);
+	sysfs_free(sra);
+}
+
+struct mdinfo *takeover0to5(int fd)
+{
+	struct mdinfo *ret_val = NULL;
+	int devnum;
+	struct mdinfo *sra = NULL;
+	struct supertype *st = NULL;
+	struct mdinfo info;
+	int dev_fd = -1;
+	int device_num;
+
+	dprintf("Takeover Raid0->Raid5.\n");
+	devnum = fd2devnum(fd);
+	if (mdmon_running(devnum)) {
+		dprintf("mdmon is runnig for this container - takeover is not required\n");
+		return ret_val;
+	}
+
+	sra = sysfs_read(fd, 0, GET_VERSION);
+	if (sra == NULL)
+		return ret_val;
+
+	st = super_by_fd(fd);
+
+	if ((sra->array.major_version != -1) ||
+	    (strncmp(sra->text_version, "imsm", 4) != 0) ||
+	    (st == NULL) ||
+	    (st->ss->external == 0))
+		goto exit_takeover0to5;
+
+	device_num = 0;
+	while (device_num > -1) {
+		char dev_name[1024];
+		char *c;
+		int err;
+
+		sprintf(st->subarray, "%i", device_num);
+		st->ss->load_super(st, fd, NULL);
+		if (st->sb == NULL)
+			break;
+
+		st->ss->getinfo_super(st, &info);
+		if (info.array.level == 0) {
+			char *p = NULL;
+
+			sprintf(dev_name, "/dev/md/%s", info.name);
+			dev_fd = open_mddev(dev_name , 1);
+
+			if (dev_fd < 0)
+				continue;
+
+			sysfs_free(sra);
+			sra = sysfs_read(dev_fd, 0, GET_VERSION);
+			if (!sra)
+				continue;
+
+			c = map_num(pers, 5);
+			if (c == NULL)
+				break;
+
+			err = sysfs_set_str(sra, NULL, "level", c);
+			if (err) {
+				fprintf(stderr, Name": %s: could not set level to "
+					"%s for external super.\n", sra->sys_name, c);
+				break;
+			}
+
+			/* return to this raid level and do not release
+			 */
+			ret_val = sra;
+			sra = NULL;
+
+			/* send update with return level,
+			 * return level tells monitor to:
+			 * - after reshape return automatically to this level
+			 * - if return level is set do not activate spares
+			 */
+
+			/* if after takeover mdmon is not running,
+			 * start it
+			 */
+			if (!mdmon_running(devnum))
+				start_mdmon(devnum);
+			p = devnum2devname(devnum);
+			if (p) {
+				ping_monitor(p);
+				free(p);
+			}
+			sleep(1);
+			device_num = -2;
+			break;
+		}
+		device_num++;
+	}
+
+exit_takeover0to5:
+	if (st)
+		st->ss->free_super(st);
+	sysfs_free(sra);
+	if (dev_fd >= 0)
+		close(dev_fd);
+
+dprintf("Takeover ret = %p\n\n", ret_val);
+	return ret_val;
+
+}
+
 int Manage_ro(char *devname, int fd, int readonly)  {
 	/* switch to readonly or rw
@@ -118,7 +249,7 @@ int Manage_ro(char *devname, int fd, int readonly)
 
 static void remove_devices(int devnum, char *path)  {
-	/* 
+	/*
 	 * Remove names at 'path' - possibly with
 	 * partition suffixes - which link to the 'standard'
 	 * name for devnum.  These were probably created @@ -144,7 +275,7 @@ static void remove_devices(int devnum, char *path)
 	path2 = malloc(strlen(path)+20);
 	strcpy(path2, path);
 	pe = path2 + strlen(path2);
-	
+
 	for (part = 0; part < 16; part++) {
 		if (part) {
 			sprintf(be, "p%d", part);
@@ -161,7 +292,7 @@ static void remove_devices(int devnum, char *path)
 	}
 	free(path2);
 }
-	
+
 
 int Manage_runstop(char *devname, int fd, int runstop, int quiet)  { @@ -285,7 +416,7 @@ int Manage_runstop(char *devname, int fd, int runstop, int quiet)
 		if (mdi)
 			sysfs_uevent(mdi, "change");
 
-		
+
 		if (devnum != NoMdDev &&
 		    (stat("/dev/.udev", &stb) != 0 ||
 		     check_env("MDADM_NO_UDEV"))) {
@@ -820,19 +951,32 @@ int Manage_subdevs(char *devname, int fd,
 						dv->devname);
 					return 1;
 				}
+				/* Raid 0 add spare via takeover
+				*/
+				struct mdinfo *return_raid0_sra = NULL;
+				/* try to perform takeover if needed
+				*/
+				return_raid0_sra = takeover0to5(container_fd);
 
 				if (!mdmon_running(devnum)) {
 					fprintf(stderr, Name ": add failed for %s: mdmon not running\n",
 						dv->devname);
+					takeover5to0(return_raid0_sra);
 					close(container_fd);
 					return 1;
 				}
 
 				sra = sysfs_read(container_fd, -1, 0);
 				if (!sra) {
+					char *p = devnum2devname(devnum);
 					fprintf(stderr, Name ": add failed for %s: sysfs_read failed\n",
 						dv->devname);
+					takeover5to0(return_raid0_sra);
 					close(container_fd);
+					if (p) {
+						ping_monitor(p);
+						free(p);
+					}
 					return 1;
 				}
 				sra->array.level = LEVEL_CONTAINER; @@ -844,12 +988,15 @@ int Manage_subdevs(char *devname, int fd,
 				if (sysfs_add_disk(sra, &new_mdi, 0) != 0) {
 					fprintf(stderr, Name ": add new device to external metadata"
 						" failed for %s\n", dv->devname);
+					takeover5to0(return_raid0_sra);
 					close(container_fd);
+					sysfs_free(sra);
 					return 1;
 				}
-				ping_monitor(devnum2devname(devnum));
+				takeover5to0(return_raid0_sra);
 				sysfs_free(sra);
 				close(container_fd);
+				ping_monitor(devnum2devname(devnum));
 			} else if (ioctl(fd, ADD_NEW_DISK, &disc)) {
 				fprintf(stderr, Name ": add new device failed for %s as %d: %s\n",
 					dv->devname, j, strerror(errno));

