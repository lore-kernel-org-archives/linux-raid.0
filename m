Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05F63EA9C
	for <linux-raid@vger.kernel.org>; Fri, 22 Mar 2024 11:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711108310; cv=none; b=C5owQKBbppAQOwKrhLvlcHJOyavVVOit71HO+w7jna06LooSF6vkqlYEsRZiRROOOUyQ7AiHsG7g1UGfpWOn8zaMO/XlSZ9IN9KB57sl4BFILYxOQE43xLx3/xBAGyKPDHTwHPxp/UBIa4N1aMEFyHtQfgZO8zw8EcKdjKLm7Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711108310; c=relaxed/simple;
	bh=tARphSr2lc3NpQJsG7DStWyCdE01yj9Fc68YISU4fTE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=e9Ings1a3tcOFCDDXkHUi0pbgrKgGMMMY/4OlAC8Zi4OkeH0kC6VaqqxFAAgkRb4tTQWid4d/mA0iHuGxEyXigyqNKHhHRiFyoGD0QTCKsUtdN44IMh2QyC3tBgeKNXTYvliaN7gdASGeO9SRasra9KrmBCYq9n3HXGRPk7sNEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KxW7E1f7; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KxW7E1f7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711108309; x=1742644309;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tARphSr2lc3NpQJsG7DStWyCdE01yj9Fc68YISU4fTE=;
  b=KxW7E1f7tZMjJfnVmFfnD6UgN1Q7L8fsHzIxgen6kpzrHrb+7midBHGV
   bYCFEv7H1xyVCj3vfQlMDSWFSH0kE5hjxNkhl9lFtjY1GuJhCnBLJDwcK
   9lUKZ387etwpVvgSl3uaF+0DzUNpVWWueDxiYr75Kuo1GoAlI+NU1nBdN
   uF/qPFtaCqVmlvXQxn/PM+QTgMT/QLpxvfdi+ZYqiwvzIcxadPLv9hR0w
   acty1I/DlDQTu2s2etrqWasd9K82ytZOC32qb7EkEFKj3vyVM/rukwHNX
   SVnzwt5g8czp9n5Ua+5T/IPcB+chBvWjsVJv39I1tc1+4/7DTB20IbWaO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="6006788"
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="6006788"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 04:51:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="46001005"
Received: from linux-myjy.igk.intel.com ([10.102.108.92])
  by fmviesa001.fm.intel.com with ESMTP; 22 Mar 2024 04:51:47 -0700
From: Blazej Kucman <blazej.kucman@intel.com>
To: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
Subject: [PATCH v2 0/6] Disk encryption status handling
Date: Fri, 22 Mar 2024 12:51:14 +0100
Message-Id: <20240322115120.12325-1-blazej.kucman@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The purpose of this series is to add functionality of reading information
about the encryption status of OPAL NVMe/SATA and SATA drives and use this
information for purposes of IMSM metadata, which introduces restrictions
on the possibility of mixing disks with encryption enabled and disabled
because of security reasons.

Changes in V2:
- add separate patch for change location of pr_vrb(),
- add example results for usage of new feature to commit message in patch 5,
- adjust commit messages to 75 characters,
- general fixes after review.

Blazej Kucman (6):
  mdadm: Move pr_vrb define to mdadm.h
  Add reading Opal NVMe encryption information
  Add reading SATA encryption information
  Add key ENCRYPTION_NO_VERIFY to conf
  imsm: print disk encryption information
  imsm: drive encryption policy implementation

 Makefile           |   4 +-
 config.c           |  25 +-
 drive_encryption.c | 724 +++++++++++++++++++++++++++++++++++++++++++++
 drive_encryption.h |  37 +++
 mdadm.conf.5.in    |  16 +
 mdadm.h            |   4 +
 super-intel.c      | 117 +++++++-
 sysfs.c            |  29 ++
 8 files changed, 947 insertions(+), 9 deletions(-)
 create mode 100644 drive_encryption.c
 create mode 100644 drive_encryption.h

-- 
2.35.3

