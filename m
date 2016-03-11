From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 1/2] super-intel: Make print_vmd_attached_devs() return int again
Date: Fri, 11 Mar 2016 16:47:15 +0100
Message-ID: <1457711236-16990-1-git-send-email-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@redhat.com, artur.paszkiewicz@intel.com, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

This patch reverts a0abe1e
(super-intel: Make print_found_intel_controllers() return void)
and make this function "return int" again.
Also, interpreting the return value is added.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 super-intel.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 3fe304a..8a80c5b 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1766,7 +1766,7 @@ static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_b
 	return err;
 }
 
-static void print_vmd_attached_devs(struct sys_dev *hba)
+static int print_vmd_attached_devs(struct sys_dev *hba)
 {
 	struct dirent *ent;
 	DIR *dir;
@@ -1775,14 +1775,14 @@ static void print_vmd_attached_devs(struct sys_dev *hba)
 	char *c, *rp;
 
 	if (hba->type != SYS_DEV_VMD)
-		return;
+		return 1;
 
 	/* scroll through /sys/dev/block looking for devices attached to
 	 * this hba
 	 */
 	dir = opendir("/sys/bus/pci/drivers/nvme");
 	if (!dir)
-		return;
+		return 1;
 
 	for (ent = readdir(dir); ent; ent = readdir(dir)) {
 		int n;
@@ -1818,6 +1818,7 @@ static void print_vmd_attached_devs(struct sys_dev *hba)
 	}
 
 	closedir(dir);
+	return 0;
 }
 
 static void print_found_intel_controllers(struct sys_dev *elem)
@@ -2024,7 +2025,11 @@ static int detail_platform_imsm(int verbose, int enumerate_only, char *controlle
 					print_imsm_capability(&entry->orom);
 					printf(" I/O Controller : %s (%s)\n",
 						vmd_domain_to_controller(hba, buf), get_sys_dev_type(hba->type));
-					print_vmd_attached_devs(hba);
+					if (print_vmd_attached_devs(hba)) {
+						if (verbose > 0)
+							pr_err("failed to get devices attached to VMD domain.\n");
+						result |= 2;
+					}
 					printf("\n");
 				}
 			}
-- 
2.5.0

