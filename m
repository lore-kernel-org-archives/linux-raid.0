From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 10/53] Initialize st->devnum and st->container_dev in
	super_by_fd
Date: Fri, 26 Nov 2010 09:05:07 +0100
Message-ID: <20101126080507.5221.27587.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Precludes needing to deduce this information later, like in Detail.c and
soon in Grow.c.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Detail.c |   21 ++++++++++-----------
 util.c   |   23 ++++++++++++++---------
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/Detail.c b/Detail.c
index e0817aa..0fb90e8 100644
--- a/Detail.c
+++ b/Detail.c
@@ -97,16 +97,13 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
 	if (st)
 		max_disks = st->max_devs;
 
-	if (sra && is_subarray(sra->text_version) &&
-		strchr(sra->text_version+1, '/')) {
+	if (st && st->subarray[0]) {
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
 
@@ -417,7 +414,7 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
 		}
 		free_mdstat(ms);
 
-		if (st->sb && info.reshape_active) {
+		if (st && st->sb && info.reshape_active) {
 #if 0
 This is pretty boring
 			printf("  Reshape pos'n : %llu%s\n", (unsigned long long) info.reshape_progress<<9,
@@ -567,9 +564,11 @@ This is pretty boring
 		if (!brief) printf("\n");
 	}
 	if (spares && brief && array.raid_disks) printf(" spares=%d", spares);
-	if (brief && st && st->sb)
-		st->ss->brief_detail_super(st);
-	st->ss->free_super(st);
+	if (st) {
+		if (brief && st->sb)
+			st->ss->brief_detail_super(st);
+		st->ss->free_super(st);
+	}
 
 	if (brief > 1 && devices) printf("\n   devices=%s", devices);
 	if (brief) printf("\n");
diff --git a/util.c b/util.c
index 5f2694e..8739278 100644
--- a/util.c
+++ b/util.c
@@ -1085,9 +1085,10 @@ struct supertype *super_by_fd(int fd)
 	struct supertype *st = NULL;
 	struct mdinfo *sra;
 	char *verstr;
-	char version[20];
+	char version[30];
 	int i;
 	char *subarray = NULL;
+	int container = NoMdDev;
 
 	sra = sysfs_read(fd, 0, GET_VERSION);
 
@@ -1109,15 +1110,16 @@ struct supertype *super_by_fd(int fd)
 	}
 	if (minor == -2 && is_subarray(verstr)) {
 		char *dev = verstr+1;
+
 		subarray = strchr(dev, '/');
-		int devnum;
-		if (subarray)
+		if (subarray) {
 			*subarray++ = '\0';
-		devnum = devname2devnum(dev);
-		subarray = strdup(subarray);
+			subarray = strdup(subarray);
+		}
+		container = devname2devnum(dev);
 		if (sra)
 			sysfs_free(sra);
-		sra = sysfs_read(-1, devnum, GET_VERSION);
+		sra = sysfs_read(-1, container, GET_VERSION);
 		if (sra && sra->text_version[0])
 			verstr = sra->text_version;
 		else
@@ -1132,12 +1134,15 @@ struct supertype *super_by_fd(int fd)
 	if (st) {
 		st->sb = NULL;
 		if (subarray) {
-			strncpy(st->subarray, subarray, 32);
-			st->subarray[31] = 0;
-			free(subarray);
+			strncpy(st->subarray, subarray, sizeof(st->subarray));
+			st->subarray[sizeof(st->subarray) - 1] = 0;
 		} else
 			st->subarray[0] = 0;
+		st->container_dev = container;
+		st->devnum = fd2devnum(fd);
 	}
+	if (subarray)
+		free(subarray);
 	return st;
 }
 #endif /* !defined(MDASSEMBLE) || defined(MDASSEMBLE) && defined(MDASSEMBLE_AUTO) */

