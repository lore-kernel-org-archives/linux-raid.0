Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535ECC433E0
	for <linux-raid@archiver.kernel.org>; Wed, 17 Mar 2021 12:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0122064F3E
	for <linux-raid@archiver.kernel.org>; Wed, 17 Mar 2021 12:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhCQMCF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Mar 2021 08:02:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:55757 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231599AbhCQMCD (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 17 Mar 2021 08:02:03 -0400
IronPort-SDR: nDPa9IhfvHu+fDCBu24WNc1+K/MwIlWKo4QQWfY2GeO63+yFh+tmnT/M7fPa0M7eDxvHfEObfp
 77JsjrzwyHHw==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="169364526"
X-IronPort-AV: E=Sophos;i="5.81,256,1610438400"; 
   d="scan'208";a="169364526"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 05:02:03 -0700
IronPort-SDR: lpRDPQizidYegcqwzv769QHEE7ImHEQIzmhuo07APf3aXuweNkKhqKyccEROz3hG1mrsDrbJAU
 pKZkIERlrk/w==
X-IronPort-AV: E=Sophos;i="5.81,256,1610438400"; 
   d="scan'208";a="412618991"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 05:02:02 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] imsm: support for third Sata controller
Date:   Wed, 17 Mar 2021 13:01:54 +0100
Message-Id: <20210317120154.30806-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Add new UEFI TSata variable. Remove CSata variable.
This variable has been never exposed by UEFI.
Remove vulnerability to match different hbas with SATA variable.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 platform-intel.c | 58 ++++++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index f1f6d4cd..5ae2d453 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -486,7 +486,7 @@ static const struct imsm_orom *find_imsm_hba_orom(struct sys_dev *hba)
 #define SCU_PROP "RstScuV"
 #define AHCI_PROP "RstSataV"
 #define AHCI_SSATA_PROP "RstsSatV"
-#define AHCI_CSATA_PROP "RstCSatV"
+#define AHCI_TSATA_PROP "RsttSatV"
 #define VMD_PROP "RstUefiV"
 
 #define VENDOR_GUID \
@@ -494,7 +494,8 @@ static const struct imsm_orom *find_imsm_hba_orom(struct sys_dev *hba)
 
 #define PCI_CLASS_RAID_CNTRL 0x010400
 
-static int read_efi_var(void *buffer, ssize_t buf_size, char *variable_name, struct efi_guid guid)
+static int read_efi_var(void *buffer, ssize_t buf_size,
+			const char *variable_name, struct efi_guid guid)
 {
 	char path[PATH_MAX];
 	char buf[GUID_STR_MAX];
@@ -523,7 +524,8 @@ static int read_efi_var(void *buffer, ssize_t buf_size, char *variable_name, str
 	return 0;
 }
 
-static int read_efi_variable(void *buffer, ssize_t buf_size, char *variable_name, struct efi_guid guid)
+static int read_efi_variable(void *buffer, ssize_t buf_size,
+			     const char *variable_name, struct efi_guid guid)
 {
 	char path[PATH_MAX];
 	char buf[GUID_STR_MAX];
@@ -576,7 +578,9 @@ const struct imsm_orom *find_imsm_efi(struct sys_dev *hba)
 {
 	struct imsm_orom orom;
 	struct orom_entry *ret;
-	int err;
+	static const char * const sata_efivars[] = {AHCI_PROP, AHCI_SSATA_PROP,
+						    AHCI_TSATA_PROP};
+	unsigned long i;
 
 	if (check_env("IMSM_TEST_AHCI_EFI") || check_env("IMSM_TEST_SCU_EFI"))
 		return imsm_platform_test(hba);
@@ -585,35 +589,35 @@ const struct imsm_orom *find_imsm_efi(struct sys_dev *hba)
 	if (check_env("IMSM_TEST_OROM"))
 		return NULL;
 
-	if (hba->type == SYS_DEV_SATA && hba->class != PCI_CLASS_RAID_CNTRL)
-		return NULL;
-
-	err = read_efi_variable(&orom, sizeof(orom), hba->type == SYS_DEV_SAS ? SCU_PROP : AHCI_PROP, VENDOR_GUID);
+	switch (hba->type) {
+	case SYS_DEV_SAS:
+		if (!read_efi_variable(&orom, sizeof(orom), SCU_PROP,
+				       VENDOR_GUID))
+			break;
 
-	/* try to read variable for second AHCI controller */
-	if (err && hba->type == SYS_DEV_SATA)
-		err = read_efi_variable(&orom, sizeof(orom), AHCI_SSATA_PROP, VENDOR_GUID);
+		return NULL;
+	case SYS_DEV_SATA:
+		if (hba->class != PCI_CLASS_RAID_CNTRL)
+			return NULL;
 
-	/* try to read variable for combined AHCI controllers */
-	if (err && hba->type == SYS_DEV_SATA) {
-		static struct orom_entry *csata;
+		for (i = 0; i < ARRAY_SIZE(sata_efivars); i++) {
+			if (!read_efi_variable(&orom, sizeof(orom),
+						sata_efivars[i], VENDOR_GUID))
+				break;
 
-		err = read_efi_variable(&orom, sizeof(orom), AHCI_CSATA_PROP, VENDOR_GUID);
-		if (!err) {
-			if (!csata)
-				csata = add_orom(&orom);
-			add_orom_device_id(csata, hba->dev_id);
-			csata->type = hba->type;
-			return &csata->orom;
 		}
-	}
+		if (i == ARRAY_SIZE(sata_efivars))
+			return NULL;
 
-	if (hba->type == SYS_DEV_VMD) {
-		err = read_efi_variable(&orom, sizeof(orom), VMD_PROP, VENDOR_GUID);
-	}
-
-	if (err)
+		break;
+	case SYS_DEV_VMD:
+		if (!read_efi_variable(&orom, sizeof(orom), VMD_PROP,
+				       VENDOR_GUID))
+			break;
 		return NULL;
+	default:
+		return NULL;
+	}
 
 	ret = add_orom(&orom);
 	add_orom_device_id(ret, hba->dev_id);
-- 
2.26.2

