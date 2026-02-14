Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFFC2556E;
	Sat, 14 Feb 2026 06:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771049417; cv=none; b=eVavjxLKtlVyNnZLtUbL4cA3Ox7SeP4F0IYwiNZJ9OiOy05USbWsJXf6079ngpOH54VkKdkNQN+nlFoDl8x5wmoy7eG8aaKJmiomD0vJtwMLjGkWuRjYeYx5EUdEU+FD8RanlNcIfQV2NStdEfqt8vgRUyz4vdkF30OUYMg37kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771049417; c=relaxed/simple;
	bh=5ifd4/XehWphDkZXFw973TrhoGUufDzCVmp5iKfRAFY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jyxb0sedS0dOt502cPfbWEAO8sG/oZ4/hyZ8dAnFf5E8urF1lunJUJcbPaJLb63eHpDZ0n7rYdGmz7NmkktTbmHCLgl80D1Zok8gBOrTIOe+sEm23ESLkqC5O3mZmEBWi/rDLCghp8gEE3kEGSreXqb/hJ4s4yZtETBYvNgTeHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6F3C19421;
	Sat, 14 Feb 2026 06:10:15 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org
Cc: linan122@huawei.com,
	xni@redhat.com,
	colyli@fnnas.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] md/md-llbitmap: fixes and proactive parity building support
Date: Sat, 14 Feb 2026 14:10:08 +0800
Message-ID: <20260214061013.2335604-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 drivers/md/md.c          | 109 +++++++++++++++++++-
 2 files changed, 301 insertions(+), 21 deletions(-)

-- 
2.51.0

