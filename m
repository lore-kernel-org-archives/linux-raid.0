Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B389B208A6
	for <linux-raid@vger.kernel.org>; Thu, 18 Jan 2024 10:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705573768; cv=none; b=M4IArRSFcSursrLEWaPHURRlfxJmh73hUEFRhpH1NZGaQOUEn/mwp46CGRWy0Jv6++Y+2B8cuLpHhAJEIftp/vz1gGHzjg/8ht6PYYt1Q/9JcuFQotwbvLH7Dh5PC5u+jS7PqGieeggSPcw9PTgh4gs84L3+QbTpuOn3aCwwFtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705573768; c=relaxed/simple;
	bh=fzJarOmPy/WDb3qerWx2rZBLPcRLboXLj4usnhFHui0=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding; b=pnnPJhSlz7OYT4ScDyflIFORmSAxO5Kp2qV2qKHEVVSc9MsprMYIJ4x3LUSXlUpcGtbHWT34ej7F/HA5Rr1SKptOQYUdACKIf4eWmvnvIfmeSw+yEJirOAo4nLqEj7ULVjQQjJGac8YcDo3pvefHowSQDoqQpTn+pEr1QOa2yL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nZKFN9gI; arc=none smtp.client-ip=192.55.52.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nZKFN9gI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705573766; x=1737109766;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fzJarOmPy/WDb3qerWx2rZBLPcRLboXLj4usnhFHui0=;
  b=nZKFN9gIE0ZpeBAjOfajdN8zit0o3om4UOk5fbUf+BEXEGwVTG8yzi1H
   NLCDO+o4gYvD3NAWYWGywfCzsYLZ0GKbR2HZCcLHrqY8lReBj0zUtKpTX
   4AWO1uRlh/+BTradO4ZaBe/YHHlypm2YGNMGo3iaVGgDGQgM2Z6tfGRQh
   h7k1UzKeRNLKHdCH0xrTIN1h/YX2qB1insynVSaGYHZKcwd8BBT+Bz3oD
   YNN1ZxvEh9O/fDkc0ICLeNqnnRgXqwPGQWZKPVPysRktEm7owprtQ1yBd
   6S2Fyx78Lv0xEiRdX2uZyNvBB8XM2u/DfwVVz/UBo4l1D6OeZ+GrYp4xz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="486563730"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="486563730"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2024 02:29:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="26735622"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmviesa001.fm.intel.com with ESMTP; 18 Jan 2024 02:29:25 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH v2 0/3] Fix checkpointing - minors
Date: Thu, 18 Jan 2024 11:28:39 +0100
Message-Id: <20240118102842.12304-1-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the first half of splitted patchset "Fix checkpointing" as
asked. It contains minor changes that should be safe to merge prior to
release.

Fixed minor things in "Replace "none" with macro":
- Replaced hardcoded "null" size to "sizeof(STR_COMMON_NONE) - 1"
  in str_is_none().
- Removed is_none() on optarg as it checked only first four chars,
  bad for user input.

I included "Add understanding output section in man" in second patchset
to preserve history (adding it here, prior to release might seem
random).

Mateusz Kusiak (3):
  Define sysfs max buffer size
  Replace "none" with macro
  super-intel: Remove inaccessible code

 Assemble.c    |  3 +--
 Build.c       |  4 ++--
 Create.c      |  2 +-
 Grow.c        | 51 +++++++++++++++++++++++++--------------------------
 Incremental.c |  4 ++--
 Manage.c      | 10 +++++-----
 Monitor.c     |  6 +++---
 config.c      |  2 +-
 managemon.c   |  6 +++---
 maps.c        |  4 ++--
 mdadm.c       |  7 +++----
 mdadm.h       | 18 ++++++++++++++++++
 monitor.c     | 24 ++++++++++++------------
 msg.c         |  4 ++--
 super-intel.c | 35 +++++++++--------------------------
 sysfs.c       | 12 ++++++------
 util.c        |  2 +-
 17 files changed, 96 insertions(+), 98 deletions(-)

-- 
2.35.3

