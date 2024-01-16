Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64FE1B940
	for <linux-raid@vger.kernel.org>; Tue, 16 Jan 2024 11:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J4xRZH2j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705404308; x=1736940308;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=16qv7+hhIAmQoFpsPXHO0kOOzlETaeDTcjDNCmq56+k=;
  b=J4xRZH2jUrPAbBrXFhzDAA4WPZgbG4clkmLIFaKnzo0REIK0jjp77gNx
   hukbj3IidOwdlT4p2+W2SHEFHcaqPFvOruwNQsmNSzmo/RXAU4mhyjDkz
   dbz2aZTAjlZ8Y/dBem3EwS4EKsde+yS8rkWg1cRpiNw618SKCdmS4mIUM
   J9LSVb9iAsa4cwoJ0681w4dzby8UK66jvUrqscMMBo1eIMdkCku1dS40n
   BIcDvZBm2z1JAtOxiBCLe2OohnEd75loF79h5AE7HH5fDCLtqUSpKZOvI
   e6Ah3GHLNRV9hDcYO1IyU3XiiowsTd8e46+lQlYgDkQydCQXILxiuUPS9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="21307030"
X-IronPort-AV: E=Sophos;i="6.05,199,1701158400"; 
   d="scan'208";a="21307030"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 03:25:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,199,1701158400"; 
   d="scan'208";a="26111517"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmviesa001.fm.intel.com with ESMTP; 16 Jan 2024 03:25:06 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 0/8] Fix checkpointing
Date: Tue, 16 Jan 2024 12:24:26 +0100
Message-Id: <20240116112434.30705-1-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently there are multiple issues regarding checkpointing in mdadm.
This patchset fixes most of them.

Thanks,
Mateusz

Mateusz Kusiak (8):
  Remove hardcoded checkpoint interval checking
  monitor: refactor checkpoint update
  Super-intel: Fix first checkpoint restart
  Define sysfs max buffer size
  Replace "none" with macro
  super-intel: Remove inaccessible code
  Grow: Move update_tail assign to Grow_reshape()
  Add understanding output section in man

 Assemble.c    |  3 +-
 Build.c       |  4 +--
 Create.c      |  2 +-
 Grow.c        | 64 +++++++++++++++++++-------------------
 Incremental.c |  4 +--
 Manage.c      | 10 +++---
 Monitor.c     |  6 ++--
 config.c      |  2 +-
 managemon.c   |  6 ++--
 maps.c        |  4 +--
 mdadm.8.in    | 21 ++++++++++++-
 mdadm.c       |  7 ++---
 mdadm.h       | 18 +++++++++++
 monitor.c     | 85 ++++++++++++++++++++++-----------------------------
 msg.c         |  4 +--
 super-intel.c | 38 ++++++++---------------
 sysfs.c       | 12 ++++----
 util.c        |  2 +-
 18 files changed, 151 insertions(+), 141 deletions(-)

-- 
2.35.3

