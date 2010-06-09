From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 17/23] Add spares to raid0 array using takeover
Date: Wed, 9 Jun 2010 15:39:45 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11EECE8EF@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

(Online Capacity Expansion for IMSM)
Spares are used by Online Capacity Expansion to expand array.
To run expansion on raid0, spares have to be added to raid0 volume also.
Raid0 cannot have spares (no mdmon runs for raid0 array).
To do this, takeover to raid5 (and back) is used. mdmon runs temporary for raid5 and spare drives can be added to container.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Manage.c |  144 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 143 insertions(+), 1 deletions(-)

diff --git a/Manage.c b/Manage.c
index f848d8b..6d6dda7 100644
--- a/Manage.c
+++ b/Manage.c
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
+		goto exit_takeover5to0;
+
+	c = map_num(pers, 0);
+	if (c == NULL)
+		goto exit_takeover5to0;
+
+	err = sysfs_set_str(sra, NULL, "level", c);
+
+	if (err)
+		fprintf(stderr,
+			Name ": %s: could not set level "
+			"to %s for external super.\n",
+			sra->sys_name, c);
+
+exit_takeover5to0:
+	sysfs_free(sra);
+}
+
+struct mdinfo *takeover0to5(int fd)
+{
+	struct mdinfo *ret_val = NULL;
+	int devnum;
+	struct mdinfo *sra = NULL;;
+	struct supertype *st = NULL;
+	struct mdinfo info;
+	int dev_fd = -1;
+	int device_num;
+
+	dprintf("Takeover Raid0->Raid5.\n");
+
+	if (fd < 0)
+		goto exit_takeover0to5;
+
+	devnum = fd2devnum(fd);
+	if (mdmon_running(devnum)) {
+		dprintf("mdmon is runnig for this container - takeover is not required\n");
+		goto exit_takeover0to5;
+	}
+
+	sra = sysfs_read(fd, 0, GET_VERSION);
+	if (sra == NULL)
+		goto exit_takeover0to5;
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
+			ping_monitor(devnum2devname(devnum));
+			sleep2(1, 0);
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
+	return ret_val;
+
+}
+
 int Manage_ro(char *devname, int fd, int readonly)  {
 	/* switch to readonly or rw
@@ -708,10 +839,17 @@ int Manage_subdevs(char *devname, int fd,
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
@@ -720,7 +858,9 @@ int Manage_subdevs(char *devname, int fd,
 				if (!sra) {
 					fprintf(stderr, Name ": add failed for %s: sysfs_read failed\n",
 						dv->devname);
+					takeover5to0(return_raid0_sra);
 					close(container_fd);
+					ping_monitor(devnum2devname(devnum));
 					return 1;
 				}
 				sra->array.level = LEVEL_CONTAINER; @@ -732,12 +872,14 @@ int Manage_subdevs(char *devname, int fd,
 				if (sysfs_add_disk(sra, &new_mdi, 0) != 0) {
 					fprintf(stderr, Name ": add new device to external metadata"
 						" failed for %s\n", dv->devname);
+					takeover5to0(return_raid0_sra);
 					close(container_fd);
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

