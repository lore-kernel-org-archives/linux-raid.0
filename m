Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23616C636CC
	for <linux-raid@archiver.kernel.org>; Thu, 16 Feb 2023 04:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjBPElo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Feb 2023 23:41:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBPElm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Feb 2023 23:41:42 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4930D28222
        for <linux-raid@vger.kernel.org>; Wed, 15 Feb 2023 20:41:41 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id v17so1043272qto.3
        for <linux-raid@vger.kernel.org>; Wed, 15 Feb 2023 20:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OoyTFc43eYXfuZ/sdaSlncWbBAOaB42jgN1w4jGMTGU=;
        b=Dk5faSTwfM4AA5DYCfDc3Jzg/2vIVeWj+V2FNf0kYKCivuucENZEBumrasfVRx7SdZ
         F3mut5nQXJJf9c787p7FVrse6ShV9a+NBCWKzn0tEhxb9pwfpWRFRSmAvAYn71XTzvb5
         NlyUydvH7t3X112d0zuqjvE6GtQlnaabWgQBKmhskEtXDSi6HyRuF2Qf5g2BbzQdY6h1
         Ri9xXdOCBDFmRWDGOI589EXTJ11/b1jcwU/A1eOUAUvpGoo7c/BYBEAa7u8ma5UH7GZj
         LVFt/ZNxggOiVTcAWdoWEY5sV1NEdB1S9cR/+mxQ62RKPgmrIv4h3Fv52Fkv4D5Zj3t5
         MQ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OoyTFc43eYXfuZ/sdaSlncWbBAOaB42jgN1w4jGMTGU=;
        b=JtHVinbaf2ygZmTwI6/L3p4z8/g68KX46DeAana/cY3+C4E5oa7hBpoBGJy+/Jgs2P
         Q/bPtMnLxquoswCZAZGE2P7I/BD39T9TUJpXeJHAU8iADNFDoaa2Vqt0uVmiJTijhTDj
         jqLZCRWdj094Lcn2XzFTo07pAURPpmRwuyO6wo6BYCrqQJHBgdPoCP9kW2aa6bRMmmWV
         wYPQblt6pL+OvZv7XBSWBoCoUMkG/lSouY3eM5hdTVbIsnUzWRIifyRBOihmI7x4R8Ig
         KBvwf39gvnix8C2Q3C8n+R2ruJYPslx4ujcbZKXblJdeU/cakfkQcFsB7rLUmHC1dZeN
         ++UQ==
X-Gm-Message-State: AO0yUKXu649ccNJ8AeAhBwYs8BPL1y74M79CgC3B6S1zsAM8+DYM5Wx3
        IMfH4NdqR2MVa9Y/XNssZPy15YSGC84=
X-Google-Smtp-Source: AK7set8FpN8XmpO6Sfk+voDQAhzPQsahy16ntzqQ/dHRaLBkwSxU3y3sRD5ycL0g3AWOSfoX016vzQ==
X-Received: by 2002:ac8:58d1:0:b0:3a8:2ccb:f55d with SMTP id u17-20020ac858d1000000b003a82ccbf55dmr8370421qta.33.1676522500310;
        Wed, 15 Feb 2023 20:41:40 -0800 (PST)
Received: from jump.. (135-23-177-101.cpe.pppoe.ca. [135.23.177.101])
        by smtp.gmail.com with ESMTPSA id o13-20020ac8698d000000b003ba19e53e43sm571610qtq.25.2023.02.15.20.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 20:41:40 -0800 (PST)
From:   Kevin Friedberg <kev.friedberg@gmail.com>
To:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com
Cc:     Kevin Friedberg <kev.friedberg@gmail.com>
Subject: [PATCH] enable RAID for SATA under VMD
Date:   Wed, 15 Feb 2023 23:41:34 -0500
Message-Id: <20230216044134.30581-1-kev.friedberg@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Detect when a SATA controller has been mapped under Intel Alderlake RST
VMD, so that it can use the VMD controller's RAID capabilities. Create
new device type SYS_DEV_SATA_VMD and list separate controller to prevent
mixing with the NVMe SYS_DEV_VMD devices on the same VMD domain.

Signed-off-by: Kevin Friedberg <kev.friedberg@gmail.com>
---
 platform-intel.c | 21 ++++++++++++++++++---
 platform-intel.h |  1 +
 super-intel.c    | 28 ++++++++++++++++++----------
 3 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 757f0b1b..914164c0 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -64,9 +64,10 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 
 	if (strcmp(driver, "isci") == 0)
 		type = SYS_DEV_SAS;
-	else if (strcmp(driver, "ahci") == 0)
+	else if (strcmp(driver, "ahci") == 0) {
+		vmd = find_driver_devices("pci", "vmd");
 		type = SYS_DEV_SATA;
-	else if (strcmp(driver, "nvme") == 0) {
+	} else if (strcmp(driver, "nvme") == 0) {
 		/* if looking for nvme devs, first look for vmd */
 		vmd = find_driver_devices("pci", "vmd");
 		type = SYS_DEV_NVME;
@@ -115,6 +116,17 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 			free(rp);
 		}
 
+		/* change sata type if under a vmd controller */
+		if (type == SYS_DEV_SATA) {
+			struct sys_dev *dev;
+			char *rp = realpath(path, NULL);
+			for (dev = vmd; dev; dev = dev->next) {
+				if ((strncmp(dev->path, rp, strlen(dev->path)) == 0))
+					type = SYS_DEV_SATA_VMD;
+			}
+			free(rp);
+		}
+
 		/* if it's not Intel device or mark as VMD connected - skip it. */
 		if (devpath_to_vendor(path) != 0x8086 || skip == 1)
 			continue;
@@ -166,7 +178,8 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 	}
 	closedir(driver_dir);
 
-	if (vmd) {
+	/* nvme vmd needs a list separate from sata vmd */
+	if (vmd && type == SYS_DEV_NVME) {
 		if (list)
 			list->next = vmd;
 		else
@@ -273,6 +286,7 @@ struct sys_dev *find_intel_devices(void)
 		free_sys_dev(&intel_devices);
 
 	isci = find_driver_devices("pci", "isci");
+	/* Searching for AHCI will return list of SATA and SATA VMD controllers */
 	ahci = find_driver_devices("pci", "ahci");
 	/* Searching for NVMe will return list of NVMe and VMD controllers */
 	nvme = find_driver_devices("pci", "nvme");
@@ -638,6 +652,7 @@ const struct imsm_orom *find_imsm_efi(struct sys_dev *hba)
 
 		break;
 	case SYS_DEV_VMD:
+	case SYS_DEV_SATA_VMD:
 		for (i = 0; i < ARRAY_SIZE(vmd_efivars); i++) {
 			if (!read_efi_variable(&orom, sizeof(orom),
 						vmd_efivars[i], VENDOR_GUID))
diff --git a/platform-intel.h b/platform-intel.h
index 6238d23f..2c0f4e39 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -196,6 +196,7 @@ enum sys_dev_type {
 	SYS_DEV_SATA,
 	SYS_DEV_NVME,
 	SYS_DEV_VMD,
+	SYS_DEV_SATA_VMD,
 	SYS_DEV_MAX
 };
 
diff --git a/super-intel.c b/super-intel.c
index 89fac626..13671be1 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -626,7 +626,8 @@ static const char *_sys_dev_type[] = {
 	[SYS_DEV_SAS] = "SAS",
 	[SYS_DEV_SATA] = "SATA",
 	[SYS_DEV_NVME] = "NVMe",
-	[SYS_DEV_VMD] = "VMD"
+	[SYS_DEV_VMD] = "VMD",
+	[SYS_DEV_SATA_VMD] = "SATA VMD"
 };
 
 const char *get_sys_dev_type(enum sys_dev_type type)
@@ -2559,6 +2560,8 @@ static void print_found_intel_controllers(struct sys_dev *elem)
 
 		if (elem->type == SYS_DEV_VMD)
 			fprintf(stderr, "VMD domain");
+		else if (elem->type == SYS_DEV_SATA_VMD)
+			fprintf(stderr, "SATA VMD domain");
 		else
 			fprintf(stderr, "RAID controller");
 
@@ -2729,8 +2732,9 @@ static int detail_platform_imsm(int verbose, int enumerate_only, char *controlle
 		if (!find_imsm_capability(hba)) {
 			char buf[PATH_MAX];
 			pr_err("imsm capabilities not found for controller: %s (type %s)\n",
-				  hba->type == SYS_DEV_VMD ? vmd_domain_to_controller(hba, buf) : hba->path,
-				  get_sys_dev_type(hba->type));
+				  hba->type == SYS_DEV_VMD || hba->type == SYS_DEV_SATA_VMD ?
+				  vmd_domain_to_controller(hba, buf) :
+				  hba->path, get_sys_dev_type(hba->type));
 			continue;
 		}
 		result = 0;
@@ -2783,11 +2787,12 @@ static int detail_platform_imsm(int verbose, int enumerate_only, char *controlle
 
 			printf(" I/O Controller : %s (%s)\n",
 				hba->path, get_sys_dev_type(hba->type));
-			if (hba->type == SYS_DEV_SATA) {
+			if (hba->type == SYS_DEV_SATA || hba->type == SYS_DEV_SATA_VMD) {
 				host_base = ahci_get_port_count(hba->path, &port_count);
 				if (ahci_enumerate_ports(hba->path, port_count, host_base, verbose)) {
 					if (verbose > 0)
-						pr_err("failed to enumerate ports on SATA controller at %s.\n", hba->pci_id);
+						pr_err("failed to enumerate ports on %s controller at %s.\n",
+							get_sys_dev_type(hba->type), hba->pci_id);
 					result |= 2;
 				}
 			}
@@ -2817,7 +2822,8 @@ static int export_detail_platform_imsm(int verbose, char *controller_path)
 		if (!find_imsm_capability(hba) && verbose > 0) {
 			char buf[PATH_MAX];
 			pr_err("IMSM_DETAIL_PLATFORM_ERROR=NO_IMSM_CAPABLE_DEVICE_UNDER_%s\n",
-			hba->type == SYS_DEV_VMD ? vmd_domain_to_controller(hba, buf) : hba->path);
+				hba->type == SYS_DEV_VMD || hba->type == SYS_DEV_SATA_VMD ?
+				vmd_domain_to_controller(hba, buf) : hba->path);
 		}
 		else
 			result = 0;
@@ -2826,7 +2832,7 @@ static int export_detail_platform_imsm(int verbose, char *controller_path)
 	const struct orom_entry *entry;
 
 	for (entry = orom_entries; entry; entry = entry->next) {
-		if (entry->type == SYS_DEV_VMD) {
+		if (entry->type == SYS_DEV_VMD || entry->type == SYS_DEV_SATA_VMD) {
 			for (hba = list; hba; hba = hba->next)
 				print_imsm_capability_export(&entry->orom);
 			continue;
@@ -4742,10 +4748,12 @@ static int find_intel_hba_capability(int fd, struct intel_super *super, char *de
 				"    but the container is assigned to Intel(R) %s %s (",
 				devname,
 				get_sys_dev_type(hba_name->type),
-				hba_name->type == SYS_DEV_VMD ? "domain" : "RAID controller",
+				hba_name->type == SYS_DEV_VMD || hba_name->type == SYS_DEV_SATA_VMD ?
+					"domain" : "RAID controller",
 				hba_name->pci_id ? : "Err!",
 				get_sys_dev_type(super->hba->type),
-				hba->type == SYS_DEV_VMD ? "domain" : "RAID controller");
+				hba->type == SYS_DEV_VMD || hba_name->type == SYS_DEV_SATA_VMD ?
+					"domain" : "RAID controller");
 
 			while (hba) {
 				fprintf(stderr, "%s", hba->pci_id ? : "Err!");
@@ -11234,7 +11242,7 @@ static const char *imsm_get_disk_controller_domain(const char *path)
 		hba = find_disk_attached_hba(-1, path);
 		if (hba && hba->type == SYS_DEV_SAS)
 			drv = "isci";
-		else if (hba && hba->type == SYS_DEV_SATA)
+		else if (hba && (hba->type == SYS_DEV_SATA || hba->type == SYS_DEV_SATA_VMD))
 			drv = "ahci";
 		else if (hba && hba->type == SYS_DEV_VMD)
 			drv = "vmd";
-- 
2.39.1

