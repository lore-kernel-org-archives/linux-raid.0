Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648A0188CC8
	for <linux-raid@vger.kernel.org>; Thu,  8 Aug 2024 07:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723101156; cv=none; b=S9ZYrgVhKoPg3DKk903bt5YGkPMklPosrN+P6QOCIzt6WutVVFa1dSOveHOMOT59ru55fE/BFlG7yL47lnjRNzWY7wRcKFgP/sPlsmpqBPeKM1UUz2hBAbkU8sLxpw/nz0XkuIF5cyD2XDGTeCAPSQZLSdDGyoOOmtar7OEdxII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723101156; c=relaxed/simple;
	bh=rOxVHXe0R/dBeWcbDw0JOUngLG+a9UKo2fQKeU/t4kA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BtZMtMfSF4UylkhaO6vneTnPVyECdQDPqYAjlDVsKKNFF4eMUFr/FcknmvjpF69OHCJQDwTlhA7buGYI/JK6PEfZhUSlwocPoSkVuQRBHW6ZEjgCUNDVbUHE5w7A86HcOXJYKr14ROYXa4ITaWLeDi2WCIvhY21Uc2x2fAbmQNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g/GySvZE; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g/GySvZE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723101155; x=1754637155;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rOxVHXe0R/dBeWcbDw0JOUngLG+a9UKo2fQKeU/t4kA=;
  b=g/GySvZER73P9Ha5yz+9AlxSNnfIUK9ZOuJwYdG47gxz0nUNWGufVyeg
   nP4J/LpORzCfGzI4MW2ORihMM4SxmVlmtnjRVo+8BmcD14JRMbLhYTZI7
   c2xI5IvYUGDa9xDoozHrTANrQsXfMgGujG5sNGzp57wHlV9aAdO9bpFB1
   A94umVvzaAJW+oImTsx6Pny5jIBbVbzwDT19BOWsUg9ivtLNTNsBG09rt
   +VUmLN081qtDfwAY4Ng9R/80fN1MliJIcCPTNGAJ/HYOfHv5KQhRHHlxz
   tAK6BQzN+EK+sTRm3Keofpuo9wYkp+MHb2kfcoCnOvQc2VXYJP+kddBdl
   Q==;
X-CSE-ConnectionGUID: tjQ6CpBRRgejyDZZaKLLvg==
X-CSE-MsgGUID: negidkFtTLG4gny37YmoWg==
X-IronPort-AV: E=McAfee;i="6700,10204,11157"; a="21350511"
X-IronPort-AV: E=Sophos;i="6.09,272,1716274800"; 
   d="scan'208";a="21350511"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 00:12:34 -0700
X-CSE-ConnectionGUID: gMwjUlRhTBGetcoHktnbDQ==
X-CSE-MsgGUID: m9pR5r1AScKcT2u3+cKGoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,272,1716274800"; 
   d="scan'208";a="88033801"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by fmviesa001.fm.intel.com with ESMTP; 08 Aug 2024 00:12:32 -0700
From: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai3@huawei.com
Subject: [PATCH v9 0/1] md: generate CHANGE uevents for md device
Date: Thu,  8 Aug 2024 09:15:21 +0200
Message-ID: <20240808071522.14283-1-kinga.stefaniuk@intel.com>
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

 drivers/md/md.c     | 72 +++++++++++++++++++++++++++++++--------------
 drivers/md/md.h     |  3 +-
 drivers/md/raid10.c |  2 +-
 drivers/md/raid5.c  |  2 +-
 4 files changed, 54 insertions(+), 25 deletions(-)

-- 
2.43.0

