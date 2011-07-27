From: NeilBrown <neilb@suse.de>
Subject: Using the new bad-block-log in md for Linux 3.1
Date: Wed, 27 Jul 2011 14:16:52 +1000
Message-ID: <20110727141652.7511fc51@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


As mentioned earlier, Linux 3.1 will contain support for recording and
avoiding bad blocks on devices in md arrays.

These patches are currently in -next and I expect to send them to Linus
tomorrow.

Using this funcitonality requires support in mdadm.  When an array is created
some space needs to be reserved to store the bad block list.

I have just created an mdadm branch called devel-3.3 which provides initial
functionality.  The main patch is included inline below.

This only supports creating new arrays with badblock support.  It also only
supports 1.x metadata.

I hope to add support to add a bad block list to an existing 1.x array at
some stage, but support for 0.90 metadata is not expected to ever be added.

If you create an array with this mdadm it will add a bad block log - you
cannot turn it off (it is only 4K long so why would you want to).  Then as
errors occur they will cause the faulty block to be added to the log rather
than the device to be remove from the array.
If writing the new bad block list fails, then the device as a whole will fail.

I would very much appreciate any reports of success of failure when using
this new feature.  If you can make a test array using a known-faulty device
and can experiment with that I would particularly like to hear about any
experiences.

Thanks,
NeilBrown

 git://neil.brown.name/mdadm devel-3.3

http://neil.brown.name/git?p=mdadm;a=shortlog;h=refs/heads/devel-3.3



From f727829c300f5fd56306e5ed5708a55d28fe228e Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 27 Jul 2011 14:08:10 +1000
Subject: [PATCH] Bad block log


diff --git a/super1.c b/super1.c
index 09be351..f911593 100644
--- a/super1.c
+++ b/super1.c
@@ -70,7 +70,12 @@ struct mdp_superblock_1 {
 	__u8	device_uuid[16]; /* user-space setable, ignored by kernel */
         __u8    devflags;        /* per-device flags.  Only one defined...*/
 #define WriteMostly1    1        /* mask for writemostly flag in above */
-	__u8	pad2[64-57];	/* set to 0 when writing */
+	/* bad block log.  If there are any bad blocks the feature flag is set.
+	 * if offset and size are non-zero, that space is reserved and available.
+	 */
+	__u8	bblog_shift;	/* shift from sectors to block size for badblocklist */
+	__u16	bblog_size;	/* number of sectors reserved for badblocklist */
+	__u32	bblog_offset;	/* sector offset from superblock to bblog, signed */
 
 	/* array state information - 64 bytes */
 	__u64	utime;		/* 40 bits second, 24 btes microseconds */
@@ -99,8 +104,9 @@ struct misc_dev_info {
 					   * must be honoured
 					   */
 #define	MD_FEATURE_RESHAPE_ACTIVE	4
+#define	MD_FEATURE_BAD_BLOCKS		8 /* badblock list is not empty */
 
-#define	MD_FEATURE_ALL			(1|2|4)
+#define	MD_FEATURE_ALL			(1|2|4|8)
 
 #ifndef offsetof
 #define offsetof(t,f) ((size_t)&(((t*)0)->f))
@@ -278,7 +284,7 @@ static void examine_super1(struct supertype *st, char *homehost)
 		printf("Internal Bitmap : %ld sectors from superblock\n",
 		       (long)(int32_t)__le32_to_cpu(sb->bitmap_offset));
 	}
-	if (sb->feature_map & __le32_to_cpu(MD_FEATURE_RESHAPE_ACTIVE)) {
+	if (sb->feature_map & __cpu_to_le32(MD_FEATURE_RESHAPE_ACTIVE)) {
 		printf("  Reshape pos'n : %llu%s\n", (unsigned long long)__le64_to_cpu(sb->reshape_position)/2,
 		       human_size(__le64_to_cpu(sb->reshape_position)<<9));
 		if (__le32_to_cpu(sb->delta_disks)) {
@@ -322,6 +328,17 @@ static void examine_super1(struct supertype *st, char *homehost)
 	atime = __le64_to_cpu(sb->utime) & 0xFFFFFFFFFFULL;
 	printf("    Update Time : %.24s\n", ctime(&atime));
 
+	if (sb->bblog_size && sb->bblog_offset) {
+		printf("  Bad Block Log : %d entries available at offset %ld sectors",
+		       __le16_to_cpu(sb->bblog_size)*512/8,
+		       (long)__le32_to_cpu(sb->bblog_offset));
+		if (sb->feature_map &
+		    __cpu_to_le32(MD_FEATURE_BAD_BLOCKS))
+			printf(" - bad blocks present.");
+		printf("\n");
+	}
+
+
 	if (calc_sb_1_csum(sb) == sb->sb_csum)
 		printf("       Checksum : %x - correct\n", __le32_to_cpu(sb->sb_csum));
 	else
@@ -1105,10 +1122,12 @@ static int write_init_super1(struct supertype *st)
 		 * 2: 4K from start of device.
 		 * Depending on the array size, we might leave extra space
 		 * for a bitmap.
+		 * Also leave 4K for bad-block log.
 		 */
 		array_size = __le64_to_cpu(sb->size);
-		/* work out how much space we left for a bitmap */
-		bm_space = choose_bm_space(array_size);
+		/* work out how much space we left for a bitmap,
+		 * Add 8 sectors for bad block log */
+		bm_space = choose_bm_space(array_size) + 8;
 
 		switch(st->minor_version) {
 		case 0:
@@ -1120,6 +1139,10 @@ static int write_init_super1(struct supertype *st)
 			if (sb_offset < array_size + bm_space)
 				bm_space = sb_offset - array_size;
 			sb->data_size = __cpu_to_le64(sb_offset - bm_space);
+			if (bm_space >= 8) {
+				sb->bblog_size = __cpu_to_le16(8);
+				sb->bblog_offset = __cpu_to_le32((unsigned)-8);
+			}
 			break;
 		case 1:
 			sb->super_offset = __cpu_to_le64(0);
@@ -1134,6 +1157,10 @@ static int write_init_super1(struct supertype *st)
 
 			sb->data_offset = __cpu_to_le64(reserved);
 			sb->data_size = __cpu_to_le64(dsize - reserved);
+			if (reserved >= 16) {
+				sb->bblog_size = __cpu_to_le16(8);
+				sb->bblog_offset = __cpu_to_le32(reserved-8);
+			}
 			break;
 		case 2:
 			sb_offset = 4*2;
@@ -1154,6 +1181,10 @@ static int write_init_super1(struct supertype *st)
 
 			sb->data_offset = __cpu_to_le64(reserved);
 			sb->data_size = __cpu_to_le64(dsize - reserved);
+			if (reserved >= 16+16) {
+				sb->bblog_size = __cpu_to_le16(8);
+				sb->bblog_offset = __cpu_to_le32(reserved-8-8);
+			}
 			break;
 		default:
 			return -EINVAL;
