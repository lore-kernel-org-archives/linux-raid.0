From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC mdadm PATCH 08/11] imsm: read cache metadata
Date: Thu, 24 Apr 2014 00:23:01 -0700
Message-ID: <20140424072301.4515.25655.stgit@viggo.jf.intel.com>
References: <20140424071902.4515.19684.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140424071902.4515.19684.stgit@viggo.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, jes.sorensen@redhat.com, artur.paszkiewicz@intel.com, dave.jiang@intel.com
List-Id: linux-raid.ids

Add support for identifying cache volumes and retrieving the associated
cache mpb located at the start of the volume marked with a
DEV_NVC_VOLUME flag.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 super-intel.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index acc46368322f..f179d80b8209 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -345,6 +345,7 @@ static unsigned int mpb_sectors(struct imsm_super *mpb)
 struct intel_dev {
 	struct imsm_dev *dev;
 	struct intel_dev *next;
+	struct nv_cache_control_data *nvc;
 	unsigned index;
 };
 
@@ -3086,6 +3087,7 @@ static void free_devlist(struct intel_super *super)
 
 	while (super->devlist) {
 		dv = super->devlist->next;
+		free(super->devlist->nvc);
 		free(super->devlist->dev);
 		free(super->devlist);
 		super->devlist = dv;
@@ -3467,9 +3469,34 @@ static void end_migration(struct imsm_dev *dev, struct intel_super *super,
 }
 #endif
 
-static int parse_raid_devices(struct intel_super *super)
+static int load_cache(int fd, struct intel_dev *dv)
 {
-	int i;
+	struct imsm_dev *dev = dv->dev;
+	struct imsm_map *map = get_imsm_map(dev, MAP_X);
+	off_t offset = pba_of_lba0(map) << 9;
+	ssize_t size = (sizeof(*dv->nvc) + 511) & ~511;
+	int ret;
+
+	if (posix_memalign((void**) &dv->nvc, 512, size) != 0) {
+		pr_err("Failed to allocate cache anchor buffer"
+				" for %.16s\n", dev->volume);
+		return 1;
+	}
+
+	ret = pread(fd, dv->nvc, size, offset);
+	if (ret != size) {
+		pr_err("Failed to read cache metadata for %.16s: %s\n",
+			dev->volume, strerror(errno));
+		free(dv->nvc);
+		dv->nvc = NULL;
+	}
+
+	return ret != size;
+}
+
+static int load_raid_devices(int fd, struct intel_super *super)
+{
+	int i, err;
 	struct imsm_dev *dev_new;
 	size_t len, len_migr;
 	size_t max_len = 0;
@@ -3496,6 +3523,16 @@ static int parse_raid_devices(struct intel_super *super)
 		dv->index = i;
 		dv->next = super->devlist;
 		super->devlist = dv;
+
+		/* volumes that serve as caches have metadata at offset-0 from
+		 * the start of the volume
+		 */
+		if (dv->dev->status & DEV_NVC_VOLUME) {
+			err = load_cache(fd, dv);
+			if (err)
+				return err;
+		} else
+			dv->nvc = NULL;
 	}
 
 	/* ensure that super->buf is large enough when all raid devices
@@ -3718,8 +3755,7 @@ static void clear_hi(struct intel_super *super)
 	}
 }
 
-static int
-load_and_parse_mpb(int fd, struct intel_super *super, char *devname, int keep_fd)
+static int load_mpb(int fd, struct intel_super *super, char *devname, int keep_fd)
 {
 	int err;
 
@@ -3729,7 +3765,10 @@ load_and_parse_mpb(int fd, struct intel_super *super, char *devname, int keep_fd
 	err = load_imsm_disk(fd, super, devname, keep_fd);
 	if (err)
 		return err;
-	err = parse_raid_devices(super);
+	err = load_raid_devices(fd, super);
+	if (err)
+		return err;
+
 	clear_hi(super);
 	return err;
 }
@@ -4384,13 +4423,13 @@ static int get_super_block(struct intel_super **super_list, char *devnm, char *d
 	}
 
 	find_intel_hba_capability(dfd, s, devname);
-	err = load_and_parse_mpb(dfd, s, NULL, keep_fd);
+	err = load_mpb(dfd, s, NULL, keep_fd);
 
 	/* retry the load if we might have raced against mdmon */
 	if (err == 3 && devnm && mdmon_running(devnm))
 		for (retry = 0; retry < 3; retry++) {
 			usleep(3000);
-			err = load_and_parse_mpb(dfd, s, NULL, keep_fd);
+			err = load_mpb(dfd, s, NULL, keep_fd);
 			if (err != 3)
 				break;
 		}
@@ -4473,7 +4512,7 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 		free_imsm(super);
 		return 2;
 	}
-	rv = load_and_parse_mpb(fd, super, devname, 0);
+	rv = load_mpb(fd, super, devname, 0);
 
 	if (rv) {
 		if (devname)

