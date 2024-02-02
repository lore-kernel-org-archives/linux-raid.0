Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE87148304
	for <linux-raid@vger.kernel.org>; Fri,  2 Feb 2024 16:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706891951; cv=none; b=S/7KLvTuf3ir8y1NRSBm33GT4/xdUcNJyP6y3N3lUlEBNCvOOHhbIJng6QapMb+p0XxIoiB996YOZs8NX/wwgW11MzjcO38af2ZvxlURFZIdzah0S21XdsPe1ZnszhLlAlfVF3YLrelJj3fGQfaTyZyq1wOkxYtJIT8ncwwWtUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706891951; c=relaxed/simple;
	bh=zAVKWjwtZyHitdQiL+w+pntSOHpy2LceQz0sSVUm8ao=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mwvE9j3EA2+7Twgi/n41nvcf151EpeMht6zhxN7OvJlB4WN6q/7ZUUyK/rsJHjL7g01ql0vUxiTQvxmfHHYSKTcZYXTDuXAe15cwalcyV28AZkCMl+N2J2ZXAWoti2/Z3LPcm7lEkDAegylmlRkJdDcIRz3w/UMj+qLbk1AIlDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tj/H8wlC; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tj/H8wlC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706891950; x=1738427950;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zAVKWjwtZyHitdQiL+w+pntSOHpy2LceQz0sSVUm8ao=;
  b=Tj/H8wlCNXnMQ+LIM3m9xZMr1Bf3eK5zS3QUg37UuyA7XglUV5ahxlsZ
   COiXFYlFnzRssxy3qcRti6JVmjZED3awS9G0/141xGNiSkk8LP76Udvry
   3hSR0Hp6YaMUNpb1F9XHq+c2qB85eU32iAUDb71TFR+kceXX0hV3cu4hX
   oti5aYLsgxbI/6swXS/iOrU/TgmLvS+K8rA4d2Ms7F65R69a32SUX74Go
   MjVe7cNvxItpvCpj7bXriZZEvRf0NfO3nTku9UzPh9geZ1W3z6VnyE6oj
   x+v3CIo3w+fZae8p9hrfDftQiGEnu3YX6U9B3A6KeRAnSBgiYYAdDGy7U
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="376768"
X-IronPort-AV: E=Sophos;i="6.05,238,1701158400"; 
   d="scan'208";a="376768"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 08:39:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,238,1701158400"; 
   d="scan'208";a="4723284"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 08:39:07 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 0/2] Revert bug prone commits
Date: Fri,  2 Feb 2024 17:38:33 +0100
Message-Id: <20240202163835.9652-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We determine few regressions with various customer impact.
Unfortunately, initial testing didn't show them.
It must be reverted to proceed with release which is the most important now.

Sorry for the mess!
Thanks,
Mariusz

Mariusz Tkaczyk (2):
  Revert "Fix assembling RAID volume by using incremental"
  Revert "mdadm: remove container_enough logic"

 Assemble.c    | 10 ++++++----
 Incremental.c | 11 +++++++++++
 mdadm.h       |  3 +++
 super-ddf.c   |  1 +
 super-intel.c | 32 +++++++++++++++++++++++++++++++-
 5 files changed, 52 insertions(+), 5 deletions(-)

-- 
2.35.3

