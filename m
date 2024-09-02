Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DE5176AC3
	for <linux-raid@vger.kernel.org>; Mon,  2 Sep 2024 08:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725266288; cv=none; b=H2fxReRe42mNJCU0Ttjv+Ep2v71piD0kaE7HNA4GjaWYGd4OwY8Nh7JuU3mTnOjwyujiXyowtQR5WsyhpOQ3ybgMnLahvMYk10UmH11MiULqoF3Vcjp+T40MA8Ndhqje4JW7pZ89iNdpkpSyu4F+vaIltL3EuEQcbUuFgRDArSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725266288; c=relaxed/simple;
	bh=yOnPW7DWqsk8r5SPYI65wlSKEqSFFrh0SSAHDXUVS8c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b2wu+HbSDEzc1KNQQWfIv+ZMZoIM+rI1lr4Q8LphgjCx91k97jl00SIo3lNoguIbrF21sFJcHAH7ISXWqW5ie7nnNeoOkM0Y1RRD/GzeCnu3Eujdt6GQ7lrpEefB1An9mNvTA5XhJRM6Zv8lUCyqWJny6xTqcL5QCXOLFPmCqCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DYKU8jFG; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DYKU8jFG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725266287; x=1756802287;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yOnPW7DWqsk8r5SPYI65wlSKEqSFFrh0SSAHDXUVS8c=;
  b=DYKU8jFGK2/iLevsvXaqm9ZNphrNgjXDNk4nYD11NdvMHY+ah5lj7+DQ
   eDXcsmekn3xQ5CqEm0BpeGY8+pmuY8BSB/dEI/dFyybYSFpTkFU13I1Tt
   Ix9fHnmnVGn62vUBLBlPR6N4ujg25daVipfn2q/7TH5L1mmT+EDgQ15vf
   T+nnyZWmmGj1p+2fZPLYJpcpog2pmHqiv1k/YfJQ6+WtCkNNxIqmrT/yA
   L7V7PlYFVdTHYLla8JkrdSg+U+gXUoGLUkG1pqoEDtdG2VBY2AVcrOrmU
   rDk7TByhVnZvqdXfAschzYeCDShErXyU6/TupE6KNaG6uMqRUX1vZSUzx
   w==;
X-CSE-ConnectionGUID: ORJRz0QRSFKmX8npRk9zHQ==
X-CSE-MsgGUID: Lvx3nM8KRWOHFcei79i0YA==
X-IronPort-AV: E=McAfee;i="6700,10204,11182"; a="23643788"
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="23643788"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 01:38:06 -0700
X-CSE-ConnectionGUID: kac73ZauTKiCzSxvLLjSMA==
X-CSE-MsgGUID: TlTqFEeMShWqBE6vc1BuiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="64513415"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orviesa009.jf.intel.com with ESMTP; 02 Sep 2024 01:38:05 -0700
From: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai3@huawei.com
Subject: [PATCH md-6.12 v14 0/1] md: generate CHANGE uevents for md device
Date: Mon,  2 Sep 2024 10:38:15 +0200
Message-ID: <20240902083816.26099-1-kinga.stefaniuk@intel.com>
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

