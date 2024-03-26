Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3D57441F
	for <linux-raid@vger.kernel.org>; Tue, 26 Mar 2024 12:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711455696; cv=none; b=XE9ssAWlr75YuQ5F2ORIm4iGyQRq2x2CIfmGhij8zGK5qhZeNr61jIGm09EyVeT2yiRZl/70X1rTGwVOA+EoiU4Z/DOZaNSOw/UtPb4ChbOwfL0R3/xFQl6rsNbuj+j+xqYBi31VI7CE60SrvAa57Z4Rxc5zLEhgRLnKHrltKVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711455696; c=relaxed/simple;
	bh=d7MXrakVYhbiQOVtb+3VbSgM5P0qu42U+NK48Yjtc7g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=asrYydjr9nkXbeK7gx+VayMAmFppc9QsnuQRuBR+LzJpogvilpgVjNXKBsDu66vefv5MK8cMNlFVilehAoxOHIs7PiGpCha8d+lvRdtXazmKG/pwImsQiWFUmTAL6Lq7+r8zxE1tMTaOLdAdAOjhvDlYBdJcG+O+8rdN82DYlqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kzKv15T3; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kzKv15T3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711455695; x=1742991695;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=d7MXrakVYhbiQOVtb+3VbSgM5P0qu42U+NK48Yjtc7g=;
  b=kzKv15T3OabQY9Yb/Ku2Y8iF46/fjNymytiiPzFQGnm/gmteHTnKIGLo
   fWDrEwBNj7Ha5B8vk0h9g4TViHmMZB1uOtz4LAUu2dASksjtReDWYC9H1
   GNUQCWgsTVxyI/wMaIzJbRY1oHP/1x7M2lfYLrveThUcm+yPMsSk289j6
   IDXTRAGQS9KCREDdkCcAJJoDV8fxPHpf81/10HZkpViCIhFhGzryQYczd
   Inx/Ks9eYnzrdxZOoKx6XuGDiiNpFDqUgM3Tem/5Ln6Unta8xeU7d5hde
   ktu06X/HlESr3oJht9iYm80f2dxM1PXlCePxtGuF1mmpUqyLVezCq2XUX
   Q==;
X-CSE-ConnectionGUID: VLJSW0URSrqMR+4oiyARQw==
X-CSE-MsgGUID: X8FftRRpS0y/sWCPcELP5g==
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="17891005"
X-IronPort-AV: E=Sophos;i="6.07,156,1708416000"; 
   d="scan'208";a="17891005"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 05:21:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,156,1708416000"; 
   d="scan'208";a="20425496"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 05:21:33 -0700
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Jes Sorensen <jes@trained-monkey.org>,
	Nix <nix@esperi.org.uk>
Subject: [PATCH 0/3] mdadm: Add .md doc files
Date: Tue, 26 Mar 2024 13:21:09 +0100
Message-Id: <20240326122112.25552-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an attempt to document some flows for submitters and
maintainers. It removes ANNOUNCE files in flavour of one
CHANGELOG.md, all releases are ported to this file.

For sure there are missing sections in README.md, for example I didn't
provide compilation HOWTO. If there are no objections I will do that
later.

I pushed it to my github to help with review:
https://github.com/mtkaczyk/mdadm/tree/add_md_files

You can either report suggestions here or on github. I will be happy
to answer.

Cc: Jes Sorensen <jes@trained-monkey.org>
Cc: Nix <nix@esperi.org.uk>

Mariusz Tkaczyk (3):
  mdadm: add CHANGELOG.md
  mdadm: Add MAINTAINERS.md
  mdadm: Add README.md

 ANNOUNCE-3.0   |  98 -------------
 ANNOUNCE-3.0.1 |  22 ---
 ANNOUNCE-3.0.2 |  21 ---
 ANNOUNCE-3.0.3 |  29 ----
 ANNOUNCE-3.1   |  33 -----
 ANNOUNCE-3.1.1 |  39 ------
 ANNOUNCE-3.1.2 |  46 -------
 ANNOUNCE-3.1.3 |  46 -------
 ANNOUNCE-3.1.4 |  37 -----
 ANNOUNCE-3.1.5 |  42 ------
 ANNOUNCE-3.2   |  77 -----------
 ANNOUNCE-3.2.1 |  75 ----------
 ANNOUNCE-3.2.2 |  36 -----
 ANNOUNCE-3.2.3 |  24 ----
 ANNOUNCE-3.2.4 | 144 -------------------
 ANNOUNCE-3.2.5 |  31 -----
 ANNOUNCE-3.2.6 |  57 --------
 ANNOUNCE-3.3   |  63 ---------
 ANNOUNCE-3.3.1 |  23 ----
 ANNOUNCE-3.3.2 |  16 ---
 ANNOUNCE-3.3.3 |  18 ---
 ANNOUNCE-3.3.4 |  37 -----
 ANNOUNCE-3.4   |  24 ----
 ANNOUNCE-4.0   |  22 ---
 ANNOUNCE-4.1   |  16 ---
 ANNOUNCE-4.2   |  19 ---
 CHANGELOG.md   | 368 +++++++++++++++++++++++++++++++++++++++++++++++++
 ChangeLog      | 306 ----------------------------------------
 MAINTAINERS.md |  44 ++++++
 README.md      |  83 +++++++++++
 30 files changed, 495 insertions(+), 1401 deletions(-)
 delete mode 100644 ANNOUNCE-3.0
 delete mode 100644 ANNOUNCE-3.0.1
 delete mode 100644 ANNOUNCE-3.0.2
 delete mode 100644 ANNOUNCE-3.0.3
 delete mode 100644 ANNOUNCE-3.1
 delete mode 100644 ANNOUNCE-3.1.1
 delete mode 100644 ANNOUNCE-3.1.2
 delete mode 100644 ANNOUNCE-3.1.3
 delete mode 100644 ANNOUNCE-3.1.4
 delete mode 100644 ANNOUNCE-3.1.5
 delete mode 100644 ANNOUNCE-3.2
 delete mode 100644 ANNOUNCE-3.2.1
 delete mode 100644 ANNOUNCE-3.2.2
 delete mode 100644 ANNOUNCE-3.2.3
 delete mode 100644 ANNOUNCE-3.2.4
 delete mode 100644 ANNOUNCE-3.2.5
 delete mode 100644 ANNOUNCE-3.2.6
 delete mode 100644 ANNOUNCE-3.3
 delete mode 100644 ANNOUNCE-3.3.1
 delete mode 100644 ANNOUNCE-3.3.2
 delete mode 100644 ANNOUNCE-3.3.3
 delete mode 100644 ANNOUNCE-3.3.4
 delete mode 100644 ANNOUNCE-3.4
 delete mode 100644 ANNOUNCE-4.0
 delete mode 100644 ANNOUNCE-4.1
 delete mode 100644 ANNOUNCE-4.2
 create mode 100644 CHANGELOG.md
 delete mode 100644 ChangeLog
 create mode 100644 MAINTAINERS.md
 create mode 100644 README.md

-- 
2.35.3

