Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3841539C62F
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 12:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782130423; cv=none; b=nqU29AZ9UoO4lNQIPUGhGf0OoPoy8LY3ApTLsVPcqiZ13SWj6oB4U/7lfaQtbR8bJcU/mvmX9AbBmtMj5Wa3lxwfnYAATG7BLLqBqJEK8Qp/ThZLhPBJnqIqOTTR/o9qteuH4QcMOYrbf0YvCLnIme/jg1wX1T0KLe0WeDopfQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782130423; c=relaxed/simple;
	bh=8O0C8FAG5IJ3QhRE+HtDbSS4hJ46k91dDPf8HdHRh7U=;
	h=From:Mime-Version:Content-Type:Subject:Cc:To:Date:Message-Id; b=NOQNDmNHKwPmjc/WQ1kxdO1VMFpjBhcmoRcKXRjX+F2Ok+sF2H4+PCbolSGcu1KywgD7lSDM3bUgvMDo8oNQK6PgB1BMdNGiGU05MXOd9WkYqlC7o8nYLyFx5jrzoPZqXcq8q55M05S3Km2XpKwa8B4MBEly4CkLMWmrf8wzD6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=ETSq0JQq; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="ETSq0JQq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782130405;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=9dm4+B11tIpDTUMgJbxb1sBuYK6aBf2NTP1Tr7KQIYM=;
 b=ETSq0JQqltNedKbvmOmiW34LvELVLhAatPUY/HDG81GG0VRVU8yUIjDrbAG4kMY4ZxpzJs
 hPR0ha7LScINJ6mleHd43NaYm0AIJjoVmoomip7mACESglle4kPFEWylJv408CotHPqGMf
 p8tH111JMJLv5LAldcuuVh2imfEI6sTJQXVL4YeUriR0to9BMypzo/BLZAGvfqFhdJSNa0
 t6yB8678/6NULbAIm1H9sgsUMhUTb0NSy9A3Wd/MjWK7Vh4IWllnd/4EqNuio2P//RAyTU
 XgoRdfw1z10S7354gQE7/azUQhENkSp3cHAfP5DQ7ge/yKefyoHuL4T7exzBCg==
From: "Chen Cheng" <chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a3926e3+c7ad67+vger.kernel.org+chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v5 0/3] md/raid10: fix r10bio width mismatches across reshape
X-Mailer: git-send-email 2.54.0
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
Date: Mon, 22 Jun 2026 20:13:09 +0800
Message-Id: <20260622121312.1775322-1-chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com
Received: from localhost.localdomain ([183.34.162.92]) by smtp.feishu.cn with ESMTPS; Mon, 22 Jun 2026 20:13:22 +0800

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


kcsan report:

  BUG: KASAN: slab-out-of-bounds in free_r10bio+0x1c4/0x260 [raid10]
  Read of size 8 at addr ffff00008c2dfac8 by task ksoftirqd/0/15
  free_r10bio
  raid_end_bio_io
  one_write_done
  raid10_end_write_request


This series addresses the problem in three steps:

  1. ensure the sync_action=reshape caller suspends and locks before start_reshape

  2. covert the r10bio pool fixed-size from old geometry to new.

  3. reorder r10bio free flow to avoid race when free r10bio.

Changes in v5(suggesst by yukuai):
   - patch 2 simpify
   - patch 3 use new way{reorder free r10bio flow} instead of 
     old way {bound reused r10bio devs[] walks by used_nr_devs}

Changes in v4:
   - The sync_action=reshape path, caller now invokes
     mddev_suspend_and_lock() before calling start_reshape()
   - The md-cluster and dm-raid paths are unchanged, that is reach
     start_reshape() with the mddev locked but without suspended.


Changes in v3:
   - Replace freeze_array()/unfreeze_array() in raid10_start_reshape() with
     mddev_suspend_and_lock_nointr()/mddev_unlock_and_resume(). freeze_array()
     returns when nr_pending == nr_queued, which still allows retry-list items
     to hold pool objects; mddev_suspend() provides the correct upper-layer
     quiesce interface. (Suggested by Yu Kuai)


Changes in v2:
  - add this cover letter
  - convert r10bio_pool to a fixed-size kmalloc mempool
  - rebuild r10bio_pool inside the freeze window before switching live reshape
    geometry
  - switch raid10_quiesce() to freeze_array()/unfreeze_array()


Testing:
  - reproduced the original KASAN slab-out-of-bounds on 4-disk -> 5-disk
    raid10 reshape with fsstress
  - verified that this series fixes that reproducer
  - exercised the 5-disk -> 4-disk reshape direction as well

Thanks,
Chen Cheng



Chen Cheng (3):
  md: suspend array before raid10 reshape via sync_action
  md/raid10: make r10bio_pool use fixed-size objects
  md/raid10: bound reused r10bio devs[] walks by used_nr_devs

 drivers/md/md.c     | 22 ++++++++++++++----
 drivers/md/raid10.c | 56 +++++++++++++++++++++++++++++++++------------
 drivers/md/raid10.h |  4 +++-
 3 files changed, 61 insertions(+), 21 deletions(-)

-- 
2.54.0
