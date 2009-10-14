From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm PATCH 05/12] imsm: fix/support --update
Date: Tue, 13 Oct 2009 19:10:41 -0700
Message-ID: <20091014021041.31570.22953.stgit@dwillia2-linux.ch.intel.com>
References: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, krzysztof.wojcik@intel.com, ed.ciechanowski@intel.com, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

Fix init_super_imsm() to return an empty mpb when info == NULL, and
teach store_super_imsm() to simply write out the passed in mpb.

Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=523320

Reported-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 super-intel.c |   54 ++++++++++++++++++++++++++----------------------------
 1 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 0e3ed89..eaf5b0b 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2819,24 +2819,33 @@ static int init_super_imsm(struct supertype *st, mdu_array_info_t *info,
 	size_t mpb_size;
 	char *version;
 
-	if (!info) {
-		st->sb = NULL;
-		return 0;
-	}
 	if (st->sb)
-		return init_super_imsm_volume(st, info, size, name, homehost,
-					      uuid);
+		return init_super_imsm_volume(st, info, size, name, homehost, uuid);
+
+	if (info)
+		mpb_size = disks_to_mpb_size(info->nr_disks);
+	else
+		mpb_size = 512;
 
 	super = alloc_super(1);
-	if (!super)
-		return 0;
-	mpb_size = disks_to_mpb_size(info->nr_disks);
-	if (posix_memalign(&super->buf, 512, mpb_size) != 0) {
+	if (super && posix_memalign(&super->buf, 512, mpb_size) != 0) {
 		free(super);
+		super = NULL;
+	}
+	if (!super) {
+		fprintf(stderr, Name
+			": %s could not allocate superblock\n", __func__);
 		return 0;
 	}
+	memset(super->buf, 0, mpb_size);
 	mpb = super->buf;
-	memset(mpb, 0, mpb_size); 
+	mpb->mpb_size = __cpu_to_le32(mpb_size);
+	st->sb = super;
+
+	if (info == NULL) {
+		/* zeroing superblock */
+		return 0;
+	}
 
 	mpb->attributes = MPB_ATTRIB_CHECKSUM_VERIFY;
 
@@ -2844,9 +2853,7 @@ static int init_super_imsm(struct supertype *st, mdu_array_info_t *info,
 	strcpy(version, MPB_SIGNATURE);
 	version += strlen(MPB_SIGNATURE);
 	strcpy(version, MPB_VERSION_RAID0);
-	mpb->mpb_size = mpb_size;
 
-	st->sb = super;
 	return 1;
 }
 
@@ -3188,24 +3195,15 @@ static int write_init_super_imsm(struct supertype *st)
 }
 #endif
 
-static int store_zero_imsm(struct supertype *st, int fd)
+static int store_super_imsm(struct supertype *st, int fd)
 {
-	unsigned long long dsize;
-	void *buf;
-
-	get_dev_size(fd, NULL, &dsize);
-
-	/* first block is stored on second to last sector of the disk */
-	if (lseek64(fd, dsize - (512 * 2), SEEK_SET) < 0)
-		return 1;
+	struct intel_super *super = st->sb;
+	struct imsm_super *mpb = super ? super->anchor : NULL;
 
-	if (posix_memalign(&buf, 512, 512) != 0)
+	if (!mpb)
 		return 1;
 
-	memset(buf, 0, 512);
-	if (write(fd, buf, 512) != 512)
-		return 1;
-	return 0;
+	return store_imsm_mpb(fd, mpb);
 }
 
 static int imsm_bbm_log_size(struct imsm_super *mpb)
@@ -4914,7 +4912,7 @@ struct superswitch super_imsm = {
 
 	.load_super	= load_super_imsm,
 	.init_super	= init_super_imsm,
-	.store_super	= store_zero_imsm,
+	.store_super	= store_super_imsm,
 	.free_super	= free_super_imsm,
 	.match_metadata_desc = match_metadata_desc_imsm,
 	.container_content = container_content_imsm,

