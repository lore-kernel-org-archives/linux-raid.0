Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098F3535A2
	for <linux-raid@vger.kernel.org>; Mon, 18 Mar 2024 16:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710779177; cv=none; b=H3suiba7HQFg+vleuP8afe0f00QbOzU670URpZlGfhSuwjb6V9dGTICfmumhXtdwwa0hfuuGv54UxwR5s2yYefLaimAT3dPfHE9BBNPTSX7t7HuH8fxSB4URe8sItS4btsIc3VME277FoQTUv0PKXAt2HVEsvod4S590tbh1tfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710779177; c=relaxed/simple;
	bh=CwnT4SqSfsmgHFM3L767tLIkg/0Zw01s52u6ZBH59r0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZEeYCtvPUYfby63uMAr+Wk8ugV+XdlPi7Flx1KHUAHqf3rnUuFMBTKZYtkcKJhuADrWtP3+O+fcyPQ2VjNK1yH/OfO3WE6CAAniaZGfhuEn7RLxL00/m+VJ1JRywh8ORD+xZkFEJzRO3ntWTcmxtOkTHB/3JIyQ6P7vIm+sBgN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gvflaYQq; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gvflaYQq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710779174; x=1742315174;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CwnT4SqSfsmgHFM3L767tLIkg/0Zw01s52u6ZBH59r0=;
  b=gvflaYQqTbpv+zYzpX43eUxjUDHzjgAqyeS0Qg98I33xG7m7/3sMlcT4
   r8FvIeYsdVkfbj+qdfC+laF7XX6rq+FtoJsgp1GPqwLG8y+lJZQ29lJlA
   q0+IK4JRdMK1AcpFLTSdcTcZNMbBBlpWIYVdkAq3ApPRTipddCZ9WAuRd
   V/sdgvqIfxjUYfQyhzW0qf2nvhIRi3k1lMxOBi/+ZdtHtxnXz17jqeB7i
   rV1gMVskSodjTv7p2nr17dar7codZrjSO0xWNH0iabLoeR0EA4VBYmm6M
   FmfhBHfuREw5K14nkMf2EE1rsjaHCOhrlVuMECqoDjMoXSA/eGQXdmr/k
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="5453353"
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="5453353"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 09:26:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="13553994"
Received: from linux-myjy.igk.intel.com ([10.102.108.92])
  by orviesa009.jf.intel.com with ESMTP; 18 Mar 2024 09:26:03 -0700
From: Blazej Kucman <blazej.kucman@intel.com>
To: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
Subject: [PATCH 0/5] Disk encryption status handling
Date: Mon, 18 Mar 2024 17:25:30 +0100
Message-Id: <20240318162535.13674-1-blazej.kucman@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The purpose of this series is to add functionality of
reading information about the encryption status of
OPAL NVMe/SATA and SATA drives and use this
information for purposes of IMSM metadata,
which introduces restrictions on the possibility of mixing disks
with encryption enabled and disabled because of security reasons.

Blazej Kucman (5):
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

