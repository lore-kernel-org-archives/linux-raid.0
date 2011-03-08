From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 07/14] imsm: detail_platform_imsm displays AHCI and SAS
 controller information
Date: Tue, 8 Mar 2011 15:21:01 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A8AEC90@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From ab6cb1a7303f693131fe3a4c05763cce315fdaba Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Fri, 4 Mar 2011 16:43:20 +0100
Subject: [PATCH 07/14] imsm: detail_platform_imsm displays AHCI and SAS controller information

The function uses find_intel_device and find_imsm_capability to present
AHCI and SAS controller capabilities taken from OROM or EFI.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |   95 +++++++++++++++++++++++++++++++-------------------------
 1 files changed, 53 insertions(+), 42 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 9f78aff..02952a4 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1346,6 +1346,39 @@ static int ahci_get_port_count(const char *hba_path, int *port_count)
 	return host_base;
 }
 
+static void print_imsm_capability(const struct imsm_orom *orom)
+{
+	printf("       Platform : Intel(R) Matrix Storage Manager\n");
+	printf("        Version : %d.%d.%d.%d\n", orom->major_ver, orom->minor_ver,
+	       orom->hotfix_ver, orom->build);
+	printf("    RAID Levels :%s%s%s%s%s\n",
+	       imsm_orom_has_raid0(orom) ? " raid0" : "",
+	       imsm_orom_has_raid1(orom) ? " raid1" : "",
+	       imsm_orom_has_raid1e(orom) ? " raid1e" : "",
+	       imsm_orom_has_raid10(orom) ? " raid10" : "",
+	       imsm_orom_has_raid5(orom) ? " raid5" : "");
+	printf("    Chunk Sizes :%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
+	       imsm_orom_has_chunk(orom, 2) ? " 2k" : "",
+	       imsm_orom_has_chunk(orom, 4) ? " 4k" : "",
+	       imsm_orom_has_chunk(orom, 8) ? " 8k" : "",
+	       imsm_orom_has_chunk(orom, 16) ? " 16k" : "",
+	       imsm_orom_has_chunk(orom, 32) ? " 32k" : "",
+	       imsm_orom_has_chunk(orom, 64) ? " 64k" : "",
+	       imsm_orom_has_chunk(orom, 128) ? " 128k" : "",
+	       imsm_orom_has_chunk(orom, 256) ? " 256k" : "",
+	       imsm_orom_has_chunk(orom, 512) ? " 512k" : "",
+	       imsm_orom_has_chunk(orom, 1024*1) ? " 1M" : "",
+	       imsm_orom_has_chunk(orom, 1024*2) ? " 2M" : "",
+	       imsm_orom_has_chunk(orom, 1024*4) ? " 4M" : "",
+	       imsm_orom_has_chunk(orom, 1024*8) ? " 8M" : "",
+	       imsm_orom_has_chunk(orom, 1024*16) ? " 16M" : "",
+	       imsm_orom_has_chunk(orom, 1024*32) ? " 32M" : "",
+	       imsm_orom_has_chunk(orom, 1024*64) ? " 64M" : "");
+	printf("      Max Disks : %d\n", orom->tds);
+	printf("    Max Volumes : %d\n", orom->vpa);
+	return;
+}
+
 static int detail_platform_imsm(int verbose, int enumerate_only)
 {
 	/* There are two components to imsm platform support, the ahci SATA
@@ -1366,9 +1399,20 @@ static int detail_platform_imsm(int verbose, int enumerate_only)
 	int result=0;
 
 	if (enumerate_only) {
-		if (check_env("IMSM_NO_PLATFORM") || find_imsm_orom())
+		if (check_env("IMSM_NO_PLATFORM"))
 			return 0;
-		return 2;
+		list = find_intel_devices();
+		if (!list)
+			return 2;
+		for (hba = list; hba; hba = hba->next) {
+			orom = find_imsm_capability(hba->type);
+			if (!orom) {
+				result = 2;
+				break;
+			}
+		}
+		free_sys_dev(&list);
+		return result;
 	}
 
 	list = find_intel_devices();
@@ -1381,43 +1425,15 @@ static int detail_platform_imsm(int verbose, int enumerate_only)
 	} else if (verbose)
 		print_found_intel_controllers(list);
 
-	orom = find_imsm_orom();
-	if (!orom) {
-		free_sys_dev(&list);
-		if (verbose)
-			fprintf(stderr, Name ": imsm option-rom not found\n");
-		return 2;
+	for (hba = list; hba; hba = hba->next) {
+		orom = find_imsm_capability(hba->type);
+		if (!orom)
+			fprintf(stderr, Name ": imsm capabilities not found for controller: %s (type %s)\n",
+				hba->path, get_sys_dev_type(hba->type));
+		else
+			print_imsm_capability(orom);
 	}
 
-	printf("       Platform : Intel(R) Matrix Storage Manager\n");
-	printf("        Version : %d.%d.%d.%d\n", orom->major_ver, orom->minor_ver,
-	       orom->hotfix_ver, orom->build);
-	printf("    RAID Levels :%s%s%s%s%s\n",
-	       imsm_orom_has_raid0(orom) ? " raid0" : "",
-	       imsm_orom_has_raid1(orom) ? " raid1" : "",
-	       imsm_orom_has_raid1e(orom) ? " raid1e" : "",
-	       imsm_orom_has_raid10(orom) ? " raid10" : "",
-	       imsm_orom_has_raid5(orom) ? " raid5" : "");
-	printf("    Chunk Sizes :%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
-	       imsm_orom_has_chunk(orom, 2) ? " 2k" : "",
-	       imsm_orom_has_chunk(orom, 4) ? " 4k" : "",
-	       imsm_orom_has_chunk(orom, 8) ? " 8k" : "",
-	       imsm_orom_has_chunk(orom, 16) ? " 16k" : "",
-	       imsm_orom_has_chunk(orom, 32) ? " 32k" : "",
-	       imsm_orom_has_chunk(orom, 64) ? " 64k" : "",
-	       imsm_orom_has_chunk(orom, 128) ? " 128k" : "",
-	       imsm_orom_has_chunk(orom, 256) ? " 256k" : "",
-	       imsm_orom_has_chunk(orom, 512) ? " 512k" : "",
-	       imsm_orom_has_chunk(orom, 1024*1) ? " 1M" : "",
-	       imsm_orom_has_chunk(orom, 1024*2) ? " 2M" : "",
-	       imsm_orom_has_chunk(orom, 1024*4) ? " 4M" : "",
-	       imsm_orom_has_chunk(orom, 1024*8) ? " 8M" : "",
-	       imsm_orom_has_chunk(orom, 1024*16) ? " 16M" : "",
-	       imsm_orom_has_chunk(orom, 1024*32) ? " 32M" : "",
-	       imsm_orom_has_chunk(orom, 1024*64) ? " 64M" : "");
-	printf("      Max Disks : %d\n", orom->tds);
-	printf("    Max Volumes : %d\n", orom->vpa);
-
 	for (hba = list; hba; hba = hba->next) {
 		printf(" I/O Controller : %s (%s)\n",
 			hba->path, get_sys_dev_type(hba->type));
@@ -1430,11 +1446,6 @@ static int detail_platform_imsm(int verbose, int enumerate_only)
 						"ports on SATA controller at %s.", hba->pci_id);
 				result |= 2;
 			}
-		} else if (hba->type == SYS_DEV_SAS) {
-				if (verbose)
-					fprintf(stderr, Name ": failed to enumerate "
-						"devices on SAS controller at %s.", hba->pci_id);
-				result |= 2;
 		}
 	}
 
-- 
1.6.4.2

