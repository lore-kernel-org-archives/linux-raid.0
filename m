Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AB516A38B
	for <linux-raid@vger.kernel.org>; Mon, 22 Jul 2024 13:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721653884; cv=none; b=IZ7hJpA7wVhJ/yKeQSUR7aquAKKVVr5hveVN50qhVnMckZ8E/Fi4+fPhaUhYGseCInGtWYcK0sY7GTslqHYGC+nE+7HSmgPbAsCyeJQ6jHIRjAhvCNngmLFc8GqH3BmNKZyIUYxsZe18ZxfROvsyWB2tcVd8XzLuR6Xeaj+ZvG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721653884; c=relaxed/simple;
	bh=NaOA25AovOhDDsPVglaM8yV52tE7NI0/68J/VEfG3CE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gyteaJ4iNiU4r4ywXhisExmDXrasGTkKojklRvLf73ftiDbVjZlKUIDeJ5Z2MrW9fp5vhdG5aoQ8Ek5fyROr9H3isyCDPfWUIZsn5dr+ebje6yDVfPj1uk6y+PHOLhu/lDVG4B0vqeGEpY018EXgOb3a5Zj6q+ca1Ku0GAjYYRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hey2XlMz; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hey2XlMz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721653882; x=1753189882;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NaOA25AovOhDDsPVglaM8yV52tE7NI0/68J/VEfG3CE=;
  b=Hey2XlMzBo+c1r79z2RGr66emhk8FuN8FCBv+ESi4x0XknS6tqJb7GLm
   QWgBvtxN98a7VnDfpHNRb0I76lQDrwb0aKn917OTIAo8amtFcsqoo+Hk6
   oDa+n1elVSXw4Ie6yQ1wa49xiYSOxuBjsjWJcxxU5HXwh2MAJJo5sXMyJ
   kghDbp+QfLUxthciLMlJXNMg2F7NnjyiZ6R4dL2mH6nXVoQsEC1jfSQZj
   xO+zPHlhgD5yVWtqw4+7daqjpZxM1Pr/WZuoLEf7ELPtIeiP778xzjdDY
   4O/ffXuTv6YFv7mg1i7M3Bsjf2n9Ye886ZK4IKeLpvVuP4W1IekTWuOVU
   w==;
X-CSE-ConnectionGUID: KEOrzkb+Q5GdnBIHLAELsQ==
X-CSE-MsgGUID: K8oshL4LQIC1fag9X23tnA==
X-IronPort-AV: E=McAfee;i="6700,10204,11140"; a="22985506"
X-IronPort-AV: E=Sophos;i="6.09,228,1716274800"; 
   d="scan'208";a="22985506"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2024 06:11:22 -0700
X-CSE-ConnectionGUID: Mslp8wTYTNObqA/Qy1kCpQ==
X-CSE-MsgGUID: 0tngK4yiSLeH4LxWr++IBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,228,1716274800"; 
   d="scan'208";a="51781133"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by fmviesa008.fm.intel.com with ESMTP; 22 Jul 2024 06:11:21 -0700
From: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai3@huawei.com
Subject: [PATCH v8 0/1] md: generate CHANGE uevents for md device
Date: Mon, 22 Jul 2024 15:13:39 +0200
Message-ID: <20240722131340.29880-1-kinga.stefaniuk@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch is caused by changes in mdadm - now mdmonitor is relying on udev
events instead of pooling changes on /proc/mdstat file. This change 
gave possibility to send events to the userspace.
Now, more events will be read by mdmonitor, but mechanism of getting
details of the event will remain the same - all devices have to be
scanned on new event and their parameters read. It can be changed by
adding environmental data, which will fully describe this uevent,
as Kuai suggested. This change needs to be analyzed and planned,
because it requires a lot of work in md and design changes in
mdmonitor - to stop scanning all of the devices on new event and read
uevent details directly from udev. Mariusz will take care of this topic,
and follow up on this later.
Paul, the test suite which was used is internal and checks if mdmonitor
has noticed expected events. For now there is no plan for adding test,
which checking events to mdadm.

Kinga Stefaniuk (1):
  md: generate CHANGE uevents for md device

 drivers/md/md.c     | 73 +++++++++++++++++++++++++++++++--------------
 drivers/md/md.h     |  3 +-
 drivers/md/raid10.c |  2 +-
 drivers/md/raid5.c  |  2 +-
 4 files changed, 55 insertions(+), 25 deletions(-)

-- 
2.43.0

