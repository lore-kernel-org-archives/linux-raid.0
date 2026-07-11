Received: from va-2-36.ptr.blmpb.com (va-2-36.ptr.blmpb.com [209.127.231.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E2E368263
	for <linux-raid@vger.kernel.org>; Sat, 11 Jul 2026 10:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783764258; cv=none; b=RV4gkklrXe4/zb0v+tt7L02RPxsxic+j8NcBko5GyMUEu5/8izeaT0AE2e6cUPfZQnSMA3ThMxai80/4+P+AZaTg9yrkuZupso3bgF4zP4rFQUZ8lT9uzfp5NmaA/Wxw9h3PUoTSC2kQ2itizJGyhGp1NDmwe7aWqXxSc0RXWL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783764258; c=relaxed/simple;
	bh=BHH9tBoo/hepwC0eGVi8Zx/Ja5iKAxumMluAaWMIzcE=;
	h=To:Content-Type:Cc:From:Date:Subject:Message-Id:Mime-Version; b=TQLjafFvec1+gGM4ysfluEWB1qid4NGG7X/fcxQK8FpxUW6mt5/toQqGAe4hzJ70zWNUV710Ftza4+UwG3QXr/ZRtlXhkPexGVsRVOF+7gfZ8TNVWbaJPpLQvdMXmEOTl0ydjRJnGL7+SRo8OKCAZdLyziJxAA0Q2BleNiGUuy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=dJ6d/Fhz; arc=none smtp.client-ip=209.127.231.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="dJ6d/Fhz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783764249;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=JrLQWy1f704E27lLw4eY04Hh4HOqqZFLXi33FT18HjY=;
 b=dJ6d/Fhz6fYDkQzfHCoIygQ+4mLtx0mECsA6DCMdknD2ICe88zlqR3u7jKFGX8KOuAOcgp
 pDaop6/R+i+aqL8vGu6zDRbj4zNuwDlgl589qP9du2/ea6AXPndqNAf/k+E0HhSCQ/MNYL
 n3VQGzQ/VK+u6Jd1xc7KndUAPZ+fWlkKx55oUhen8B/LXiVFqgpRlOU/2SqRkSajldoVFJ
 NwqgJDintZWYfh2Jdb/wM7HolGJj/XPpFx0prR23WnywFTfLa+SooULD2q2ncp3pVnbm3v
 HTialg4WA7aMR1lRrF5nFGetP5dZACHs5nLfHk8vB2bsZ4K/BcjcaEtpJncd5g==
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26a521517+0bdd64+vger.kernel.org+chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
X-Original-From: chencheng@fnnas.com
From: "Chen Cheng" <chencheng@fnnas.com>
Date: Sat, 11 Jul 2026 18:03:49 +0800
Received: from fedora ([183.34.162.102]) by smtp.feishu.cn with ESMTPS; Sat, 11 Jul 2026 18:04:06 +0800
X-Mailer: git-send-email 2.54.0
Subject: [PATCH v6 0/3] md/raid10: fix r10bio width mismatches across reshape
Message-Id: <20260711100352.425177-1-chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

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

Changes in v7:
   - patch #1, refactor out suspend from retry block
   - patch #3, raid_end_bio_io() refactor to:
        free(r10_bio) -> free(master_bio) -> allow_barrier

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
