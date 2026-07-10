Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E848282F06
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783689826; cv=none; b=RKQxFCOyuCZM9vxiftLzWVXuniz1Lb5IAzUooFhQ94RilhoJaWr0qSE6CkUKwSTSMt0pb2yc+DSR84RpcHedwPrmiTtgKQjBfToXLA2nx5QW+tcgsh6jHXaeK75dNZ54XjOsfzOC4f5Ho0sfPEiRzoeolDLWQTS91035KjZIL5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783689826; c=relaxed/simple;
	bh=rILqh2AK/wV2oaCV6mXWPyP6nIH7VlWbJRVUdRAVWuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojd2xD5ypnRvLk06qmMjde6KZoqYkGWXgq26gPzeNYdRn5fPWGDeOmMFjUa+c63R8GHnBIJtaBSWT8Jhm7TVNq94kqgQZamvy5x9GPxMtBwHqIjiqEfzJqfTgS946oAD0IJ33OQl/UOcte1ghSUTWxUEXQRWo26OlIjHAaBfuFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EK4aSRsP; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EK4aSRsP"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-37e0a189b0bso860481a91.1
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 06:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783689825; x=1784294625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=htRKr+bV2R+fMpKz8/j8vcbQE0s04qSNR7/x8WoH3ss=;
        b=EK4aSRsPKEg9Zb+/EsMN2w1GDyRm8f0JMvU08cl++aVkOxf5975T3MyyyWFp004CT8
         km/YbZt9k4BwhVZNTd4F0wp1rLEv16XOl65a/F/Cc2qwkon4GLAEjG4dCpYzQ6sPtqPF
         O0WurkQIE5AxQXC/egqQtObpRAzpCQ0w+lE2RBB37ZoLv4g5YzzXKlAgXM4Z/wnjegy5
         jiClReeeBQiUaxGHoYxzGgJYdgwZi82KIcPnL2TYk74PcYNBYJY6q4YYsZWpwpsOEDX1
         7hz0wwj7FZA2HiQdN6vIeMl0wD7BXqMjQiO8d01EUv8D2gJtKT8nX1vuq9BNBKF0SLKD
         SLBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783689825; x=1784294625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=htRKr+bV2R+fMpKz8/j8vcbQE0s04qSNR7/x8WoH3ss=;
        b=bBXtmkGQ+ElQqtjppZwrphFVY6/iYodgSvtfeO2KGzEj7w7boCtBsAwXcy6eqTnenl
         eazi8Q6gHtP0XaCY21Uko+sFM2/H76e5utx8FT8KZjCr1g8bEwSwLSJ0Uirk9Nzew+m6
         5zOYjYBXh5qPxzfwYnLcx749SYp1IUm+lxMbqzj0+Xrlz0DE/VgAxHKijdy2OWR1TbEX
         gQWxrA5VhJiYrWE5ORW/hcIm2X0rvwZucKEYh50Ffmu+bzOheOnQoEBw5t7xAxvOZxuo
         j4V4cz+nv/hyxV4vuVcEwGfXHajYFOMKL2bziOVN1fJIimpexQWYBpNizCIXp75gjTM1
         zhjQ==
X-Forwarded-Encrypted: i=1; AHgh+RphTbHy3fWtTgn6Q0JvpP6nvqhkOEHmY/CTrQuSMosASBgAZ7Qdxb729S6yVoHNN/nvTzYbDI4MyUgO@vger.kernel.org
X-Gm-Message-State: AOJu0YwVbl39UApGUQH9Iw8cYmR3wNMbByR7FfVjInLT/lyg+t5/s+zm
	m/h/VbFlF9UNsBqo3KoBtQipiwMZOC4Mnd+sDBwCQLRGxBWLWw4yss9e
X-Gm-Gg: AfdE7ckpQQIUmjpgMr92YbpHtTp0RDSvo2a2aFU+EGQSyKiCBy0LH2bv2lUv52sMZ31
	2AiyMURZpkjQGHPHfJNbdVc9u64koOLJoHx28OQtA7LSBLdC19JSdsaHScK41lQPW5V30J8slHT
	FNXiP4MXajydHPuGBOQtWVe35vKpszJkXieqoXa7XEgPctP5RWON3yJGvBKOrIIxs0nHkF0TinU
	/Ubgm1b5Vvuh2d0Eje80Lezd1AxvjIy6v0Vp7jTBBz+Bt502nIe/xAs8nj2isEUnb8STLJdBuMa
	R6TOgG3iRiXVczkwhWrwUHkCWXRazlcMKRQKiHzrT9dl1uZmXXLGxi10vq6duolWbIww5ff4Uk9
	X5u9ZRpiCK83FV/db7ou081tyGKBt/j1YFRzL2TCV7M3liRwvm7jzT9/sDPZvGlcurBBhtqDDqu
	palyTI/F1/ZL6G6sFy/ek2A+G3XdxPRz15SsBx8C8Z5NEt2gN4V4CXX+r3dPZtMMys7TSTWRexp
	u3g0mQ=
X-Received: by 2002:a17:90a:e70d:b0:37f:9cdf:f03a with SMTP id 98e67ed59e1d1-38941fb57e3mr11438439a91.29.1783689824706;
        Fri, 10 Jul 2026 06:23:44 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38d2fbc64b5sm549778a91.2.2026.07.10.06.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 06:23:44 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 2/2] md/raid5: reserve stripe cache for user I/O during rebuild
Date: Fri, 10 Jul 2026 06:23:39 -0700
Message-ID: <20260710132339.7284-3-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710132339.7284-1-nishidafmly@gmail.com>
References: <20260710132339.7284-1-nishidafmly@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The resync read-ahead window (RAID5_SYNC_WINDOW) can fill the stripe
cache with rebuild stripes and starve concurrent user I/O, producing a
burst-starvation flip-flop between rebuild and application throughput.

Add two yield points to the window-submission loop:
 - stop the window immediately if any thread is waiting for a stripe
   (waitqueue_active(&conf->wait_for_stripe)); the check is intentionally
   racy -- a waiter appearing just after is serviced by the next
   sync_request call, so no barrier is needed.
 - stop expanding once active_stripes reaches half the cache
   (max_nr_stripes / RAID5_SYNC_HWMARK), but only when
   preread_active_stripes > 0, i.e. user write I/O is actually competing.
   Sync stripes never set STRIPE_PREREAD_ACTIVE, so during a pure rebuild
   the counter stays zero and the window fills freely; rebuild-only
   throughput is unchanged.

This bounds the share of the stripe cache a rebuild may hold while user
I/O is present, so application latency no longer collapses during the
read-ahead bursts, without throttling a rebuild that has the array to
itself.

Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/raid5.c | 21 +++++++++++++++++++++
 drivers/md/raid5.h |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 574880e4f23f..6575bdb84bb2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6656,6 +6656,27 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 	     submitted < RAID5_SYNC_WINDOW && win_sector < max_sector &&
 	     win_sector < mddev->resync_max;
 	     submitted++, win_sector += RAID5_STRIPE_SECTORS(conf)) {
+		/*
+		 * Yield to user I/O: stop the read-ahead if anyone is waiting
+		 * for a stripe.  The check is intentionally racy -- a waiter
+		 * appearing just after is serviced by the next sync_request
+		 * call, so no barrier is needed.
+		 */
+		if (waitqueue_active(&conf->wait_for_stripe))
+			break;
+		/*
+		 * Reserve cache for user I/O only when it is actually competing.
+		 * preread_active_stripes counts stripes queued for write I/O
+		 * (including the read phase of RMW); sync stripes never set
+		 * STRIPE_PREREAD_ACTIVE, so during a pure rebuild it stays zero
+		 * and the window fills freely.  Competing user reads do not bump
+		 * the counter but are caught by the waitqueue_active() check
+		 * above.
+		 */
+		if (atomic_read(&conf->preread_active_stripes) > 0 &&
+		    atomic_read(&conf->active_stripes) >=
+		    conf->max_nr_stripes / RAID5_SYNC_HWMARK)
+			break;
 		sh = raid5_get_active_stripe(conf, NULL, win_sector,
 					     R5_GAS_NOBLOCK);
 		if (!sh)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 63b630118782..263330af4e7d 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -492,6 +492,7 @@ struct disk_info {
 #define HASH_MASK		(NR_HASH - 1)
 #define MAX_STRIPE_BATCH	8
 #define RAID5_SYNC_WINDOW	32	/* stripes to pre-submit per sync_request call */
+#define RAID5_SYNC_HWMARK	2	/* rebuild uses at most 1/N of stripe cache */
 
 /* NOTE NR_STRIPE_HASH_LOCKS must remain below 64.
  * This is because we sometimes take all the spinlocks
-- 
2.43.0

