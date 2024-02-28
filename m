Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2F31487DC
	for <linux-raid@vger.kernel.org>; Wed, 28 Feb 2024 15:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709134668; cv=none; b=o7f1zBp5ZV7qg0KKa/+k0ZYmwweH7zNrpyQHouoEPFFKqGAQytjdtt+l//ByokyrWUUR35GrnTH1OinOUvoK7hbNp2EhT0JJnPKYm77mT4yMVis1yogEUC7+3aDcx80MJjr7evltrF4hI/SpooUAFfv9ifVm2J26VUdAvAKb/dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709134668; c=relaxed/simple;
	bh=Nlue7TLE9G0Ds1NW916jHWLgfSZD7vXKFMyQGVBYVDY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XqbjN2gCXDi4uGus85xKH1rr0uku7NFrezleyo9J+oh3IJgiRteeqo/eS97wXGUc5W5VumIz/TlxIjfCL8k0QmtR2LVJXRKpia5knSGNm5dr7t2P3uDy1zH/5uowXgXHbnxD0L1wPBw3SaolysUZJCRca3CVWxnhWg6sN8SO1kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZKOATu9+; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZKOATu9+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709134666; x=1740670666;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Nlue7TLE9G0Ds1NW916jHWLgfSZD7vXKFMyQGVBYVDY=;
  b=ZKOATu9+aknzEWx3gYJr4y2LxM3uhbd5bP2lA7UgtOlqteO3qgnA3q1J
   3vLhqvNuKrGIQq3DKFed5g5oMnmJIbwRUc5pJdVhv4tZPeUxcJX3AbgwN
   lSYeW8t7Tz32k/ybnD51rpCl/lQpzJ1rYvbWAD5k8EWsscGKJ95Ii3KVW
   L3QtCdX0LBLGtVbjdEthNER0AlivRXWCXGCrZLoR76R6pZECf4P9UV96a
   KUjf4n/nh21Z+f4HEP1fkbiTX4mA9ZDW7Hn5WKe/jXGpMZU1BgD51p235
   OQtc1OOcv4DQOttg7M54Lx2RHRSZggY6bxuxw07cu8M9Dksb02aTWqGhN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="26004815"
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="26004815"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 07:37:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="7584364"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmviesa008.fm.intel.com with ESMTP; 28 Feb 2024 07:37:44 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 0/1] Fix regression when no PID file
Date: Wed, 28 Feb 2024 16:37:19 +0100
Message-Id: <20240228153720.12685-1-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Following patch is a fix for regression introduced by commit b7d7837128e9
("Monitor: open file before check in check_one_sharer()").

This prevented Monitor from starting if there was no PID file in
/run/mdadm. 

Mateusz Kusiak (1):
  Monitor: Allow no PID in check_one_sharer()

 Monitor.c | 5 +++++
 1 file changed, 5 insertions(+)

-- 
2.35.3

