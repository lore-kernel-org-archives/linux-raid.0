Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E73F18A92F
	for <linux-raid@vger.kernel.org>; Mon, 23 Mar 2026 05:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774244816; cv=none; b=qWX2744dOUCJaz3hefkLp588JvZ/GPKR4ErOJV6EDg6mVyqLrdg1e9gC+P6beX4oxs0+sXCYf0xsvpR9/dpo1nafqn2loywBo9gBotCywW5M3lFdPm1pNACrQ3aiypLunjenMdY9eQRlOpwpsM88UC9N3S1iNmo9VXxKVIBiVIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774244816; c=relaxed/simple;
	bh=r2cAKzSwnE9ipWB+IAq1WUdkUH/+dOeOV62e840Fezw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hJkbmrxzTPkt9AgaBATEpzAc7+hdfCVgIESZ9LB9285WflOK4KXOxjRmjkg2RgwBVl1/6ADUbZO6jckBy0idF/Tr6oBvAUFa34y69K7l8KNi+3N57r/Jg7lfOEGi6nuXN73nVS6L+evX/xx3Ns+AgEaDv4giQbn8cKr409Bfhyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09144C4CEF7;
	Mon, 23 Mar 2026 05:46:54 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org,
	song@kernel.org
Cc: linan122@huawei.com,
	xni@redhat.com
Subject: [PATCH v3 0/3] md/md-llbitmap: add CleanUnwritten support
Date: Mon, 23 Mar 2026 13:46:41 +0800
Message-ID: <20260323054644.3351791-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 improves compatibility with older mdadm versions by detecting
on-disk bitmap version and falling back to the correct bitmap_ops when
there's a version mismatch.

Patch 2 adds support for proactive XOR parity building in RAID-456 arrays.
This allows users to pre-build parity for unwritten regions via sysfs
before any user data is written, which can improve write performance for
workloads that will eventually use all storage. New states (CleanUnwritten,
NeedSyncUnwritten, SyncingUnwritten) are added to track these regions
separately from normal dirty/syncing states.

Patch 3 optimizes initial array sync for RAID-456 arrays on devices that
support write_zeroes with unmap. By zeroing all disks upfront, parity is
automatically consistent (0 XOR 0 = 0), allowing the bitmap to be
initialized to BitCleanUnwritten and skipping the initial sync entirely.
This significantly reduces array initialization time on modern NVMe SSDs.

Yu Kuai (3):
  md: add fallback to correct bitmap_ops on version mismatch
  md/md-llbitmap: add CleanUnwritten state for RAID-5 proactive parity
    building
  md/md-llbitmap: optimize initial sync with write_zeroes_unmap support

 drivers/md/md-llbitmap.c | 202 ++++++++++++++++++++++++++++++++++++---
 drivers/md/md.c          | 111 ++++++++++++++++++++-
 2 files changed, 299 insertions(+), 14 deletions(-)

-- 
2.51.0

