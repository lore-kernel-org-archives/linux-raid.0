Received: from harvie.cz (harvie.cz [77.87.242.242])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC7AD24B26;
	Tue, 31 Dec 2024 03:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.87.242.242
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735614878; cv=none; b=fpmt9635XKpcjKI+CnV/BreVa8Z2gRR0K4o8P7tpuDli0ZYniMvCTWhDGmmW2Eap6SWJcaefW7ESQe+vPPLblDDnpPuluP1g/FgrxnH3rjvNnAQGQ182ulV7m1nveDItn6V2QCkCR6cmuekiCW6+ftNQSihYjiBShh8W3WJtVz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735614878; c=relaxed/simple;
	bh=bmjSR1cJfEl/Buq4+MioWMy4H5lyDi/ksDKKIaRbIkc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NWEpXoyOgE/9gRX9EozHTu9QQtYokKjKWs0cI1TvIhi4nox5gaDI7TB6PrDBgJ9oVcZSgjnhpFUa/V9jxPBC7OgfIEiDVbtFJ8JI2dI2wY0W1gg4kjIs/oqVTgJn+WOduCD2mqJH9MxSLXBha54/xZoMkbZ2Qa5onWfmZwG8oBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=fail smtp.mailfrom=gmail.com; arc=none smtp.client-ip=77.87.242.242
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=gmail.com
Received: from localhost.localdomain (109-81-92-153.rct.o2.cz [109.81.92.153])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by harvie.cz (Postfix) with ESMTPSA id 8EBC31800D4;
	Tue, 31 Dec 2024 04:09:38 +0100 (CET)
From: Tomas Mudrunka <tomas.mudrunka@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: Tomas Mudrunka <tomas.mudrunka@gmail.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Export MDRAID bitmap on disk structure in UAPI header file
Date: Tue, 31 Dec 2024 04:09:27 +0100
Message-ID: <20241231030929.246059-1-tomas.mudrunka@gmail.com>
X-Mailer: git-send-email 2.47.1
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
 drivers/md/md-bitmap.h         | 42 +-------------------------------
 include/uapi/linux/raid/md_p.h | 44 +++++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 42 deletions(-)

diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 662e6fc14..6050d422b 100644
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
index 5a43c23f5..8131e7713 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
 /*
    md_p.h : physical layout of Linux RAID devices
-          Copyright (C) 1996-98 Ingo Molnar, Gadi Oxman
+          Copyright (C) 1996-98 Ingo Molnar, Gadi Oxman, Peter T. Breuer
 
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -426,4 +426,46 @@ struct ppl_header {
 	struct ppl_header_entry entries[PPL_HDR_MAX_ENTRIES];
 } __attribute__ ((__packed__));
 
+#define BITMAP_MAGIC 0x6d746962
+
+/* use these for bitmap->flags and bitmap->sb->state bit-fields */
+enum bitmap_state {
+	BITMAP_STALE	   = 1,  /* the bitmap file is out of date or had -EIO */
+	BITMAP_WRITE_ERROR = 2, /* A write error has occurred */
+	BITMAP_HOSTENDIAN  =15,
+};
+
+/* the superblock at the front of the bitmap file -- little endian */
+typedef struct bitmap_super_s {
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
+				  * reserved for the bitmap. */
+	__le32 nodes;        /* 68 the maximum number of nodes in cluster. */
+	__u8 cluster_name[64]; /* 72 cluster name to which this md belongs */
+	__u8  pad[256 - 136]; /* set to zero */
+} bitmap_super_t;
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
2.47.1

