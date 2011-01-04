From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 25/34] Add spares to raid0 in mdadm
Date: Tue, 04 Jan 2011 15:38:55 +0100
Message-ID: <20110104143855.6697.57925.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When user wants to add spares to container with raid0 arrays only
it is not possible to update metadata due to lack of running mdmon.
To allow for this direct metadata update by mdadm is used in such case.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---

 Manage.c      |   13 +++----------
 super-intel.c |    8 ++++++++
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/Manage.c b/Manage.c
index 81fa986..6b5e4be 100644
--- a/Manage.c
+++ b/Manage.c
@@ -844,9 +844,8 @@ int Manage_subdevs(char *devname, int fd,
 			if (dv->writemostly == 1)
 				disc.state |= (1 << MD_DISK_WRITEMOSTLY);
 			if (tst->ss->external) {
-				/* add a disk to an external metadata container
-				 * only if mdmon is around to see it
-				 */
+				/* add a disk
+				 * to an external metadata container */
 				struct mdinfo new_mdi;
 				struct mdinfo *sra;
 				int container_fd;
@@ -860,13 +859,6 @@ int Manage_subdevs(char *devname, int fd,
 					return 1;
 				}
 
-				if (!mdmon_running(devnum)) {
-					fprintf(stderr, Name ": add failed for %s: mdmon not running\n",
-						dv->devname);
-					close(container_fd);
-					return 1;
-				}
-
 				sra = sysfs_read(container_fd, -1, 0);
 				if (!sra) {
 					fprintf(stderr, Name ": add failed for %s: sysfs_read failed\n",
@@ -884,6 +876,7 @@ int Manage_subdevs(char *devname, int fd,
 					fprintf(stderr, Name ": add new device to external metadata"
 						" failed for %s\n", dv->devname);
 					close(container_fd);
+					sysfs_free(sra);
 					return 1;
 				}
 				ping_monitor(devnum2devname(devnum));
diff --git a/super-intel.c b/super-intel.c
index 0f10e32..276e72d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3442,6 +3442,8 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 	return 0;
 }
 
+static int write_super_imsm(struct supertype *st, int doclose);
+
 static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 			      int fd, char *devname)
 {
@@ -3506,6 +3508,12 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 		super->disks = dd;
 	}
 
+	if (!mdmon_running(st->container_dev)) {
+		dprintf("imsm: mdmon is not active- write metadata by mdadm\n");
+		super->updates_pending++;
+		write_super_imsm(st, 0);
+	}
+
 	return 0;
 }
 

