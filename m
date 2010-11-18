From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 10/13] Initialize st->devnum and st->container_dev in
	super_by_fd
Date: Thu, 18 Nov 2010 10:22:41 +0100
Message-ID: <20101118092240.29508.24050.stgit@gklab-170-111.igk.intel.com>
References: <20101118080359.29508.50648.stgit@gklab-170-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101118080359.29508.50648.stgit@gklab-170-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Dan Williams <dan.j.williams@intel.com>

Precludes needing to deduce this information later, like in Detail.c and
soon in Grow.c.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Detail.c |   11 ++++-------
 util.c   |   13 ++++++++-----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Detail.c b/Detail.c
index e0817aa..1f2dbf2 100644
--- a/Detail.c
+++ b/Detail.c
@@ -97,16 +97,13 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
 	if (st)
 		max_disks = st->max_devs;
 
-	if (sra && is_subarray(sra->text_version) &&
-		strchr(sra->text_version+1, '/')) {
+	if (st->subarray[0]) {
 		/* This is a subarray of some container.
 		 * We want the name of the container, and the member
 		 */
-		char *s = strchr(sra->text_version+1, '/');
-		int dn;
-		*s++ = '\0';
-		member = s;
-		dn = devname2devnum(sra->text_version+1);
+		int dn = st->container_dev;
+
+		member = st->subarray;
 		container = map_dev(dev2major(dn), dev2minor(dn), 1);
 	}
 
diff --git a/util.c b/util.c
index 5f2694e..5023f42 100644
--- a/util.c
+++ b/util.c
@@ -1088,6 +1088,7 @@ struct supertype *super_by_fd(int fd)
 	char version[20];
 	int i;
 	char *subarray = NULL;
+	int container = NoMdDev;
 
 	sra = sysfs_read(fd, 0, GET_VERSION);
 
@@ -1109,15 +1110,15 @@ struct supertype *super_by_fd(int fd)
 	}
 	if (minor == -2 && is_subarray(verstr)) {
 		char *dev = verstr+1;
+
 		subarray = strchr(dev, '/');
-		int devnum;
 		if (subarray)
 			*subarray++ = '\0';
-		devnum = devname2devnum(dev);
 		subarray = strdup(subarray);
+		container = devname2devnum(dev);
 		if (sra)
 			sysfs_free(sra);
-		sra = sysfs_read(-1, devnum, GET_VERSION);
+		sra = sysfs_read(-1, container, GET_VERSION);
 		if (sra && sra->text_version[0])
 			verstr = sra->text_version;
 		else
@@ -1132,11 +1133,13 @@ struct supertype *super_by_fd(int fd)
 	if (st) {
 		st->sb = NULL;
 		if (subarray) {
-			strncpy(st->subarray, subarray, 32);
-			st->subarray[31] = 0;
+			strncpy(st->subarray, subarray, sizeof(st->subarray));
+			st->subarray[sizeof(st->subarray) - 1] = 0;
 			free(subarray);
 		} else
 			st->subarray[0] = 0;
+		st->container_dev = container;
+		st->devnum = fd2devnum(fd);
 	}
 	return st;
 }

