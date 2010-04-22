From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 06/13] imsm: delete subarray metadata manipulation routine
Date: Thu, 22 Apr 2010 23:11:59 +0100
Message-ID: <66C59AD0932712458090B447266D638CD405E3BA@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Added supertype->delete_subarray and appropriate routine for imsm metadata
to remove references to array selected with st->subarray. Modifying a member of an active container is not allowed.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 mdadm.h       |    1 +
 super-intel.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 304378a..cfbe407 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -594,6 +594,7 @@ extern struct superswitch {
 	void (*locate_bitmap)(struct supertype *st, int fd);
 	int (*write_bitmap)(struct supertype *st, int fd);
 	void (*free_super)(struct supertype *st);
+	int (*delete_subarray)(struct supertype *st, int fd);
 
 	/* validate_geometry is called with an st returned by
 	 * match_metadata_desc.
diff --git a/super-intel.c b/super-intel.c
index 1a536f9..ff6fb52 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3454,6 +3454,63 @@ static int write_init_super_imsm(struct supertype *st)
 }
 #endif
 
+int delete_subarray_imsm(struct supertype *st, int fd)
+{
+	struct intel_super *super = st->sb;
+	struct imsm_super *mpb = super ? super->anchor : NULL;
+	int container_index;
+	int rv = 0;
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
+	/* First case: 2 volumes */
+	if (mpb->num_raid_devs > 1) {
+		struct intel_dev *dp;
+		struct intel_dev *d = super->devlist->next;
+
+		if (super->devlist->index == container_index) {
+			struct intel_dev *t = super->devlist;
+			super->devlist = super->devlist->next;
+			free(t->dev);
+			free(t);
+		} else
+			super->devlist->index--;
+
+		dp = super->devlist;
+		while(d) {
+			if (d->index == container_index) {
+				struct intel_dev *t = d;
+				dp->next = d->next;
+				d = d->next;
+				free(t->dev);
+				free(t);
+			} else {
+				if (d->index > container_index)
+					d->index--;
+				dp = d;
+				d = d->next;
+			}
+		}
+
+		mpb->num_raid_devs--;
+		if (!st->loaded_container)
+			super->disks->fd = fd;
+		rv = write_super_imsm(super, 0);
+	} else { /* second case: 1 volume */
+		struct dl *d;
+		for (d = super->disks; d; d = d->next)
+			rv |= Kill(d->devname, NULL, 0, 1, 1);
+	}
+	return rv;
+}
+
 static int store_super_imsm(struct supertype *st, int fd)
 {
 	struct intel_super *super = st->sb;
@@ -5230,6 +5287,7 @@ struct superswitch super_imsm = {
 	.detail_super	= detail_super_imsm,
 	.brief_detail_super = brief_detail_super_imsm,
 	.write_init_super = write_init_super_imsm,
+	.delete_subarray = delete_subarray_imsm,
 	.validate_geometry = validate_geometry_imsm,
 	.add_to_super	= add_to_super_imsm,
 	.detail_platform = detail_platform_imsm,
-- 
1.6.4.2


--
Best Regards,
Przemyslaw Hawrylewicz-Czarnowski
Software Development Engineer


