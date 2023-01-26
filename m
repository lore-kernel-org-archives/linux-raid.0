Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A5EAC27C76
	for <linux-raid@archiver.kernel.org>; Thu, 26 Jan 2023 02:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbjAZCRF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Jan 2023 21:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjAZCRE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 25 Jan 2023 21:17:04 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6952936452
        for <linux-raid@vger.kernel.org>; Wed, 25 Jan 2023 18:17:03 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id m8so301411ili.7
        for <linux-raid@vger.kernel.org>; Wed, 25 Jan 2023 18:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=fsZ8NejK7CK6suhjdmVNf0jcnc8NL5fZC4QUdx4jx+I=;
        b=qJVezncqrhLdHBlmSpeXa9iqnlOdbEMOY9tJNg0ktGe0dcjTPuoB+Tr/d4Pbbt0kF5
         z/yLS9L55nEAXNjDL2xr2ZlVMZDzHzF5pDXftG4SIKXGqnAKdbZk+alS8dLYBU+TOPbi
         hN5EhGaGZswn/7dKjpkXhR1RViqVQXHN9izmYGvJWAyOVe8GRezxz9On5q5oKEve3QYM
         FKP7O9wX7nXFFh2pRl3TrPW4peVDO/a+kmcafIlXpf5usKnaAMAzy76hpNSftg9kRacg
         umxCKIvB6R1BqTVPC0rIG1Sx/xgSL/lCleW4+zhBdp62SBwLbn8cpCZ0lqzdsju7gZNN
         178A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fsZ8NejK7CK6suhjdmVNf0jcnc8NL5fZC4QUdx4jx+I=;
        b=xFc/AvAfvQT3n1TFjsmBI1yDVCaRGvN9myhW91mk4bE5KycAAAWo5f2QilRbI1t/eQ
         QCDoupgq20CKMjSOD67/GbVErZRJBU+nVCb24F3V3Y5NbgdHEMUOMARA/I1crn3Nf9v8
         LvlZFNLQFuFG9knCid+SdcybBqwAUVh5Z6lkjrQvmmJU0HienHibKTNzQis1PNzpq35M
         Bppv164GXWnjpjDQgUzwKFV8JjN0L5N3LzMg+WtIuLy/Ge5D7+C5IMJvwORSVZkXpfKZ
         4EyI4hNqlCzDz3OZs64ysGgafM15pACD2U33bhCzbNSCpOH0AshOkZ1UnKxW4i/laKD3
         vmQA==
X-Gm-Message-State: AO0yUKX7AtzXtta4rDDhdLV/scnWp/ULtDWuy/MH3V1fAOoNzfX8VbHl
        DI8OmgcgOMv8sYRiHOXAfsb07wyjEeOajQ==
X-Google-Smtp-Source: AK7set911oM/JWah1jGFgPnq1/dozn6bnbOd119scKV3dxVtEIHUX1OzT+78NQhj1ppLc+IwMpEw8Q==
X-Received: by 2002:a05:6e02:1c0f:b0:310:a3c6:f421 with SMTP id l15-20020a056e021c0f00b00310a3c6f421mr3383930ilh.8.1674699421943;
        Wed, 25 Jan 2023 18:17:01 -0800 (PST)
Received: from jump.. (135-23-64-249.cpe.pppoe.ca. [135.23.64.249])
        by smtp.gmail.com with ESMTPSA id g68-20020a025b47000000b003a52f4285d1sm47661jab.157.2023.01.25.18.17.00
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 18:17:01 -0800 (PST)
From:   Kevin Friedberg <kev.friedberg@gmail.com>
To:     linux-raid@vger.kernel.org
Subject: [PATCH] treat AHCI controllers under VMD as part of VMD
Date:   Wed, 25 Jan 2023 21:16:59 -0500
Message-Id: <20230126021659.3801-1-kev.friedberg@gmail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Detect when a SATA controller has been mapped under Intel Alderlake RST
VMD and list it as part of the domain, instead of independently, so that
it can use the VMD controller's RAID capabilities.

Signed-off-by: Kevin Friedberg <kev.friedberg@gmail.com>
---
 platform-intel.c | 15 +++++++++------
 super-intel.c    | 25 ++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 757f0b1b..859bf743 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -64,10 +64,12 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 
 	if (strcmp(driver, "isci") == 0)
 		type = SYS_DEV_SAS;
-	else if (strcmp(driver, "ahci") == 0)
+	else if (strcmp(driver, "ahci") == 0) {
+		/* if looking for sata devs, ignore vmd */
+		vmd = find_driver_devices("pci", "vmd");
 		type = SYS_DEV_SATA;
-	else if (strcmp(driver, "nvme") == 0) {
-		/* if looking for nvme devs, first look for vmd */
+	} else if (strcmp(driver, "nvme") == 0) {
+		/* if looking for nvme devs, also look for vmd */
 		vmd = find_driver_devices("pci", "vmd");
 		type = SYS_DEV_NVME;
 	} else if (strcmp(driver, "vmd") == 0)
@@ -104,8 +106,8 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 		sprintf(path, "/sys/bus/%s/drivers/%s/%s",
 			bus, driver, de->d_name);
 
-		/* if searching for nvme - skip vmd connected one */
-		if (type == SYS_DEV_NVME) {
+		/* if searching for nvme or ahci - skip vmd connected one */
+		if (type == SYS_DEV_NVME || type == SYS_DEV_SATA) {
 			struct sys_dev *dev;
 			char *rp = realpath(path, NULL);
 			for (dev = vmd; dev; dev = dev->next) {
@@ -166,7 +168,8 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 	}
 	closedir(driver_dir);
 
-	if (vmd) {
+	/* VMD adopts multiple types but should only be listed once */
+	if (vmd && type == SYS_DEV_NVME) {
 		if (list)
 			list->next = vmd;
 		else
diff --git a/super-intel.c b/super-intel.c
index 89fac626..4ef8f0d8 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2680,6 +2680,8 @@ static void print_imsm_capability_export(const struct imsm_orom *orom)
 	printf("IMSM_MAX_VOLUMES_PER_CONTROLLER=%d\n",orom->vphba);
 }
 
+#define PCI_CLASS_AHCI_CNTRL "0x010601"
+
 static int detail_platform_imsm(int verbose, int enumerate_only, char *controller_path)
 {
 	/* There are two components to imsm platform support, the ahci SATA
@@ -2752,11 +2754,32 @@ static int detail_platform_imsm(int verbose, int enumerate_only, char *controlle
 			for (hba = list; hba; hba = hba->next) {
 				if (hba->type == SYS_DEV_VMD) {
 					char buf[PATH_MAX];
+					struct dirent *ent;
+					DIR *dir;
+
 					printf(" I/O Controller : %s (%s)\n",
 						vmd_domain_to_controller(hba, buf), get_sys_dev_type(hba->type));
+					dir = opendir(hba->path);
+					for (ent = readdir(dir); ent; ent = readdir(dir)) {
+						char ent_path[PATH_MAX];
+
+						sprintf(ent_path, "%s/%s", hba->path, ent->d_name);
+						devpath_to_char(ent_path, "class", buf, sizeof(buf), 0);
+						if (strcmp(buf, PCI_CLASS_AHCI_CNTRL) == 0) {
+							host_base = ahci_get_port_count(ent_path, &port_count);
+							if (ahci_enumerate_ports(ent_path, port_count, host_base, verbose)) {
+								if (verbose > 0)
+								pr_err("failed to enumerate ports on VMD SATA controller at %s.\n",
+									hba->pci_id);
+								result |= 2;
+							}
+						}
+					}
+					closedir(dir);
+
 					if (print_nvme_info(hba)) {
 						if (verbose > 0)
-							pr_err("failed to get devices attached to VMD domain.\n");
+							pr_err("failed to get NVMe devices attached to VMD domain.\n");
 						result |= 2;
 					}
 				}
-- 
2.39.0

