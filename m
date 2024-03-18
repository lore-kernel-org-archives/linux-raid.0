Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F60C537E0
	for <linux-raid@vger.kernel.org>; Mon, 18 Mar 2024 15:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710777257; cv=none; b=NRtMF98us2EJjYmgXh0JyplpRV9Ody+XmDvd90X/5g0G9FS6H1fDUs52h5Qfg0yZExJJJmxWhbskLnXa5OLlfXH78CC+eqztxwzYRH0Q0KOZPDJ2fOkoVe8TMA2Y+F0PdOKC6Vh4eJ1gNXkKNtQy6c0omkADUaB/ZoJ4xuoGfJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710777257; c=relaxed/simple;
	bh=n2O7Jm2g2cO3fzhUaBB7dH0Pby93/6OcB2z6Iknc7ic=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=S+gZQaH3Ybo/RVcsMLahB09Jim+dKsQ08EtMogxSxfxz2gpBBfCqo9AWWbv061Klacp+hcyETuhKAWPOxthRxfiZnqBtFsrvOU+Jwbz+dFaWMG1jvDZLFLWMBYBQD43TEybjul3M8VOippEzmImtKZODlC0SQ+QQFXtUl2JwufI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Un7jvhjK; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Un7jvhjK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710777255; x=1742313255;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n2O7Jm2g2cO3fzhUaBB7dH0Pby93/6OcB2z6Iknc7ic=;
  b=Un7jvhjKVReF/dZDYQODw7DRPCL62z858wh72NK0eDuDxlTOyiIopEUi
   kaiGmZAcKlT7VB+OY35RtF3hDhFsVAYZBhyjLesHT1OhN9mCcooOw/WbA
   OKKYVowcyWacl1c3Ri6AEO50xb/rb+O3xYLXkJN49uvxsLymKGGaf+Tbh
   YhAYEz7WpnYnop3boSzh7qQm6yW83UD2FDfkUaSTyDbId8YuefKzRzwEn
   BL1Kx1Jzd9ePXqkFr7AVOZRPz4OCdGp9kzITnc1WSPynda9kleZ8eiSOh
   kE3XOW3xp7URluyr9tQmNs8trJS/qcnZ+DruBln5+EHYrsnnC4fLLEV3X
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="5721519"
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="5721519"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 08:54:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="13398115"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by orviesa010.jf.intel.com with ESMTP; 18 Mar 2024 08:54:14 -0700
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Subject: [PATCH] sysfs: remove vers parameter from sysfs_set_array
Date: Mon, 18 Mar 2024 16:53:31 +0100
Message-Id: <20240318155331.1439-1-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

9003 was passed directly to sysfs_set_array() since md_get_version()
always returned this value. md_get_version() was removed long ago.

Remove dead version check from sysfs_set_array().
Remove "vers" argument and fix function calls.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Assemble.c | 2 +-
 mdadm.h    | 2 +-
 sysfs.c    | 6 ++----
 util.c     | 3 +--
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 9d042055ad4e..f6c5b99e25e2 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1988,7 +1988,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
 	 * and ignoring special character on the first place.
 	 */
 	if (strcmp(sra->text_version + 1, content->text_version + 1) != 0) {
-		if (sysfs_set_array(content, 9003) != 0) {
+		if (sysfs_set_array(content) != 0) {
 			sysfs_free(sra);
 			return 1;
 		}
diff --git a/mdadm.h b/mdadm.h
index 1f28b3e754be..48e5a4935868 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -807,7 +807,7 @@ extern int sysfs_attribute_available(struct mdinfo *sra, struct mdinfo *dev,
 extern int sysfs_get_str(struct mdinfo *sra, struct mdinfo *dev,
 			 char *name, char *val, int size);
 extern int sysfs_set_safemode(struct mdinfo *sra, unsigned long ms);
-extern int sysfs_set_array(struct mdinfo *info, int vers);
+extern int sysfs_set_array(struct mdinfo *info);
 extern int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume);
 extern int sysfs_disk_to_scsi_id(int fd, __u32 *id);
 extern int sysfs_unique_holder(char *devnm, long rdev);
diff --git a/sysfs.c b/sysfs.c
index f95ef7013e84..937a02e88a79 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -655,7 +655,7 @@ int sysfs_set_safemode(struct mdinfo *sra, unsigned long ms)
 	return sysfs_set_str(sra, NULL, "safe_mode_delay", delay);
 }
 
-int sysfs_set_array(struct mdinfo *info, int vers)
+int sysfs_set_array(struct mdinfo *info)
 {
 	int rv = 0;
 	char ver[100];
@@ -679,9 +679,7 @@ int sysfs_set_array(struct mdinfo *info, int vers)
 			if (strlen(buf) >= 9 && buf[9] == '-')
 				ver[9] = '-';
 
-		if ((vers % 100) < 2 ||
-		    sysfs_set_str(info, NULL, "metadata_version",
-				  ver) < 0) {
+		if (sysfs_set_str(info, NULL, "metadata_version", ver) < 0) {
 			pr_err("This kernel does not support external metadata.\n");
 			return 1;
 		}
diff --git a/util.c b/util.c
index b145447370b3..a3a46255d297 100644
--- a/util.c
+++ b/util.c
@@ -1899,8 +1899,7 @@ int set_array_info(int mdfd, struct supertype *st, struct mdinfo *info)
 	int rv;
 
 	if (st->ss->external)
-		return sysfs_set_array(info, 9003);
-		
+		return sysfs_set_array(info);
 	memset(&inf, 0, sizeof(inf));
 	inf.major_version = info->array.major_version;
 	inf.minor_version = info->array.minor_version;
-- 
2.39.2

