Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9E57CF2B
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 11:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709207567; cv=none; b=PPbT5kLA0Jkk+T6OApg/UqgzVx5IyLCwztk2gycJDp788KUXZtqNQLgivEbY1Oka6RnhzQKdCMVAx4mwC5B/EV/uXw5gsl36oNQ/KHZ+8mUBkyV3B9WGXkeJQHg8hvtAHVjV7jkm1KmVxQkAARz4kHpdaoGsECE0vRxgpqsmpTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709207567; c=relaxed/simple;
	bh=HyTTvCxts5mgRn8h+UxxxucPxTziXVg7TxoCFPyZp4c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mPfBQbecf2tlkvwhtK1z2HK6aUO94jyOHRh6JHgXmLrWjogKrqFUwuvZDDzS+XZG60bmI+IapndWC+UEP1CWISKjYxQECeXHwa6Q/Gk7VytCfjuIeIUYxY+qj0yY8JQLwURmOm2YSmHrNwvmXCX/YyxI4nq+xjBPBjZOX3hr0ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NHUT+eDn; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NHUT+eDn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709207566; x=1740743566;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HyTTvCxts5mgRn8h+UxxxucPxTziXVg7TxoCFPyZp4c=;
  b=NHUT+eDnwMtLSrEJDM2glCz53d6A0HeL3oWRgVUjQRFvyz+ku42L3Gky
   csRl+ZQedp1WHyTiqTjPfrliOpgu4FEtI0JHZ3ve9ldNbzpqZDHfCQXdD
   Q+F0KGokm0Bamf1k2VrPD3ikYyeBFiKUFsbyh+ihDrlIYUQZQ66DtmC7q
   p5GhgENIbBrAUmGOStXWXAj630PMegndv81RyTn4e2FudfsyFkO0uk3IY
   HBVuvTcjDUAVohzAuEgCvnn7oBXPt1taOah9iy5ynRjSSnUe0vybZKCPw
   tyWXB8/dK8+ExEad2rnJE6eakLAo/Jgx/2UNEqt+0Zmy3S+qFU/R+Qd1S
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="7499471"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7499471"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7754832"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:45 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 09/13] Manage: check device policies in manage_add_external()
Date: Thu, 29 Feb 2024 12:52:13 +0100
Message-Id: <20240229115217.26543-10-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240229115217.26543-1-mariusz.tkaczyk@linux.intel.com>
References: <20240229115217.26543-1-mariusz.tkaczyk@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only IMSM is going to use device policies so it is added to
manage_add_external(). Test policies before adding the drive to
container.

The change blocks adding new device to the container which already
contains not matching devices

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Manage.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Manage.c b/Manage.c
index 969d0ea9d81f..96e5ee5427a2 100644
--- a/Manage.c
+++ b/Manage.c
@@ -704,6 +704,7 @@ mdadm_status_t manage_add_external(struct supertype *st, int fd, char *disk_name
 {
 	mdadm_status_t rv = MDADM_STATUS_ERROR;
 	char container_devpath[MD_NAME_MAX];
+	struct dev_policy *pols = NULL;
 	struct mdinfo new_mdi;
 	struct mdinfo *sra = NULL;
 	int container_fd;
@@ -722,6 +723,9 @@ mdadm_status_t manage_add_external(struct supertype *st, int fd, char *disk_name
 				       0, 1))
 		goto out;
 
+	if (mddev_test_and_add_drive_policies(st, &pols, container_fd, 1))
+		goto out;
+
 	Kill(disk_name, NULL, 0, -1, 0);
 
 	disk_fd = dev_open(disk_name, O_RDWR | O_EXCL | O_DIRECT);
@@ -730,6 +734,9 @@ mdadm_status_t manage_add_external(struct supertype *st, int fd, char *disk_name
 		goto out;
 	}
 
+	if (drive_test_and_add_policies(st, &pols, disk_fd, 1))
+		goto out;
+
 	if (st->ss->add_to_super(st, disc, disk_fd, disk_name, INVALID_SECTORS))
 		goto out;
 
@@ -760,6 +767,7 @@ mdadm_status_t manage_add_external(struct supertype *st, int fd, char *disk_name
 
 out:
 	close(container_fd);
+	dev_policy_free(pols);
 
 	if (sra)
 		sysfs_free(sra);
-- 
2.35.3

