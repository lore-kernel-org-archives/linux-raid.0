Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D402016C69B
	for <linux-raid@vger.kernel.org>; Wed, 28 Aug 2024 12:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724846533; cv=none; b=QIkwVEGEtqE2EeYrI6OeLXxv71k2tM9C4pq6COSZZlvmP5JEAsXBerTF4IlyJmMvZ+Iy4sznRs+e8cKBTEjieGeAEAbsJ+ciw1Rm2brQrg8XtpqADNFdgQ6YizPlRAdSyiCEUpB1hL0O8MHFpYnroJE05Y6KLBA1BDdpx4mvqTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724846533; c=relaxed/simple;
	bh=yOnPW7DWqsk8r5SPYI65wlSKEqSFFrh0SSAHDXUVS8c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=md5D8btHAH7L5xGJBb+xGX4lTv7Nss33b4/qMX7EZhS8Qf6rnzbO9EoGUVMIQa6br6K4kqF9ZMUlKeuia76SCgiZSAtOJcD7fBLWyso9IRMutWx5Y9jpmodbHVQOSnNDwcbEuipCGhDCvGXsFWJ0KcoPeh4MubErNTOzRyou8vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XkbCAjDs; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XkbCAjDs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724846532; x=1756382532;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yOnPW7DWqsk8r5SPYI65wlSKEqSFFrh0SSAHDXUVS8c=;
  b=XkbCAjDs9l4zDRUel3RRjVxWQWIVNQZ2dqDytBFUVMXYRxiT7iaKnuMz
   aa2FXkGEDGDyFKCURGWTlrSerMxVHngeEYGw7YXqVvli2mRHTZpXJOujR
   j70AtfuvMimW7rOmfTet9CM46dCoWwRVhtZfbHrKIaYUQ/8TBFl82MtAz
   7XcQPu3626PrHRDQPK9hFCStSwbBhVdCPcvzBYjlwCYQOmR6X5IGRGKA5
   XUnikxBfg5dJV/XWw0Ezta5hcn6I91LyIhnM/zKcLO9wjmPCPyJ3GPNe2
   EtlCtsTY5ArWZG2R4uExv9t99yxptL7H+kC4c3NVDVAHzDhnaDzzLNBnB
   A==;
X-CSE-ConnectionGUID: 2eZjQlMSQjaa4TBgsLIcuQ==
X-CSE-MsgGUID: t+04jelXT/CcXVpAlLIgHw==
X-IronPort-AV: E=McAfee;i="6700,10204,11177"; a="33993643"
X-IronPort-AV: E=Sophos;i="6.10,182,1719903600"; 
   d="scan'208";a="33993643"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2024 05:02:11 -0700
X-CSE-ConnectionGUID: 6C1wtiFXR6iH4blnFaWw7w==
X-CSE-MsgGUID: hrLYGhM1QLK05j9TeNFNrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,182,1719903600"; 
   d="scan'208";a="67869024"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by fmviesa004.fm.intel.com with ESMTP; 28 Aug 2024 05:02:10 -0700
From: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai3@huawei.com
Subject: [PATCH v13 0/1] md: generate CHANGE uevents for md device
Date: Wed, 28 Aug 2024 14:02:11 +0200
Message-ID: <20240828120212.31865-1-kinga.stefaniuk@intel.com>
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

 drivers/md/md.c     | 148 +++++++++++++++++++++++++++-----------------
 drivers/md/md.h     |   3 +-
 drivers/md/raid10.c |   2 +-
 drivers/md/raid5.c  |   2 +-
 4 files changed, 94 insertions(+), 61 deletions(-)

-- 
2.43.0

