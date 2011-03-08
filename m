From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 12/14] imsm: move code for retrieving HBA to a function
Date: Tue, 8 Mar 2011 15:21:28 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A8AEC95@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From c41e0bc44b5b191f7993eb5f09ee0670be3a91f1 Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Mon, 7 Mar 2011 16:23:39 +0100
Subject: [PATCH 12/14] imsm: move code for retrieving HBA to a function

Function find_intel_hba_capability attaches HBA information
to intel_super structure based on fd of the component disk.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |  102 ++++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 65 insertions(+), 37 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 01f82ac..141ebc5 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2846,6 +2846,65 @@ static struct intel_super *alloc_super(void)
 	return super;
 }
 
+
+/*
+ * find and allocate hba and OROM/EFI based on valid fd of RAID component device
+ */
+static int find_intel_hba_capability(int fd, struct intel_super *super, int verbose)
+{
+	struct sys_dev *hba_name;
+	int rv = 0;
+
+	if ((fd < 0) || check_env("IMSM_NO_PLATFORM")) {
+		super->hba = NULL;
+		return 0;
+	}
+	hba_name = find_disk_attached_hba(fd, NULL);
+	if (!hba_name) {
+		if (verbose) {
+			char str[256];
+
+			fd2devname(fd, str);
+			fprintf(stderr,
+				Name ": %s is not attached to Intel(R) RAID controller.\n",
+				str);
+		}
+		return 1;
+	}
+	rv = attach_hba_to_super(super, hba_name);
+	if (rv == 2) {
+		if (verbose) {
+			char str[256];
+
+			fd2devname(fd, str);
+			fprintf(stderr, Name ": %s is attached to Intel(R) %s RAID "
+				"controller (%s),\n    but the container is assigned to Intel(R) "
+				"%s RAID controller (",
+				str,
+				hba_name->path,
+				hba_name->pci_id ? : "Err!",
+				get_sys_dev_type(hba_name->type));
+			
+			struct intel_hba *hba = super->hba;
+			while (hba) {
+				fprintf(stderr, "%s", hba->pci_id ? : "Err!");
+				if (hba->next)
+					fprintf(stderr, ", ");
+				hba = hba->next;
+			}
+
+			fprintf(stderr, ").\n"
+				"    Mixing devices attached to different controllers "
+				"is not allowed.\n");
+		}
+		free_sys_dev(&hba_name);
+		return 2;
+	}
+	free_sys_dev(&hba_name);
+	return 0;
+}
+
+
 #ifndef MDASSEMBLE
 /* find_missing - helper routine for load_super_imsm_all that identifies
  * disks that have disappeared from the system.  This routine relies on
@@ -3706,43 +3765,12 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	 * We do not need to test disks attachment for container based additions,
 	 * they shall be already tested when container was created/assembled.
 	 */
-	if ((fd != -1) && !check_env("IMSM_NO_PLATFORM")) {
-		struct sys_dev *hba_name;
-		struct intel_hba *hba;
-
-		hba_name = find_disk_attached_hba(fd, NULL);
-		if (!hba_name) {
-			fprintf(stderr,
-				Name ": %s is not attached to Intel(R) RAID controller.\n",
-				devname ? : "disk");
-			return 1;
-		}
-		rv = attach_hba_to_super(super, hba_name);
-		switch (rv) {
-		case 2:
-			fprintf(stderr, Name ": %s is attached to Intel(R) %s RAID "
-				"controller (%s),\n    but the container is assigned to Intel(R) "
-				"%s RAID controller (",
-				devname,
-				get_sys_dev_type(hba_name->type),
-				hba_name->pci_id ? : "Err!",
-				get_sys_dev_type(hba_name->type));
-
-			hba = super->hba;
-			while (hba) {
-				fprintf(stderr, "%s", hba->pci_id ? : "Err!");
-				if (hba->next)
-					fprintf(stderr, ", ");
-				hba = hba->next;
-			}
-
-			fprintf(stderr, ").\n"
-				"    Mixing devices attached to different controllers "
-				"is not allowed.\n");
-			free_sys_dev(&hba_name);
-			return 1;
-		}
-		free_sys_dev(&hba_name);
+	rv = find_intel_hba_capability(fd, super, 1);
+	/* no intel hba of the disk */
+	if (rv != 0) {
+		dprintf("capability: %p fd: %d ret: %d\n",
+			super->orom, fd, rv);
+		return 1;
 	}
 
 	if (super->current_vol >= 0)
-- 
1.6.4.2

