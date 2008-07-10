From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 5/5] md: Remove some unused macros.
Date: Thu, 10 Jul 2008 11:15:38 +0200
Message-ID: <1215681338-32365-6-git-send-email-maan@systemlinux.org>
References: <1215681338-32365-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1215681338-32365-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids


Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 include/linux/raid/md_p.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/raid/md_p.h b/include/linux/raid/md_p.h
index 3f2cd98..8b4de4a 100644
--- a/include/linux/raid/md_p.h
+++ b/include/linux/raid/md_p.h
@@ -43,14 +43,11 @@
  */
 #define MD_RESERVED_BYTES		(64 * 1024)
 #define MD_RESERVED_SECTORS		(MD_RESERVED_BYTES / 512)
-#define MD_RESERVED_BLOCKS		(MD_RESERVED_BYTES / BLOCK_SIZE)
 
 #define MD_NEW_SIZE_SECTORS(x)		((x & ~(MD_RESERVED_SECTORS - 1)) - MD_RESERVED_SECTORS)
-#define MD_NEW_SIZE_BLOCKS(x)		((x & ~(MD_RESERVED_BLOCKS - 1)) - MD_RESERVED_BLOCKS)
 
 #define MD_SB_BYTES			4096
 #define MD_SB_WORDS			(MD_SB_BYTES / 4)
-#define MD_SB_BLOCKS			(MD_SB_BYTES / BLOCK_SIZE)
 #define MD_SB_SECTORS			(MD_SB_BYTES / 512)
 
 /*
-- 
1.5.3.8

