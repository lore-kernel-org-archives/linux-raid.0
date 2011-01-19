From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: PATCH 4/5] imsm: detail_platform_imsm supports Intel SAS controller
 (isci driver)
Date: Wed, 19 Jan 2011 17:14:08 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176EFD551@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From 3b9e73baf8c3015f08219658b04808319f79b2a4 Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Wed, 19 Jan 2011 12:18:48 +0100
Subject: [PATCH 4/5] imsm: detail_platform_imsm supports Intel SAS controller (isci driver)

Added support in detail_platform_imsm for Intel (R) SAS controller.
Function supports AHCI and ISCI controllers. RAID properties are derived
from common OROM for both types.

Based on code From: Artur Wojcik <artur.wojcik@intel.com>
Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index d77d61c..8f8e062 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1288,12 +1288,15 @@ static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_b
 }
 
 
+
 static void print_found_intel_controllers(struct sys_dev *elem)
 {
 	for (; elem; elem = elem->next) {
 		fprintf(stderr, Name ": found Intel(R) ");
 		if (elem->type == SYS_DEV_SATA)
 			fprintf(stderr, "SATA ");
+		else if (elem->type == SYS_DEV_SAS)
+			fprintf(stderr, "SAS ");
 		fprintf(stderr, "RAID controller");
 		if (elem->pci_id)
 			fprintf(stderr, " at %s", elem->pci_id);
@@ -1302,7 +1305,6 @@ static void print_found_intel_controllers(struct sys_dev *elem)
 	fflush(stderr);
 }
 
-
 static int ahci_get_port_count(const char *hba_path, int *port_count)
 {
 	struct dirent *ent;
@@ -1355,22 +1357,19 @@ static int detail_platform_imsm(int verbose, int enumerate_only)
 		return 2;
 	}
 
-	list = find_driver_devices("pci", "ahci");
-	for (hba = list; hba; hba = hba->next)
-		if (devpath_to_vendor(hba->path) == 0x8086)
-			break;
-
-	if (!hba) {
+	list = find_intel_devices();
+	if (!list) {
 		if (verbose)
-			fprintf(stderr, Name ": unable to find active ahci controller\n");
+			fprintf(stderr, Name ": no active Intel(R) RAID "
+				"controller found.\n");
 		free_sys_dev(&list);
 		return 2;
 	} else if (verbose)
-		fprintf(stderr, Name ": found Intel SATA AHCI Controller\n");
+		print_found_intel_controllers(list);
 
-	print_found_intel_controllers(list);
 	orom = find_imsm_orom();
 	if (!orom) {
+		free_sys_dev(&list);
 		if (verbose)
 			fprintf(stderr, Name ": imsm option-rom not found\n");
 		return 2;
@@ -1405,7 +1404,6 @@ static int detail_platform_imsm(int verbose, int enumerate_only)
 	printf("      Max Disks : %d\n", orom->tds);
 	printf("    Max Volumes : %d\n", orom->vpa);
 
-
 	for (hba = list; hba; hba = hba->next) {
 		printf(" I/O Controller : %s (%s)\n",
 			hba->path, get_sys_dev_type(hba->type));
@@ -1418,8 +1416,14 @@ static int detail_platform_imsm(int verbose, int enumerate_only)
 						"ports on SATA controller at %s.", hba->pci_id);
 				result |= 2;
 			}
+		} else if (hba->type == SYS_DEV_SAS) {
+				if (verbose)
+					fprintf(stderr, Name ": failed to enumerate "
+						"devices on SAS controller at %s.", hba->pci_id);
+				result |= 2;
 		}
 	}
+
 	free_sys_dev(&list);
 	return result;
 }
@@ -2701,7 +2705,7 @@ static void __free_imsm(struct intel_super *super, int free_disks)
 		next = elem->next;
 		free(elem);
 		elem = next;
- 	}
+	}
 	super->hba = NULL;
 }
 
-- 
1.6.4.2

