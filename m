Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8612F8EA5
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 02:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782268864; cv=none; b=EXq0QhfWcJTlXAErOh+Bc0x604xXfiK9Tp2yar0MfFjELnxir98UgrakDCQOUE1rOix+KvwFvuxIIJS2/J2ZPcvizAxKNMveN3PfPPSmXwSzKiVc2kk/fIUl1dWGGsxF/R78vTb4Jj223fVG2AKE6Pi9iDZ9ndnohNYngZMPORs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782268864; c=relaxed/simple;
	bh=t4EuNo//Mi2y/Y7KTnrudzR8N4002wT/TRksL55PVOI=;
	h=Cc:Date:Message-Id:Mime-Version:From:To:Subject:Content-Type; b=PjWymFyF16TuEnUR4faGwVr72hYON7fajiGHd+k0+NmdnXZfRCzMnUf04kJLKewpzybd5zNfubTWDPFuFHtLKm1azDlB1prfxoW41yeKVpXD604qFxRSap8pYqlEELEOiIuDhOzGXAVSWkKYS0YdFYksdLZr1U1hNtqUA174LC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=FGm63yYz; arc=none smtp.client-ip=209.127.231.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="FGm63yYz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782268856;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Eku4zNgmxKjB5KdDsW0BdCpRK5W6m2Bx/z0iIoLpXiY=;
 b=FGm63yYzxgr67syOEtDxGzKPQ3nzb1V3R/0IBjn8ZGzbXrhlXgNXRW2I69/2mQ1e8MnS7g
 Kiqtjd7tV33wNYAQwPiuEKjUUdtCSK5vjWXIQT4hMNMhDdVrNm594YF4PnozQtOMMeSWLC
 JuzicWO2hJh/ye6kMNcKf53WwtST83ZOpzYLBIVsgdGIRANH3n1f/d9FUdtmO/Sy/gpPkK
 2k0J18neHTH1l/sXqlA2JbQGq+kP6f+ZRRSgy4vzvrFHzlaXj2irxXBYc9wleBQgNm3x4u
 jOhFvXg9hUpLPmtl0IehGzseAx/8VC0BuhelYIBm8AfufhXPJUyGP9f/AjIthQ==
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Date: Wed, 24 Jun 2026 10:40:42 +0800
Message-Id: <20260624024042.2561803-1-chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: chencheng@fnnas.com
Received: from localhost.localdomain ([183.34.167.222]) by smtp.feishu.cn with ESMTPS; Wed, 24 Jun 2026 10:40:53 +0800
From: "Chen Cheng" <chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a3b43b6+037489+vger.kernel.org+chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
Subject: [PATCH] md/raid5: fix lockless max_nr_stripes reads
X-Mailer: git-send-email 2.54.0
Content-Type: text/plain; charset=UTF-8

From: Chen Cheng <chencheng@fnnas.com>

max_nr_stripes is updated under cache_size_mutex in the stripe cache
grow/shrink paths, while is_inactive_blocked() and
raid5_end_read_request() read it without that lock.

Use READ_ONCE() for those reads in lockless path to match the WRITE_ONCE()
updates and avoid KCSAN data race reports.

A similar issue was previously fixed in commit-id:
	dfd2bf436709b2bccb78c2dda550dde93700efa7.

Fixes: 0009fad033370 ("raid5 improve too many read errors msg by adding limits")
Fixes: 3514da58be9c4 ("md/raid5: Make is_inactive_blocked() helper")

KCSAN report:
=================

BUG: KCSAN: data-race in grow_one_stripe / is_inactive_blocked

write (marked) to 0xffff8f01f0b5a268 of 4 bytes by task 12616 on cpu 9:
 grow_one_stripe+0x2d8/0x320
 raid5d+0xb57/0xba0
 md_thread+0x15a/0x2d0
 [..........]

read to 0xffff8f01f0b5a268 of 4 bytes by task 12670 on cpu 11:
 is_inactive_blocked+0x97/0xc0
 raid5_get_active_stripe+0x2fd/0xa70
 raid5_make_request+0x4aa/0x2940
 [..........]

value changed: 0x000003b9 -> 0x000003ba

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cb58b4353995..cacdf4211628 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -799,11 +799,11 @@ static bool is_inactive_blocked(struct r5conf *conf, int hash)
 
 	if (!test_bit(R5_INACTIVE_BLOCKED, &conf->cache_state))
 		return true;
 
 	return (atomic_read(&conf->active_stripes) <
-		(conf->max_nr_stripes * 3 / 4));
+		(READ_ONCE(conf->max_nr_stripes) * 3 / 4));
 }
 
 struct stripe_head *raid5_get_active_stripe(struct r5conf *conf,
 		struct stripe_request_ctx *ctx, sector_t sector,
 		unsigned int flags)
@@ -2767,10 +2767,11 @@ static void raid5_end_read_request(struct bio * bi)
 		if (atomic_read(&rdev->read_errors))
 			atomic_set(&rdev->read_errors, 0);
 	} else {
 		int retry = 0;
 		int set_bad = 0;
+		int max_nr_stripes = READ_ONCE(conf->max_nr_stripes);
 
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 		if (!(bi->bi_status == BLK_STS_PROTECTION))
 			atomic_inc(&rdev->read_errors);
 		if (test_bit(R5_ReadRepl, &sh->dev[i].flags))
@@ -2792,17 +2793,16 @@ static void raid5_end_read_request(struct bio * bi)
 			pr_warn_ratelimited(
 				"md/raid:%s: read error NOT corrected!! (sector %llu on %pg).\n",
 				mdname(conf->mddev),
 				(unsigned long long)s,
 				rdev->bdev);
-		} else if (atomic_read(&rdev->read_errors)
-			 > conf->max_nr_stripes) {
+		} else if (atomic_read(&rdev->read_errors) > max_nr_stripes) {
 			if (!test_bit(Faulty, &rdev->flags)) {
 				pr_warn("md/raid:%s: %d read_errors > %d stripes\n",
 				    mdname(conf->mddev),
 				    atomic_read(&rdev->read_errors),
-				    conf->max_nr_stripes);
+				    max_nr_stripes);
 				pr_warn("md/raid:%s: Too many read errors, failing device %pg.\n",
 				    mdname(conf->mddev), rdev->bdev);
 			}
 		} else
 			retry = 1;
-- 
2.54.0
