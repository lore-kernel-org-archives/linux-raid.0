Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E79119DFA2
	for <linux-raid@vger.kernel.org>; Thu, 22 Aug 2024 14:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724335457; cv=none; b=bsYF7pCSEauVJsO7FO77NwFeZuZeQ69bx1R6PcPGwB6KZ6X3OFfpeSC1zVshw1KsvgmjSu+jAtYcateuLEz522skUHqpgMpo5eGuMGZsjeUFcCDSDM1GNKpcDjIcmN7eTJFkYpVS9ItYDg2BPY+KU4wWpC6WjdUKtAjuMcFYFJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724335457; c=relaxed/simple;
	bh=GNw2KFIuYSUsT3CZzV3cHqQIqgoqEJr3A7w46yA4idA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HRqH6o+jugaWsskUASoYY9jJwuKXB/PPEFTffNS+oAz+xcy80Mdij6MMvKPSb3x0qqwzDeFc3fUI+GBniX8FAAZjiDAN3/kK6Bjsz4qbeYpqUq5OwO+zI3ErlYj1lZj4h2kU4bxNFOqF+TK5H28aG3sfAqu5TYy9PAJbf8VOz2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h5E65aYT; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h5E65aYT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724335456; x=1755871456;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GNw2KFIuYSUsT3CZzV3cHqQIqgoqEJr3A7w46yA4idA=;
  b=h5E65aYTEGiX6eVAiV2WwzRHb77+hRMuVRQjx7mQz7pC0fOuDdt+TPxR
   vk45XGBgXvO/8RGC0xyCpEoe4lodO4lxWlvFNn5PVL+sD2IxGc4L6J+HZ
   Aj3hKk49G4uUOkE076Y7ZnumW5hlVRKUw6O2hAZVBhF2DEvPrjaPS/ZaF
   lLTzi5necc166SXG8zSFGDe+zDmBrsY+ShaoGEhsozylxvOFDYffQZuA5
   Dj+Cgd1cpsR5dTkVfyJ0VqEEAz1vieRMyoWM9j8AhNvyDwUgU8emfoGgE
   apgZk0hzHRUI37QFnha3v3OYVrRUJqSZkktnx2gU+gUS/uMpdkZpsbDT7
   w==;
X-CSE-ConnectionGUID: gY7KgOR/TRWbHPKD7G+WEQ==
X-CSE-MsgGUID: jg1YE5oCT82epk1AEEaMHA==
X-IronPort-AV: E=McAfee;i="6700,10204,11172"; a="48144088"
X-IronPort-AV: E=Sophos;i="6.10,167,1719903600"; 
   d="scan'208";a="48144088"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2024 07:04:15 -0700
X-CSE-ConnectionGUID: XvKC4ejtRv21RIuEMceYag==
X-CSE-MsgGUID: bhWVYy2vQPiwCQ2WbvWpAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,167,1719903600"; 
   d="scan'208";a="62172299"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orviesa008.jf.intel.com with ESMTP; 22 Aug 2024 07:04:15 -0700
From: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai3@huawei.com
Subject: [PATCH v10 0/1] md: generate CHANGE uevents for md device
Date: Thu, 22 Aug 2024 16:04:02 +0200
Message-ID: <20240822140403.11402-1-kinga.stefaniuk@intel.com>
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

