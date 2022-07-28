Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3EC5C04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238350AbiG1MWp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238371AbiG1MWY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:22:24 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476744B0C6
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:22:23 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id CA561373A7;
        Thu, 28 Jul 2022 12:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L8eOsEW2VE2uEYahxm41kNWsE6KWrMLIm6yS8buJUxU=;
        b=saBBITTiWOesVD1e1jdMe5GSu6nVovNVhag1ztmnlv+7OMKKBZSuVna0RoVoBYgl+VYL9i
        dcgK1INFm75MFMtSczxBn8CEQUHyrMpYGZseNHICRGHjum8XYlXFg9IZscfWCPkz0nfyPk
        GKyKeCupkh2G5QrZPxiVl/41IlNLEtc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010941;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L8eOsEW2VE2uEYahxm41kNWsE6KWrMLIm6yS8buJUxU=;
        b=PmTAB/mFG8t7D68AXiYWCwCx5fU3VV5Qj/TaACUvblDmlQ9iFdW2NsDnUhY+zuUxLPY+Uo
        byO5d6glNonEtQDA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id A21DC2C141;
        Thu, 28 Jul 2022 12:22:19 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 19/23] mdadm: enable Intel Alderlake RSTe configuration
Date:   Thu, 28 Jul 2022 20:20:57 +0800
Message-Id: <20220728122101.28744-20-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Alderlake has a slightly different RST configuration; the UEFI
variable is name 'RstVmdV', and the AHCI controller shows up as
a child device of the VMD bridge, but continues to use the 'AHCI HBA'
PCI class (and not the RAID class as RSTe would normally do).

Signed-off-by: Hannes Reinecke <hare@suse.de>
Acked-by: Coly Li <colyli@suse.de>
---
 platform-intel.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 5a8729e7..a4d55a38 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -512,12 +512,14 @@ static const struct imsm_orom *find_imsm_hba_orom(struct sys_dev *hba)
 #define AHCI_PROP "RstSataV"
 #define AHCI_SSATA_PROP "RstsSatV"
 #define AHCI_TSATA_PROP "RsttSatV"
+#define AHCI_RST_PROP "RstVmdV"
 #define VMD_PROP "RstUefiV"
 
 #define VENDOR_GUID \
 	EFI_GUID(0x193dfefa, 0xa445, 0x4302, 0x99, 0xd8, 0xef, 0x3a, 0xad, 0x1a, 0x04, 0xc6)
 
 #define PCI_CLASS_RAID_CNTRL 0x010400
+#define PCI_CLASS_SATA_HBA 0x010601
 
 static int read_efi_var(void *buffer, ssize_t buf_size,
 			const char *variable_name, struct efi_guid guid)
@@ -604,7 +606,8 @@ const struct imsm_orom *find_imsm_efi(struct sys_dev *hba)
 	struct imsm_orom orom;
 	struct orom_entry *ret;
 	static const char * const sata_efivars[] = {AHCI_PROP, AHCI_SSATA_PROP,
-						    AHCI_TSATA_PROP};
+						    AHCI_TSATA_PROP,
+						    AHCI_RST_PROP};
 	unsigned long i;
 
 	if (check_env("IMSM_TEST_AHCI_EFI") || check_env("IMSM_TEST_SCU_EFI"))
@@ -622,7 +625,8 @@ const struct imsm_orom *find_imsm_efi(struct sys_dev *hba)
 
 		return NULL;
 	case SYS_DEV_SATA:
-		if (hba->class != PCI_CLASS_RAID_CNTRL)
+		if (hba->class != PCI_CLASS_RAID_CNTRL &&
+		    hba->class != PCI_CLASS_SATA_HBA)
 			return NULL;
 
 		for (i = 0; i < ARRAY_SIZE(sata_efivars); i++) {
-- 
2.35.3

