From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 05/10] Add spares to raid0 array using takeover
Date: Thu, 02 Dec 2010 09:19:20 +0100
Message-ID: <20101202081920.4639.78609.stgit@gklab-170-024.igk.intel.com>
References: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Spares are used by Online Capacity Expansion to expand array.
To run expansion on raid0, spares have to be added to raid0 volume also.
Raid0 cannot have spares (no mdmon runs for raid0 array).
To do this, takeover to raid5 (and back) is used. mdmon runs temporary for raid5 and spare drives can be added to container.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Manage.c |  120 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 119 insertions(+), 1 deletions(-)

diff --git a/Manage.c b/Manage.c
index a203ec9..8c04ba9 100644
--- a/Manage.c
+++ b/Manage.c
@@ -31,6 +31,103 @@
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
+	struct mdstat_ent *mdstat = NULL;
+	struct mdstat_ent *m;
+	int dev_fd = -1;
+
+	dprintf("Takeover Raid0->Raid5.\n");
+	devnum = fd2devnum(fd);
+	if (mdmon_running(devnum)) {
+		dprintf("mdmon is runnig for this container - takeover is not required\n");
+		return ret_val;
+	}
+
+	mdstat = mdstat_read(0, 0);
+	for (m=mdstat; m; m=m->next) {
+		if (m->metadata_version &&
+		    strncmp(m->metadata_version, "external:", 9)==0 &&
+		    is_subarray(m->metadata_version+9) &&
+		    devname2devnum(m->metadata_version+10) == devnum) {
+			if (strncmp(m->level, "raid0", 5) == 0) {
+				char *p = NULL;
+				char dev_name[PATH_MAX];
+				int err;
+
+				sprintf(dev_name, "/dev/md%i", m->devnum);
+				dev_fd = open_mddev(dev_name , 1);
+				if (dev_fd < 0)
+					continue;
+
+				sra = sysfs_read(dev_fd, 0, GET_VERSION|GET_LEVEL);
+				if (!sra)
+					break;
+
+				err = sysfs_set_str(sra, NULL, "level", "raid5");
+				if (err) {
+					fprintf(stderr, Name": %s: could not set level to "
+						"raid5 for external super.\n", sra->sys_name);
+					break;
+				}
+
+				/* return to this raid level and do not release
+				*/
+				ret_val = sra;
+				sra = NULL;
+
+				/* if after takeover mdmon is not running,
+				 * start it
+				 */
+				if (!mdmon_running(devnum))
+					start_mdmon(devnum);
+				p = devnum2devname(devnum);
+				if (p) {
+					ping_monitor(p);
+					free(p);
+				}
+				sleep(1);
+				break;
+			}
+		}
+	}
+
+	sysfs_free(sra);
+	free_mdstat(mdstat);
+	if (dev_fd >= 0)
+		close(dev_fd);
+
+	return ret_val;
+}
+
 int Manage_ro(char *devname, int fd, int readonly)
 {
 	/* switch to readonly or rw
@@ -832,6 +929,7 @@ int Manage_subdevs(char *devname, int fd,
 				struct mdinfo *sra;
 				int container_fd;
 				int devnum = fd2devnum(fd);
+				char *devname = NULL;
 
 				container_fd = open_dev_excl(devnum);
 				if (container_fd < 0) {
@@ -840,10 +938,17 @@ int Manage_subdevs(char *devname, int fd,
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
@@ -852,7 +957,13 @@ int Manage_subdevs(char *devname, int fd,
 				if (!sra) {
 					fprintf(stderr, Name ": add failed for %s: sysfs_read failed\n",
 						dv->devname);
+					takeover5to0(return_raid0_sra);
 					close(container_fd);
+					devname = devnum2devname(devnum);
+					if (devname) {
+						ping_monitor(devname);
+						free(devname);
+					}
 					return 1;
 				}
 				sra->array.level = LEVEL_CONTAINER;
@@ -864,12 +975,19 @@ int Manage_subdevs(char *devname, int fd,
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
+				devname = devnum2devname(devnum);
+				if (devname) {
+					ping_monitor(devname);
+					free(devname);
+				}
 			} else if (ioctl(fd, ADD_NEW_DISK, &disc)) {
 				fprintf(stderr, Name ": add new device failed for %s as %d: %s\n",
 					dv->devname, j, strerror(errno));

