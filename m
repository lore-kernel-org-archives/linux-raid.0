Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B98E31E833;
	Sat,  1 Aug 2026 17:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605135; cv=none; b=H5TVM0HQHIDxegfGDZKAqQsgQr2MHu9/y7YeuKdVVhlXfK6iEnBeioNl0iFEM3TTligdDjrcdCk40mdotr/vfS/BwawZvNCCkVUapr5dN8I9KoKRmIr6S2WHE5nXoCVsfLlSlRyriOvp2IqaJqzkedZJ45b5Vi6SQhYpt1CbdeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605135; c=relaxed/simple;
	bh=VfjxbcJL8/gSToXg1vkt8OxQMAH8ZhH17UGWLqGr9a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gva9L3GL/n1CZkiatLho3pzrNNrkcYKle2JMOUFz1JW3NKe6Fg/JNZLIUIzFVoDnUDnL9jWa3Lcs+MZUgw4APNBw+nHCH0IT+/3f59xpdsiWrAHqEV9YypC22HO+tFAY5PZFrXu1i6E2YJq6DDmDknDKIBipiKMfbuRhOjjFwqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mlJpNB6Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mlJpNB6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCACA1F00ACA;
	Sat,  1 Aug 2026 17:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605133;
	bh=ObOE+s2buET3Z5WjVvzdDr2VEYnY9W3nx5j/qB2xlPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlJpNB6QEUAT5ad+pHX3Hd3TICxx5IwgG8DZ35ImcVIsjbgYM/D7rN09y0Fgj/RQy
	 UAnkys2OVNkcVaLZ6swxRVfWQ80EwRR0d5M5GBQMyba7cQsk8jfvrpLb6qiYDz1Jv9
	 nQkiJP0bSAroNXDZYmZu5BIpss4CefkktA2lKwoRioD2R0gY6oC8dSNCRNZxyyj5PS
	 lbjmL/3qT5fcjLMC7S9BuIKRvkl3qMQZDEi5rAQH/9IumIhlJXXAJyxBojK2Qq10co
	 idGqaDsxiJ0rHf89h1b2/HqZCDSOqSejuM7JvjdHvlFPvwzv3FKnGLqGRBzEhvHiWz
	 AslKNAmgooL3Q==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 01/25] md/md-llbitmap: clear flush state after daemon flush
Date: Sun,  2 Aug 2026 01:24:55 +0800
Message-ID: <20260801172519.2982121-2-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260801172519.2982121-1-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
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

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 5a4e2abaa757..131582724e7e 100644
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

