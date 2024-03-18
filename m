Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE076535A9
	for <linux-raid@vger.kernel.org>; Mon, 18 Mar 2024 16:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710779180; cv=none; b=JO8HASZz7aavQGiBJgLIx8ZMLZQbrtxqoGdT8UNClijGGTlddLLKRuZkMhAAuiSjyNv+V3IJiqHg6z/1gKWnOeuN5Sbl8C+pEQGeaUXBEzHDsLL+Mxds0nDRjm1N/82sPSViLw9g1jIJtAdxJOrQ5UPJS3Y08oK0UqTaoT+1N7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710779180; c=relaxed/simple;
	bh=LGJc53PNbHrXJvEvucZHjuTSfkdixUT7X6rBDeGQ5oQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ry3UCRWKSb+PEc2eXouodLI20lV9dW7lCusHjtkKlvcLu3jcIR/ZBsj1GCEiTXXoxnpSUWROH/kGescJZ6FV3y9DX+VDtzH/Y37Jb7gT6LlboRf+of5UuukkF+aimA/TtRgzoc49LKyoew45g4K8eZSmO4FHtjm3aXzPh6VjWsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eF3TKHTF; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eF3TKHTF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710779178; x=1742315178;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LGJc53PNbHrXJvEvucZHjuTSfkdixUT7X6rBDeGQ5oQ=;
  b=eF3TKHTFb0RUxH2oKd16IcIobzIYAx3g4zF4YxAQcxQIyjbkYqEg4dz0
   68q4+O+URAiSYGAz3vFgISRP37yutfOEoirenRDrz/gT7ATbkC/vdK6VI
   jsfoT/heP+jg864+JvM/3T7NY595j00CY3FcLYv8EXJguTSi+EvIZuRpN
   99efuDbtpnr0sITO/UpAfYIFfODztU9rbpwOjeDM6tWX2P84IfWErE6Bn
   2B7hCP/pXRkB3EAuEbtISFE9E6AoTX/B5fOw6sRmqe7YS/JTlwi3/ahnD
   jvkJoY7DARaE6dxUo63amQ8Wjc9Awu4mlCmCOp8fFLDfgO9R3JApjmXAp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="5453369"
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="5453369"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 09:26:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="13554006"
Received: from linux-myjy.igk.intel.com ([10.102.108.92])
  by orviesa009.jf.intel.com with ESMTP; 18 Mar 2024 09:26:06 -0700
From: Blazej Kucman <blazej.kucman@intel.com>
To: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
Subject: [PATCH 2/5] Add reading SATA encryption information
Date: Mon, 18 Mar 2024 17:25:32 +0100
Message-Id: <20240318162535.13674-3-blazej.kucman@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240318162535.13674-1-blazej.kucman@intel.com>
References: <20240318162535.13674-1-blazej.kucman@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Functionality reads information about SATA disk encryption.
Technical documentation used is given in the implementation.

The implementation is able to recognized two encryption standards
for SATA drives OPAL and ATA security.

If the SATA drive supports OPAL, encryption status and
ability are completed based on Opal Level 0 discovery response,
for ATA security, based on ATA identify response.
If SATA supports OPAL, ability is set to "SED",
for ATA security to "Other".

SED(Self-Encrypting Drive) is commonly used to describe drive
which using OPAL or Enterprise standards developed by
Trusted Computing Group.
Ability "Other" is used for ATA security because we rely only on
information from ATA identify which describe the overall
state of encryption.

It is allowed to mix disks with different encryption ability
such as "SED" and "Other" and it is not security gap.

Motivation for adding this functionality is to block mixing of disks
in IMSM arrays with encryption enabled and disabled.
The main goal is to not allow stealing data by rebuilding array to not
encrypted drive which can be read elsewhere.

For SATA Opal drives, libata allow_tmp parameter enabled
is required, which is necessary for Opal Security commands to work,
therefore, if the parameter is not enabled, SATA Opal disk cannot
be used in case the encryption will be checked by metadata.

Implemented functions will be used in one of the next patches.
In one of the next patches, a flag will be added to enable
disabling SATA Opal encryption checking due to allow_tpm kernel
setting dependency.

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
---
 drive_encryption.c | 318 +++++++++++++++++++++++++++++++++++++++++++++
 drive_encryption.h |   3 +
 mdadm.h            |   1 +
 sysfs.c            |  29 +++++
 4 files changed, 351 insertions(+)

diff --git a/drive_encryption.c b/drive_encryption.c
index 0fa214a9..8421e374 100644
--- a/drive_encryption.c
+++ b/drive_encryption.c
@@ -10,8 +10,12 @@
 
 #include <asm/types.h>
 #include <linux/nvme_ioctl.h>
+#include <scsi/sg.h>
+#include <scsi/scsi.h>
 #include "drive_encryption.h"
 
+#define DEFAULT_SECTOR_SIZE (512)
+
 /*
  * Opal defines
  * TCG Storage Opal SSC 2.01 chapter 3.3.3
@@ -34,6 +38,35 @@
 #define NVME_OACS_BYTE_POSITION (256)
 #define NVME_IDENTIFY_CONTROLLER_DATA (1)
 
+/*
+ * ATA defines
+ * ATA/ATAPI Command Set ATA8-ACS
+ * SCSI / ATA Translation - 3 (SAT-3)
+ * SCSI Primary Commands - 4 (SPC-4)
+ * AT Attachment-8 - ATA Serial Transport (ATA8-AST)
+ * ATA Command Pass-Through
+ */
+#define ATA_IDENTIFY (0xec)
+#define ATA_TRUSTED_RECEIVE (0x5c)
+#define ATA_SECURITY_WORD_POSITION (128)
+#define HDIO_DRIVE_CMD (0x031f)
+#define ATA_TRUSTED_COMPUTING_POS (48)
+#define ATA_PASS_THROUGH_12 (0xa1)
+#define ATA_IDENTIFY_RESPONSE_LEN (512)
+#define ATA_PIO_DATA_IN (4)
+#define SG_CHECK_CONDITION (0x02)
+#define ATA_STATUS_RETURN_DESCRIPTOR (0x09)
+#define ATA_PT_INFORMATION_AVAILABLE_ASCQ (0x1d)
+#define ATA_PT_INFORMATION_AVAILABLE_ASC (0x00)
+#define ATA_INQUIRY_LENGTH (0x0c)
+#define SG_INTERFACE_ID 'S'
+#define SG_IO_TIMEOUT (60000)
+#define SG_SENSE_SIZE (32)
+#define SENSE_DATA_CURRENT_FIXED (0x70)
+#define SENSE_DATA_CURRENT_DESC (0x72)
+#define SENSE_CURRENT_RES_DESC_POS (8)
+#define SG_DRIVER_SENSE	(0x08)
+
 typedef enum drive_feature_support_status {
 	/* Drive feature is supported. */
 	DRIVE_FEAT_SUP_ST = 0,
@@ -87,6 +120,27 @@ typedef struct supported_security_protocols {
 	__u8  list[504];
 } supported_security_protocols_t;
 
+/* ATA/ATAPI Command Set - 3 (ACS-3), Table 45 */
+typedef struct ata_security_status {
+	__u16 security_supported : 1;
+	__u16 security_enabled : 1;
+	__u16 security_locked : 1;
+	__u16 security_frozen : 1;
+	__u16 security_count_expired : 1;
+	__u16 enhanced_security_erase_supported : 1;
+	__u16 reserved1 : 2;
+	__u16 security_level : 1;
+	__u16 reserved2 : 7;
+} __attribute__((__packed__)) ata_security_status_t;
+
+/* ATA/ATAPI Command Set - 3 (ACS-3), Table 45 */
+typedef struct ata_trusted_computing {
+	__u16 tc_feature :1;
+	__u16 reserved : 13;
+	__u16 var1 : 1;
+	__u16 var2 : 1;
+} __attribute__((__packed__)) ata_trusted_computing_t;
+
 /**
  * get_opal_locking_feature_description() - get opal locking feature description.
  * @response: response from Opal Discovery Level 0.
@@ -360,3 +414,267 @@ get_nvme_opal_encryption_informations(int disk_fd, encryption_information_t *inf
 
 	return status;
 }
+
+/**
+ * ata_pass_through12_ioctl() - ata pass through12 ioctl.
+ * @disk_fd: a disk file descriptor.
+ * @ata_command: ata command.
+ * @sec_protocol: security protocol.
+ * @comm_id: additional command id.
+ * @response_buffer: response buffer to fill out.
+ * @buf_size: response buffer size.
+ * @verbose: verbose flag.
+ *
+ * Based on the documentations ATA Command Pass-Through, chapter 13.2.2 and
+ * ATA Translation - 3 (SAT-3), send read ata pass through 12 command via ioctl().
+ * On success, @response_buffer will be completed.
+ *
+ * Return: %MDADM_STATUS_SUCCESS on success, %MDADM_STATUS_ERROR on fail.
+ */
+static mdadm_status_t
+ata_pass_through12_ioctl(int disk_fd, __u8 ata_command,  __u8 sec_protocol, __u16 comm_id,
+			 void *response_buffer, size_t buf_size, const int verbose)
+{
+	__u8 cdb[ATA_INQUIRY_LENGTH] = {0};
+	__u8 sense[SG_SENSE_SIZE] = {0};
+	__u8 *sense_desc = NULL;
+	sg_io_hdr_t sg = {0};
+
+	/*
+	 * ATA Command Pass-Through, chapter 13.2.2
+	 * SCSI Primary Commands - 4 (SPC-4)
+	 * ATA Translation - 3 (SAT-3)
+	 */
+	cdb[0] = ATA_PASS_THROUGH_12;
+	/* protocol, bits 1-4 */
+	cdb[1] = ATA_PIO_DATA_IN << 1;
+	/* Bytes: CK_COND=1, T_DIR = 1, BYTE_BLOCK = 1, Length in Sector Count = 2 */
+	cdb[2] = 0x2E;
+	cdb[3] = sec_protocol;
+	/* Sector count */
+	cdb[4] = buf_size / DEFAULT_SECTOR_SIZE;
+	cdb[6] = (comm_id) & 0xFF;
+	cdb[7] = (comm_id >> 8) & 0xFF;
+	cdb[9] = ata_command;
+
+	sg.interface_id = SG_INTERFACE_ID;
+	sg.cmd_len = sizeof(cdb);
+	sg.mx_sb_len = sizeof(sense);
+	sg.dxfer_direction = SG_DXFER_FROM_DEV;
+	sg.dxfer_len = buf_size;
+	sg.dxferp = response_buffer;
+	sg.cmdp = cdb;
+	sg.sbp = sense;
+	sg.timeout = SG_IO_TIMEOUT;
+	sg.usr_ptr = NULL;
+
+	if (ioctl(disk_fd, SG_IO, &sg) < 0) {
+		pr_vrb("Failed ata passthrough12 ioctl. Device: /dev/%s.\n", fd2kname(disk_fd));
+		return MDADM_STATUS_ERROR;
+	}
+
+	if ((sg.status && sg.status != SG_CHECK_CONDITION) || sg.host_status ||
+	    (sg.driver_status && sg.driver_status != SG_DRIVER_SENSE)) {
+		pr_vrb("Failed ata passthrough12 ioctl. Device: /dev/%s.\n", fd2kname(disk_fd));
+		pr_vrb("SG_IO error: ATA_12 Status: %d Host Status: %d, Driver Status: %d\n",
+		       sg.status, sg.host_status, sg.driver_status);
+		return MDADM_STATUS_ERROR;
+	}
+
+	/* verify expected sense response code */
+	if (!(sense[0] == SENSE_DATA_CURRENT_DESC || sense[0] == SENSE_DATA_CURRENT_FIXED)) {
+		pr_vrb("Failed ata passthrough12 ioctl. Device: /dev/%s.\n", fd2kname(disk_fd));
+		return MDADM_STATUS_ERROR;
+	}
+
+	sense_desc = sense + SENSE_CURRENT_RES_DESC_POS;
+	/* verify sense data current response with descriptor format */
+	if (sense[0] == SENSE_DATA_CURRENT_DESC &&
+	    !(sense_desc[0] == ATA_STATUS_RETURN_DESCRIPTOR &&
+	    sense_desc[1] == ATA_INQUIRY_LENGTH)) {
+		pr_vrb("Failed ata passthrough12 ioctl. Device: /dev/%s. Sense data ASC: %d, ASCQ: %d.\n",
+		       fd2kname(disk_fd), sense[2], sense[3]);
+		return MDADM_STATUS_ERROR;
+	}
+
+	/* verify sense data current response with fixed format */
+	if (sense[0] == SENSE_DATA_CURRENT_FIXED &&
+	    !(sense[12] == ATA_PT_INFORMATION_AVAILABLE_ASC &&
+	    sense[13] == ATA_PT_INFORMATION_AVAILABLE_ASCQ)) {
+		pr_vrb("Failed ata passthrough12 ioctl. Device: /dev/%s. Sense data ASC: %d, ASCQ: %d.\n",
+		       fd2kname(disk_fd), sense[12], sense[13]);
+		return MDADM_STATUS_ERROR;
+	}
+
+	return MDADM_STATUS_SUCCESS;
+}
+
+/**
+ * is_sec_prot_01h_supported_ata() - check if security protocol 01h supported for given SATA disk.
+ * @disk_fd: a disk file descriptor.
+ * @verbose: verbose flag.
+ *
+ * Return: %DRIVE_FEAT_SUP_ST if TCG_SECP_01 supported, %DRIVE_FEAT_NOT_SUP_ST if not supported,
+ * %DRIVE_FEAT_CHECK_FAILED_ST if failed.
+ */
+static drive_feat_sup_st is_sec_prot_01h_supported_ata(int disk_fd, const int verbose)
+{
+	supported_security_protocols_t security_protocols;
+
+	mdadm_status_t result = ata_pass_through12_ioctl(disk_fd, ATA_TRUSTED_RECEIVE, TCG_SECP_00,
+							 0x0, &security_protocols,
+							 sizeof(security_protocols), verbose);
+	if (result)
+		return DRIVE_FEAT_CHECK_FAILED_ST;
+
+	if (is_sec_prot_01h_supported(&security_protocols))
+		return DRIVE_FEAT_SUP_ST;
+
+	return DRIVE_FEAT_NOT_SUP_ST;
+}
+
+/**
+ * is_ata_trusted_computing_supported() - check if ata trusted computing supported.
+ * @buffer: buffer with ATA identify response, not NULL.
+ *
+ * Return: true if trusted computing bit set, false otherwise.
+ */
+bool is_ata_trusted_computing_supported(__u16 *buffer)
+{
+	/* Added due to warnings from the compiler about a possible uninitialized variable below. */
+	assert(buffer);
+
+	__u16 security_tc_frame = __le16_to_cpu(buffer[ATA_TRUSTED_COMPUTING_POS]);
+	ata_trusted_computing_t *security_tc = (ata_trusted_computing_t *)&security_tc_frame;
+
+	if (security_tc->tc_feature == 1)
+		return true;
+
+	return false;
+}
+
+/**
+ * get_ata_standard_security_status() - get ATA disk encryption information from ATA identify.
+ * @buffer: buffer with response from ATA identify, not NULL.
+ * @information: struct to fill out, describing encryption status of disk.
+ *
+ * The function based on the Security status frame from ATA identify,
+ * completed encryption information.
+ * For possible encryption statuses and abilities,
+ * please refer to enums &encryption_status and &encryption_ability.
+ *
+ * Return: %MDADM_STATUS_SUCCESS on success, %MDADM_STATUS_ERROR on fail.
+ */
+static mdadm_status_t get_ata_standard_security_status(__u16 *buffer,
+						       struct encryption_information *information)
+{
+	/* Added due to warnings from the compiler about a possible uninitialized variable below. */
+	assert(buffer);
+
+	__u16 security_status_frame = __le16_to_cpu(buffer[ATA_SECURITY_WORD_POSITION]);
+	ata_security_status_t *security_status = (ata_security_status_t *)&security_status_frame;
+
+	if (!security_status->security_supported) {
+		information->ability = ENA_NONE;
+		information->status = ENS_UNENCRYPTED;
+
+		return MDADM_STATUS_SUCCESS;
+	}
+
+	information->ability = ENA_OTHER;
+
+	if (security_status->security_enabled == 0)
+		information->status = ENS_UNENCRYPTED;
+	else if (security_status->security_locked == 1)
+		information->status = ENS_LOCKED;
+	else
+		information->status = ENS_UNLOCKED;
+
+	return MDADM_STATUS_SUCCESS;
+}
+
+/**
+ * is_ata_opal() - check if SATA disk support Opal.
+ * @disk_fd: a disk file descriptor.
+ * @buffer: buffer with ATA identify response.
+ * @verbose: verbose flag.
+ *
+ * Return: %DRIVE_FEAT_SUP_ST if TCG_SECP_01 supported, %DRIVE_FEAT_NOT_SUP_ST if not supported,
+ * %DRIVE_FEAT_CHECK_FAILED_ST if failed to check.
+ */
+static drive_feat_sup_st is_ata_opal(int disk_fd, __u16 *buffer_identify, const int verbose)
+{
+	bool tc_status = is_ata_trusted_computing_supported(buffer_identify);
+	drive_feat_sup_st tcg_sec_prot_status;
+
+	if (!tc_status)
+		return DRIVE_FEAT_NOT_SUP_ST;
+
+	tcg_sec_prot_status = is_sec_prot_01h_supported_ata(disk_fd, verbose);
+
+	if (tcg_sec_prot_status == DRIVE_FEAT_CHECK_FAILED_ST) {
+		pr_vrb("Failed to verify if security protocol 01h supported. Device /dev/%s.\n",
+		       fd2kname(disk_fd));
+		return DRIVE_FEAT_CHECK_FAILED_ST;
+	}
+
+	if (tc_status && tcg_sec_prot_status == DRIVE_FEAT_SUP_ST)
+		return DRIVE_FEAT_SUP_ST;
+
+	return DRIVE_FEAT_NOT_SUP_ST;
+}
+
+/**
+ * get_ata_encryption_information() - get ATA disk encryption information.
+ * @disk_fd: a disk file descriptor.
+ * @information: struct to fill out, describing encryption status of disk.
+ * @verbose: verbose flag.
+ *
+ * The function reads information about encryption, if the disk supports Opal,
+ * the information is completed based on Opal Level 0 discovery, otherwise,
+ * based on ATA security status frame from ATA identification response.
+ * For possible encryption statuses and abilities,
+ * please refer to enums &encryption_status and &encryption_ability.
+ *
+ * Based on the documentations ATA/ATAPI Command Set ATA8-ACS and
+ * AT Attachment-8 - ATA Serial Transport (ATA8-AST).
+ *
+ * Return: %MDADM_STATUS_SUCCESS on success, %MDADM_STATUS_ERROR on fail.
+ */
+mdadm_status_t
+get_ata_encryption_information(int disk_fd, struct encryption_information *information,
+			       const int verbose)
+{
+	__u8 buffer_opal_level0_discovery[OPAL_IO_BUFFER_LEN] = {0};
+	__u16 buffer_identify[ATA_IDENTIFY_RESPONSE_LEN] = {0};
+	drive_feat_sup_st ata_opal_status;
+	mdadm_status_t status;
+
+	/* Get disk ATA identification */
+	status = ata_pass_through12_ioctl(disk_fd, ATA_IDENTIFY, 0x0, 0x0, buffer_identify,
+					  sizeof(buffer_identify), verbose);
+	if (status == MDADM_STATUS_ERROR)
+		return MDADM_STATUS_ERROR;
+
+	if (is_ata_trusted_computing_supported(buffer_identify) &&
+	    !sysfs_is_libata_allow_tpm_enabled(verbose)) {
+		pr_vrb("For SATA with Trusted Computing support, required libata.tpm_enabled=1.\n");
+		return MDADM_STATUS_ERROR;
+	}
+
+	ata_opal_status = is_ata_opal(disk_fd, buffer_identify, verbose);
+	if (ata_opal_status == DRIVE_FEAT_CHECK_FAILED_ST)
+		return MDADM_STATUS_ERROR;
+
+	if (ata_opal_status == DRIVE_FEAT_NOT_SUP_ST)
+		return get_ata_standard_security_status(buffer_identify, information);
+
+	/* SATA Opal */
+	status = ata_pass_through12_ioctl(disk_fd, ATA_TRUSTED_RECEIVE, TCG_SECP_01,
+					  OPAL_DISCOVERY_COMID, buffer_opal_level0_discovery,
+					  OPAL_IO_BUFFER_LEN, verbose);
+	if (status != MDADM_STATUS_SUCCESS)
+		return MDADM_STATUS_ERROR;
+
+	return get_opal_encryption_informations(buffer_opal_level0_discovery, information);
+}
diff --git a/drive_encryption.h b/drive_encryption.h
index 27f1de55..01405e1e 100644
--- a/drive_encryption.h
+++ b/drive_encryption.h
@@ -30,3 +30,6 @@ typedef struct encryption_information {
 mdadm_status_t
 get_nvme_opal_encryption_informations(int disk_fd, struct encryption_information *information,
 				      const int verbose);
+mdadm_status_t
+get_ata_encryption_information(int disk_fd, struct encryption_information *information,
+			       const int verbose);
diff --git a/mdadm.h b/mdadm.h
index 141adbd7..f64bb783 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -853,6 +853,7 @@ extern int restore_stripes(int *dest, unsigned long long *offsets,
 			   int source, unsigned long long read_offset,
 			   unsigned long long start, unsigned long long length,
 			   char *src_buf);
+extern bool sysfs_is_libata_allow_tpm_enabled(const int verbose);
 
 #ifndef Sendmail
 #define Sendmail "/usr/lib/sendmail -t"
diff --git a/sysfs.c b/sysfs.c
index 230b842e..24790896 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -1123,3 +1123,32 @@ void sysfsline(char *line)
 	sr->next = sysfs_rules;
 	sysfs_rules = sr;
 }
+
+/**
+ * sysfs_is_libata_allow_tpm_enabled() - check if libata allow_tmp is enabled.
+ * @verbose: verbose flag.
+ *
+ * Check if libata allow_tmp flag is set, this is required for SATA Opal Security commands to work.
+ *
+ * Return: true if allow_tpm enable, false otherwise.
+ */
+bool sysfs_is_libata_allow_tpm_enabled(const int verbose)
+{
+	const char *path = "/sys/module/libata/parameters/allow_tpm";
+	const char *expected_value = "1";
+	int fd = open(path, O_RDONLY);
+	char buf[3];
+
+	if (!is_fd_valid(fd)) {
+		pr_vrb("Failed open file descriptor to %s. Cannot check libata allow_tpm param.\n",
+		       path);
+		return false;
+	}
+
+	sysfs_fd_get_str(fd, buf, sizeof(buf));
+	close(fd);
+
+	if (strncmp(buf, expected_value, 1) == 0)
+		return true;
+	return false;
+}
-- 
2.35.3

