Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 648DDEB64DA
	for <linux-raid@archiver.kernel.org>; Wed,  5 Jul 2023 14:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbjGEOpJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 5 Jul 2023 10:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbjGEOo7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 5 Jul 2023 10:44:59 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21F719AE
        for <linux-raid@vger.kernel.org>; Wed,  5 Jul 2023 07:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688568296; x=1720104296;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HYfHDBMbheuDO8RYiAvfmHyZ2bQF780x1kRvdvMC17Y=;
  b=gDCKX03kx8d0492F2+wlsxJMXSresbsDIjtNfR8zc5hUzcAIzEEntAvJ
   fvWV7+12HtmVShY2VPDMW0XY9IooJapMIJGl8TDkNcQdo2uFrBkHy4YKK
   VMcW6+5TfYddymVA1H/c+E+GlfjjpwQq5dKP/RCORcLoBq/tAU/5ZUtOE
   7zoNrX963LA65fZWAlzAgSTCffI1HQ0xeqIQXlKyxwKj4HfAG//y74H1r
   iQ0eKyqcs4Hm9kvQrsbiZ6XIzEG1UpfKWEXz8uGj4gvO8LjO6FkLu/IxR
   LUgldTCM/wESQGafq72BcJ42eC2rZ/PITcd7h05qFGE3lOjrr3hZ9vd8d
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="429395194"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="429395194"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 07:44:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="832574971"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="832574971"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.104.85])
  by fmsmga002.fm.intel.com with ESMTP; 05 Jul 2023 07:44:53 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] imsm: Add reading vmd register for finding imsm capability
Date:   Wed,  5 Jul 2023 16:23:17 +0200
Message-Id: <20230705142317.13981-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Currently mdadm does not find imsm capability when running inside VM.
This patch adds the possibility to read from vmd register and check for
capability, effectively allowing to use mdadm with imsm inside virtual machines.

Additionally refactor find_imsm_capability() to make assignments in new
lines.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 platform-intel.c | 114 ++++++++++++++++++++++++++++++++++++++++++++++-
 platform-intel.h |  11 ++++-
 super-intel.c    |  11 +++--
 3 files changed, 130 insertions(+), 6 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 757f0b1b..888a4f66 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -688,6 +688,106 @@ const struct imsm_orom *find_imsm_nvme(struct sys_dev *hba)
 	return &nvme_orom->orom;
 }
 
+#define VMD_REGISTER_OFFSET		0x3FC
+#define VMD_REGISTER_SKU_SHIFT		1
+#define VMD_REGISTER_SKU_MASK		(0x00000007)
+#define VMD_REGISTER_SKU_PREMIUM	2
+#define MD_REGISTER_VER_MAJOR_SHIFT	4
+#define MD_REGISTER_VER_MAJOR_MASK	(0x0000000F)
+#define MD_REGISTER_VER_MINOR_SHIFT	8
+#define MD_REGISTER_VER_MINOR_MASK	(0x0000000F)
+
+/*
+ * read_vmd_register() - Reads VMD register and writes contents to buff ptr
+ * @buff: buffer for vmd register data, should be the size of uint32_t
+ *
+ * Return: 0 on success, 1 on error
+ */
+int read_vmd_register(uint32_t *buff, struct sys_dev *hba)
+{
+	int fd;
+	char vmd_pci_config_path[PATH_MAX];
+
+	if (!vmd_domain_to_controller(hba, vmd_pci_config_path))
+		return 1;
+
+	strncat(vmd_pci_config_path, "/config", PATH_MAX - strnlen(vmd_pci_config_path, PATH_MAX));
+
+	fd = open(vmd_pci_config_path, O_RDONLY);
+	if (fd < 0)
+		return 1;
+
+	if (pread(fd, buff, sizeof(uint32_t), VMD_REGISTER_OFFSET) != sizeof(uint32_t)) {
+		close(fd);
+		return 1;
+	}
+	close(fd);
+	return 0;
+}
+
+/*
+ * add_vmd_orom() - Adds VMD orom cap to orom list, writes orom_entry ptr into vmd_orom
+ * @vmd_orom: pointer to orom entry pointer
+ *
+ * Return: 0 on success, 1 on error
+ */
+int add_vmd_orom(struct orom_entry **vmd_orom, struct sys_dev *hba)
+{
+	uint8_t sku;
+	uint32_t vmd_register_data;
+	struct imsm_orom vmd_orom_cap = {
+		.signature = IMSM_VMD_OROM_COMPAT_SIGNATURE,
+		.sss = IMSM_OROM_SSS_4kB | IMSM_OROM_SSS_8kB |
+					IMSM_OROM_SSS_16kB | IMSM_OROM_SSS_32kB |
+					IMSM_OROM_SSS_64kB | IMSM_OROM_SSS_128kB,
+		.dpa = IMSM_OROM_DISKS_PER_ARRAY_NVME,
+		.tds = IMSM_OROM_TOTAL_DISKS_VMD,
+		.vpa = IMSM_OROM_VOLUMES_PER_ARRAY,
+		.vphba = IMSM_OROM_VOLUMES_PER_HBA_VMD,
+		.attr = IMSM_OROM_ATTR_2TB | IMSM_OROM_ATTR_2TB_DISK,
+		.driver_features = IMSM_OROM_CAPABILITIES_EnterpriseSystem |
+				   IMSM_OROM_CAPABILITIES_TPV
+	};
+
+	if (read_vmd_register(&vmd_register_data, hba) != 0)
+		return 1;
+
+	sku = (uint8_t)((vmd_register_data >> VMD_REGISTER_SKU_SHIFT) &
+		VMD_REGISTER_SKU_MASK);
+
+	if (sku == VMD_REGISTER_SKU_PREMIUM)
+		vmd_orom_cap.rlc = IMSM_OROM_RLC_RAID0 | IMSM_OROM_RLC_RAID1 |
+				   IMSM_OROM_RLC_RAID10 | IMSM_OROM_RLC_RAID5;
+	else
+		vmd_orom_cap.rlc = IMSM_OROM_RLC_RAID_CNG;
+
+	vmd_orom_cap.major_ver = (uint8_t)
+		((vmd_register_data >> MD_REGISTER_VER_MAJOR_SHIFT) &
+			MD_REGISTER_VER_MAJOR_MASK);
+	vmd_orom_cap.minor_ver = (uint8_t)
+		((vmd_register_data >> MD_REGISTER_VER_MINOR_SHIFT) &
+			MD_REGISTER_VER_MINOR_MASK);
+
+	*vmd_orom = add_orom(&vmd_orom_cap);
+
+	return 0;
+}
+
+const struct imsm_orom *find_imsm_vmd(struct sys_dev *hba)
+{
+	static struct orom_entry *vmd_orom;
+
+	if (hba->type != SYS_DEV_VMD)
+		return NULL;
+
+	if (!vmd_orom && add_vmd_orom(&vmd_orom, hba) != 0)
+		return NULL;
+
+	add_orom_device_id(vmd_orom, hba->dev_id);
+	vmd_orom->type = SYS_DEV_VMD;
+	return &vmd_orom->orom;
+}
+
 const struct imsm_orom *find_imsm_capability(struct sys_dev *hba)
 {
 	const struct imsm_orom *cap = get_orom_by_device_id(hba->dev_id);
@@ -697,9 +797,19 @@ const struct imsm_orom *find_imsm_capability(struct sys_dev *hba)
 
 	if (hba->type == SYS_DEV_NVME)
 		return find_imsm_nvme(hba);
-	if ((cap = find_imsm_efi(hba)) != NULL)
+
+	cap = find_imsm_efi(hba);
+	if (cap)
 		return cap;
-	if ((cap = find_imsm_hba_orom(hba)) != NULL)
+
+	if (hba->type == SYS_DEV_VMD) {
+		cap = find_imsm_vmd(hba);
+		if (cap)
+			return cap;
+	}
+
+	cap = find_imsm_hba_orom(hba);
+	if (cap)
 		return cap;
 
 	return NULL;
diff --git a/platform-intel.h b/platform-intel.h
index 6238d23f..62ad7219 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -24,6 +24,7 @@ struct imsm_orom {
 	__u8 signature[4];
 	#define IMSM_OROM_SIGNATURE "$VER"
 	#define IMSM_NVME_OROM_COMPAT_SIGNATURE "$NVM"
+	#define IMSM_VMD_OROM_COMPAT_SIGNATURE "$VMD"
 	__u8 table_ver_major; /* Currently 2 (can change with future revs) */
 	__u8 table_ver_minor; /* Currently 2 (can change with future revs) */
 	__u16 major_ver; /* Example: 8 as in 8.6.0.1020 */
@@ -65,11 +66,13 @@ struct imsm_orom {
 	__u16 tds; /* Total Disks Supported */
 	#define IMSM_OROM_TOTAL_DISKS 6
 	#define IMSM_OROM_TOTAL_DISKS_NVME 12
+	#define IMSM_OROM_TOTAL_DISKS_VMD 48
 	__u8 vpa; /* # Volumes Per Array supported */
 	#define IMSM_OROM_VOLUMES_PER_ARRAY 2
 	__u8 vphba; /* # Volumes Per Host Bus Adapter supported */
 	#define IMSM_OROM_VOLUMES_PER_HBA 4
 	#define IMSM_OROM_VOLUMES_PER_HBA_NVME 4
+	#define IMSM_OROM_VOLUMES_PER_HBA_VMD 24
 	/* Attributes supported. This should map to the
 	 * attributes in the MPB. Also, lower 16 bits
 	 * should match/duplicate RLC bits above.
@@ -182,7 +185,13 @@ static inline int imsm_orom_is_enterprise(const struct imsm_orom *orom)
 static inline int imsm_orom_is_nvme(const struct imsm_orom *orom)
 {
 	return memcmp(orom->signature, IMSM_NVME_OROM_COMPAT_SIGNATURE,
-			sizeof(orom->signature)) == 0;
+		      sizeof(orom->signature)) == 0;
+}
+
+static inline int imsm_orom_is_vmd_without_efi(const struct imsm_orom *orom)
+{
+	return memcmp(orom->signature, IMSM_VMD_OROM_COMPAT_SIGNATURE,
+		      sizeof(orom->signature)) == 0;
 }
 
 static inline int imsm_orom_has_tpv_support(const struct imsm_orom *orom)
diff --git a/super-intel.c b/super-intel.c
index a5c86cb2..2a2d006a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2646,9 +2646,14 @@ static void print_imsm_capability(const struct imsm_orom *orom)
 	else
 		printf("Rapid Storage Technology%s\n",
 			imsm_orom_is_enterprise(orom) ? " enterprise" : "");
-	if (orom->major_ver || orom->minor_ver || orom->hotfix_ver || orom->build)
-		printf("        Version : %d.%d.%d.%d\n", orom->major_ver,
-				orom->minor_ver, orom->hotfix_ver, orom->build);
+	if (orom->major_ver || orom->minor_ver || orom->hotfix_ver || orom->build) {
+		if (imsm_orom_is_vmd_without_efi(orom))
+			printf("        Version : %d.%d\n", orom->major_ver,
+			       orom->minor_ver);
+		else
+			printf("        Version : %d.%d.%d.%d\n", orom->major_ver,
+			       orom->minor_ver, orom->hotfix_ver, orom->build);
+	}
 	printf("    RAID Levels :%s%s%s%s%s\n",
 	       imsm_orom_has_raid0(orom) ? " raid0" : "",
 	       imsm_orom_has_raid1(orom) ? " raid1" : "",
-- 
2.26.2

