From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 28/29] IMSM compatibility for raid0 -> raid10 takeover
Date: Thu, 09 Dec 2010 16:22:32 +0100
Message-ID: <20101209152232.26876.59091.stgit@gklab-170-024.igk.intel.com>
References: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

imsm does not support raid10 array larger then 4-drives
so takeover to raid10 is allowed only from 2-drive raid0.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---

 Grow.c        |    1 +
 super-intel.c |   24 +++++++++++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 3d74db1..a01051f 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1305,6 +1305,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				rv = 1;/* not possible */
 				goto release;
 			}
+
 			if (level > 0) {
 				err = sysfs_set_str(sra, NULL, "level", c);
 				if (err) {
diff --git a/super-intel.c b/super-intel.c
index 0488c1c..395e7b9 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6342,8 +6342,30 @@ static int update_level_imsm(struct supertype *st, struct mdinfo *info,
 		((info->array.level != 0) && (geo->level != 10)))
 		return 1;
 
-	dev = __get_imsm_dev(super->anchor, 0);
+	/* imsm does not support raid0 to raid10 takeover for 2-drive raid0 */
+	if ((geo->level == 10) &&
+	    (info->array.level == 0) &&
+	    (info->array.raid_disks > 2)) {
+		fprintf(stderr, "imsm: Cannot set level to %i for array %s "\
+			"(number of drives > 2)\n",
+			geo->level,
+			geo->dev_name);
+		/* return to raid0 */
+		char fname[PATH_MAX];
+		int fd;
+		sprintf(fname, "/sys/block/md%i/md/level", geo->dev_id);
+		fd = open(fname, O_WRONLY);
+		if (fd < 0)
+			return 1;
+		if (write(fd, "raid0", 5) != 5)
+			dprintf(Name ": failed to write raid0 to '%s' (%s)\n",
+				fname,
+				strerror(errno));
+		close(fd);
+		return 1;
+	}
 
+	dev = __get_imsm_dev(super->anchor, 0);
 	map = get_imsm_map(dev, 0);
 	geo->raid_disks = (geo->level == 10) ? 4 : map->num_members;
 

