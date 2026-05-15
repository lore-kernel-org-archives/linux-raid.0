Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87DF3FB7E1
	for <linux-raid@vger.kernel.org>; Fri, 15 May 2026 09:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778837255; cv=none; b=fG8yMLPQVP7HL1iOzZOWW0ZL1p0E/bHDnrzNl/olu/8IfpJDP+60OUwybOIsE5jHVmDle1JUaBKxxnxcUQ5JWgNS9EZMbyY54nIgdYaWSy85efYKbCLw57o2sNd572EEF2l3/xiHih9xRwJBUfg9NxBZdPwrbgWg+4GjLISIe3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778837255; c=relaxed/simple;
	bh=gZ8MDGU7U1CPuMQ+vIRWA+NNbl8KPwhK/3lzjg/qwRE=;
	h=From:Content-Type:Cc:Date:To:Mime-Version:Subject:Message-Id; b=WMC85IxivkaH5V7uVIS3Aa/NsGinMvBeqU7+My366AWGchi1/X1MaybSJr9celjfIx2PGxTefKIkmKqQluy7PVX6zvKwp7gTerp50xdkuKXGbKM1OtKKAMfjpBRyB7Fm1+x5ndECnIOpVgTZ5INaJ5aLOmZL1KGK9NDGynz9qho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=vRXqz2TO; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="vRXqz2TO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1778837241;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=LAZoujsTP+xOfKzmN0K0FnlO3MxDUpstIwjUhmLlvxQ=;
 b=vRXqz2TOUw6fqH8wk/o6VmzZdTbgeuBFQlA4/CXzXG8SlpL17KYKb/cYPo/24vmmlXsmnS
 JtUq+sfye9ELc3UoLn/wpdPhG2e4mlBKrvKq/WjosMU3o2T4rPPezkSyMnojdTxoem/2rJ
 zKRcpkQAGdGafecLRVHb8ku+5g1a1lvBrTk5gW6HkLFPKuGgSpoZut/zQkMmuNWqlO5L7C
 GtZh6oiUcAvu27oDaWGMWHnEF2HhnZVbrYHVv+LmDQqAQ1YvSA7eV34Jyx5JKE+Wt/NuQd
 T38+LR+ifw5XwD0tCcKCHeqhwuvAh4iQlImptzBFiPiTd/ffv/uxV7e0bYlQhg==
From: "Chen Cheng" <chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a06e6f7+f74870+vger.kernel.org+chencheng@fnnas.com>
X-Mailer: git-send-email 2.54.0
Cc: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Date: Fri, 15 May 2026 17:27:05 +0800
X-Original-From: chencheng@fnnas.com
Received: from localhost.localdomain ([113.111.244.134]) by smtp.feishu.cn with ESMTPS; Fri, 15 May 2026 17:27:18 +0800
To: "Yu Kuai" <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH v2 0/2] md/raid10: fix r10bio width mismatches across reshape
Message-Id: <20260515092707.3436464-1-chencheng@fnnas.com>

From: Chen Cheng <chencheng@fnnas.com>

Hi,

This series fixes slab out-of-bounds accesses in raid10 when reshape changes
the number of raid disks while regular I/O is still reusing r10bio objects
allocated under the previous geometry.

The bug is reproducible with a simple 4-disk to 5-disk reshape under write
load, for example:

  mdadm -C /dev/md777 -l10 -n4 /dev/sda /dev/sdb /dev/sdc /dev/sdd
  mkfs.ext4 /dev/md777
  mount /dev/md777 /mnt/test
  fsstress -d /mnt/test -n 24000 -p 8 -l 24 &
  mdadm /dev/md777 --add /dev/sde
  mdadm --grow /dev/md777 --raid-devices=5 \
    --backup-file=/tmp/md-reshape-backup

Without these changes, an r10bio allocated under the old geometry can later be
reused, initialized, or freed after conf->geo.raid_disks has switched to the
new geometry. This creates width mismatches between the object and the current
devs[] walk/initialization width, which can trigger KASAN reports such as
slab-out-of-bounds in __make_request(), put_all_bios(), or find_bio_disk().

This series addresses the problem in two steps:

  1. make the regular r10bio pool fixed-size across reshape transitions, and
     move the pool rebuild into the freeze window before the live geometry
     switch;

  2. track the number of valid devs[] entries in each reused r10bio and use
     that recorded width when walking devs[] after reshape.

Changes in v2:
  - add this cover letter
  - convert r10bio_pool to a fixed-size kmalloc mempool
  - rebuild r10bio_pool inside the freeze window before switching live reshape
    geometry
  - switch raid10_quiesce() to freeze_array()/unfreeze_array()

Open issues:

One point where this v2 series still differs from raid1 is the pool-switch
semantics during reshape.

raid1 handles this by:
  - converting r1bio_pool to a fixed-size pool,
  - freezing the array,
  - swapping in the new pool while the array is frozen,
  - switching the live geometry/state,
  - unfreezing the array, and
  - destroying the old pool afterwards.

In other words, raid1 keeps the old and new regular I/O pools logically
separated across the reshape transition.

This raid10 v2 series follows the same high-level direction by converting
r10bio_pool to a fixed-size pool and moving the pool rebuild into the freeze
window before the live geometry switch. However, it does not yet mirror
raid1 completely: queued regular r10bios may still exist on retry_list or
bio_end_io_list at the time of the pool replacement, and raid10's current
freeze semantics only guarantee that in-flight I/O has either completed or
been queued.

My current understanding is that there are two possible directions to make
this fully robust:

  1. strengthen raid10 freeze semantics so that the reshape-time pool switch
     guarantees that no old regular r10bio can survive across the transition;
     or

  2. explicitly associate in-flight regular r10bios with the pool they were
     allocated from, so they can always be returned to the correct pool even
     if old and new pools overlap in time.

There is also a pre-existing boundary issue in find_bio_disk(): if the bio
is not found in devs[], the code can still walk past the recorded width.
That issue is not addressed in this series.

Testing:
  - reproduced the original KASAN slab-out-of-bounds on 4-disk -> 5-disk
    raid10 reshape with fsstress
  - verified that this series fixes that reproducer
  - exercised the 5-disk -> 4-disk reshape direction as well

Thanks,
Chen Cheng


Chen Cheng (2):
  md/raid10: make r10bio_pool use fixed-size objects
  md/raid10: bound reused r10bio devs[] walks by used_nr_devs

 drivers/md/raid10.c | 63 +++++++++++++++++++++++++++++++++------------
 drivers/md/raid10.h |  4 ++-
 2 files changed, 49 insertions(+), 18 deletions(-)

-- 
2.54.0
