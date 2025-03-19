Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A2E54F8C
	for <linux-raid@vger.kernel.org>; Wed, 19 Mar 2025 17:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742404273; cv=none; b=YRnB8naJp232EEZZO9TKulB9aw6SJ0a4l1QH+EACdVF36CmiTaYtJg4oDsgVeEcODtGl/qxZmE0j9uQeorPXJuDfl9AQ8QTLWknhd97mnoaduvbE2myhsAeR7EasXuYiVrGQ99Zwx11/Ctw9tlzPYCFCfsAvGhQ9nmNAlJni0l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742404273; c=relaxed/simple;
	bh=6iXixONznw9M2Yv8UTBFLHEJ3HQmuHYWxIFLKnfZiq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5Gm4A8dQ/0Q9xYZr+eCyN01RdgcWqmfk34XiOSEiUNMhpGZOGkzzqNudePxmRLXYD7cfg8YxwtSxiXG4md+tRuYRAq8YyJCOD+vjUN68gF5AxwqjgIWGIUm1XKGbp5Sz892Xqo02YgYdfVtCSSPlR+5ahfziqARn5km+39ri6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gQNc/5s0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQNc/5s0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30733C4CEE9;
	Wed, 19 Mar 2025 17:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742404272;
	bh=6iXixONznw9M2Yv8UTBFLHEJ3HQmuHYWxIFLKnfZiq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQNc/5s0Au+7elLg8B9L93RspGN0E3V40bBCte1gqGMZpfBfkj7i9IwY8CuDNW/X1
	 GsU0mXohoH+ivZ+/vMF8FwiyBmFZFtU/Ku0fzwp+GbZfXSkLXzZ1AfvT/OJ6uC3O5/
	 qA7+SBAZU3YVbTW3mthPbGI7A9EZKXqDqHt1S6nfEdjZdDYwtseOkfb0QfY0avBv3d
	 0SF6neQ4vX3CpJzggcsyo/EmNMza8Mio2qWLq7J6HVNYvf2qhAvuKpgGm8wvL9MxGG
	 YkcmCFcX+O1lcKCyJNI7z+QjL7qDxALO9NVyrXMNFUG/NnRTpPAwh2D3CaqS/whTMs
	 3FfcU9eF2IF3A==
From: mtkaczyk@kernel.org
To: linux-raid@vger.kernel.org
Cc: Mariusz Tkaczyk <mtkaczyk@kernel.org>,
	Xiao Ni <xni@redhat.com>,
	Nigel Croxon <ncroxon@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@kernel.org>
Subject: [PATCH v0 3/3] mdadm: use kernel raid headers
Date: Wed, 19 Mar 2025 18:10:58 +0100
Message-ID: <20250319171058.20052-4-mtkaczyk@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250319171058.20052-1-mtkaczyk@kernel.org>
References: <20250319171058.20052-1-mtkaczyk@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mariusz Tkaczyk <mtkaczyk@kernel.org>

For a years we redefined these headers in mdadm. We should reuse headers
exported by kernel to integrate driver and mdadm better.
Include them and remove mdadm owned headers.

There are 3 defines not available in kernel headers, so define them
directly but put them in ifndef guard to make them transparent later.

Use MD_FEATURE_CLUSTERED instead of MD_FEATURE_BITMAP_VERSIONED. The
value is same, kernel define has different name.

Signed-off-by: Mariusz Tkaczyk <mtkaczyk@kernel.org>
---
 Create.c    |   2 -
 Detail.c    |   2 -
 Examine.c   |   2 -
 Grow.c      |   6 ---
 Kill.c      |   2 -
 Manage.c    |   2 -
 Query.c     |   2 -
 mdadm.h     |  16 ++++++-
 mdmonitor.c |   2 -
 super1.c    | 126 ++--------------------------------------------------
 udev.c      |   2 -
 11 files changed, 17 insertions(+), 147 deletions(-)

diff --git a/Create.c b/Create.c
index fd6c92152021..4d5c15531df1 100644
--- a/Create.c
+++ b/Create.c
@@ -23,8 +23,6 @@
  */
 
 #include	"mdadm.h"
-#include	"md_u.h"
-#include	"md_p.h"
 #include	"udev.h"
 #include	"xmalloc.h"
 
diff --git a/Detail.c b/Detail.c
index b804a624574c..3802ef8fa6fc 100644
--- a/Detail.c
+++ b/Detail.c
@@ -23,8 +23,6 @@
  */
 
 #include	"mdadm.h"
-#include	"md_p.h"
-#include	"md_u.h"
 #include	"xmalloc.h"
 
 #include	<ctype.h>
diff --git a/Examine.c b/Examine.c
index 036b7a5634ad..9c8564be90d4 100644
--- a/Examine.c
+++ b/Examine.c
@@ -24,8 +24,6 @@
 
 #include	"dlink.h"
 #include	"mdadm.h"
-#include	"md_u.h"
-#include	"md_p.h"
 #include	"xmalloc.h"
 
 #if ! defined(__BIG_ENDIAN) && ! defined(__LITTLE_ENDIAN)
diff --git a/Grow.c b/Grow.c
index 53b0b3876b26..30eaa3c6a654 100644
--- a/Grow.c
+++ b/Grow.c
@@ -30,12 +30,6 @@
 #include	<stdint.h>
 #include	<sys/wait.h>
 
-#if ! defined(__BIG_ENDIAN) && ! defined(__LITTLE_ENDIAN)
-#error no endian defined
-#endif
-#include	"md_u.h"
-#include	"md_p.h"
-
 int restore_backup(struct supertype *st,
 		   struct mdinfo *content,
 		   int working_disks,
diff --git a/Kill.c b/Kill.c
index 43c9abed3b42..9f05a1ace8e1 100644
--- a/Kill.c
+++ b/Kill.c
@@ -26,8 +26,6 @@
  */
 
 #include	"mdadm.h"
-#include	"md_u.h"
-#include	"md_p.h"
 
 int Kill(char *dev, struct supertype *st, int force, int verbose, int noexcl)
 {
diff --git a/Manage.c b/Manage.c
index 034eb00c7f7d..22b1f52b7dc7 100644
--- a/Manage.c
+++ b/Manage.c
@@ -23,8 +23,6 @@
  */
 
 #include "mdadm.h"
-#include "md_u.h"
-#include "md_p.h"
 #include "udev.h"
 #include "xmalloc.h"
 
diff --git a/Query.c b/Query.c
index aedb4ce77d83..72f49a4e6e54 100644
--- a/Query.c
+++ b/Query.c
@@ -23,8 +23,6 @@
  */
 
 #include	"mdadm.h"
-#include	"md_p.h"
-#include	"md_u.h"
 
 int Query(char *dev)
 {
diff --git a/mdadm.h b/mdadm.h
index d2c2a4dac11b..a34a3ec2c472 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -163,8 +163,20 @@ struct dlm_lksb {
 #define GROW_SERVICE "mdadm-grow-continue"
 #endif /* GROW_SERVICE */
 
-#include	"md_u.h"
-#include	"md_p.h"
+#include	<linux/raid/md_u.h>
+#include	<linux/raid/md_p.h>
+
+/* These defines might be missing in raid headers*/
+#ifndef MD_SB_BLOCK_CONTAINER_RESHAPE
+#define MD_SB_BLOCK_CONTAINER_RESHAPE	3
+#endif
+#ifndef MD_SB_BLOCK_VOLUME
+#define MD_SB_BLOCK_VOLUME		4
+#endif
+#ifndef MD_DISK_REPLACEMENT
+#define MD_DISK_REPLACEMENT		17
+#endif
+
 #include	"bitmap.h"
 #include	"msg.h"
 #include	"mdadm_status.h"
diff --git a/mdmonitor.c b/mdmonitor.c
index d1cfbf947191..d51617cd0981 100644
--- a/mdmonitor.c
+++ b/mdmonitor.c
@@ -23,8 +23,6 @@
  */
 
 #include	"mdadm.h"
-#include	"md_p.h"
-#include	"md_u.h"
 #include	"udev.h"
 #include	"xmalloc.h"
 
diff --git a/super1.c b/super1.c
index fe3c4c64c66b..0db2544f18f4 100644
--- a/super1.c
+++ b/super1.c
@@ -26,92 +26,6 @@
 #include "mdadm.h"
 #include "xmalloc.h"
 
-/*
- * The version-1 superblock :
- * All numeric fields are little-endian.
- *
- * total size: 256 bytes plus 2 per device.
- *  1K allows 384 devices.
- */
-struct mdp_superblock_1 {
-	/* constant array information - 128 bytes */
-	__u32	magic;		/* MD_SB_MAGIC: 0xa92b4efc - little endian */
-	__u32	major_version;	/* 1 */
-	__u32	feature_map;	/* 0 for now */
-	__u32	pad0;		/* always set to 0 when writing */
-
-	__u8	set_uuid[16];	/* user-space generated. */
-	char	set_name[32];	/* set and interpreted by user-space */
-
-	__u64	ctime;		/* lo 40 bits are seconds, top 24 are microseconds or 0*/
-	__u32	level;		/* -4 (multipath), -1 (linear), 0,1,4,5 */
-	__u32	layout;		/* used for raid5, raid6, raid10, and raid0 */
-	__u64	size;		/* used size of component devices, in 512byte sectors */
-
-	__u32	chunksize;	/* in 512byte sectors */
-	__u32	raid_disks;
-	union {
-		__u32	bitmap_offset;	/* sectors after start of superblock that bitmap starts
-					 * NOTE: signed, so bitmap can be before superblock
-					 * only meaningful of feature_map[0] is set.
-					 */
-
-		/* only meaningful when feature_map[MD_FEATURE_PPL] is set */
-		struct {
-			__s16 offset; /* sectors from start of superblock that ppl starts */
-			__u16 size; /* ppl size in sectors */
-		} ppl;
-	};
-
-	/* These are only valid with feature bit '4' */
-	__u32	new_level;	/* new level we are reshaping to		*/
-	__u64	reshape_position;	/* next address in array-space for reshape */
-	__u32	delta_disks;	/* change in number of raid_disks		*/
-	__u32	new_layout;	/* new layout					*/
-	__u32	new_chunk;	/* new chunk size (sectors)			*/
-	__u32	new_offset;	/* signed number to add to data_offset in new
-				 * layout.  0 == no-change.  This can be
-				 * different on each device in the array.
-				 */
-
-	/* constant this-device information - 64 bytes */
-	__u64	data_offset;	/* sector start of data, often 0 */
-	__u64	data_size;	/* sectors in this device that can be used for data */
-	__u64	super_offset;	/* sector start of this superblock */
-	union {
-		__u64	recovery_offset;/* sectors before this offset (from data_offset) have been recovered */
-		__u64	journal_tail;/* journal tail of journal device (from data_offset) */
-	};
-	__u32	dev_number;	/* permanent identifier of this  device - not role in raid */
-	__u32	cnt_corrected_read; /* number of read errors that were corrected by re-writing */
-	__u8	device_uuid[16]; /* user-space setable, ignored by kernel */
-	__u8    devflags;        /* per-device flags.  Only one defined...*/
-#define WriteMostly1    1        /* mask for writemostly flag in above */
-#define FailFast1	2        /* Device should get FailFast requests */
-	/* bad block log.  If there are any bad blocks the feature flag is set.
-	 * if offset and size are non-zero, that space is reserved and available.
-	 */
-	__u8	bblog_shift;	/* shift from sectors to block size for badblock list */
-	__u16	bblog_size;	/* number of sectors reserved for badblock list */
-	__u32	bblog_offset;	/* sector offset from superblock to bblog, signed */
-
-	/* array state information - 64 bytes */
-	__u64	utime;		/* 40 bits second, 24 bits microseconds */
-	__u64	events;		/* incremented when superblock updated */
-	__u64	resync_offset;	/* data before this offset (from data_offset) known to be in sync */
-	__u32	sb_csum;	/* checksum upto dev_roles[max_dev] */
-	__u32	max_dev;	/* size of dev_roles[] array to consider */
-	__u8	pad3[64-32];	/* set to 0 when writing */
-
-	/* device state information. Indexed by dev_number.
-	 * 2 bytes per device
-	 * Note there are no per-device state flags. State information is rolled
-	 * into the 'roles' value.  If a device is spare or faulty, then it doesn't
-	 * have a meaningful role.
-	 */
-	__u16	dev_roles[0];	/* role in array, or 0xffff for a spare, or 0xfffe for faulty */
-};
-
 #define MAX_SB_SIZE 4096
 /* bitmap super size is 256, but we round up to a sector for alignment */
 #define BM_SUPER_SIZE 512
@@ -126,40 +40,6 @@ struct misc_dev_info {
 #define MULTIPLE_PPL_AREA_SIZE_SUPER1 (1024 * 1024) /* Size of the whole
 						     * mutliple PPL area
 						     */
-/* feature_map bits */
-#define MD_FEATURE_BITMAP_OFFSET	1
-#define	MD_FEATURE_RECOVERY_OFFSET	2 /* recovery_offset is present and
-					   * must be honoured
-					   */
-#define	MD_FEATURE_RESHAPE_ACTIVE	4
-#define	MD_FEATURE_BAD_BLOCKS		8 /* badblock list is not empty */
-#define	MD_FEATURE_REPLACEMENT		16 /* This device is replacing an
-					    * active device with same 'role'.
-					    * 'recovery_offset' is also set.
-					    */
-#define	MD_FEATURE_RESHAPE_BACKWARDS	32 /* Reshape doesn't change number
-					    * of devices, but is going
-					    * backwards anyway.
-					    */
-#define	MD_FEATURE_NEW_OFFSET		64 /* new_offset must be honoured */
-#define	MD_FEATURE_BITMAP_VERSIONED	256 /* bitmap version number checked properly */
-#define	MD_FEATURE_JOURNAL		512 /* support write journal */
-#define	MD_FEATURE_PPL			1024 /* support PPL */
-#define	MD_FEATURE_MUTLIPLE_PPLS	2048 /* support for multiple PPLs */
-#define	MD_FEATURE_RAID0_LAYOUT		4096 /* layout is meaningful in RAID0 */
-#define	MD_FEATURE_ALL			(MD_FEATURE_BITMAP_OFFSET	\
-					|MD_FEATURE_RECOVERY_OFFSET	\
-					|MD_FEATURE_RESHAPE_ACTIVE	\
-					|MD_FEATURE_BAD_BLOCKS		\
-					|MD_FEATURE_REPLACEMENT		\
-					|MD_FEATURE_RESHAPE_BACKWARDS	\
-					|MD_FEATURE_NEW_OFFSET		\
-					|MD_FEATURE_BITMAP_VERSIONED	\
-					|MD_FEATURE_JOURNAL		\
-					|MD_FEATURE_PPL			\
-					|MD_FEATURE_MULTIPLE_PPLS	\
-					|MD_FEATURE_RAID0_LAYOUT	\
-					)
 
 static int role_from_sb(struct mdp_superblock_1 *sb)
 {
@@ -319,7 +199,7 @@ static int awrite(struct align_fd *afd, void *buf, int len)
 static inline unsigned int md_feature_any_ppl_on(__u32 feature_map)
 {
 	return ((__cpu_to_le32(feature_map) &
-	    (MD_FEATURE_PPL | MD_FEATURE_MUTLIPLE_PPLS)));
+	    (MD_FEATURE_PPL | MD_FEATURE_MULTIPLE_PPLS)));
 }
 
 static inline unsigned int choose_ppl_space(int chunk)
@@ -1483,7 +1363,7 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 	}
 	case UOPT_NO_PPL:
 		sb->feature_map &= ~__cpu_to_le32(MD_FEATURE_PPL |
-						   MD_FEATURE_MUTLIPLE_PPLS);
+						  MD_FEATURE_MULTIPLE_PPLS);
 		break;
 	case UOPT_DEVICESIZE:
 		if (__le64_to_cpu(sb->super_offset) >=
@@ -2643,7 +2523,7 @@ add_internal_bitmap1(struct supertype *st,
 	bms->nodes = __cpu_to_le32(st->nodes);
 	if (st->nodes)
 		sb->feature_map = __cpu_to_le32(__le32_to_cpu(sb->feature_map) |
-						MD_FEATURE_BITMAP_VERSIONED);
+						MD_FEATURE_CLUSTERED);
 	if (st->cluster_name) {
 		len = sizeof(bms->cluster_name);
 		strncpy((char *)bms->cluster_name, st->cluster_name, len);
diff --git a/udev.c b/udev.c
index 88a997818115..961ca970d460 100644
--- a/udev.c
+++ b/udev.c
@@ -20,8 +20,6 @@
 
 #include	"mdadm.h"
 #include	"udev.h"
-#include	"md_p.h"
-#include	"md_u.h"
 #include	"xmalloc.h"
 
 #include	<sys/wait.h>
-- 
2.43.0

