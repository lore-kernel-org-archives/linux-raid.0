From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 3/3] mdadm: fixes some trivial typos in comments
Date: Tue,  5 Sep 2017 17:41:38 +0800
Message-ID: <1504604498-26048-4-git-send-email-zlliu@suse.com>
References: <1504604498-26048-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1504604498-26048-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

fix some trivial typos in comments.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 ReadMe.c | 2 +-
 super1.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/ReadMe.c b/ReadMe.c
index eb8fb4b..4d871e9 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -342,7 +342,7 @@ char OptionHelp[] =
 */
 
 char Help_create[] =
-"Usage:  mdadm --create device -chunk=X --level=Y --raid-devices=Z devices\n"
+"Usage:  mdadm --create device --chunk=X --level=Y --raid-devices=Z devices\n"
 "\n"
 " This usage will initialise a new md array, associate some\n"
 " devices with it, and activate the array.   In order to create an\n"
diff --git a/super1.c b/super1.c
index f6a1045..3cfbbc0 100644
--- a/super1.c
+++ b/super1.c
@@ -89,12 +89,12 @@ struct mdp_superblock_1 {
 	/* bad block log.  If there are any bad blocks the feature flag is set.
 	 * if offset and size are non-zero, that space is reserved and available.
 	 */
-	__u8	bblog_shift;	/* shift from sectors to block size for badblocklist */
-	__u16	bblog_size;	/* number of sectors reserved for badblocklist */
+	__u8	bblog_shift;	/* shift from sectors to block size for badblock list */
+	__u16	bblog_size;	/* number of sectors reserved for badblock list */
 	__u32	bblog_offset;	/* sector offset from superblock to bblog, signed */
 
 	/* array state information - 64 bytes */
-	__u64	utime;		/* 40 bits second, 24 btes microseconds */
+	__u64	utime;		/* 40 bits second, 24 bits microseconds */
 	__u64	events;		/* incremented when superblock updated */
 	__u64	resync_offset;	/* data before this offset (from data_offset) known to be in sync */
 	__u32	sb_csum;	/* checksum upto dev_roles[max_dev] */
@@ -2396,7 +2396,7 @@ add_internal_bitmap1(struct supertype *st,
 	/*
 	 * If not may_change, then this is a 'Grow' without sysfs support for
 	 * bitmaps, and the bitmap must fit after the superblock at 1K offset.
-	 * If may_change, then this is create or a Grow with sysfs syupport,
+	 * If may_change, then this is create or a Grow with sysfs support,
 	 * and we can put the bitmap wherever we like.
 	 *
 	 * size is in sectors,  chunk is in bytes !!!
-- 
2.6.6

