Received: from va-2-28.ptr.blmpb.com (va-2-28.ptr.blmpb.com [209.127.231.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2EB3DC4B7
	for <linux-raid@vger.kernel.org>; Wed,  3 Jun 2026 03:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780459197; cv=none; b=nU5XMKBzoeorAquhJ2HfxE7Y6eJKrQ9xAoRd7+G3ZJ2gboXnI6u9ginW0qUWUxbm+BbTftMIoLyryH3Grdu59UmKhg+BwxhY2UFYwzLo+CeGQ78vN5H0SJ1uf5DZmSI706aX8zOyWVSQjZA3MeyxTZPZJglvdPqPVkFXekdle5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780459197; c=relaxed/simple;
	bh=7U8HfoAy8wDyXDEoyJIBrNl5azBMM2mS3ZEUlvpdgWQ=;
	h=To:Cc:Message-Id:Mime-Version:From:Subject:Date:Content-Type; b=Y41aiuQIxxN1CniUm8XZLBQScUBjKslz3u0nhRcXK43XOPpMYCzcY90u8wRk73nRiDBYNr/N7NegRal6S6wUSIGDT8yj8FeJ/18ivUZZNkIxPgSQEk8xzRRnF9yRimsVwNyqUUFh4EuisCeQMMtuTL2VDvVjp59mISRWeJNYs/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=asW3zf6i; arc=none smtp.client-ip=209.127.231.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="asW3zf6i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1780459181;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Ty5p76NS9VVsfsnwWtt/phXtMPFZVLY3p58UrSRthp4=;
 b=asW3zf6ipktNn3ieOaGSRNyxwYZaR8Rx2mQZmWICtnKv0DXcuDtm3P581UJoZJfZHlQoQS
 AGy/fgGMMrc8RTakqaq9twjQQCr9YjVmmTLtgSQLY5wsISN7k/nqIisewZ/imLwV4umSox
 EymMCHCrBT+E/+mRCEvYjpP11KkOqzxAvguZovI6FQ6z9IwnHG6tigS47+IElVy9E5/9lG
 Dax/AnRIXQqeigg25Ic+IJRpDNEo9aNu6bJh/1gGrla4pdW4dMOfC3uy6M2NCWmdsJWqo/
 gPV88upN2ClJW2u69MTZ9Vq5DS/vfcy5eegq1eR6dEw+M/6ClFUtGb3YMAZULA==
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Message-Id: <20260603035925.217847-1-chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from localhost.localdomain ([183.34.161.59]) by smtp.feishu.cn with ESMTPS; Wed, 03 Jun 2026 11:59:39 +0800
X-Lms-Return-Path: <lba+26a1fa6ab+e2851c+vger.kernel.org+chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.54.0
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: [PATCH v4 0/3] md/raid10: fix r10bio width mismatches across reshape
Date: Wed,  3 Jun 2026 11:59:22 +0800
Content-Type: text/plain; charset=UTF-8

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

This series addresses the problem in three steps:

  1. ensure the sync_action=reshape caller suspends and locks before start_reshape

  2. make the regular r10bio pool fixed-size across reshape transitions, and
     move the pool rebuild into the freeze window before the live geometry
     switch;

  3. track the number of valid devs[] entries in each reused r10bio and use
     that recorded width when walking devs[] after reshape.


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
