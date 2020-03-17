From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH] imsm: support the Array Creation Time field in metadata
Date: Tue, 17 Mar 2020 10:20:12 +0100
Message-ID: <20200317092012.7093-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Also present its value in --examine and --examine --export.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 super-intel.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index c9a1af5b..533becb2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -260,8 +260,9 @@ struct imsm_super {
 					 * (starts at 1)
 					 */
 	__u16 filler1;			/* 0x4E - 0x4F */
-#define IMSM_FILLERS 34
-	__u32 filler[IMSM_FILLERS];	/* 0x50 - 0xD7 RAID_MPB_FILLERS */
+	__u64 creation_time;		/* 0x50 - 0x57 Array creation time */
+#define IMSM_FILLERS 32
+	__u32 filler[IMSM_FILLERS];	/* 0x58 - 0xD7 RAID_MPB_FILLERS */
 	struct imsm_disk disk[1];	/* 0xD8 diskTbl[numDisks] */
 	/* here comes imsm_dev[num_raid_devs] */
 	/* here comes BBM logs */
@@ -2014,6 +2015,7 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 	__u32 sum;
 	__u32 reserved = imsm_reserved_sectors(super, super->disks);
 	struct dl *dl;
+	time_t creation_time;
 
 	strncpy(str, (char *)mpb->sig, MPB_SIG_LEN);
 	str[MPB_SIG_LEN-1] = '\0';
@@ -2022,6 +2024,9 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 	printf("    Orig Family : %08x\n", __le32_to_cpu(mpb->orig_family_num));
 	printf("         Family : %08x\n", __le32_to_cpu(mpb->family_num));
 	printf("     Generation : %08x\n", __le32_to_cpu(mpb->generation_num));
+	creation_time = __le64_to_cpu(mpb->creation_time);
+	printf("  Creation Time : %.24s\n",
+		creation_time ? ctime(&creation_time) : "Unknown");
 	printf("     Attributes : ");
 	if (imsm_check_attributes(mpb->attributes))
 		printf("All supported\n");
@@ -2126,6 +2131,7 @@ static void export_examine_super_imsm(struct supertype *st)
 	printf("MD_LEVEL=container\n");
 	printf("MD_UUID=%s\n", nbuf+5);
 	printf("MD_DEVICES=%u\n", mpb->num_disks);
+	printf("MD_CREATION_TIME=%llu\n", __le64_to_cpu(mpb->creation_time));
 }
 
 static void detail_super_imsm(struct supertype *st, char *homehost,
@@ -5762,6 +5768,7 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 		sum += __gen_imsm_checksum(mpb);
 		mpb->family_num = __cpu_to_le32(sum);
 		mpb->orig_family_num = mpb->family_num;
+		mpb->creation_time = __cpu_to_le64((__u64)time(NULL));
 	}
 	super->current_disk = dl;
 	return 0;
-- 
2.24.0
