Received: from va-2-36.ptr.blmpb.com (va-2-36.ptr.blmpb.com [209.127.231.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC643B14AC
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 12:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782218345; cv=none; b=tPp624aUvfAzz3E4zLp7+KaW7+9f6wqFB/mxqhSGWbeFMRa5OCGXoE0qUqi2lIH7zuAz4gC5J+ZImss+xinWeCXs/w93V+R7j17tgMEatI1hrbU41iiJZr6YzdGz4s10gnjp7zj7vZwegCOoHTGBHRrFlTKiNVDBOf6iZ7ulQuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782218345; c=relaxed/simple;
	bh=6LKVWZ/sZLNwGGmVhYXwVS9SjaeIu2820oDHTPZ8o5Y=;
	h=From:Message-Id:Cc:Mime-Version:Date:Content-Type:Subject:To; b=qCGeFB3IO9N27sMuBp2cltev80OUnO0+BdeOW9edXXAljeeLxbXq1bi4lMcr1kYDptTxmPeOIYI5gMScBl4SSKTPEu0keKHvMW1GeChIcgt5xsBXAUc93SkR/VkmN/cjYzG+iNrYUDXzZ0QP/wRzif3Q/UVJ5JURYlgtsuKvzAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=gEv25bKa; arc=none smtp.client-ip=209.127.231.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="gEv25bKa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782218333;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=wOtnvlfu566VCTAPwRj+MQ53UsHX8BeIVt8xMTDMqJk=;
 b=gEv25bKahVFMwoLDMMQAgnohSMpUBn7A/bMUQRg8ki7WN7X57RKPAGqIwxCjNBpMHsQVZB
 e9DS7z1Gjytu4nf5j6VHyz1vB7vgnOMPQyq21S0QdZT4sWt/mrveneh+e6iuglyxYgFSjh
 gZ0OD0wlHVpltqkWasCqSyj/qWeiuomORBgxqRYCxq4b62zlu9fMpVdrLKaaFhPQ4+ni2a
 ii6q1NArN+gqI+tC06NH6AIqXS0FVlEZnZV69oQLMclAunQ0SRRMuJU0DeOu39sJwJsUel
 eSXz/+wRNMZhgUmZopGvwuFqBma1J0hjpjzBzSC62XdF9Bpge6Sh1V2ff1Ov2A==
From: "Chen Cheng" <chencheng@fnnas.com>
Message-Id: <20260623123840.2521340-1-chencheng@fnnas.com>
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
X-Original-From: chencheng@fnnas.com
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Date: Tue, 23 Jun 2026 20:38:37 +0800
Content-Transfer-Encoding: 7bit
Received: from localhost.localdomain ([183.34.169.141]) by smtp.feishu.cn with ESMTPS; Tue, 23 Jun 2026 20:38:50 +0800
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v6 0/3] md/raid10: fix r10bio width mismatches across reshape
X-Lms-Return-Path: <lba+26a3a7e5b+03a74f+vger.kernel.org+chencheng@fnnas.com>
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>

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


KASAN report:

  BUG: KASAN: slab-out-of-bounds in free_r10bio+0x1c4/0x260 [raid10]
  Read of size 8 at addr ffff00008c2dfac8 by task ksoftirqd/0/15
  free_r10bio
  raid_end_bio_io
  one_write_done
  raid10_end_write_request


This series addresses the problem in three steps:

  1. ensure the sync_action=reshape caller suspends and locks before start_reshape

  2. resize r10bio_pool when reshape grows raid_disks

  3. reorder the r10bio free flow before bio_endio in the regular and discard
     completion paths


Changes in v6:
   - suspend the array in action_store() after flush_work()
   - free r10bio before ending the discard master bio

Changes in v5 (suggested by Yu Kuai):
   - simplify patch 2
   - switch patch 3 from bounding reused r10bio devs[] walks by used_nr_devs
     to reordering the free/endio flow

Changes in v4:
   - make the sync_action=reshape path invoke mddev_suspend_and_lock() before
     calling start_reshape()
   - leave the md-cluster and dm-raid paths unchanged; they still reach
     start_reshape() with the mddev locked but without suspend

Changes in v3:
   - replace freeze_array()/unfreeze_array() in raid10_start_reshape() with
     mddev_suspend_and_lock_nointr()/mddev_unlock_and_resume(); freeze_array()
     can return while retry-list items still hold pool objects, while
     mddev_suspend() provides the correct upper-layer quiesce interface

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
  md: suspend array when sync_action=reshape
  md/raid10: resize r10bio_pool for reshape
  md/raid10: free r10bio before ending master_bio in raid_end_bio_io()
    and raid_end_discard_bio()

 drivers/md/md.c     | 17 +++++++++----
 drivers/md/raid10.c | 61 ++++++++++++++++++++++++++++++++-------------
 drivers/md/raid10.h |  2 +-
 3 files changed, 56 insertions(+), 24 deletions(-)

-- 
2.54.0
