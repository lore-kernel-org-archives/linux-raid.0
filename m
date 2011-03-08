From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 02/14] Platform-intel: support for OROM SAS and AHCI
 controller
Date: Tue, 8 Mar 2011 15:20:33 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A8AEC8B@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From 65ddd52114b70837c8f2e69e2e5200dff1eab90a Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Thu, 3 Mar 2011 13:41:41 +0100
Subject: [PATCH 02/14] Platform-intel: support for OROM SAS and AHCI controller

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 platform-intel.c |  130 +++++++++++++++++++++++++++++++++++++++++------------
 platform-intel.h |    8 +++-
 2 files changed, 106 insertions(+), 32 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 0dc90b7..95e3a1a 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -28,6 +28,10 @@
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <limits.h>
+
+
+static __u16 devpath_to_vendor(const char *dev_path);
 
 void free_sys_dev(struct sys_dev **list)
 {
@@ -113,7 +117,8 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 	return head;
 }
 
-__u16 devpath_to_vendor(const char *dev_path)
+
+static __u16 devpath_to_vendor(const char *dev_path)
 {
 	char path[strlen(dev_path) + strlen("/vendor") + 1];
 	char vendor[7];
@@ -167,19 +172,21 @@ static int platform_has_intel_devices(void)
 }
 
 /*
- * PCI Expansion ROM Data Structure Format
- */
+ * PCI Expansion ROM Data Structure Format */
 struct pciExpDataStructFormat {
 	__u8  ver[4];
 	__u16 vendorID;
 	__u16 deviceID;
 } __attribute__ ((packed));
 
-static struct imsm_orom imsm_orom;
+static struct imsm_orom imsm_orom[SYS_DEV_MAX];
+static int populated_orom[SYS_DEV_MAX];
+
 static int scan(const void *start, const void *end, const void *data)
 {
 	int offset;
 	const struct imsm_orom *imsm_mem;
+	int dev;
 	int len = (end - start);
 	struct pciExpDataStructFormat *ptr= (struct pciExpDataStructFormat *)data;
 
@@ -187,46 +194,85 @@ static int scan(const void *start, const void *end, const void *data)
 		(ulong) __le16_to_cpu(ptr->vendorID),
 		(ulong) __le16_to_cpu(ptr->deviceID));
 
-	if (!((__le16_to_cpu(ptr->vendorID) == 0x8086) &&
-	      (__le16_to_cpu(ptr->deviceID) == 0x2822)))
+	if ((__le16_to_cpu(ptr->vendorID) == 0x8086) &&
+	    (__le16_to_cpu(ptr->deviceID) == 0x2822))
+		dev = SYS_DEV_SATA;
+	else if ((__le16_to_cpu(ptr->vendorID) == 0x8086) &&
+		 (__le16_to_cpu(ptr->deviceID) == 0x1D60))
+		dev = SYS_DEV_SAS;
+	else
 		return 0;
 	
 	for (offset = 0; offset < len; offset += 4) {
 		imsm_mem = start + offset;
 		if (memcmp(imsm_mem->signature, "$VER", 4) == 0) {
-			imsm_orom = *imsm_mem;
-			return 1;
+			imsm_orom[dev] = *imsm_mem;
+			populated_orom[dev] = 1;
+			return populated_orom[SYS_DEV_SATA] && populated_orom[SYS_DEV_SAS];
 		}
 	}
 	return 0;
 }
 
-const struct imsm_orom *find_imsm_orom(void)
-{
-	static int populated = 0;
-	unsigned long align;
-
-	/* it's static data so we only need to read it once */
-	if (populated)
-		return &imsm_orom;
 
-	if (check_env("IMSM_TEST_OROM")) {
-		memset(&imsm_orom, 0, sizeof(imsm_orom));
-		imsm_orom.rlc = IMSM_OROM_RLC_RAID0 | IMSM_OROM_RLC_RAID1 |
+const struct imsm_orom *imsm_platform_test(enum sys_dev_type hba_id, int *populated, 
+					  struct imsm_orom *imsm_orom)
+{
+	memset(imsm_orom, 0, sizeof(*imsm_orom));
+	imsm_orom->rlc = IMSM_OROM_RLC_RAID0 | IMSM_OROM_RLC_RAID1 |
 				IMSM_OROM_RLC_RAID10 | IMSM_OROM_RLC_RAID5;
-		imsm_orom.sss = IMSM_OROM_SSS_4kB | IMSM_OROM_SSS_8kB |
+	imsm_orom->sss = IMSM_OROM_SSS_4kB | IMSM_OROM_SSS_8kB |
 				IMSM_OROM_SSS_16kB | IMSM_OROM_SSS_32kB |
 				IMSM_OROM_SSS_64kB | IMSM_OROM_SSS_128kB |
 				IMSM_OROM_SSS_256kB | IMSM_OROM_SSS_512kB |
 				IMSM_OROM_SSS_1MB | IMSM_OROM_SSS_2MB;
-		imsm_orom.dpa = 6;
-		imsm_orom.tds = 6;
-		imsm_orom.vpa = 2;
-		imsm_orom.vphba = 4;
-		imsm_orom.attr = imsm_orom.rlc | IMSM_OROM_ATTR_ChecksumVerify;
-		populated = 1;
-		return &imsm_orom;
+	imsm_orom->dpa = IMSM_OROM_DISKS_PER_ARRAY;
+	imsm_orom->tds = IMSM_OROM_TOTAL_DISKS;
+	imsm_orom->vpa = IMSM_OROM_VOLUMES_PER_ARRAY;
+	imsm_orom->vphba = IMSM_OROM_VOLUMES_PER_HBA;
+	imsm_orom->attr = imsm_orom->rlc | IMSM_OROM_ATTR_ChecksumVerify;
+	*populated = 1;
+
+	if (check_env("IMSM_TEST_OROM_NORAID5")) {
+		imsm_orom->rlc = IMSM_OROM_RLC_RAID0 | IMSM_OROM_RLC_RAID1 |
+				IMSM_OROM_RLC_RAID10;
+	}	
+	if (check_env("IMSM_TEST_AHCI_EFI_NORAID5") && (hba_id == SYS_DEV_SAS)) {
+		imsm_orom->rlc = IMSM_OROM_RLC_RAID0 | IMSM_OROM_RLC_RAID1 |
+				IMSM_OROM_RLC_RAID10;
+	}	
+	if (check_env("IMSM_TEST_SCU_EFI_NORAID5") && (hba_id == SYS_DEV_SATA)) {
+		imsm_orom->rlc = IMSM_OROM_RLC_RAID0 | IMSM_OROM_RLC_RAID1 |
+				IMSM_OROM_RLC_RAID10;
+	}	
+	
+	return imsm_orom;
+}
+
+
+
+static const struct imsm_orom *find_imsm_hba_orom(enum sys_dev_type hba_id)
+{
+	unsigned long align;
+
+	if (hba_id >= SYS_DEV_MAX)
+		return NULL;
+
+	/* it's static data so we only need to read it once */
+	if (populated_orom[hba_id]) {
+		dprintf("OROM CAP: %p, pid: %d pop: %d\n",
+			&imsm_orom[hba_id], (int) getpid(), populated_orom[hba_id]);
+		return &imsm_orom[hba_id];
+	}
+	if (check_env("IMSM_TEST_OROM")) {
+		dprintf("OROM CAP: %p,  pid: %d pop: %d\n",
+                     &imsm_orom[hba_id], (int) getpid(), populated_orom[hba_id]); 
+		return imsm_platform_test(hba_id, &populated_orom[hba_id], &imsm_orom[hba_id]);
 	}
+	/* return empty OROM capabilities in EFI test mode */
+	if (check_env("IMSM_TEST_AHCI_EFI") ||
+	    check_env("IMSM_TEST_SCU_EFI"))
+		return NULL;
 
 	if (!platform_has_intel_devices())
 		return NULL;
@@ -239,11 +285,30 @@ const struct imsm_orom *find_imsm_orom(void)
 	if (probe_roms_init(align) != 0)
 		return NULL;
 	probe_roms();
-	populated = scan_adapter_roms(scan);
+	/* ignore result - True is returned if both are found */
+	scan_adapter_roms(scan);
 	probe_roms_exit();
 
-	if (populated)
-		return &imsm_orom;
+	if (populated_orom[hba_id])
+		return &imsm_orom[hba_id];
+	return NULL;
+}
+
+
+/* 
+ * backward interface compatibility 
+ */
+const struct imsm_orom *find_imsm_orom(void)
+{
+	return find_imsm_hba_orom(SYS_DEV_SATA);
+}
+
+const struct imsm_orom *find_imsm_capability(enum sys_dev_type hba_id) 
+{
+	const struct imsm_orom *cap=NULL;
+
+	if ((cap = find_imsm_hba_orom(hba_id)) != NULL)
+		return cap;
 	return NULL;
 }
 
@@ -273,6 +338,11 @@ char *diskfd_to_devpath(int fd)
 int path_attached_to_hba(const char *disk_path, const char *hba_path)
 {
 	int rc;
+	
+	if (check_env("IMSM_TEST_AHCI_DEV") ||
+	    check_env("IMSM_TEST_SCU_DEV")) {
+		return 1;
+	}
 
 	if (!disk_path || !hba_path)
 		return 0;
diff --git a/platform-intel.h b/platform-intel.h
index 82cc85e..18f1ea2 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -19,7 +19,7 @@
 #include <asm/types.h>
 #include <strings.h>
 
-/* The IMSM OROM Version Table definition */
+/* The IMSM Capability (IMSM AHCI and ISCU OROM/EFI variable) Version Table definition */
 struct imsm_orom {
 	__u8 signature[4];
 	__u8 table_ver_major; /* Currently 2 (can change with future revs) */
@@ -58,9 +58,13 @@ struct imsm_orom {
 	#define IMSM_OROM_SSS_32MB (1 << 14)
 	#define IMSM_OROM_SSS_64MB (1 << 15)
 	__u16 dpa; /* Disks Per Array supported */
+	#define IMSM_OROM_DISKS_PER_ARRAY 6
 	__u16 tds; /* Total Disks Supported */
+	#define IMSM_OROM_TOTAL_DISKS 6
 	__u8 vpa; /* # Volumes Per Array supported */
+	#define IMSM_OROM_VOLUMES_PER_ARRAY 2
 	__u8 vphba; /* # Volumes Per Host Bus Adapter supported */
+	#define IMSM_OROM_VOLUMES_PER_HBA 4
 	/* Attributes supported. This should map to the
 	 * attributes in the MPB. Also, lower 16 bits
 	 * should match/duplicate RLC bits above.
@@ -184,8 +188,8 @@ struct sys_dev {
 char *diskfd_to_devpath(int fd);
 struct sys_dev *find_driver_devices(const char *bus, const char *driver);
 struct sys_dev *find_intel_devices(void);
-__u16 devpath_to_vendor(const char *dev_path);
 void free_sys_dev(struct sys_dev **list);
+const struct imsm_orom *find_imsm_capability(enum sys_dev_type hba_id);
 const struct imsm_orom *find_imsm_orom(void);
 int disk_attached_to_hba(int fd, const char *hba_path);
 char *devt_to_devpath(dev_t dev);
-- 
1.6.4.2

