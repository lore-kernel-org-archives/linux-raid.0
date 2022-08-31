Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE71ECAAD1
	for <linux-raid@archiver.kernel.org>; Wed, 31 Aug 2022 17:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbiHaR6K (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 Aug 2022 13:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbiHaR6H (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 31 Aug 2022 13:58:07 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62D1D87C3
        for <linux-raid@vger.kernel.org>; Wed, 31 Aug 2022 10:58:06 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b44so19394924edf.9
        for <linux-raid@vger.kernel.org>; Wed, 31 Aug 2022 10:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=vCGf0U4+AGLdD0foW73xZ2g8LIDlLl9YxUwToinPD/E=;
        b=FpEC6uo9Wkx08kvtJ1ZFU08ZoH5X2He6T0mKGnqdjKLMjrd9w+6nYl+DwOasVjojem
         Xu+lltEM3G+ZF0HyTH3fnf7ElI0v28coDktvMOnpeptCUpOC16KTwjnal/5zVg08UiK1
         YH4QdhHDRBNlwaV3Ky+lHpZKhlecnwHFJLx+JKSJgwJzQTLW8XyHdvGMj3HcufneYS2c
         pp9uOcSjKtpR86uFpWSq8oCFfS9pkYDwfuhQJk7xEbwVL2mCA+32gObVgzU4PdvMjP1Z
         +ufnfqBzZNtxV0Pvlmh0tQUoTaEO/Q9wSipvxuLgZ7kZp1QJeWbLDCYzS7iZowaTyR58
         eWoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=vCGf0U4+AGLdD0foW73xZ2g8LIDlLl9YxUwToinPD/E=;
        b=eeRq9Hu4qKUM51ww6JsOTzC+4r8H4czWplh6pC+hy7UojBRiIFo56G2Zj7qHHeuZMF
         fEHRaYiet3Xo5HyrFmFwv7jmqwBC0Fvv9Oc3iuoHy5zVHoAu4OJclZsaCfavsXx1rRzg
         asD2TM6XL4qMjkuBfDQXgfAN62KO4EWLdhz2nLlZ+mlWTWhCXks1aF/o9jDx/2eiA8/v
         S9nZfx663Gqv/5R2mgxqrtXmjWH5/MoueQuedXJAOV3Zol1WqNivKLosgVn60yUiij0n
         2p22yLTuSAuvcybv8w/rczkKzvTc0sQYT6okRyrKy/C9PEXas/R2qIcSHMRDybO/PHqq
         CYow==
X-Gm-Message-State: ACgBeo1TRkkFlfo5mtWAjK3QBTfphAMjDuvPMnj61q2DUN16B2SOOAwk
        Qcg/U0lC1Ujm61ssfer7E9ruXrEfsCdvag==
X-Google-Smtp-Source: AA6agR6vwoGfPkL2LDqNuXVxY8eDi6QDURpfOFIQGSEaAZRE/E8nGfRKdzj/vsuImHttoFs/ysOasg==
X-Received: by 2002:a05:6402:e96:b0:443:a086:e3e8 with SMTP id h22-20020a0564020e9600b00443a086e3e8mr26204313eda.330.1661968684724;
        Wed, 31 Aug 2022 10:58:04 -0700 (PDT)
Received: from localhost.localdomain (smtp.home.oldium.net. [77.48.26.242])
        by smtp.gmail.com with ESMTPSA id g17-20020a17090604d100b0073d732e440asm7277564eja.84.2022.08.31.10.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 10:58:04 -0700 (PDT)
From:   =?UTF-8?q?Old=C5=99ich=20Jedli=C4=8Dka?= <oldium.pro@gmail.com>
To:     linux-raid@vger.kernel.org
Cc:     =?UTF-8?q?Old=C5=99ich=20Jedli=C4=8Dka?= <oldium.pro@gmail.com>
Subject: [PATCH v2] mdadm: added support for Intel Alderlake RST on VMD platform
Date:   Wed, 31 Aug 2022 19:57:29 +0200
Message-Id: <20220831175729.1020-1-oldium.pro@gmail.com>
X-Mailer: git-send-email 2.37.2.windows.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Alderlake RST on VMD uses RstVmdV UEFI variable name, so detect it.

Signed-off-by: Oldřich Jedlička <oldium.pro@gmail.com>
---
 platform-intel.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 5a8729e7..757f0b1b 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -512,7 +512,8 @@ static const struct imsm_orom *find_imsm_hba_orom(struct sys_dev *hba)
 #define AHCI_PROP "RstSataV"
 #define AHCI_SSATA_PROP "RstsSatV"
 #define AHCI_TSATA_PROP "RsttSatV"
-#define VMD_PROP "RstUefiV"
+#define VROC_VMD_PROP "RstUefiV"
+#define RST_VMD_PROP "RstVmdV"
 
 #define VENDOR_GUID \
 	EFI_GUID(0x193dfefa, 0xa445, 0x4302, 0x99, 0xd8, 0xef, 0x3a, 0xad, 0x1a, 0x04, 0xc6)
@@ -605,6 +606,7 @@ const struct imsm_orom *find_imsm_efi(struct sys_dev *hba)
 	struct orom_entry *ret;
 	static const char * const sata_efivars[] = {AHCI_PROP, AHCI_SSATA_PROP,
 						    AHCI_TSATA_PROP};
+	static const char * const vmd_efivars[] = {VROC_VMD_PROP, RST_VMD_PROP};
 	unsigned long i;
 
 	if (check_env("IMSM_TEST_AHCI_EFI") || check_env("IMSM_TEST_SCU_EFI"))
@@ -636,10 +638,16 @@ const struct imsm_orom *find_imsm_efi(struct sys_dev *hba)
 
 		break;
 	case SYS_DEV_VMD:
-		if (!read_efi_variable(&orom, sizeof(orom), VMD_PROP,
-				       VENDOR_GUID))
-			break;
-		return NULL;
+		for (i = 0; i < ARRAY_SIZE(vmd_efivars); i++) {
+			if (!read_efi_variable(&orom, sizeof(orom),
+						vmd_efivars[i], VENDOR_GUID))
+				break;
+		}
+
+		if (i == ARRAY_SIZE(vmd_efivars))
+			return NULL;
+
+		break;
 	default:
 		return NULL;
 	}
-- 
2.37.2.windows.2

