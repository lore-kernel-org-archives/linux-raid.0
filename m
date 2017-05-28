From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 17/22] partitions/ldm: switch to use uuid_t
Date: Sun, 28 May 2017 13:20:03 +0300
Message-ID: <20170528102008.30276-18-hch@lst.de>
References: <20170528102008.30276-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170528102008.30276-1-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

And the uuid helpers.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 block/partitions/ldm.c | 10 +++++-----
 block/partitions/ldm.h |  6 ++----
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/block/partitions/ldm.c b/block/partitions/ldm.c
index edcea70674c9..bbf929e80b94 100644
--- a/block/partitions/ldm.c
+++ b/block/partitions/ldm.c
@@ -115,7 +115,7 @@ static bool ldm_parse_privhead(const u8 *data, struct privhead *ph)
 		ldm_error("PRIVHEAD disk size doesn't match real disk size");
 		return false;
 	}
-	if (uuid_be_to_bin(data + 0x0030, (uuid_be *)ph->disk_id)) {
+	if (uuid_to_bin(data + 0x0030, &ph->disk_id)) {
 		ldm_error("PRIVHEAD contains an invalid GUID.");
 		return false;
 	}
@@ -234,7 +234,7 @@ static bool ldm_compare_privheads (const struct privhead *ph1,
 		(ph1->logical_disk_size  == ph2->logical_disk_size)	&&
 		(ph1->config_start       == ph2->config_start)		&&
 		(ph1->config_size        == ph2->config_size)		&&
-		!memcmp (ph1->disk_id, ph2->disk_id, GUID_SIZE));
+		uuid_equal(&ph1->disk_id, &ph2->disk_id));
 }
 
 /**
@@ -557,7 +557,7 @@ static struct vblk * ldm_get_disk_objid (const struct ldmdb *ldb)
 
 	list_for_each (item, &ldb->v_disk) {
 		struct vblk *v = list_entry (item, struct vblk, list);
-		if (!memcmp (v->vblk.disk.disk_id, ldb->ph.disk_id, GUID_SIZE))
+		if (uuid_equal(&v->vblk.disk.disk_id, &ldb->ph.disk_id))
 			return v;
 	}
 
@@ -892,7 +892,7 @@ static bool ldm_parse_dsk3 (const u8 *buffer, int buflen, struct vblk *vb)
 	disk = &vb->vblk.disk;
 	ldm_get_vstr (buffer + 0x18 + r_diskid, disk->alt_name,
 		sizeof (disk->alt_name));
-	if (uuid_be_to_bin(buffer + 0x19 + r_name, (uuid_be *)disk->disk_id))
+	if (uuid_to_bin(buffer + 0x19 + r_name, &disk->disk_id))
 		return false;
 
 	return true;
@@ -927,7 +927,7 @@ static bool ldm_parse_dsk4 (const u8 *buffer, int buflen, struct vblk *vb)
 		return false;
 
 	disk = &vb->vblk.disk;
-	memcpy (disk->disk_id, buffer + 0x18 + r_name, GUID_SIZE);
+	uuid_copy(&disk->disk_id, (uuid_t *)(buffer + 0x18 + r_name));
 	return true;
 }
 
diff --git a/block/partitions/ldm.h b/block/partitions/ldm.h
index 374242c0971a..f4c6055df956 100644
--- a/block/partitions/ldm.h
+++ b/block/partitions/ldm.h
@@ -112,8 +112,6 @@ struct frag {				/* VBLK Fragment handling */
 
 /* In memory LDM database structures. */
 
-#define GUID_SIZE		16
-
 struct privhead {			/* Offsets and sizes are in sectors. */
 	u16	ver_major;
 	u16	ver_minor;
@@ -121,7 +119,7 @@ struct privhead {			/* Offsets and sizes are in sectors. */
 	u64	logical_disk_size;
 	u64	config_start;
 	u64	config_size;
-	u8	disk_id[GUID_SIZE];
+	uuid_t	disk_id;
 };
 
 struct tocblock {			/* We have exactly two bitmaps. */
@@ -154,7 +152,7 @@ struct vblk_dgrp {			/* VBLK Disk Group */
 };
 
 struct vblk_disk {			/* VBLK Disk */
-	u8	disk_id[GUID_SIZE];
+	uuid_t	disk_id;
 	u8	alt_name[128];
 };
 
-- 
2.11.0
