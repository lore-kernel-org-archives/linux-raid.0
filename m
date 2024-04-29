Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F4D5F861
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 13:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714396060; cv=none; b=H3RyfP2VLnzM+uI8dz/Y5ltcv2IjsCX9w36NokZCxr7TPXm+VZjX8/PcNgWV2Shd3UyVm3taAzmHAr++txqk0GgcQ6C5psL/Eagt8KzYnEzRfQsCFcFMkBRzl+wc5o/rB2PO6jRv6nLBjWYRkMuOXM+Cqpra6geQEn3iAlCu9jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714396060; c=relaxed/simple;
	bh=4ewksl0sr6lYxrCpAOaraQVFhTYwdEr4QUUPtlmhkTc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QVAaAmdklm/3P6n9l+w2MfYMJljtpTwYNqTalzCuaf6mT4pOeWTgbsfUO5KOdrPUybxfSEazYz3tXOHwf55ogRvwsNX2mLL6w8bAN8aNsRlbNNeo1+F5GcbUArGE9qo8cURJwRlNpddx9cxWP0xoNC97MOlYISXeTQiN+5gQkxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D95IIuq8; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D95IIuq8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714396058; x=1745932058;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4ewksl0sr6lYxrCpAOaraQVFhTYwdEr4QUUPtlmhkTc=;
  b=D95IIuq8yZvaflplDMBcx6Zhxa9ih4vc7x8hmVQO0UsD2LEjnTtTKMcu
   G1ZJYhj9Hf1sspYgVfAAt3BfcUUuEXMCFqTC31wdUJGSbZDG5J8aUMWkX
   GbneR7r+qc1RxqKZCVKw3wFrTdgc9ERMztpR2/SXV8UB5q/zCmE4wPm9/
   KMTGClhqJkfRyWqkV3ZAwmN4F8d36B3K9tYjEG3Y85fs2vx2HJA9BPz0y
   8iAesYG4lvga/hBlN/A6QfH7rSlyPXmfaPzMSMu09wChz5RmQZmbTAM/I
   aBvrWgtTkF+tLinpkskIuoqRHwM53RfyGz6Aw9LCZuouQs6ETHnimHy6R
   Q==;
X-CSE-ConnectionGUID: HuNhLIu/TIW5U93zuJRkpQ==
X-CSE-MsgGUID: Lv8nUoFjR12qQjfvCyAVTA==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="32554402"
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="32554402"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 06:07:37 -0700
X-CSE-ConnectionGUID: hC6xQLRrS/GPgReUNVRdpQ==
X-CSE-MsgGUID: 6Hc95zlwQ0qDS8fJsVPKAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="26609853"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by orviesa007.jf.intel.com with ESMTP; 29 Apr 2024 06:07:36 -0700
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Subject: [PATCH 0/8] Add R10D4+ support for IMSM
Date: Mon, 29 Apr 2024 15:07:12 +0200
Message-Id: <20240429130720.260452-1-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series of patches adds support for RAID10 with more than 4 drives
(R10D4+) to IMSM.

Mateusz Kusiak (8):
  mdadm: pass struct context for external reshapes
  mdadm: use struct context in reshape_super()
  imsm: add support for literal RAID 10
  imsm: refactor RAID level handling
  imsm: bump minimal version
  imsm: define RAID_10 attribute
  imsm: simplify imsm_check_attributes()
  imsm: support RAID 10 with more than 4 drives

 Assemble.c       |   7 +-
 Create.c         |   9 +-
 Grow.c           | 143 ++++++++++------
 mdadm.c          |   2 +-
 mdadm.h          |  25 ++-
 platform-intel.c |  58 +++++++
 platform-intel.h |  32 ++--
 super-intel.c    | 433 +++++++++++++++++++++++------------------------
 util.c           |  39 +++--
 9 files changed, 419 insertions(+), 329 deletions(-)

-- 
2.39.2

