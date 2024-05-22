Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A310419470
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 07:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716363157; cv=none; b=nGts8+xZeUQKnZOiPPltdJW1oqnbu8BEWqKEkfpU4qHQ0oZ6/5x6wPPqF/e3JmjTjvZaxuF55VBa9YQkoNcLso/OZvQErA4LScQN6hZFKDv/07F0utt0EokfwYkEoMr2n5Do9foJ7xwq6H4KKsnufKEiRcjueAVB57SH/zBV/aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716363157; c=relaxed/simple;
	bh=BdQuKFOkwznhzMlmPzitxiv7/msIA7yNm8crrH0Sepw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OgBBsTAdAMc2RtgSyrL0g90OyTB/FH6Zd9Vk4xNC1vtHDsdL5ObX3mzjW2fzp33/R0llop92XU/6Txdb7EF7bnbQdwjg9+8/LJDXUGC8oPh1lGcywI7WAXRqywjNJYhlm0wXxPZjpOuxoD8Fwr4pGLv8Q6IWTMquhmZXK5E2w90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HgrNVu2h; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HgrNVu2h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716363156; x=1747899156;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BdQuKFOkwznhzMlmPzitxiv7/msIA7yNm8crrH0Sepw=;
  b=HgrNVu2hnUy59blKgy+BvjrtylWoKhFnEamXgXkR0FVKmBY3zjEWbvsf
   xHhCkosPlcyPD1PZl9hyT2IV8uw15FzarZCPwGYp4seadE0Vmkc4A0EkA
   C+NCsCBqdBAnB6e+vBUZQtm7fP4Q32i5EcKf4pNqxN7jT3XuJ9Orvhh27
   2E7IPpTAUIs4/fcUhhIihvVMvyy3zb6GDVxlaW8k4X0N+Ij8z+KvLvMuT
   XAXI0VtdCh6z7DrD5aPeP80Vn+NWb3b2abF90fD0ESKRtG4pD1TeIHRAl
   EnLX20SJg4yjPMVROf8c+68qy/rt/PYslqttOfVt7vv3mlZybImPq/0wj
   Q==;
X-CSE-ConnectionGUID: JyHtsQtFQoioHyYrWnERtA==
X-CSE-MsgGUID: VcTGGkE1RoiKgduRuQ8GJg==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="23207574"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="23207574"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 00:32:35 -0700
X-CSE-ConnectionGUID: 6sjqhjm2QXiY3/8A50VTpw==
X-CSE-MsgGUID: gkTvVG13T02j5ufYwZrKXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="64020612"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orviesa002.jf.intel.com with ESMTP; 22 May 2024 00:32:34 -0700
From: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org
Subject: [PATCH v6 0/1] md: generate CHANGE uevents for md device 
Date: Wed, 22 May 2024 09:33:09 +0200
Message-Id: <20240522073310.8014-1-kinga.stefaniuk@intel.com>
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

 drivers/md/md.c     | 47 ++++++++++++++++++++++++++++++---------------
 drivers/md/md.h     |  2 +-
 drivers/md/raid10.c |  2 +-
 drivers/md/raid5.c  |  2 +-
 4 files changed, 35 insertions(+), 18 deletions(-)

-- 
2.35.3

