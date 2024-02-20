Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1931657CA
	for <linux-raid@vger.kernel.org>; Tue, 20 Feb 2024 10:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708426792; cv=none; b=f9n0LKJK3L/kryzLipnh+hN3SHGdDN/8LMWvVeg4QE/QvcOsIzlSj8HXjiv2oJYlHZFE5HlXS1x0qWel/MMJQKJmVGXfVxQ6kOR1GDVu1JN6viQN/f9MB8NSXZb95tvBRsEM8uRZVPvKOBj8eTUINcF3M4M1ydTfnn4hDsc3Ghg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708426792; c=relaxed/simple;
	bh=UO4eiaJ86cy1/q9QJogpUxXvIHfVHCQDCmSC/Kea3uw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OgVy0Mz3yWYIO8c7FEcGMpTDipNifUZDBCY+vpOv8Eg2X6hqre+hVv7OXKt6CMHbnooVzxYhhEcdsJjqNuG44xC/SJvuL45p3gdToBIIztPBjwVSbarpy2a2+xNGcQUj92JGqj+BebbuPrndWBJOT+cqxRhf7poFTNaKeeMIS3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CU9Aps9d; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CU9Aps9d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708426791; x=1739962791;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UO4eiaJ86cy1/q9QJogpUxXvIHfVHCQDCmSC/Kea3uw=;
  b=CU9Aps9d9THyuUcUl0be82J6UhSAP/hoU5NgosBoWzw/glpALJ6J4tjb
   XQci1gToJMewLPwYWumkKTy44vWyjCta9wN0lvTXjKV3CqxSbHKdb5ifK
   fG546cSXCf/nLbF/ie/hy/ZADzHUSe+If/3as4IH7MvrTi5VBjf0+nn+K
   8kqoQc+blEi17HlV6Ov9KSjGklNI2vnmMiCTlRJQMk6FNeg94S2WWLHR2
   f86w25PSJaWMNgmbkzDPeOHraItsPI+pvGDYWoAAffAN/6UTDNqHvnV1R
   adf5iFBkSzklJbB5NvXCfbZNEkg5njDNokLy//frR25DDfhzwoqezPYxv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="13934330"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="13934330"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 02:59:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="4735098"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmviesa010.fm.intel.com with ESMTP; 20 Feb 2024 02:59:49 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 0/6] SAST fixes
Date: Tue, 20 Feb 2024 11:56:06 +0100
Message-Id: <20240220105612.31058-1-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset contains minor fixes for issues reported by SAST tool.

Mateusz Kusiak (6):
  Create: add_disk_to_super() fix resource leak
  mdadm: signal_s() init variables
  Monitor: open file before check in check_one_sharer()
  Grow: remove dead condition in Grow_reshape()
  super1: check fd before passing to get_dev_size() in add_to_super1()
  mdmon: refactor md device name check in main()

 Create.c  |  6 +++++-
 Grow.c    |  6 +-----
 Monitor.c | 13 +++++--------
 mdadm.h   |  5 ++---
 mdmon.c   | 21 +++++++++++----------
 super1.c  |  5 ++++-
 6 files changed, 28 insertions(+), 28 deletions(-)

-- 
2.35.3

