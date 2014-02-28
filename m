From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 1/2] imsm: support for second AHCI controller in EFI mode
Date: Fri, 28 Feb 2014 11:29:27 +0100
Message-ID: <1393583368-31542-2-git-send-email-artur.paszkiewicz@intel.com>
References: <1393583368-31542-1-git-send-email-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1393583368-31542-1-git-send-email-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

mdadm was unable to find IMSM platform capabilities when only the second
AHCI controller was enabled on a platform in EFI mode. The second AHCI
controller uses a different EFI variable and this patch adds support for
reading this variable.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Reviewed-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 platform-intel.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/platform-intel.c b/platform-intel.c
index f347382..77f8639 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -343,6 +343,7 @@ static const struct imsm_orom *find_imsm_hba_orom(enum sys_dev_type hba_id)
 #define SYS_EFI_VAR_PATH "/sys/firmware/efi/vars"
 #define SCU_PROP "RstScuV"
 #define AHCI_PROP "RstSataV"
+#define AHCI_SSATA_PROP "RstsSatV"
 
 #define VENDOR_GUID \
 	EFI_GUID(0x193dfefa, 0xa445, 0x4302, 0x99, 0xd8, 0xef, 0x3a, 0xad, 0x1a, 0x04, 0xc6)
@@ -397,6 +398,8 @@ int read_efi_variable(void *buffer, ssize_t buf_size, char *variable_name, struc
 
 const struct imsm_orom *find_imsm_efi(enum sys_dev_type hba_id)
 {
+	int err;
+
 	if (hba_id >= SYS_DEV_MAX)
 		return NULL;
 
@@ -419,7 +422,13 @@ const struct imsm_orom *find_imsm_efi(enum sys_dev_type hba_id)
 	if (check_env("IMSM_TEST_OROM"))
 		return NULL;
 
-	if (read_efi_variable(&imsm_efi[hba_id], sizeof(imsm_efi[0]), hba_id == SYS_DEV_SAS ? SCU_PROP : AHCI_PROP, VENDOR_GUID)) {
+	err = read_efi_variable(&imsm_efi[hba_id], sizeof(imsm_efi[0]), hba_id == SYS_DEV_SAS ? SCU_PROP : AHCI_PROP, VENDOR_GUID);
+
+	/* try to read variable for second AHCI controller */
+	if (err && hba_id == SYS_DEV_SATA)
+		err = read_efi_variable(&imsm_efi[hba_id], sizeof(imsm_efi[0]), AHCI_SSATA_PROP, VENDOR_GUID);
+
+	if (err) {
 		populated_efi[hba_id] = 0;
 		return NULL;
 	}
-- 
1.8.4.5

