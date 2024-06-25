Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB2816D33D
	for <linux-raid@vger.kernel.org>; Tue, 25 Jun 2024 14:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719325681; cv=none; b=eJEy4j+OAh4uPDumlsrSkb18yxelPDYKWnYAZ9r4BJ776c8qvVKBJtktZOPyRakScPsxeyIuGqmyvkdkVGBsJnSjD9wgVl8/L28mxfBMPtLhpg97xoAdBpzowNToO7Kwwmo0/QP32nYoRRyV2L4PwzNg1Xg96Pr8Ud1ZQWAreQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719325681; c=relaxed/simple;
	bh=1wrUuqnZJxsI/I/u3nbByWwqoOcPNdei2E8WvJQBG2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cf9i9xe4tm0EztayxWhEjKLZ8C/h4Oexz7gebwlcipkCort1cjF7HPI+AS2WoLM2PCSaFrYn3N/ETKKYm5DPWSnr2X9kIFLsqP7XzdXCd4+FYOThSE/mPDfHIcgPtPMkiDbWBtJT8PC6XQNHQo13gP/CfIwL/n283aMnTml86n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PB7hUAPl; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PB7hUAPl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719325680; x=1750861680;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1wrUuqnZJxsI/I/u3nbByWwqoOcPNdei2E8WvJQBG2Y=;
  b=PB7hUAPl8qaQb6d6iEMEwvRX4sa92madMB+87+9RXjg/zY9wceJdQFXw
   b6F/fb9I/ICg7LOxRZbUdS0fFDVYnq7dSRdDSAp7x9km/VdVXgm4w4VYs
   OCDclSlJWgwOKgAW+ANGRyRQF/5fvR0sfz5JBf5kEYaS+Ke9QWB3QcGzJ
   0xP1GWdO1trTZRf4APuazr7xvkuwwTdzbUjs2LavvRoJbkO7T4puzT8Hp
   0Cpcg5lGbU16WQRWqcJT/Gp/kEsukwfe5FdvL6Y5LV4BzaMdr1r4714Gs
   zsuStHoyiKej031jV/7tCldxxjSCJv1h3684E41UqMnnONgikMJHFUH/0
   w==;
X-CSE-ConnectionGUID: sqvtZHyDS3eSFdC4G88i+g==
X-CSE-MsgGUID: K39A51vtSl6YznvWeuwWQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="16491740"
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="16491740"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 07:27:59 -0700
X-CSE-ConnectionGUID: HVY9sN26RXmMoplBuyYe/Q==
X-CSE-MsgGUID: isuqXrcOQw2L0hhezRjFPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="44373841"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orviesa008.jf.intel.com with ESMTP; 25 Jun 2024 07:27:58 -0700
From: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai3@huawei.com
Subject: [PATCH v7 0/1] md: generate CHANGE uevents for md device
Date: Tue, 25 Jun 2024 16:29:27 +0200
Message-ID: <20240625142928.28090-1-kinga.stefaniuk@intel.com>
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

 drivers/md/md.c     | 50 +++++++++++++++++++++++++++++++--------------
 drivers/md/md.h     |  3 ++-
 drivers/md/raid10.c |  2 +-
 drivers/md/raid5.c  |  2 +-
 4 files changed, 39 insertions(+), 18 deletions(-)

-- 
2.43.0

