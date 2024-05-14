Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2001912EBF3
	for <linux-raid@vger.kernel.org>; Tue, 14 May 2024 09:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715679286; cv=none; b=JnPjzG7LKVhmqgbFU1K3S/VosBEBgKXVjF1gpe0oAEQiRWqDGH9Qa3PTnDq3mfNYfzdWrOJi3tzQ72ulH6wXMyVHJ2Wf74E5butJHdcHoLmC5Gu1KTrnRYMNkAY6xrq9N/OygVjhKtgggHc7INN6H9+F/7oposHMaDQY1SOoXjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715679286; c=relaxed/simple;
	bh=rz7o9VDCaVhf+9MrG85XTYGjdx56uRDqsxYW2Ib4hNo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=M+caVUnqjGYsdNUSYALrJQeqwLP6wh1OC5IoyUmEdg84pPgvAyHb0CLPXmOm6MG1r7odoa8xqIa655gxv8eFNvoTzF3Ke9ak9R8NOqXVXWvfUUPZ29j39xWFIp7fR92ZfdqqZP/T0JEMXsKf84KLpQt1tmD5pCqOInw2bvfIQzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZDDsiIaR; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZDDsiIaR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715679284; x=1747215284;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rz7o9VDCaVhf+9MrG85XTYGjdx56uRDqsxYW2Ib4hNo=;
  b=ZDDsiIaRH+1HYtf0HVMBR52nCxr5ODloRSGJJyIIYqB+U9PkMaWBKlbs
   btQGIyyCgw2k22QvDfY7GOzqSgskH2eI+qZYZbVPckSr9PitqvePPCsgT
   EzyWqL6Vo5qF7SHqUZXPXySiz9DyixDP/jWAtgK9qOfFa3cIzcpnhQKIL
   l4ArO6p5U6V9nZfdyj5GST/RImxthQZRgYnvEXzwSQw0eGzWmdfYruVJ1
   ZdKY1iAZsvP7vCBT890pfBBqWrzwWLpEuhfYd9tp3JPjTKmcp7mwKAGC6
   mxIvXg+emS8PofecPBQxM1HM++SjWn87LgF/aXZH+XDJ3qWRNsCoQVvsz
   w==;
X-CSE-ConnectionGUID: G3f8adSNTNKQ5uuDPJ32Kw==
X-CSE-MsgGUID: lXtragzuT62Wc/okrA4uTQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11072"; a="22796864"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="22796864"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 02:34:44 -0700
X-CSE-ConnectionGUID: GkMPAZysQuqnAJRyli+SlQ==
X-CSE-MsgGUID: ycYAlUntRrGmQIgGdwOLdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="61456034"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orviesa002.jf.intel.com with ESMTP; 14 May 2024 02:34:43 -0700
From: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org
Subject: [PATCH v5 0/1] md: generate CHANGE uevents for md device
Date: Tue, 14 May 2024 11:35:00 +0200
Message-Id: <20240514093501.2527-1-kinga.stefaniuk@intel.com>
X-Mailer: git-send-email 2.35.3
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

 drivers/md/md.c     | 44 +++++++++++++++++++++++++++++---------------
 drivers/md/md.h     |  3 ++-
 drivers/md/raid10.c |  2 +-
 drivers/md/raid5.c  |  2 +-
 4 files changed, 33 insertions(+), 18 deletions(-)

-- 
2.35.3

