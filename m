From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 2/5] imsm: support for second and combined AHCI controllers in UEFI mode
Date: Wed, 19 Nov 2014 13:53:27 +0100
Message-ID: <1416401610-16209-3-git-send-email-artur.paszkiewicz@intel.com>
References: <1416401610-16209-1-git-send-email-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1416401610-16209-1-git-send-email-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Grantly platform introduces a second AHCI controller (sSATA) and two new
UEFI variables for the RSTe firmware. This patch adds support for those
variables in order to correctly determine IMSM platform capabilities in
UEFI mode.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 platform-intel.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/platform-intel.c b/platform-intel.c
index f779d02..c5a0aa4 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -401,6 +401,8 @@ static const struct imsm_orom *find_imsm_hba_orom(struct sys_dev *hba)
 #define SYS_EFI_VAR_PATH "/sys/firmware/efi/vars"
 #define SCU_PROP "RstScuV"
 #define AHCI_PROP "RstSataV"
+#define AHCI_SSATA_PROP "RstsSatV"
+#define AHCI_CSATA_PROP "RstCSatV"
 
 #define VENDOR_GUID \
 	EFI_GUID(0x193dfefa, 0xa445, 0x4302, 0x99, 0xd8, 0xef, 0x3a, 0xad, 0x1a, 0x04, 0xc6)
@@ -455,6 +457,7 @@ const struct imsm_orom *find_imsm_efi(struct sys_dev *hba)
 {
 	struct imsm_orom orom;
 	const struct imsm_orom *ret;
+	int err;
 
 	if (check_env("IMSM_TEST_AHCI_EFI") || check_env("IMSM_TEST_SCU_EFI"))
 		return imsm_platform_test(hba);
@@ -466,7 +469,26 @@ const struct imsm_orom *find_imsm_efi(struct sys_dev *hba)
 	if (hba->type == SYS_DEV_SATA && hba->class != PCI_CLASS_RAID_CNTRL)
 		return NULL;
 
-	if (read_efi_variable(&orom, sizeof(orom), hba->type == SYS_DEV_SAS ? SCU_PROP : AHCI_PROP, VENDOR_GUID))
+	err = read_efi_variable(&orom, sizeof(orom), hba->type == SYS_DEV_SAS ? SCU_PROP : AHCI_PROP, VENDOR_GUID);
+
+	/* try to read variable for second AHCI controller */
+	if (err && hba->type == SYS_DEV_SATA)
+		err = read_efi_variable(&orom, sizeof(orom), AHCI_SSATA_PROP, VENDOR_GUID);
+
+	/* try to read variable for combined AHCI controllers */
+	if (err && hba->type == SYS_DEV_SATA) {
+		static const struct imsm_orom *csata;
+
+		err = read_efi_variable(&orom, sizeof(orom), AHCI_CSATA_PROP, VENDOR_GUID);
+		if (!err) {
+			if (!csata)
+				csata = add_orom(&orom);
+			add_orom_device_id(csata, hba->dev_id);
+			return csata;
+		}
+	}
+
+	if (err)
 		return NULL;
 
 	ret = add_orom(&orom);
-- 
1.8.4.5

