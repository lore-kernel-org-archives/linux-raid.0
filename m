Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5093002B9;
	Sun,  2 Aug 2026 19:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700252; cv=none; b=DLorpmApGbCGIr+LzKveDbGlaaB1UtGM6vD4obDHf7MM1CkHLCbeQfOyFxWNVzraR0gA81tnBiKoVsZkBX4o2zR5w1mGocoigWTwGrzMLBStI41zf7bPTX91f1K/jRTCYcxao449fmIFtWn7bmIyMTEJRF8RLvIHyy2laoMdrno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700252; c=relaxed/simple;
	bh=Iu/k9tdgkPqDHBtJe0dzZZYxYB7j870w1vAFOE8DOKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpt1L4N3nrUseEdcMsC/X0P1lMGY7Zc0Tud/8J3ALrXE39XVbR2NSbCx7qOBtshd5U7hC9BhWytB0pAINUIKPa7F8soRDyLGXFRBdFhD27Dh5qAnLMVX3fYghTTAH3sxrFlGaOxBMb+TJZkO4aBeZWp+GouOq0DCGVRFawTMhfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oyzA89nE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oyzA89nE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A8E1F00A3A;
	Sun,  2 Aug 2026 19:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700250;
	bh=LwFUXhNbqVsFRuYQdRZ6MNKemfzqMBb3k7WjbIe3rkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oyzA89nEnYCyaiZEI02iEes6e7vnSq3q0oyDhJL2Ucjj2ha/0RqnSmcsdQJ0UBivV
	 wI2aRPH0x3EyGcSTzJvz/6UICultg2wOhz3oD1HlkaZVL6+MrkFRxn7jGUuN1Hb7N/
	 5PcCiF22piyfz8EADSlNvX6/jXXUXcItbfzRN69+pdr2kK01bZXbtn3EIbaCvJ4CqV
	 hWRgPmaxefuuoBKZV4fwXla+L2juVUkeG0Iq+NGAZvStklhoQRRIQdP3npRw1aYjTP
	 WDrJ9jOeH57vMw8qTmUYwSb2W8BxOp6M5DwhDZn1kmlpfJxEFQf58iSJtTqtiIk7gE
	 F9q4znwxggjuw==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 01/29] md/md-llbitmap: clear flush state after daemon flush
Date: Mon,  3 Aug 2026 03:50:10 +0800
Message-ID: <20260802195038.164272-2-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260802195038.164272-1-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

llbitmap_flush() sets LLPageFlush on each bitmap page before it queues the
daemon worker. The flag tells md_llbitmap_daemon_fn() to ignore the normal
barrier_idle expiry check and clean the page immediately.

The daemon only tested LLPageFlush. Once a page had been flushed explicitly,
the flag stayed set, so later dirty bits on that page also bypassed
barrier_idle and were cleaned the next time the daemon ran. That can make a
new write look clean much earlier than the configured idle window.

Consume LLPageFlush in md_llbitmap_daemon_fn() with test_and_clear_bit() and
use the returned value for the current expiry check. The explicit flush still
forces the current daemon pass, while later writes on the same page wait for
barrier_idle again.

This can be reproduced through normal sysfs operations:

  1. Create a small RAID1 with --bitmap=lockless and --assume-clean.
  2. Set llbitmap/daemon_sleep=1 and llbitmap/barrier_idle=10.
  3. Toggle md/array_state from active to readonly and back to active to call
     llbitmap_flush() without destroying the in-memory bitmap.
  4. Write one sector and read llbitmap/bits immediately, after 2 seconds,
     and after 12 seconds.

On the bad kernel the dirty bit is already clean after 2 seconds. With this
change it remains dirty until the barrier_idle window expires.

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 2a2b38c663c3..71e9a21b98b2 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1066,14 +1066,14 @@ static void md_llbitmap_daemon_fn(struct work_struct *work)
 
 	for (idx = 0; idx < llbitmap->nr_pages; idx++) {
 		struct llbitmap_page_ctl *pctl = llbitmap->pctl[idx];
+		bool flush = test_and_clear_bit(LLPageFlush, &pctl->flags);
 
 		if (idx > 0) {
 			start = end + 1;
 			end = min(end + PAGE_SIZE, llbitmap->chunks - 1);
 		}
 
-		if (!test_bit(LLPageFlush, &pctl->flags) &&
-		    time_before(jiffies, pctl->expire)) {
+		if (!flush && time_before(jiffies, pctl->expire)) {
 			restart = true;
 			continue;
 		}
-- 
2.51.0

