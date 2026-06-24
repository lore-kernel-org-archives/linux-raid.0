Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F0A3DCDB3
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 15:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316518; cv=none; b=pA68R5HMYmCBOMMZCZdQr0d7JZ6XkL6x4qNLT2esBZ875R77UfvK6m9DukBvUyCZLMKtHKqPW1OrFyiemhYYVyMoExeQHdME4a9hH0hL59ueK04v95W1bBbho50E+HXrNN9jDVMDYG6+NnRFqbqwxeAAzvYlf2qyR+xJePd5yqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316518; c=relaxed/simple;
	bh=t1uj1IUEKjBEFFYpHnyLCaDRWo8aPPY9JAML3T2kDuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RcgJOTbjy4XA5LPcfnbk6a19Z1wmJTkeRRQiumMxcp3Nzjr/RQ5Vx/M2fto5Ji7KHcrUEdsaxFJw9oWd4SgGXpuogtM6+DPkcofeuV6QiE5cQYKFla9BUWt8/PyhHWa59qyXdCn7/6TCs5DYB9JBSiivXTDuLLkG8+7q5dZACAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QfWssQ+k; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QfWssQ+k"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84236f9b638so703085b3a.2
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 08:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782316515; x=1782921315; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kCcmbF5OsIJ88nJrszmo8vk/FguefJrYsZdf2oyW79s=;
        b=QfWssQ+kUOrA7URvhiM0IHzxim8pEOxCdbbcI/OoTZFBCIbpeHejUNMGWA3CS1e75N
         hADevmYfjZs11QhjGfktYHK1ECotK8DR+IUVOUKRoxVW2quPQD7d8x+BkKK3nliONnD1
         1sjtsEyFJZd8bKBmJmOKKR+eaokip0jOimS/yfhC+dWY6Eg+4xtnIq/KCl175vtDCR1K
         dp89D45K9IYAIG/4tbUZtKDzq/+pucV4phCA6Td4Q28xRAxvr5fa/DgKQf9CusMVbcsH
         yV3h/INryoR9kyh8EbtJ18ozfBt8H/5zcMwLt+GvYy6WJdN0cs0VFhSGb8wZbcOtjW3o
         ARfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782316515; x=1782921315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kCcmbF5OsIJ88nJrszmo8vk/FguefJrYsZdf2oyW79s=;
        b=JOhGFWT1UmxWiD1HakrJbhuoKirpj5hI4lfaN7pm7PaQRKjWQpQ/uCxT2YCS8cT0ao
         9XfEk1MbcWeL7fm6WNoi/UwiqJ60LS+HLihkX2L0Tdi9rLR9BkSOzTFCrAD4Mh1e+ihy
         /rH9nvZuHsBwuY1NeBI0gREAGpWKOEm7lchk6vMfQpmvlMAnEMlY6YBRX5Iyptuae2EH
         /CAIO2L65ek8FyP0xHMg5bavLaG+24N+ENZF8yGbU/3YD17BK7H0f1L5V1cWTe3stgZ/
         Ue9SuUt0hfIXD0aB3PDx7Kuz/bHG6JTSG2H89rjENwvw99w6phgUjKeNoKLlK8AQUegR
         XMtQ==
X-Forwarded-Encrypted: i=1; AFNElJ+T1BkAD3GxDoH81NADOyA/ZAYwPhofSXLQ+qAfxqZZ1yVy1HP7E7/5vjuvjtaIO3vrRg1VaGhCAX+3@vger.kernel.org
X-Gm-Message-State: AOJu0YzcqTOUkO+CZdY/avC5oNMFsvUc37/dPYDMHqWHbzyyMJ7n/j56
	/nsoe/qppGTRqR0bdy0MojxMT4M/ch4C1OcI1YKlbOcbJW5tkbLYwgNsbYIiN+GS0B8=
X-Gm-Gg: AfdE7cn7VBzaR6QNaSimGxTbR/ce9dHqVRQRzl/f/QRoQazm346p0pxgeiEXRjjb6LB
	ne1B3kZZTbLFFQ+YlUT+K1bnBDfMPCTfwpRwcjEYSH/tJkYev9+RXlKiHfK8DDc/XAE/GVuYhtD
	km+oA3QhWTfpCuX9RVoFG5DQD7gbYKCHqedSP6g8FilXt8aD/CBvLzc3nkFIjwaUpZDPgbf+1Xf
	wkAXXNeqVhdAtUjFht3yy8ry0rNZFkUzvBnQaxnx8yhqgcTlcFWMNuCTJ/CpP6Sk5mVHT6TqTKW
	kw8wyF42b82FZBPS5OsK3n0Me3FqPgx3iPb6h2upSGG4NgAc8doZOJDpkoOOBJSnvuCpAozoTh8
	gzFNPn4Hjaz5sLskEWHFyqIMgwZ+tMvMvTx7CqUAMXrcu8C0G1e3U1LdRt1h31uz0O5X/UuSbLm
	UrDRzy2inTO5NMjPD4fWEsg7Eg7d0/0u1Ni/yPiFHe23Hyq5CwbWC/mZQT29V2adng91Ji15Lam
	Os4znc=
X-Received: by 2002:a05:6a00:27a4:b0:845:352a:a207 with SMTP id d2e1a72fcca58-845a27c3137mr5086116b3a.34.1782316515334;
        Wed, 24 Jun 2026 08:55:15 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a40f55cesm2658387b3a.44.2026.06.24.08.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 08:55:15 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 8/8] md/raid5: reserve stripe cache for user I/O during rebuild
Date: Wed, 24 Jun 2026 08:54:52 -0700
Message-ID: <20260624155452.211646-9-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260624155452.211646-1-nishidafmly@gmail.com>
References: <20260624155452.211646-1-nishidafmly@gmail.com>
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

Assisted-by: Claude:claude-opus-4-8 [Claude Code]
Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/raid5.c | 21 +++++++++++++++++++++
 drivers/md/raid5.h |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ad6230415af3..480f3aa069ef 100644
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
index 1f37dabd727b..7833cc07597f 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -499,6 +499,7 @@ struct disk_info {
 #define MAX_STRIPE_BATCH	32	/* stripes per handle_active_stripes pass */
 #define STRIPE_BATCH_WORKERS	8	/* stripes-per-worker threshold for spawning */
 #define RAID5_SYNC_WINDOW	32	/* stripes to pre-submit per sync_request call */
+#define RAID5_SYNC_HWMARK	2	/* rebuild uses at most 1/N of stripe cache */
 
 /* NR_STRIPE_HASH_LOCKS must be a power of two, since
  * STRIPE_HASH_LOCKS_MASK masks with (NR_STRIPE_HASH_LOCKS - 1).
-- 
2.43.0

