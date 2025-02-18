Received: from harvie.cz (harvie.cz [77.87.242.242])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4DA1ADFE3;
	Tue, 18 Feb 2025 11:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.87.242.242
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739879154; cv=none; b=RZZGhwkt9JR3IOue2inBWOg7RtErNihsw6qo/4K4tNKErcPrKlyH7rutZZQVlSq89t/9YmJ0CNsuL/gJmJotlA3xKcc0JjPM89RbHB8fYyPaTDYgpYhEHfBQTxAjCIbecgasiwgwJi9Httqx+2HQ4g+ABzKmIPrOZ+ISGi03GeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739879154; c=relaxed/simple;
	bh=2Eauxf+JLpV+mLoqw6uc4VuzS2dTyT4yqfOm91N1Wt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtcO2s+6LW8tJDurV/Cfd92e26RrR04LQcjkWrmZS6FWN1Ds2UHJCaCv4LBV2M9QdpaPCnGcpLip9RAVsqiJuMMzGIYHBjDGO+aifvnHRm8BsG+RTf9KbLucGksgcpNY7B/8anuRZU5zMnTo2MVP8SN1QoNcggh1QFQ2VSOs3Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=fail smtp.mailfrom=gmail.com; arc=none smtp.client-ip=77.87.242.242
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=gmail.com
Received: from anemophobia.amit.cz (unknown [31.30.84.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by harvie.cz (Postfix) with ESMTPSA id 21E1E1800FF;
	Tue, 18 Feb 2025 12:39:20 +0100 (CET)
From: Tomas Mudrunka <tomas.mudrunka@gmail.com>
To: yukuai3@huawei.com
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	mtkaczyk@kernel.org,
	song@kernel.org,
	tomas.mudrunka@gmail.com
Subject: [PATCH v4] Export MDRAID bitmap on disk structure in UAPI header file
Date: Tue, 18 Feb 2025 12:38:49 +0100
Message-ID: <20250218113849.561007-1-tomas.mudrunka@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <bead708f-b901-18df-f461-c5324fbe2555@huawei.com>
References: <bead708f-b901-18df-f461-c5324fbe2555@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When working on software that manages MD RAID disks from
userspace. Currently provided headers only contain MD superblock.
That is not enough to fully populate MD RAID metadata.
Therefore this patch adds bitmap superblock as well.

Signed-off-by: Tomas Mudrunka <tomas.mudrunka@gmail.com>
---
V3 -> V4: Removed typedef
V2 -> V3: Fixed checkpatch errors
V1 -> V2: Also exported stuff needed by mdadm according to Mariusz Tkaczyk

 drivers/md/md-bitmap.c         | 45 +++++++++++---------------
 drivers/md/md-bitmap.h         | 42 +-----------------------
 include/uapi/linux/raid/md_p.h | 58 +++++++++++++++++++++++++++++++++-
 3 files changed, 76 insertions(+), 69 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index ec4ecd96e..9f7252f08 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -32,15 +32,6 @@
 #include "md.h"
 #include "md-bitmap.h"
 
-#define BITMAP_MAJOR_LO 3
-/* version 4 insists the bitmap is in little-endian order
- * with version 3, it is host-endian which is non-portable
- * Version 5 is currently set only for clustered devices
- */
-#define BITMAP_MAJOR_HI 4
-#define BITMAP_MAJOR_CLUSTERED 5
-#define	BITMAP_MAJOR_HOSTENDIAN 3
-
 /*
  * in-memory bitmap:
  *
@@ -673,7 +664,7 @@ static void md_bitmap_wait_writes(struct bitmap *bitmap)
 /* update the event counter and sync the superblock to disk */
 static void bitmap_update_sb(void *data)
 {
-	bitmap_super_t *sb;
+	struct bitmap_super *sb;
 	struct bitmap *bitmap = data;
 
 	if (!bitmap || !bitmap->mddev) /* no bitmap for this array */
@@ -713,7 +704,7 @@ static void bitmap_update_sb(void *data)
 
 static void bitmap_print_sb(struct bitmap *bitmap)
 {
-	bitmap_super_t *sb;
+	struct bitmap_super *sb;
 
 	if (!bitmap || !bitmap->storage.sb_page)
 		return;
@@ -752,7 +743,7 @@ static void bitmap_print_sb(struct bitmap *bitmap)
  */
 static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
 {
-	bitmap_super_t *sb;
+	struct bitmap_super *sb;
 	unsigned long chunksize, daemon_sleep, write_behind;
 
 	bitmap->storage.sb_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
@@ -812,7 +803,7 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
 static int md_bitmap_read_sb(struct bitmap *bitmap)
 {
 	char *reason = NULL;
-	bitmap_super_t *sb;
+	struct bitmap_super *sb;
 	unsigned long chunksize, daemon_sleep, write_behind;
 	unsigned long long events;
 	int nodes = 0;
@@ -843,7 +834,7 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 		bm_blocks = DIV_ROUND_UP_SECTOR_T(bm_blocks,
 			   (bitmap->mddev->bitmap_info.chunksize >> 9));
 		/* bits to bytes */
-		bm_blocks = ((bm_blocks+7) >> 3) + sizeof(bitmap_super_t);
+		bm_blocks = ((bm_blocks+7) >> 3) + sizeof(struct bitmap_super);
 		/* to 4k blocks */
 		bm_blocks = DIV_ROUND_UP_SECTOR_T(bm_blocks, 4096);
 		offset = bitmap->cluster_slot * (bm_blocks << 3);
@@ -859,7 +850,7 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 				bitmap, bytes, sb_page);
 	} else {
 		err = read_sb_page(bitmap->mddev, offset, sb_page, 0,
-				   sizeof(bitmap_super_t));
+				   sizeof(struct bitmap_super));
 	}
 	if (err)
 		return err;
@@ -980,7 +971,7 @@ static inline unsigned long file_page_index(struct bitmap_storage *store,
 					    unsigned long chunk)
 {
 	if (store->sb_page)
-		chunk += sizeof(bitmap_super_t) << 3;
+		chunk += sizeof(struct bitmap_super) << 3;
 	return chunk >> PAGE_BIT_SHIFT;
 }
 
@@ -989,7 +980,7 @@ static inline unsigned long file_page_offset(struct bitmap_storage *store,
 					     unsigned long chunk)
 {
 	if (store->sb_page)
-		chunk += sizeof(bitmap_super_t) << 3;
+		chunk += sizeof(struct bitmap_super) << 3;
 	return chunk & (PAGE_BITS - 1);
 }
 
@@ -1015,7 +1006,7 @@ static int md_bitmap_storage_alloc(struct bitmap_storage *store,
 
 	bytes = DIV_ROUND_UP(chunks, 8);
 	if (with_super)
-		bytes += sizeof(bitmap_super_t);
+		bytes += sizeof(struct bitmap_super);
 
 	num_pages = DIV_ROUND_UP(bytes, PAGE_SIZE);
 	offset = slot_number * num_pages;
@@ -1382,7 +1373,7 @@ static int md_bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 			void *paddr;
 
 			if (i == 0 && !mddev->bitmap_info.external)
-				offset = sizeof(bitmap_super_t);
+				offset = sizeof(struct bitmap_super);
 
 			/*
 			 * If the bitmap is out of date, dirty the whole page
@@ -1543,7 +1534,7 @@ static void bitmap_daemon_work(struct mddev *mddev)
 	    mddev->bitmap_info.external == 0) {
 		/* Arrange for superblock update as well as
 		 * other changes */
-		bitmap_super_t *sb;
+		struct bitmap_super *sb;
 		bitmap->need_sync = 0;
 		if (bitmap->storage.filemap) {
 			sb = kmap_local_page(bitmap->storage.sb_page);
@@ -2123,7 +2114,7 @@ static struct bitmap *__bitmap_create(struct mddev *mddev, int slot)
 	int err;
 	struct kernfs_node *bm = NULL;
 
-	BUILD_BUG_ON(sizeof(bitmap_super_t) != 256);
+	BUILD_BUG_ON(sizeof(struct bitmap_super) != 256);
 
 	BUG_ON(file && mddev->bitmap_info.offset);
 
@@ -2351,7 +2342,7 @@ static int bitmap_get_stats(void *data, struct md_bitmap_stats *stats)
 	struct bitmap_storage *storage;
 	struct bitmap_counts *counts;
 	struct bitmap *bitmap = data;
-	bitmap_super_t *sb;
+	struct bitmap_super *sb;
 
 	if (!bitmap)
 		return -ENOENT;
@@ -2415,7 +2406,7 @@ static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 			 */
 			bytes = DIV_ROUND_UP(bitmap->counts.chunks, 8);
 			if (!bitmap->mddev->bitmap_info.external)
-				bytes += sizeof(bitmap_super_t);
+				bytes += sizeof(struct bitmap_super);
 			space = DIV_ROUND_UP(bytes, 512);
 			bitmap->mddev->bitmap_info.space = space;
 		}
@@ -2427,9 +2418,9 @@ static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 			chunks = DIV_ROUND_UP_SECTOR_T(blocks, 1 << chunkshift);
 			bytes = DIV_ROUND_UP(chunks, 8);
 			if (!bitmap->mddev->bitmap_info.external)
-				bytes += sizeof(bitmap_super_t);
+				bytes += sizeof(struct bitmap_super);
 		} while (bytes > (space << 9) && (chunkshift + BITMAP_BLOCK_SHIFT) <
-			(BITS_PER_BYTE * sizeof(((bitmap_super_t *)0)->chunksize) - 1));
+			(BITS_PER_BYTE * sizeof(((struct bitmap_super *)0)->chunksize) - 1));
 	} else
 		chunkshift = ffz(~chunksize) - BITMAP_BLOCK_SHIFT;
 
@@ -2463,7 +2454,7 @@ static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	if (store.sb_page && bitmap->storage.sb_page)
 		memcpy(page_address(store.sb_page),
 		       page_address(bitmap->storage.sb_page),
-		       sizeof(bitmap_super_t));
+		       sizeof(struct bitmap_super));
 	spin_lock_irq(&bitmap->counts.lock);
 	md_bitmap_file_unmap(&bitmap->storage);
 	bitmap->storage = store;
@@ -2859,7 +2850,7 @@ chunksize_store(struct mddev *mddev, const char *buf, size_t len)
 	    !is_power_of_2(csize))
 		return -EINVAL;
 	if (BITS_PER_LONG > 32 && csize >= (1ULL << (BITS_PER_BYTE *
-		sizeof(((bitmap_super_t *)0)->chunksize))))
+		sizeof(((struct bitmap_super *)0)->chunksize))))
 		return -EOVERFLOW;
 	mddev->bitmap_info.chunksize = csize;
 	return len;
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 31c93019c..75bbe6b84 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -7,7 +7,7 @@
 #ifndef BITMAP_H
 #define BITMAP_H 1
 
-#define BITMAP_MAGIC 0x6d746962
+#include <linux/raid/md_p.h>
 
 typedef __u16 bitmap_counter_t;
 #define COUNTER_BITS 16
@@ -18,46 +18,6 @@ typedef __u16 bitmap_counter_t;
 #define RESYNC_MASK ((bitmap_counter_t) (1 << (COUNTER_BITS - 2)))
 #define COUNTER_MAX ((bitmap_counter_t) RESYNC_MASK - 1)
 
-/* use these for bitmap->flags and bitmap->sb->state bit-fields */
-enum bitmap_state {
-	BITMAP_STALE	   = 1,  /* the bitmap file is out of date or had -EIO */
-	BITMAP_WRITE_ERROR = 2, /* A write error has occurred */
-	BITMAP_HOSTENDIAN  =15,
-};
-
-/* the superblock at the front of the bitmap file -- little endian */
-typedef struct bitmap_super_s {
-	__le32 magic;        /*  0  BITMAP_MAGIC */
-	__le32 version;      /*  4  the bitmap major for now, could change... */
-	__u8  uuid[16];      /*  8  128 bit uuid - must match md device uuid */
-	__le64 events;       /* 24  event counter for the bitmap (1)*/
-	__le64 events_cleared;/*32  event counter when last bit cleared (2) */
-	__le64 sync_size;    /* 40  the size of the md device's sync range(3) */
-	__le32 state;        /* 48  bitmap state information */
-	__le32 chunksize;    /* 52  the bitmap chunk size in bytes */
-	__le32 daemon_sleep; /* 56  seconds between disk flushes */
-	__le32 write_behind; /* 60  number of outstanding write-behind writes */
-	__le32 sectors_reserved; /* 64 number of 512-byte sectors that are
-				  * reserved for the bitmap. */
-	__le32 nodes;        /* 68 the maximum number of nodes in cluster. */
-	__u8 cluster_name[64]; /* 72 cluster name to which this md belongs */
-	__u8  pad[256 - 136]; /* set to zero */
-} bitmap_super_t;
-
-/* notes:
- * (1) This event counter is updated before the eventcounter in the md superblock
- *    When a bitmap is loaded, it is only accepted if this event counter is equal
- *    to, or one greater than, the event counter in the superblock.
- * (2) This event counter is updated when the other one is *if*and*only*if* the
- *    array is not degraded.  As bits are not cleared when the array is degraded,
- *    this represents the last time that any bits were cleared.
- *    If a device is being added that has an event count with this value or
- *    higher, it is accepted as conforming to the bitmap.
- * (3)This is the number of sectors represented by the bitmap, and is the range that
- *    resync happens across.  For raid1 and raid5/6 it is the size of individual
- *    devices.  For raid10 it is the size of the array.
- */
-
 struct md_bitmap_stats {
 	u64		events_cleared;
 	int		behind_writes;
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index ff47b6f0b..980a40376 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
 /*
    md_p.h : physical layout of Linux RAID devices
-          Copyright (C) 1996-98 Ingo Molnar, Gadi Oxman
+	Copyright (C) 1996-98 Ingo Molnar, Gadi Oxman, Peter T. Breuer
 
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -15,6 +15,11 @@
 #include <linux/types.h>
 #include <asm/byteorder.h>
 
+/*
+ * Note: use of typedefs from this header file is deprecated,
+ * please refer directly to structs when writing new code.
+ */
+
 /*
  * RAID superblock.
  *
@@ -426,4 +431,55 @@ struct ppl_header {
 	struct ppl_header_entry entries[PPL_HDR_MAX_ENTRIES];
 } __attribute__ ((__packed__));
 
+#define MD_BITMAP_SUBERBLOCK_EXPORTED 1	/* Notify that kernel provides it */
+#define BITMAP_MAGIC 0x6d746962		/* This is actually "bitm" in ASCII :-) */
+#define BITMAP_MAJOR_LO 3
+/* version 4 insists the bitmap is in little-endian order
+ * with version 3, it is host-endian which is non-portable
+ */
+#define BITMAP_MAJOR_HI 4
+#define BITMAP_MAJOR_CLUSTERED 5
+#define BITMAP_MAJOR_HOSTENDIAN 3
+
+/* use these for bitmap->flags and bitmap->sb->state bit-fields */
+enum bitmap_state {
+	BITMAP_STALE	   = 1,  /* the bitmap file is out of date or had -EIO */
+	BITMAP_WRITE_ERROR = 2, /* A write error has occurred */
+	BITMAP_HOSTENDIAN  = 15,
+};
+
+/* the superblock at the front of the bitmap file -- little endian */
+struct bitmap_super {
+	__le32 magic;        /*  0  BITMAP_MAGIC */
+	__le32 version;      /*  4  the bitmap major for now, could change... */
+	__u8  uuid[16];      /*  8  128 bit uuid - must match md device uuid */
+	__le64 events;       /* 24  event counter for the bitmap (1)*/
+	__le64 events_cleared;/*32  event counter when last bit cleared (2) */
+	__le64 sync_size;    /* 40  the size of the md device's sync range(3) */
+	__le32 state;        /* 48  bitmap state information */
+	__le32 chunksize;    /* 52  the bitmap chunk size in bytes */
+	__le32 daemon_sleep; /* 56  seconds between disk flushes */
+	__le32 write_behind; /* 60  number of outstanding write-behind writes */
+	__le32 sectors_reserved; /* 64 number of 512-byte sectors that are
+				  * reserved for the bitmap.
+				  */
+	__le32 nodes;        /* 68 the maximum number of nodes in cluster. */
+	__u8 cluster_name[64]; /* 72 cluster name to which this md belongs */
+	__u8  pad[256 - 136]; /* set to zero */
+} __attribute__ ((__packed__));
+
+/* notes:
+ * (1) This event counter is updated before the eventcounter in the md superblock
+ *    When a bitmap is loaded, it is only accepted if this event counter is equal
+ *    to, or one greater than, the event counter in the superblock.
+ * (2) This event counter is updated when the other one is *if*and*only*if* the
+ *    array is not degraded.  As bits are not cleared when the array is degraded,
+ *    this represents the last time that any bits were cleared.
+ *    If a device is being added that has an event count with this value or
+ *    higher, it is accepted as conforming to the bitmap.
+ * (3)This is the number of sectors represented by the bitmap, and is the range that
+ *    resync happens across.  For raid1 and raid5/6 it is the size of individual
+ *    devices.  For raid10 it is the size of the array.
+ */
+
 #endif
-- 
2.48.1

