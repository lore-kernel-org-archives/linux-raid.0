From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 10/13] imsm: rename subarray functionality
Date: Thu, 22 Apr 2010 23:12:35 +0100
Message-ID: <66C59AD0932712458090B447266D638CD405E3BE@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Added supertype->volume_rename() containing metadata manipulation that
renames volume. For IMSM, rename is made by changing intel_super->volume,
and writing updates of mpb on disk accordingly.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 mdadm.h       |    1 +
 super-intel.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 118edd0..81fde4c 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -597,6 +597,7 @@ extern struct superswitch {
 	int (*write_bitmap)(struct supertype *st, int fd);
 	void (*free_super)(struct supertype *st);
 	int (*delete_subarray)(struct supertype *st, int fd);
+	int (*rename_subarray)(struct supertype *st, char *new_name, int fd);
 
 	/* validate_geometry is called with an st returned by
 	 * match_metadata_desc.
diff --git a/super-intel.c b/super-intel.c
index 739ab7d..b26cd06 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3596,6 +3596,66 @@ int delete_subarray_imsm(struct supertype *st, int fd)
 	return rv;
 }
 
+#define IMSM_SERIAL_MAX_LEN 16
+
+static int _validate_name(char *name)
+{
+	int i, len;
+
+	if (!name)
+		return 1;
+
+	if ((len = strlen(name)) > IMSM_SERIAL_MAX_LEN)
+		return 1;
+
+	for (i = 0; name[i] && i < len; i++) {
+		if (name[i] < 32 || name[i] > 126 || name[i] == 92)
+			break;
+	}
+
+	if (i < len)
+		return 1;
+	return 0;
+}
+
+static int rename_subarray_imsm(struct supertype *st, char *new_name, int fd)
+{
+	struct intel_super *super;
+	struct imsm_super *mpb;
+	struct imsm_dev *dev;
+	int container_index;
+	int rv = 0;
+
+	if (!st)
+		return 1;
+
+	super = st->sb;
+	mpb = super ? super->anchor : NULL;
+
+	if (!mpb)
+		return 1;
+
+	container_index = super->current_vol;
+	if (container_index < 0) {
+		fprintf(stderr, Name ": Superblock does not point to subarray.\n");
+		return 1;
+	}
+
+	if (_validate_name(new_name)) {
+		fprintf(stderr, Name ": New array name contains illegal characters or is too long.\n");
+		return 1;
+	}
+
+	dev = get_imsm_dev(super, container_index);
+	strncpy((char *) dev->volume, new_name, MAX_RAID_SERIAL_LEN);
+
+	/* use passed fd as handle in intel_super is not available */
+	super->disks->fd = fd;
+
+	rv = write_super_imsm(super, 0);
+
+	return rv;
+}
 static int store_super_imsm(struct supertype *st, int fd)
 {
 	struct intel_super *super = st->sb;
@@ -5380,6 +5440,7 @@ struct superswitch super_imsm = {
 	.brief_detail_super = brief_detail_super_imsm,
 	.write_init_super = write_init_super_imsm,
 	.delete_subarray = delete_subarray_imsm,
+	.rename_subarray = rename_subarray_imsm,
 	.validate_geometry = validate_geometry_imsm,
 	.add_to_super	= add_to_super_imsm,
 	.detail_platform = detail_platform_imsm,
-- 
1.6.4.2


--
Best Regards,
Przemyslaw Hawrylewicz-Czarnowski
Software Development Engineer


