Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3785F42EEBB
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783689831; cv=none; b=qqmHSwsl6sZRiz/XNc4D9JB1LjGRa9WHxAQyNy1511+dOun0SwJg+g2Ihw8OVXug28hox+LAky0uvIYzojtutINvcC+uJ+/V5pu/eL/8YJOBrdFhteMqTK1eETplhYpIh5LsEc8Mu/gU7EExe1NHMMKs9b2pUz5npapwjkx/WlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783689831; c=relaxed/simple;
	bh=R7TDV0Q1h/qruG1y6coDHYIFxXLtxtOCASDEtl7VWWc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jqvvi4PYyVQGjmE1APAsf3ClqOx9Ch5Mt4rG3J01M8HW43z0+fWHhoZ3SlXeWHOFDbLX+BfivKRIzfRV69dZKhJu650wYQ9uDeHseMtPddaKDfhpQIZClEztZF10pEQzLNZlvY5r5GxxONvSwjPa8wk+AfokZSSU9AeBzwLnySk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mOTpSAut; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mOTpSAut"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-848595b338cso976088b3a.0
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 06:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783689829; x=1784294629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hmAchr8iFxD30ErCV9YYAvznEm9Zls+Mg0t1tuNJ0JA=;
        b=mOTpSAutty/9fn+WYgn2ra3d1GzyXy6GWhIsevYsBuyvYbwxr5m2UAdUWOt8PI1iQy
         t2IqMksGM0rclu2tMTz4wGmD+DE2UNZbbmmyxUbFFnuvlwb2mMb8PT0/yQ8BLt0EGOKf
         wwI17uDETCLspFnPTJwS5x2nGAPG/Y0NcC4mvSxNjuB8X9enBOruGnIO/RXyvRJkwrPb
         S6oIvw2+rKpORSzAvILjx+VJp3HruRKxJ41tsqR4kt4fXV43Wc8w9QunyDc9FdIMZg+8
         JPRGGtzY1SUIt1aKMzY45TeEo4gP03BgGJMh/ukSZzh4DVUx90SvrTFl5vv4pzajWRoF
         R17Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783689829; x=1784294629;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hmAchr8iFxD30ErCV9YYAvznEm9Zls+Mg0t1tuNJ0JA=;
        b=BHzeMDLu1BRWcnuDCN3CskosBUKc8SvA9RFytcLjTxuhS1Yc/s0Di6swIiNGUvF8On
         98wD0wY5/HWnIiNznD67MaJHqvFR0BRoFehdUnjFblzdp/btuJKzl/nWVsmzPk2KC+IB
         28puZ54WgoymgzB8ISv30okuLkxlS8wJGWJp7d+cWH47N24D+7S97vZdoF7mGzE9mnfd
         jCR66ldrUPPUVr3hsiFuRxLC7WUiD5/41WezPPGOrn/toCPArVllcPxTrgmfByxgiNfm
         6Y3hXvbP+ZNrlOqOlwWv+7V4MzRC+8FF5OwU4WCO15HovkNVnpDwUM1lKorkO1x/c87J
         O/0w==
X-Forwarded-Encrypted: i=1; AHgh+Rokb+Kc79iqnSEwrQaQuPpGOI0ZLoy29VbipdZOQPk9gAv0KxLz97WTmOhUvZMSeDDC9OU9LfoprPQh@vger.kernel.org
X-Gm-Message-State: AOJu0YxhYm6Pb56Ufbh1jZi4y2MJN47wMNFNc6KQAkHnKfYlyjBRqpyX
	JqoVci4PtRtDMk5lIgYkpjZd9yALFYcMSjzBeF6u4L6KPGUvod6txvzg
X-Gm-Gg: AfdE7clQY7cITP2dIhBKCLJq4Lpyi/0vsMa7jPWxuVtVH9vXfHfhGV4YQNZKgcw2pgm
	crGKhacyP/KmN43z+40VnJwylz6als11m+wvLwwgHXM3lPvvyQlmz2IbiOvYBdwVey9SGF156FW
	OZVpRyYsNvG0YhbGQ5zEICZTCB0ev6ofHA4w7nQAC6qe9Pq6bmcFNapJDU9H1T6c3udYpwkmOiQ
	xRGItX0qM61MWeEoA8YBjeh0cvAtUhypFSx5kTWwi9Kxg0Qfp3AgCjlQkJ0N2Yneq+/PDFuoeGf
	mD+44tBGMg9lNiSftlmr26Wd9hGodwH//BNjK3a7bE+hoQabiPDqVlcNH28+CCzPQ6l8Srv5y6O
	uPdDETchsaOzLwNacAlYjaiqnDEEayUTzlH3enRtO3m/ziX/EbPi07gVOID86OoDYmPOC+Br2HJ
	LEyNgKLnFotxCfCZ7YL+JSXB0cHS81ut5zHkzWfR1hh5aBEoyZhPNRfYWhm2XHr161XbPSnWmR+
	eNAZRABau+5jiwbkg==
X-Received: by 2002:a05:6a00:4fd4:b0:847:9745:2f8f with SMTP id d2e1a72fcca58-84842ef9336mr11254149b3a.18.1783689829454;
        Fri, 10 Jul 2026 06:23:49 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3b251eesm4903776a12.31.2026.07.10.06.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 06:23:49 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 0/6] md/raid5: size stripe-cache and worker tuning from the hardware
Date: Fri, 10 Jul 2026 06:23:40 -0700
Message-ID: <20260710132346.7295-1-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

md/raid5 has several tuning values that are compile-time constants chosen
for the modest systems of years ago:

  - NR_STRIPE_HASH_LOCKS   (8)    stripe-cache hash lock striping
  - the 32768 stripe_cache_size ceiling
  - NR_STRIPES             (256)  initial stripe cache size
  - MAX_STRIPE_BATCH       (8)    stripes handled per device_lock
  - worker_cnt_per_group   (0)    raid5 worker threads (group_thread_cnt)

On a large-memory, many-core host backing a wide array these are all too
small, and the only remedy today is to retune each one by hand after every
assembly, or to recompile.  On a small NAS a fixed larger value would just
waste memory.

This series makes each value derive a default from the hardware -- system
memory for the cache sizes, CPU count for the lock and worker counts --
while keeping every one overridable:

  1/6 (prerequisite) size the worker_groups[] array by nr_node_ids
  2/6 size the stripe-cache hash locks from the CPU count (8..32)
  3/6 scale the stripe_cache_size limit with memory (never below 32768)
  4/6 make the stripe batch size a module parameter
  5/6 scale the default stripe cache size with memory (256..4096)
  6/6 derive the default group_thread_cnt from the CPU count

Patch 1 is a prerequisite correctness fix that patch 6 depends on:
alloc_thread_groups() sizes the worker_groups[] array by
num_possible_nodes() (a node count) but indexes it by cpu_to_node() (a
node id), so a sparse NUMA node map can index out of bounds.  That is only
reachable once worker groups are enabled, which patch 6 does by default --
so the fix goes first.  It stands alone (Fixes: 851c30c9badf) and can be
taken independently.

Each tunable default only rises on hardware that can back it: the lock and
worker counts (2, 6) scale with the CPU count, the cache sizes (3, 5) with
RAM.  A genuinely small system -- a few cores and a few GB -- therefore
keeps today's values and today's memory footprint.  Patches 2-6 each add a
module parameter to override or pin the value (patch 6 also keeps the
existing per-array group_thread_cnt sysfs attribute), so an administrator
can force any of them, including back to the historical behaviour.

Patches 2-5 are sizing/capability changes with no throughput claim -- the
intent is simply that the out-of-the-box configuration tracks the machine
instead of a fixed constant.  Patch 6 does move throughput: enabling md's
worker groups by default measures 2.1-3.2x on a 16-disk NVMe array (a
32-vCPU / 16-core host, steady state), with no regression on small
machines -- a 4-CPU box gets 2 workers and is never slower, a box with two
or fewer CPUs gets 0 and is unchanged.

Tested on a KASAN + lockdep + DEBUG_LIST kernel (RAID5 on loop devices):
create, 180MB write + sha256 verify, disk fail + spare rebuild (data
verified), scrub (mismatch_cnt=0), and bitmap add/remove -- which drives
raid5_quiesce()'s lock_all_device_hash_locks_irq() path -- with the
parameters both left at their hardware-derived defaults and pinned to
explicit values, including nr_stripe_hash_locks=32 (the 33-lock quiesce
path).  No KASAN, lockdep, or list-debug reports.

Hiroshi Nishida (6):
  md/raid5: size the worker group array by nr_node_ids
  md/raid5: size stripe-cache hash locks from the CPU count
  md/raid5: scale the stripe_cache_size limit with system memory
  md/raid5: make the stripe batch size a module parameter
  md/raid5: scale the default stripe cache size with system memory
  md/raid5: derive the default group_thread_cnt from the hardware

 drivers/md/raid5-cache.c |   2 +-
 drivers/md/raid5.c       | 233 +++++++++++++++++++++++++++++++++------
 drivers/md/raid5.h       |  43 ++++++--
 3 files changed, 233 insertions(+), 45 deletions(-)


base-commit: 55b77337bdd088c77461588e5ec094421b89911b
--
2.43.0

