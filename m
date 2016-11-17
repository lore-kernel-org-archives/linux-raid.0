From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH v2 2/4] IMSM: Read and store device sector size
Date: Thu, 17 Nov 2016 14:58:36 +0100
Message-ID: <1479391118-31600-3-git-send-email-pawel.baldysiak@intel.com>
References: <1479391118-31600-1-git-send-email-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1479391118-31600-1-git-send-email-pawel.baldysiak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

This patch adds retriving device sector size at startup
and set it in intel_super, so it can be used in other places.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 super-intel.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index 21e8532..a1b5cfb 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -366,6 +366,7 @@ struct intel_super {
 	unsigned long long create_offset; /* common start for 'current_vol' */
 	__u32 random; /* random data for seeding new family numbers */
 	struct intel_dev *devlist;
+	unsigned int sector_size; /* sector size of used member drives */
 	struct dl {
 		struct dl *next;
 		int index;
@@ -4491,6 +4492,7 @@ static int get_super_block(struct intel_super **super_list, char *devnm, char *d
 		goto error;
 	}
 
+	get_dev_sector_size(dfd, NULL, &s->sector_size);
 	find_intel_hba_capability(dfd, s, devname);
 	err = load_and_parse_mpb(dfd, s, NULL, keep_fd);
 
@@ -4570,6 +4572,7 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 	free_super_imsm(st);
 
 	super = alloc_super();
+	get_dev_sector_size(fd, NULL, &super->sector_size);
 	/* Load hba and capabilities if they exist.
 	 * But do not preclude loading metadata in case capabilities or hba are
 	 * non-compliant and ignore_hw_compat is set.
@@ -5102,6 +5105,7 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	struct intel_super *super = st->sb;
 	struct dl *dd;
 	unsigned long long size;
+	unsigned int member_sector_size;
 	__u32 id;
 	int rv;
 	struct stat stb;
@@ -5182,6 +5186,19 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	}
 
 	get_dev_size(fd, NULL, &size);
+	get_dev_sector_size(fd, NULL, &member_sector_size);
+
+	if (super->sector_size == 0) {
+		/* this a first device, so sector_size is not set yet */
+		super->sector_size = member_sector_size;
+	} else if (member_sector_size != super->sector_size) {
+		pr_err("Mixing between different sector size is forbidden, aborting...\n");
+		if (dd->devname)
+			free(dd->devname);
+		free(dd);
+		return 1;
+	}
+
 	/* clear migr_rec when adding disk to container */
 	memset(super->migr_rec_buf, 0, MIGR_REC_BUF_SIZE);
 	if (lseek64(fd, size - MIGR_REC_POSITION, SEEK_SET) >= 0) {
@@ -5529,6 +5546,12 @@ static int validate_geometry_imsm_container(struct supertype *st, int level,
 	 * note that there is no fd for the disks in array.
 	 */
 	super = alloc_super();
+	if (!get_dev_sector_size(fd, NULL, &super->sector_size)) {
+		close(fd);
+		free_imsm(super);
+		return 0;
+	}
+
 	rv = find_intel_hba_capability(fd, super, verbose > 0 ? dev : NULL);
 	if (rv != 0) {
 #if DEBUG
-- 
2.7.4

