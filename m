Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC732F2D
	for <linux-raid@vger.kernel.org>; Tue, 27 Feb 2024 13:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040751; cv=none; b=C7ArVHJ/balHxe+8kS1i6jmyTM51ak4mUCujIPBXIHPmGhIOaIRCnhPU8J0sAqTzUsLiC0PVSH3dbIvltuWmKv+xtYAnYSOtoTtyq0ySaibogmBemfXV//FlZ4rFGbl6FIaOXZE1J8mEq7cUAjy3bZP6vtvmyZMOkGGOGrCIVt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040751; c=relaxed/simple;
	bh=yI1AZFvsCXvk+tcpSOxdx9fepAVS7vzwoPUouISPaw4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KcVCvVF1zjbLE+KNIbJZ9fyXG5l2KgwOWq0Rf/kEJ3OHnLeSddLo3TFFPfOHvQ65Rc3Jf8gLwiy4xuuTNw3fN7bNDNpUEjP4/0buNRLDzGltiUjhKssxOs0zuul/pIH6bfbm0r1d1gvJEIiUe4d76bcShcx+9dP43Ct4Ag9xraw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qe95m0cj; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qe95m0cj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709040750; x=1740576750;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yI1AZFvsCXvk+tcpSOxdx9fepAVS7vzwoPUouISPaw4=;
  b=Qe95m0cjHLcrtJaxDSkC68S3s3VdlxJ62Ngbi3l/LzLauAUCL0nCjK7g
   YQ/mGawzo2mZCNBqx3fbKz8TOUd8LUaseLEJB5bQUnZuOs1cJrm0lffEN
   GJwXAJ0Km0KnMamwig9qkSfTDHcxyI9BCmMC9Q/GVuMPS/BBAw5nQqNYT
   xLikAZ3OZkyk6m9a3JJ5/eVavHabj7wRLbYyCAqpEl//nydFSWninW/oW
   +R7Tx64qkK5NW6RzSerb99Z0fZ1HnA6oYYeRjbAgJjaPc6AHIbi7dWUnl
   zQwknE0LB2DLaMszxjKDTrHT+a8/uGA4RnQjzAMZJhFDDvIfthVqNIUN6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="14017512"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="14017512"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 05:32:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="7190104"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by fmviesa008.fm.intel.com with ESMTP; 27 Feb 2024 05:32:28 -0800
From: Kinga Tanska <kinga.tanska@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH] super-intel: respect IMSM_DEVNAME_AS_SERIAL flag
Date: Tue, 27 Feb 2024 07:36:39 +0100
Message-Id: <20240227063639.31396-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IMSM_DEVNAME_AS_SERIAL flag was respected only when searching
serial using nvme or scsi device wasn't successful. This
flag shall be applied first, to have user settings with
the highest priority.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 super-intel.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 6bdd5c4c..880e5977 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4172,17 +4172,17 @@ static int imsm_read_serial(int fd, char *devname,
 
 	memset(buf, 0, sizeof(buf));
 
+	if (check_env("IMSM_DEVNAME_AS_SERIAL")) {
+		memset(serial, 0, serial_buf_len);
+		fd2devname(fd, (char *) serial);
+		return 0;
+	}
+
 	rv = nvme_get_serial(fd, buf, sizeof(buf));
 
 	if (rv)
 		rv = scsi_get_serial(fd, buf, sizeof(buf));
 
-	if (rv && check_env("IMSM_DEVNAME_AS_SERIAL")) {
-		memset(serial, 0, MAX_RAID_SERIAL_LEN);
-		fd2devname(fd, (char *) serial);
-		return 0;
-	}
-
 	if (rv != 0) {
 		if (devname)
 			pr_err("Failed to retrieve serial for %s\n",
-- 
2.26.2

