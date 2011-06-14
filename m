From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH] imsm: Metadata Attributes compatibility support
Date: Tue, 14 Jun 2011 15:59:18 +0200
Message-ID: <20110614135918.4994.26622.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Adam Kwolek <adam.kwolek@intel.com>

IMSM's meta data contains Attributes field that contains information about
supported features.
To assembly an array mdadm has to support all features specified by attributes.

The patch introduces new attributes support and validation of the attribuses
during an array assembly.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |  146 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 137 insertions(+), 9 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 3b4010d..e3e21e6 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -41,15 +41,47 @@
 #define MAX_SIGNATURE_LENGTH  32
 #define MAX_RAID_SERIAL_LEN   16
 
-#define MPB_ATTRIB_CHECKSUM_VERIFY __cpu_to_le32(0x80000000)
-#define MPB_ATTRIB_PM      __cpu_to_le32(0x40000000)
-#define MPB_ATTRIB_2TB     __cpu_to_le32(0x20000000)
-#define MPB_ATTRIB_RAID0   __cpu_to_le32(0x00000001)
-#define MPB_ATTRIB_RAID1   __cpu_to_le32(0x00000002)
-#define MPB_ATTRIB_RAID10  __cpu_to_le32(0x00000004)
-#define MPB_ATTRIB_RAID1E  __cpu_to_le32(0x00000008)
-#define MPB_ATTRIB_RAID5   __cpu_to_le32(0x00000010)
-#define MPB_ATTRIB_RAIDCNG __cpu_to_le32(0x00000020)
+/* supports RAID0 */
+#define MPB_ATTRIB_RAID0		__cpu_to_le32(0x00000001)
+/* supports RAID1 */
+#define MPB_ATTRIB_RAID1		__cpu_to_le32(0x00000002)
+/* supports RAID10 */
+#define MPB_ATTRIB_RAID10		__cpu_to_le32(0x00000004)
+/* supports RAID1E */
+#define MPB_ATTRIB_RAID1E		__cpu_to_le32(0x00000008)
+/* supports RAID5 */
+#define MPB_ATTRIB_RAID5		__cpu_to_le32(0x00000010)
+/* supports RAID CNG */
+#define MPB_ATTRIB_RAIDCNG		__cpu_to_le32(0x00000020)
+/* supports expanded stripe sizes of  256K, 512K and 1MB */
+#define MPB_ATTRIB_EXP_STRIPE_SIZE	__cpu_to_le32(0x00000040)
+
+/* The OROM Support RST Caching of Volumes */
+#define MPB_ATTRIB_NVM			__cpu_to_le32(0x02000000)
+/* The OROM supports creating disks greater than 2TB */
+#define MPB_ATTRIB_2TB_DISK		__cpu_to_le32(0x04000000)
+/* The OROM supports Bad Block Management */
+#define MPB_ATTRIB_BBM			__cpu_to_le32(0x08000000)
+
+/* THe OROM Supports NVM Caching of Volumes */
+#define MPB_ATTRIB_NEVER_USE2           __cpu_to_le32(0x10000000)
+/* The OROM supports creating volumes greater than 2TB */
+#define MPB_ATTRIB_2TB			__cpu_to_le32(0x20000000)
+/* originally for PMP, now it's wasted b/c. Never use this bit! */
+#define MPB_ATTRIB_NEVER_USE		__cpu_to_le32(0x40000000)
+/* Verify MPB contents against checksum after reading MPB */
+#define MPB_ATTRIB_CHECKSUM_VERIFY	__cpu_to_le32(0x80000000)
+
+/* Define all supported attributes that have to be accepted by mdadm
+ */
+#define MPB_ATTRIB_SUPPORTED		MPB_ATTRIB_CHECKSUM_VERIFY | \
+					MPB_ATTRIB_2TB             | \
+					MPB_ATTRIB_2TB_DISK        | \
+					MPB_ATTRIB_RAID0           | \
+					MPB_ATTRIB_RAID1           | \
+					MPB_ATTRIB_RAID10          | \
+					MPB_ATTRIB_RAID5           | \
+					MPB_ATTRIB_EXP_STRIPE_SIZE
 
 #define MPB_SECTOR_CNT 2210
 #define IMSM_RESERVED_SECTORS 4096
@@ -1096,6 +1128,90 @@ void examine_migr_rec_imsm(struct intel_super *super)
 	}
 }
 
+/*******************************************************************************
+ * function: imsm_check_attributes
+ * Description: Function checks if features represented by attributes flags
+ * 		are supported by mdadm.
+ * Parameters:
+ *		attributes - Attributes read from metadata
+ * Returns:
+ * 		0 - passed attributes contains unsupported features flags
+ * 		1 - all features are supported
+ ******************************************************************************/
+static int imsm_check_attributes(__u32 attributes)
+{
+	int ret_val = 1;
+	__u32 not_supported = (MPB_ATTRIB_SUPPORTED)^0xffffffff;
+
+	not_supported &= attributes;
+	if (not_supported) {
+		fprintf(stderr, Name "(IMSM): Unsupported attributes : %x\n", not_supported);
+		if (not_supported & MPB_ATTRIB_CHECKSUM_VERIFY) {
+			dprintf("\t\tMPB_ATTRIB_CHECKSUM_VERIFY \n");
+			not_supported ^= MPB_ATTRIB_CHECKSUM_VERIFY;
+		}
+		if (not_supported & MPB_ATTRIB_2TB) {
+			dprintf("\t\tMPB_ATTRIB_2TB\n");
+			not_supported ^= MPB_ATTRIB_2TB;
+		}
+		if (not_supported & MPB_ATTRIB_RAID0) {
+			dprintf("\t\tMPB_ATTRIB_RAID0\n");
+			not_supported ^= MPB_ATTRIB_RAID0;
+		}
+		if (not_supported & MPB_ATTRIB_RAID1) {
+			dprintf("\t\tMPB_ATTRIB_RAID1\n");
+			not_supported ^= MPB_ATTRIB_RAID1;
+		}
+		if (not_supported & MPB_ATTRIB_RAID10) {
+			dprintf("\t\tMPB_ATTRIB_RAID10\n");
+			not_supported ^= MPB_ATTRIB_RAID10;
+		}
+		if (not_supported & MPB_ATTRIB_RAID1E) {
+			dprintf("\t\tMPB_ATTRIB_RAID1E\n");
+			not_supported ^= MPB_ATTRIB_RAID1E;
+		}
+		if (not_supported & MPB_ATTRIB_RAID5) {
+		dprintf("\t\tMPB_ATTRIB_RAID5\n");
+			not_supported ^= MPB_ATTRIB_RAID5;
+		}
+		if (not_supported & MPB_ATTRIB_RAIDCNG) {
+			dprintf("\t\tMPB_ATTRIB_RAIDCNG\n");
+			not_supported ^= MPB_ATTRIB_RAIDCNG;
+		}
+		if (not_supported & MPB_ATTRIB_BBM) {
+			dprintf("\t\tMPB_ATTRIB_BBM\n");
+		not_supported ^= MPB_ATTRIB_BBM;
+		}
+		if (not_supported & MPB_ATTRIB_CHECKSUM_VERIFY) {
+			dprintf("\t\tMPB_ATTRIB_CHECKSUM_VERIFY (== MPB_ATTRIB_LEGACY)\n");
+			not_supported ^= MPB_ATTRIB_CHECKSUM_VERIFY;
+		}
+		if (not_supported & MPB_ATTRIB_EXP_STRIPE_SIZE) {
+			dprintf("\t\tMPB_ATTRIB_EXP_STRIP_SIZE\n");
+			not_supported ^= MPB_ATTRIB_EXP_STRIPE_SIZE;
+		}
+		if (not_supported & MPB_ATTRIB_2TB_DISK) {
+			dprintf("\t\tMPB_ATTRIB_2TB_DISK\n");
+			not_supported ^= MPB_ATTRIB_2TB_DISK;
+		}
+		if (not_supported & MPB_ATTRIB_NEVER_USE2) {
+			dprintf("\t\tMPB_ATTRIB_NEVER_USE2\n");
+			not_supported ^= MPB_ATTRIB_NEVER_USE2;
+		}
+		if (not_supported & MPB_ATTRIB_NEVER_USE) {
+			dprintf("\t\tMPB_ATTRIB_NEVER_USE\n");
+			not_supported ^= MPB_ATTRIB_NEVER_USE;
+		}
+
+		if (not_supported)
+			dprintf(Name "(IMSM): Unknown attributes : %x\n", not_supported);
+
+		ret_val = 0;
+	}
+
+	return ret_val;
+}
+
 static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *map);
 
 static void examine_super_imsm(struct supertype *st, char *homehost)
@@ -1117,6 +1233,11 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 	printf("    Orig Family : %08x\n", __le32_to_cpu(mpb->orig_family_num));
 	printf("         Family : %08x\n", __le32_to_cpu(mpb->family_num));
 	printf("     Generation : %08x\n", __le32_to_cpu(mpb->generation_num));
+	printf("     Attributes : ");
+	if (imsm_check_attributes(mpb->attributes))
+		printf("All supported\n");
+	else
+		printf("not supported\n");
 	getinfo_super_imsm(st, &info, NULL);
 	fname_from_uuid(st, &info, nbuf, ':');
 	printf("           UUID : %s\n", nbuf + 5);
@@ -5405,6 +5526,13 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 	struct dl *d;
 	int spare_disks = 0;
 
+	/* do not assemble arrays when not all attributes are supported */
+	if (imsm_check_attributes(mpb->attributes) == 0) {
+		fprintf(stderr, Name ": IMSM metadata loading not allowed "
+			"due to attributes incompatibility.\n");
+		return NULL;
+	}
+
 	/* check for bad blocks */
 	if (imsm_bbm_log_size(super->anchor))
 		bbm_errors = 1;

