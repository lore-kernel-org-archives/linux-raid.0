Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P2mrDqOH"
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25527BE
	for <linux-raid@vger.kernel.org>; Mon, 20 Nov 2023 23:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700553434; x=1732089434;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=enOUidnfXDbPOiDkpBrXmoCcBqSLbxNKrMgomrTA/24=;
  b=P2mrDqOHvHAmXy43u35IF9w1IeFvHFXf+GkINXKxAGYHOb6bGK/t9tUF
   CN1u5W8TWnXv7gLCfR2pWyNUyEuKnTQtd6j3WjKIuUhksH7ku8t8jiIR7
   YWSHl1SwBiZs+SEwQDgqBs8ccfKG8zccnAaU2b4opAC5v8jFYctKeUjVv
   xmlbaym8qrZdhTCLtOtC2p25/XNJPQVPXpzcEv8Vnyu7XidBh/k819l5z
   Zl6Lop1qMaS0OvzHqd2wBobP4867TI/viohLqCtKt4qRT5hBbnNVeFyQA
   D5o5pBPi+siwv71cNu+AKbLyhzl0wUew2bUThL+a4ff/eaoS9nsCCovVk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="477991891"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="477991891"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 23:57:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="890174506"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="890174506"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orsmga004.jf.intel.com with ESMTP; 20 Nov 2023 23:57:11 -0800
From: Kinga Tanska <kinga.tanska@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	colyli@suse.de
Subject: [PATCH v5 0/2] Mdmonitor refactor and udev event handling improvements
Date: Tue, 21 Nov 2023 01:58:22 +0100
Message-Id: <20231121005824.3951-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Along the way we observed many problems with current approach to event handling in mdmonitor.
It frequently doesn't report Fail and DeviceDisappeared events.
It's due to time races with udev, and too long delay in some cases.
While there was a patch intending to address time races with udev, it didn't remove them completely.
This patch series presents alternative approach, where mdmonitor wakes up on udev events, so that
there should be no more conflicts with udev we saw before.

Additionally some code quality improvements were done, to make the code more maintainable.

v2:
Fixed mismatched comment style and rebased onto master.

v3:
Resend to cleanup on patchwork.

v4:
Fix building errors. Only two last patches out of 8 didn't apply, so I'm sending just them.

v5:
Patches didn't apply. Send updated version.

Mateusz Grzonka (2):
  Mdmonitor: Improve udev event handling
  udev: Move udev_block() and udev_unblock() into udev.c

 Create.c  |   1 +
 Makefile  |  18 ++---
 Manage.c  |   3 +-
 Monitor.c | 137 ++++++++++++++------------------------
 lib.c     |  42 ------------
 mdadm.h   |   3 +-
 mdopen.c  |  19 +++---
 udev.c    | 194 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 udev.h    |  40 +++++++++++
 9 files changed, 307 insertions(+), 150 deletions(-)
 create mode 100644 udev.c
 create mode 100644 udev.h

-- 
2.26.2

