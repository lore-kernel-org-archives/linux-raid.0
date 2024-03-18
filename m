Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5A9535B9
	for <linux-raid@vger.kernel.org>; Mon, 18 Mar 2024 16:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710779179; cv=none; b=b/rNW2sudeB+XUnKD+pxw3cpvZyv3UMzNl1ztE52DH5mWbiMH+YMtvbkg5Br7rrfH+be1/N66p0BnVy1NbjLzOCaqb0mKG+Gk5P/Qga5fUJa2+DBwfVD/bcXeoKb4LmENO9SFhXRKqY40q6wtmlCpWaf1hYcam93VADbiCXdfiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710779179; c=relaxed/simple;
	bh=C4Quv6q8kmTCNNhG7C6nMDv43ZJbBQIKEA43ThJwTq4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H+GCEETnokjvDRKBgm7zYWy1NcKZr0dA4/nZ9oQidYMpe3a02QwbzeeInXLIVWz72F276Lke6SWIlOeGpFYiB/be1xrWmb9IuYilh2RjBKYunaB3OKs0XT8YJRK5VVceQih0JCVPbwRTkg1Yoiqm9UX6Sexl043caddrtQ6T63s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JIkpra43; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JIkpra43"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710779177; x=1742315177;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C4Quv6q8kmTCNNhG7C6nMDv43ZJbBQIKEA43ThJwTq4=;
  b=JIkpra43/jgW6wnRrkrcYNLOAY3wAc32Cz8Lj/3Kg+hpOrR7Gcj2IqRp
   5RWARiWS1Uk90Fbvc2oE8U5Fj0Xls2kZwIDd25ggD+n+zzsREU4i2zdxA
   gK97uq9SZtmbnTk69JTEY9E9dE1ZdYkIAyVh2ws4MMdjZ3X7ZUZ3jzIC7
   R+GPJJ4NqaWlllga9FUoMqscnJfwuoY68bRxM8iPNhPWXvOi+kn/zHnHS
   aYqchbvzy5ThkwUcm4+1pc9SmbOJ3dO5gN70g2eGsv0tDcSxjqPmwGEMz
   t849ld/IxMQnLcWNxpZcXvcE7+3W27+yYYz5o6crYAr7T2FsTetp+D6Ct
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="5453362"
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="5453362"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 09:26:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="13554000"
Received: from linux-myjy.igk.intel.com ([10.102.108.92])
  by orviesa009.jf.intel.com with ESMTP; 18 Mar 2024 09:26:04 -0700
From: Blazej Kucman <blazej.kucman@intel.com>
To: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
Subject: [PATCH 1/5] Add reading Opal NVMe encryption information
Date: Mon, 18 Mar 2024 17:25:31 +0100
Message-Id: <20240318162535.13674-2-blazej.kucman@intel.com>
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

For NVMe devices with Opal support, encryption information, status and
ability are completed based on Opal Level 0 discovery response.
Technical documentation used is given in the implementation.

Ability in general describes what type of encryption is supported,
Status describes in what state the disk with encryption support is.
The current patch only includes only the implementation of reading
encryption information, functions will be used in one of
the next patches.

Motivation for adding this functionality is to block mixing of disks
in IMSM arrays with encryption enabled and disabled.
The main goal is to not allow stealing data by rebuilding array to not
encrypted drive which can be read elsewhere.

Value ENA_OTHER from enum encryption_ability will be used
in the next patch.

Additionally, pr_vrb define is moved from super-intel.c to mdadm.h
so that it can be used globally.

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
---
 Makefile           |   4 +-
 drive_encryption.c | 362 +++++++++++++++++++++++++++++++++++++++++++++
 drive_encryption.h |  32 ++++
 mdadm.h            |   2 +
 super-intel.c      |   2 -
 5 files changed, 398 insertions(+), 4 deletions(-)
 create mode 100644 drive_encryption.c
 create mode 100644 drive_encryption.h

diff --git a/Makefile b/Makefile
index cbdba49a..7c221a89 100644
--- a/Makefile
+++ b/Makefile
@@ -170,7 +170,7 @@ OBJS = mdadm.o config.o policy.o mdstat.o  ReadMe.o uuid.o util.o maps.o lib.o u
        mdopen.o super0.o super1.o super-ddf.o super-intel.o bitmap.o \
        super-mbr.o super-gpt.o \
        restripe.o sysfs.o sha1.o mapfile.o crc32.o sg_io.o msg.o xmalloc.o \
-       platform-intel.o probe_roms.o crc32c.o
+       platform-intel.o probe_roms.o crc32c.o drive_encryption.o
 
 CHECK_OBJS = restripe.o uuid.o sysfs.o maps.o lib.o xmalloc.o dlink.o
 
@@ -183,7 +183,7 @@ MON_OBJS = mdmon.o monitor.o managemon.o uuid.o util.o maps.o mdstat.o sysfs.o c
 	Kill.o sg_io.o dlink.o ReadMe.o super-intel.o \
 	super-mbr.o super-gpt.o \
 	super-ddf.o sha1.o crc32.o msg.o bitmap.o xmalloc.o \
-	platform-intel.o probe_roms.o crc32c.o
+	platform-intel.o probe_roms.o crc32c.o drive_encryption.o
 
 MON_SRCS = $(patsubst %.o,%.c,$(MON_OBJS))
 
diff --git a/drive_encryption.c b/drive_encryption.c
new file mode 100644
index 00000000..0fa214a9
--- /dev/null
+++ b/drive_encryption.c
@@ -0,0 +1,362 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Read encryption information for Opal and ATA devices.
+ *
+ * Copyright (C) 2024 Intel Corporation
+ *	Author: Blazej Kucman <blazej.kucman@intel.com>
+ */
+
+#include "mdadm.h"
+
+#include <asm/types.h>
+#include <linux/nvme_ioctl.h>
+#include "drive_encryption.h"
+
+/*
+ * Opal defines
+ * TCG Storage Opal SSC 2.01 chapter 3.3.3
+ * NVM ExpressTM Revision 1.4c, chapter 5
+ */
+#define TCG_SECP_01 (0x01)
+#define TCG_SECP_00 (0x00)
+#define OPAL_DISCOVERY_COMID (0x0001)
+#define OPAL_LOCKING_FEATURE (0x0002)
+#define OPAL_IO_BUFFER_LEN 2048
+#define OPAL_DISCOVERY_FEATURE_HEADER_LEN (4)
+
+/*
+ * NVMe defines
+ * NVM ExpressTM Revision 1.4c, chapter 5
+ */
+#define NVME_SECURITY_RECV (0x82)
+#define NVME_IDENTIFY (0x06)
+#define NVME_IDENTIFY_RESPONSE_LEN 4096
+#define NVME_OACS_BYTE_POSITION (256)
+#define NVME_IDENTIFY_CONTROLLER_DATA (1)
+
+typedef enum drive_feature_support_status {
+	/* Drive feature is supported. */
+	DRIVE_FEAT_SUP_ST = 0,
+	/* Drive feature is not supported. */
+	DRIVE_FEAT_NOT_SUP_ST,
+	/* Drive feature support check failed. */
+	DRIVE_FEAT_CHECK_FAILED_ST
+} drive_feat_sup_st;
+
+/* TCG Storage Opal SSC 2.01 chapter 3.1.1.3 */
+typedef struct opal_locking_feature {
+	/* feature header */
+	__u16 feature_code;
+	__u8 reserved : 4;
+	__u8 version : 4;
+	__u8 description_length;
+	/* feature description */
+	__u8 locking_supported : 1;
+	__u8 locking_enabled : 1;
+	__u8 locked : 1;
+	__u8 media_encryption : 1;
+	__u8 mbr_enabled : 1;
+	__u8 mbr_done : 1;
+	__u8 mbr_shadowing_not_supported : 1;
+	__u8 hw_reset_for_dor_supported : 1;
+	__u8 reserved1[11];
+} __attribute__((__packed__)) opal_locking_feature_t;
+
+/* TCG Storage Opal SSC 2.01 chapter 3.1.1.1 */
+typedef struct opal_level0_header {
+	__u32 length;
+	__u32 version;
+	__u64 reserved;
+	__u8 vendor_specific[32];
+} opal_level0_header_t;
+
+/**
+ * NVM ExpressTM Revision 1.4c, Figure 249
+ * Structure specifies only OACS filed, which is needed in the current use case.
+ */
+typedef struct nvme_identify_ctrl {
+	__u8 reserved[255];
+	__u16 oacs;
+	__u8 reserved2[3839];
+} nvme_identify_ctrl_t;
+
+/* SCSI Primary Commands - 4 (SPC-4), Table 512 */
+typedef struct supported_security_protocols {
+	__u8  reserved[6];
+	__u16 list_length;
+	__u8  list[504];
+} supported_security_protocols_t;
+
+/**
+ * get_opal_locking_feature_description() - get opal locking feature description.
+ * @response: response from Opal Discovery Level 0.
+ *
+ * Based on the documentation TCG Storage Opal SSC 2.01 chapter 3.1.1,
+ * a Locking feature is searched for in Opal Level 0 Discovery response.
+ *
+ * Return: if locking feature found pointer to struct %opal_locking_feature_t, NULL otherwise.
+ */
+static opal_locking_feature_t *get_opal_locking_feature_description(__u8 *response)
+{
+	opal_level0_header_t *response_header = (opal_level0_header_t *)response;
+	int features_length = __be32_to_cpu(response_header->length);
+	int current_position = sizeof(*response_header);
+
+	while (current_position < features_length) {
+		opal_locking_feature_t *feature;
+
+		feature = (opal_locking_feature_t *)(response + current_position);
+
+		if (__be16_to_cpu(feature->feature_code) == OPAL_LOCKING_FEATURE)
+			return feature;
+
+		current_position += feature->description_length + OPAL_DISCOVERY_FEATURE_HEADER_LEN;
+	}
+
+	return NULL;
+}
+
+/**
+ * nvme_security_recv_ioctl() - nvme security receive ioctl.
+ * @disk_fd: a disk file descriptor.
+ * @sec_protocol: security protocol.
+ * @comm_id: command id.
+ * @response_buffer: response buffer to fill out.
+ * @buf_size: response buffer size.
+ * @verbose: verbose flag.
+ *
+ * Based on the documentations TCG Storage Opal SSC 2.01 chapter 3.3.3 and
+ * NVM ExpressTM Revision 1.4c, chapter 5.25,
+ * read security receive command via ioctl().
+ * On success, @response_buffer is completed.
+ *
+ * Return: %MDADM_STATUS_SUCCESS on success, %MDADM_STATUS_ERROR otherwise.
+ */
+static mdadm_status_t
+nvme_security_recv_ioctl(int disk_fd, __u8 sec_protocol, __u16 comm_id, void *response_buffer,
+			 size_t buf_size, const int verbose)
+{
+	struct nvme_admin_cmd nvme_cmd = {0};
+	int status;
+
+	nvme_cmd.opcode = NVME_SECURITY_RECV;
+	nvme_cmd.cdw10 = sec_protocol << 24 | comm_id << 8;
+	nvme_cmd.cdw11 = buf_size;
+	nvme_cmd.data_len = buf_size;
+	nvme_cmd.addr = (__u64)response_buffer;
+
+	status = ioctl(disk_fd, NVME_IOCTL_ADMIN_CMD, &nvme_cmd);
+	if (status != 0) {
+		pr_vrb("Failed to read NVMe security receive ioctl() for device /dev/%s, status: %d\n",
+		       fd2kname(disk_fd), status);
+		return MDADM_STATUS_ERROR;
+	}
+
+	return MDADM_STATUS_SUCCESS;
+}
+
+/**
+ * nvme_identify_ioctl() - NVMe identify ioctl.
+ * @disk_fd: a disk file descriptor.
+ * @response_buffer: response buffer to fill out.
+ * @buf_size: response buffer size.
+ * @verbose: verbose flag.
+ *
+ * Based on the documentations TCG Storage Opal SSC 2.01 chapter 3.3.3 and
+ * NVM ExpressTM Revision 1.4c, chapter 5.25,
+ * read NVMe identify via ioctl().
+ * On success, @response_buffer will be completed.
+ *
+ * Return: %MDADM_STATUS_SUCCESS on success, %MDADM_STATUS_ERROR otherwise.
+ */
+static mdadm_status_t
+nvme_identify_ioctl(int disk_fd, void *response_buffer, size_t buf_size, const int verbose)
+{
+	struct nvme_admin_cmd nvme_cmd = {0};
+	int status;
+
+	nvme_cmd.opcode = NVME_IDENTIFY;
+	nvme_cmd.cdw10 = NVME_IDENTIFY_CONTROLLER_DATA;
+	nvme_cmd.data_len = buf_size;
+	nvme_cmd.addr = (__u64)response_buffer;
+
+	status = ioctl(disk_fd, NVME_IOCTL_ADMIN_CMD, &nvme_cmd);
+	if (status != 0) {
+		pr_vrb("Failed to read NVMe identify ioctl() for device /dev/%s, status: %d\n",
+		       fd2kname(disk_fd), status);
+		return MDADM_STATUS_ERROR;
+	}
+
+	return MDADM_STATUS_SUCCESS;
+}
+
+/**
+ * is_sec_prot_01h_supported() - check if security protocol 01h supported.
+ * @security_protocols: struct with response from disk (NVMe, SATA) describing supported
+ * security protocols.
+ *
+ * Return: true if TCG_SECP_01 found, false otherwise.
+ */
+static bool is_sec_prot_01h_supported(supported_security_protocols_t *security_protocols)
+{
+	int list_length = be16toh(security_protocols->list_length);
+	int index;
+
+	for (index = 0 ; index < list_length; index++) {
+		if (security_protocols->list[index] == TCG_SECP_01)
+			return true;
+	}
+
+	return false;
+}
+
+/**
+ * is_sec_prot_01h_supported_nvme() - check if security protocol 01h supported for given NVMe disk.
+ * @disk_fd: a disk file descriptor.
+ * @verbose: verbose flag.
+ *
+ * Return: %DRIVE_FEAT_SUP_ST if TCG_SECP_01 supported, %DRIVE_FEAT_NOT_SUP_ST if not supported,
+ * %DRIVE_FEAT_CHECK_FAILED_ST if failed to check.
+ */
+static drive_feat_sup_st is_sec_prot_01h_supported_nvme(int disk_fd, const int verbose)
+{
+	supported_security_protocols_t security_protocols = {0};
+
+	/* security_protocol: TCG_SECP_00, comm_id: not applicable */
+	if (nvme_security_recv_ioctl(disk_fd, TCG_SECP_00, 0x0, &security_protocols,
+				     sizeof(security_protocols), verbose))
+		return DRIVE_FEAT_CHECK_FAILED_ST;
+
+	if (is_sec_prot_01h_supported(&security_protocols))
+		return DRIVE_FEAT_SUP_ST;
+
+	return DRIVE_FEAT_NOT_SUP_ST;
+}
+
+/**
+ * is_nvme_sec_send_recv_supported() - check if Security Send and Security Receive is supported.
+ * @disk_fd: a disk file descriptor.
+ * @verbose: verbose flag.
+ *
+ * Check if "Optional Admin Command Support" bit 0 is set in NVMe identify.
+ * Bit 0 set to 1 means controller supports the Security Send and Security Receive commands.
+ *
+ * Return: %DRIVE_FEAT_SUP_ST if security send/receive supported,
+ * %DRIVE_FEAT_NOT_SUP_ST if not supported, %DRIVE_FEAT_CHECK_FAILED_ST if check failed.
+ */
+static drive_feat_sup_st is_nvme_sec_send_recv_supported(int disk_fd, const int verbose)
+{
+	nvme_identify_ctrl_t nvme_identify = {0};
+	int status = 0;
+
+	status = nvme_identify_ioctl(disk_fd, &nvme_identify, sizeof(nvme_identify), verbose);
+	if (status)
+		return DRIVE_FEAT_CHECK_FAILED_ST;
+
+	if ((__le16_to_cpu(nvme_identify.oacs) & 0x1) == 0x1)
+		return DRIVE_FEAT_SUP_ST;
+
+	return DRIVE_FEAT_NOT_SUP_ST;
+}
+
+/**
+ * get_opal_encryption_locking_informations() - get Opal Locking information.
+ * @buffer: buffer with Opal Level 0 Discovery response.
+ * @information: struct to fill out, describing encryption status of disk.
+ *
+ * If Locking feature frame is in response from Opal Level 0 discovery, &encryption_information_t
+ * structure is completed with status and ability otherwise the status is set to &None.
+ * For possible encryption statuses and abilities,
+ * please refer to enums &encryption_status and &encryption_ability.
+ *
+ * Return: %MDADM_STATUS_SUCCESS on success, %MDADM_STATUS_ERROR otherwise.
+ */
+static mdadm_status_t get_opal_encryption_informations(__u8 *buffer,
+						       encryption_information_t *information)
+{
+	opal_locking_feature_t *opal_locking_feature =
+					get_opal_locking_feature_description(buffer);
+
+	if (!opal_locking_feature)
+		return MDADM_STATUS_ERROR;
+
+	if (opal_locking_feature->locking_supported == 1) {
+		information->ability = ENA_SED;
+
+		if (opal_locking_feature->locking_enabled == 0)
+			information->status = ENS_UNENCRYPTED;
+		else if (opal_locking_feature->locked == 1)
+			information->status = ENS_LOCKED;
+		else
+			information->status = ENS_UNLOCKED;
+	} else {
+		information->ability = ENA_NONE;
+		information->status = ENS_UNENCRYPTED;
+	}
+
+	return MDADM_STATUS_SUCCESS;
+}
+
+/**
+ * get_nvme_opal_encryption_informations() - get NVMe Opal encryption information.
+ * @disk_fd: a disk file descriptor.
+ * @information: struct to fill out, describing encryption status of disk.
+ * @verbose: verbose flag.
+ *
+ * In case the disk supports Opal Level 0 discovery, &encryption_information_t structure
+ * is completed with status and ability based on ioctl response,
+ * otherwise the ability is set to %ENA_NONE and &status to %ENS_UNENCRYPTED.
+ * As the current use case does not need the knowledge of Opal support, if there is no support,
+ * %MDADM_STATUS_SUCCESS will be returned, with the values described above.
+ * For possible encryption statuses and abilities,
+ * please refer to enums &encryption_status and &encryption_ability.
+ *
+ * %MDADM_STATUS_SUCCESS on success, %MDADM_STATUS_ERROR otherwise.
+ */
+mdadm_status_t
+get_nvme_opal_encryption_informations(int disk_fd, encryption_information_t *information,
+				      const int verbose)
+{
+	__u8 buffer[OPAL_IO_BUFFER_LEN];
+	int sec_send_recv_supported = 0;
+	int protocol_01h_supported = 0;
+	mdadm_status_t status;
+
+	information->ability = ENA_NONE;
+	information->status = ENS_UNENCRYPTED;
+
+	sec_send_recv_supported = is_nvme_sec_send_recv_supported(disk_fd, verbose);
+	if (sec_send_recv_supported == DRIVE_FEAT_CHECK_FAILED_ST)
+		return MDADM_STATUS_ERROR;
+
+	/* Opal not supported */
+	if (sec_send_recv_supported == DRIVE_FEAT_NOT_SUP_ST)
+		return MDADM_STATUS_SUCCESS;
+
+	/**
+	 * sec_send_recv_supported determine that it should be possible to read
+	 * supported sec protocols
+	 */
+	protocol_01h_supported = is_sec_prot_01h_supported_nvme(disk_fd, verbose);
+	if (protocol_01h_supported == DRIVE_FEAT_CHECK_FAILED_ST)
+		return MDADM_STATUS_ERROR;
+
+	/* Opal not supported */
+	if (sec_send_recv_supported == DRIVE_FEAT_SUP_ST &&
+	    protocol_01h_supported == DRIVE_FEAT_NOT_SUP_ST)
+		return MDADM_STATUS_SUCCESS;
+
+	if (nvme_security_recv_ioctl(disk_fd, TCG_SECP_01, OPAL_DISCOVERY_COMID, (void *)&buffer,
+				     OPAL_IO_BUFFER_LEN, verbose))
+		return MDADM_STATUS_ERROR;
+
+	status = get_opal_encryption_informations((__u8 *)&buffer, information);
+	if (status)
+		pr_vrb("Locking feature description not found in Level 0 discovery response. Device /dev/%s.\n",
+		       fd2kname(disk_fd));
+
+	if (information->ability == ENA_NONE)
+		assert(information->status == ENS_UNENCRYPTED);
+
+	return status;
+}
diff --git a/drive_encryption.h b/drive_encryption.h
new file mode 100644
index 00000000..27f1de55
--- /dev/null
+++ b/drive_encryption.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Read encryption information for Opal and ATA devices.
+ *
+ * Copyright (C) 2024 Intel Corporation
+ *	Author: Blazej Kucman <blazej.kucman@intel.com>
+ */
+
+typedef enum encryption_status {
+	/* The drive is not currently encrypted. */
+	ENS_UNENCRYPTED = 0,
+	/* The drive is encrypted and the data is not accessible. */
+	ENS_LOCKED,
+	/* The drive is encrypted but the data is accessible in unencrypted form. */
+	ENS_UNLOCKED
+} encryption_status_t;
+
+typedef enum encryption_ability {
+	ENA_NONE = 0,
+	ENA_OTHER,
+	/* Self encrypted drive */
+	ENA_SED
+} encryption_ability_t;
+
+typedef struct encryption_information {
+	encryption_ability_t ability;
+	encryption_status_t status;
+} encryption_information_t;
+
+mdadm_status_t
+get_nvme_opal_encryption_informations(int disk_fd, struct encryption_information *information,
+				      const int verbose);
diff --git a/mdadm.h b/mdadm.h
index 3fedca48..141adbd7 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1912,6 +1912,8 @@ static inline int xasprintf(char **strp, const char *fmt, ...) {
 
 #define pr_info(fmt, args...) printf("%s: "fmt, Name, ##args)
 
+#define pr_vrb(fmt, arg...) ((void)(verbose && pr_err(fmt, ##arg)))
+
 void *xmalloc(size_t len);
 void *xrealloc(void *ptr, size_t len);
 void *xcalloc(size_t num, size_t size);
diff --git a/super-intel.c b/super-intel.c
index 77140455..806b6248 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -393,8 +393,6 @@ struct md_list {
 	struct md_list *next;
 };
 
-#define pr_vrb(fmt, arg...) (void) (verbose && pr_err(fmt, ##arg))
-
 static __u8 migr_type(struct imsm_dev *dev)
 {
 	if (dev->vol.migr_type == MIGR_VERIFY &&
-- 
2.35.3

