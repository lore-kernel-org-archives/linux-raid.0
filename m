Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34F47CF3C
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 11:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709207549; cv=none; b=UGU+zSDjdzM8ueAKT3adlk1eKYucW+2nij3OuofHAxwlK/xSKu2hR6xdBKF7qH0mY0KcqPbeE9rn2+sj1GFLvOv9wH3yIDxrQSr/jImT47eTuq+OQwt1pRibfdMqr9ld+IhfacOSAnOwIBVZUWpk8lkIwzziiO3wNf3ZB1StNBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709207549; c=relaxed/simple;
	bh=xi4mmoIAXFmWNENLmosuzAXp3YOZmPzma08RWWduy+g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a5aeX/xhGiNGGBOWw29FAAeJXaPOO8oChN3hb/JekETyHuUgFfFBJVq21kdSuUWSA2IGGW+UDetHpA328xInqfcx7acAMR8/G24bp9iIqp+XPmQGf2Hjk6kpcnMspTz0afRtvuOJnOvR+NGFZQF/x+ObcvHKzAQzxYnEfd4tbz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zcz6PVM6; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zcz6PVM6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709207548; x=1740743548;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xi4mmoIAXFmWNENLmosuzAXp3YOZmPzma08RWWduy+g=;
  b=Zcz6PVM6XF64ZjHqxwtVbN6V7qz92yAHJSlhhuz82iyy43ZCHJIs74hL
   Nh/LGUG3Ji2a1KoGMS7CEi2lNCz+ffLbZbUlKCtiSHhoZfxY75I4jqgre
   lQa3lJQ+kyY2VNLus0Awu4XfUADFrzjTF4edDiB5sz43v9fBEjL/GfoVq
   vWt0470sv193My5WsLZFtArU6YctW8fHsZWdQQuUsataTldSBdhupVyWU
   P/dKAOv+jXOcCbh650NMYveNKivPa7WPBLW7tIo6QwbzesaOlfBOsYm36
   /SPMrqxxVfPPQG+vOpy3Iw0UIEUp3WIvZjoIIQklHJ8hAVvXQDu8Y89yG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="7499424"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7499424"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7754788"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:26 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 00/13] Custom drives policies verification
Date: Thu, 29 Feb 2024 12:52:04 +0100
Message-Id: <20240229115217.26543-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

validate_geometry_imsm() over the years became huge and complicated.
It is extremely hard to develop or optimize this code now. What the
most important, it doesn't address all scenarios. For example if
container contains disks under different controllers (spare container),
"autolayout" feature allows to create raid array. This code has a lot
of dependencies and it is almost impossible to add support of this
scenario without breaking something else.

There is also get_disk_controller_domain() which in my understating is a
part of validate_geometry_imsm() functionality moved outside, fit ideally
to mdmonitor needs.

Drive encryption determining will be added to IMSM soon. The encryption
status of the drive will be determined for every drive. There is no
simple way to add it.

The solution added in this serie addresses those problems by making one
easily extendable api to analyze every disk separately, outside
validate_geometry().

First five patches are optimizations with no functional changes. New
functionality replaces get_disk_controller_domain(). It should also
cover some verifications done in validate_geometry_imsm() and
add_to_super_imsm() but to lower regression risk these parts are
not removed yet.

Mariusz Tkaczyk (13):
  mdadm: Add functions for spare criteria verification
  mdadm: drop get_required_spare_criteria()
  Manage: fix check after dereference issue
  Manage: implement manage_add_external()
  mdadm: introduce sysfs_get_container_devnm()
  mdadm.h: Introduce custom device policies
  mdadm: test_and_add device policies implementation
  Create: Use device policies
  Manage: check device policies in manage_add_external()
  Monitor, Incremental: use device policies
  imsm: test_and_add_device_policies() implementation
  mdadm: drop get_disk_controller_domain()
  Revert "policy.c: Avoid to take spare without defined domain by imsm"

 Create.c         |  48 +++++++---
 Incremental.c    |  77 ++++++++++-----
 Manage.c         | 195 +++++++++++++++++++++----------------
 Monitor.c        |  50 ++--------
 mdadm.h          |  90 +++++++++--------
 platform-intel.h |   1 -
 policy.c         | 110 +++++++++++++++++----
 super-intel.c    | 245 ++++++++++++++++++++++++++++++++---------------
 sysfs.c          |  23 +++++
 util.c           | 117 ++++++++++++----------
 10 files changed, 606 insertions(+), 350 deletions(-)

-- 
2.35.3

