Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A2CC25B08
	for <linux-raid@archiver.kernel.org>; Fri,  5 Aug 2022 10:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237619AbiHEKGu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 Aug 2022 06:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236149AbiHEKGs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 5 Aug 2022 06:06:48 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB15367CA1
        for <linux-raid@vger.kernel.org>; Fri,  5 Aug 2022 03:06:46 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id uj29so4265389ejc.0
        for <linux-raid@vger.kernel.org>; Fri, 05 Aug 2022 03:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=kdE8pfCQyLCCtXJRRA4FdyA/shKFf4KIQgvHorI1wcs=;
        b=V1k+Ier9sA6LmWaask4mBCy56V9RyjmKjL4psexkabTW6gDqpu0MqNIXTp4rN+uWf8
         0EqvzkYdrQESu2bipYrwEm34I/gLzcLyq0kTQuqSxGAMs202BaHhaqkZLFkFH79tkcoT
         H3lSf5jicUaG4FI6Hu5jMgJK/JcNwijLRJq8Vzr1g9MbhlfhJ5bMl1GnoYraJEnVx2ZY
         /PDt5QRj9OSPuSC0orm5l6LVH9f3xAoXXH13ZOE37JTFyZ6f3Rlsnwn6CjaYl2YTdG1w
         vjZ1Fg/5r26iANUC15lebk6ivx+9UGoLqO9cJxpadt/xpvSSqtUxPpw3Gk6JV/+CA1W0
         fmqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=kdE8pfCQyLCCtXJRRA4FdyA/shKFf4KIQgvHorI1wcs=;
        b=xpP/smWQ6THm7HfOUM4q/G8r+++r4PMDev5RFfARa0m41gPFrw/69iunf6ia/tQoRu
         9FfmXe2ibTbt6qMPvUDP4vwxfy4uAoj2cBubwY/alcmvqp7UC6ctMiJ/CEdtcvcG1BwP
         E8HtkMnjeCI5yzor5Qx7R0QzGfzgVcKTTa3Mr8QltVBHYodJxfCay6r1meMiGJdZlYfu
         3sUwR7sz/Kv+CMK2sCR23o4ppZezrVSTkYFSz+lW/jL0MnJj5SGFrnBVun+8Vlg1NqQm
         r6FaHH/n4eRF+xRlHKJ6aDp+pcS8CsNttvHZKhzu3wDmn08Be6FIMm5CwNyLbGozDFJR
         VY3Q==
X-Gm-Message-State: ACgBeo2XFvJ91O/BuIJklH1vVNexHnJbk2djjkYanj2LvS6hukRAbbsB
        KB2urj8STccPzgQ1yI/aw5BMnlDwXoU=
X-Google-Smtp-Source: AA6agR703K0/WKzdWXJV5g+7TmEIkOtbANRw8E7zk26QV1tvRZYxJ7qPjQVReRbeIgmyavnBzlQM4g==
X-Received: by 2002:a17:907:1b25:b0:6da:8206:fc56 with SMTP id mp37-20020a1709071b2500b006da8206fc56mr4806209ejc.81.1659694005007;
        Fri, 05 Aug 2022 03:06:45 -0700 (PDT)
Received: from localhost-live.home.oldium.net (smtp.home.oldium.net. [77.48.26.242])
        by smtp.gmail.com with ESMTPSA id ca11-20020a170906a3cb00b007308812ce89sm1369206ejb.168.2022.08.05.03.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 03:06:44 -0700 (PDT)
From:   =?UTF-8?q?Old=C5=99ich=20Jedli=C4=8Dka?= <oldium.pro@gmail.com>
To:     linux-raid@vger.kernel.org
Cc:     =?UTF-8?q?Old=C5=99ich=20Jedli=C4=8Dka?= <oldium.pro@gmail.com>
Subject: [PATCH 1/1] mdadm: enable Intel Alderlake RST VMD configuration
Date:   Fri,  5 Aug 2022 12:05:45 +0200
Message-Id: <20220805100545.9369-2-oldium.pro@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220805100545.9369-1-oldium.pro@gmail.com>
References: <20220805100545.9369-1-oldium.pro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Alderlake changed UEFI variable name to 'RstVmdV' also and for VMD devices,
so check the updated name for VMD devices like it is done in the SATA case.

Signed-off-by: Oldřich Jedlička <oldium.pro@gmail.com>
---
 platform-intel.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index a4d55a3..2f8e6af 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -512,8 +512,8 @@ static const struct imsm_orom *find_imsm_hba_orom(struct sys_dev *hba)
 #define AHCI_PROP "RstSataV"
 #define AHCI_SSATA_PROP "RstsSatV"
 #define AHCI_TSATA_PROP "RsttSatV"
-#define AHCI_RST_PROP "RstVmdV"
-#define VMD_PROP "RstUefiV"
+#define RST_VMD_PROP "RstVmdV"
+#define RST_UEFI_PROP "RstUefiV"
 
 #define VENDOR_GUID \
 	EFI_GUID(0x193dfefa, 0xa445, 0x4302, 0x99, 0xd8, 0xef, 0x3a, 0xad, 0x1a, 0x04, 0xc6)
@@ -607,7 +607,8 @@ const struct imsm_orom *find_imsm_efi(struct sys_dev *hba)
 	struct orom_entry *ret;
 	static const char * const sata_efivars[] = {AHCI_PROP, AHCI_SSATA_PROP,
 						    AHCI_TSATA_PROP,
-						    AHCI_RST_PROP};
+						    RST_VMD_PROP};
+	static const char * const vmd_efivars[] = {RST_UEFI_PROP, RST_VMD_PROP};
 	unsigned long i;
 
 	if (check_env("IMSM_TEST_AHCI_EFI") || check_env("IMSM_TEST_SCU_EFI"))
@@ -640,10 +641,14 @@ const struct imsm_orom *find_imsm_efi(struct sys_dev *hba)
 
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
+		if (i == ARRAY_SIZE(vmd_efivars))
+			return NULL;
+		break;
 	default:
 		return NULL;
 	}
-- 
2.37.1

