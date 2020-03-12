From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/21] block: remove block/partitions/karma.h
Date: Thu, 12 Mar 2020 16:19:31 +0100
Message-ID: <20200312151939.645254-14-hch@lst.de>
References: <20200312151939.645254-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200312151939.645254-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org
List-Id: linux-raid.ids

Just move the single define to block/partitions/karma.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/partitions/karma.c | 3 ++-
 block/partitions/karma.h | 6 ------
 2 files changed, 2 insertions(+), 7 deletions(-)
 delete mode 100644 block/partitions/karma.h

diff --git a/block/partitions/karma.c b/block/partitions/karma.c
index 59812d705c3d..4d93512f4bd4 100644
--- a/block/partitions/karma.c
+++ b/block/partitions/karma.c
@@ -8,9 +8,10 @@
  */
 
 #include "check.h"
-#include "karma.h"
 #include <linux/compiler.h>
 
+#define KARMA_LABEL_MAGIC		0xAB56
+
 int karma_partition(struct parsed_partitions *state)
 {
 	int i;
diff --git a/block/partitions/karma.h b/block/partitions/karma.h
deleted file mode 100644
index 1b5eec57ee0c..000000000000
--- a/block/partitions/karma.h
+++ /dev/null
@@ -1,6 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- *  fs/partitions/karma.h
- */
-
-#define KARMA_LABEL_MAGIC		0xAB56
-- 
2.24.1
