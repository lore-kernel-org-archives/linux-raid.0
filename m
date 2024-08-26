Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5912718BC01
	for <linux-raid@vger.kernel.org>; Mon, 26 Aug 2024 14:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724682543; cv=none; b=NRUaYWpYXrT/rnx5NA9IlWQabVghTSJT5AXV9YSjdRCaFkDyAFWeVvwEYAWa8cEursBylNL+JM23v/FDSG9AjIudlhqszV5lEP3dCjcKC0ULJpHNvxSBch7wVX3prNRVmnkxVbZ4LOTtA/Ou0SZfo4NNulMYrBZUw9bp7gcEVWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724682543; c=relaxed/simple;
	bh=YHityZvCEGjMBPsoRzVzkYp8aNjpNTm6r4MOam/FwcM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bzmQvEux4bD6m0CGgtf9e00xhendfEBgBDEJ7HMmEWMNWa9S6dIzvO9EZNy0rQZLuXL3XsdzeW6kEKPSLDEtIgFL8FEHgZV447Z9mv6Zmr4w3A0cDxF1nT0AEdjI6u4SJheHmbV3EHvkXvzm9uSZuWreepSTo2rKH6muMJ3XMjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YhoRC1Cb; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YhoRC1Cb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724682542; x=1756218542;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YHityZvCEGjMBPsoRzVzkYp8aNjpNTm6r4MOam/FwcM=;
  b=YhoRC1CbwpRHScU8M8zxqImKLFodvriaTJGrnBtxoIqklsz2RNxlON11
   dFnBtqb1Ry2yB5ic3XYtxPPadyRxsldrBJI/0x69xuK++OvLJT4AwwKQ0
   HlmqQoqAxsWE4gLoONsfEZcxQQHSeqUUNvGVIoUsHXH4qePkDOA4oaz5H
   0GEdCZeus7wU0Tj126MArgDIj4jL212dD3IpWD91QMU11ole+yvFmYK+C
   PXYUOI0ljuojqdrmwaZzWrn665cIpfHBQ63HKinpmPALYasJ9zjT/oxVK
   est6eTMoiGx6xyYwYYdb6O7b2xcH6mvtHRbrbodB7mv71+ZmKvhbdOGM5
   w==;
X-CSE-ConnectionGUID: fkYx09i2S9699gExVrJe/A==
X-CSE-MsgGUID: AeWnzfQmQnOYmCEMR5ALRA==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="34267870"
X-IronPort-AV: E=Sophos;i="6.10,177,1719903600"; 
   d="scan'208";a="34267870"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2024 07:29:02 -0700
X-CSE-ConnectionGUID: tai9K0rpSn2nrmWlhnu/mg==
X-CSE-MsgGUID: +4UBotR5TDqnXGSEfk3TzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,177,1719903600"; 
   d="scan'208";a="62844006"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orviesa006.jf.intel.com with ESMTP; 26 Aug 2024 07:29:01 -0700
From: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai3@huawei.com
Subject: [PATCH v12 0/1] md: generate CHANGE uevents for md device
Date: Mon, 26 Aug 2024 16:28:55 +0200
Message-ID: <20240826142856.16612-1-kinga.stefaniuk@intel.com>
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

 drivers/md/md.c     | 144 ++++++++++++++++++++++++++------------------
 drivers/md/md.h     |   3 +-
 drivers/md/raid10.c |   2 +-
 drivers/md/raid5.c  |   2 +-
 4 files changed, 91 insertions(+), 60 deletions(-)

-- 
2.43.0

