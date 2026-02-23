Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8749020B80B;
	Mon, 23 Feb 2026 02:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771814442; cv=none; b=NN1QlhgMB8nJHnr2lwCFYPislGv8+l9/Yff3x7ZZcqaWvy3QwUWcrH7HUbcsC5bOu6kZa0AxZoVSMZuTtx7GXMCIyI5SLeNkZkrDqXngfFfaWfHunSBRgx/E7rxCtW0pdCnn9eY0oRHUhT4H+nxpvFqrK6Nw5dXjJm/QOfkfPaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771814442; c=relaxed/simple;
	bh=R9IjAwIGFodu77XV6zmhnJx041VLyWPPsdl/SBPFDDg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AnrVhy5nzaXknSt1jbcxYNNiKflINoMCXvrg8YG/SjmSEiphKe858mci09ISbb4OZSfW2SUUQ6w8xdrLjW3uJf2YQnm7HdDrwx/4ArVe+7VWcy3GvCoR0ZCpPa3xQal/kTn3yH6QPPUGL+GCx8ddG+o25/FElcxL1Ote/vy+lb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854B3C116D0;
	Mon, 23 Feb 2026 02:40:40 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org
Cc: linan122@huawei.com,
	xni@redhat.com,
	colyli@fnnas.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] md/md-llbitmap: fixes and proactive parity building support
Date: Mon, 23 Feb 2026 10:40:33 +0800
Message-ID: <20260223024038.3084853-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes in v2:
 - add error message in error path in patch 3;

This series contains fixes and enhancements for the md-llbitmap (lockless
bitmap) implementation.

Patches 1-2 are bug fixes:
- Patch 1 fixes bitmap data being read from spare disks that are not yet
  in sync, which could lead to incorrect dirty bit tracking.
- Patch 2 fixes a race condition where the state machine could transition
  before the barrier is properly raised.

Patch 3 improves compatibility with older mdadm versions by detecting
on-disk bitmap version and falling back to the correct bitmap_ops when
there's a version mismatch.

Patch 4 adds support for proactive XOR parity building in RAID-456 arrays.
This allows users to pre-build parity for unwritten regions via sysfs
before any user data is written, which can improve write performance for
workloads that will eventually use all storage. New states (CleanUnwritten,
NeedSyncUnwritten, SyncingUnwritten) are added to track these regions
separately from normal dirty/syncing states.

Patch 5 optimizes initial array sync for RAID-456 arrays on devices that
support write_zeroes with unmap. By zeroing all disks upfront, parity is
automatically consistent (0 XOR 0 = 0), allowing the bitmap to be
initialized to BitCleanUnwritten and skipping the initial sync entirely.
This significantly reduces array initialization time on modern NVMe SSDs.

Yu Kuai (5):
  md/md-llbitmap: skip reading rdevs that are not in_sync
  md/md-llbitmap: raise barrier before state machine transition
  md: add fallback to correct bitmap_ops on version mismatch
  md/md-llbitmap: add CleanUnwritten state for RAID-5 proactive parity
    building
  md/md-llbitmap: optimize initial sync with write_zeroes_unmap support

 drivers/md/md-llbitmap.c | 213 +++++++++++++++++++++++++++++++++++----
 drivers/md/md.c          | 117 ++++++++++++++++++++-
 2 files changed, 309 insertions(+), 21 deletions(-)

-- 
2.51.0

