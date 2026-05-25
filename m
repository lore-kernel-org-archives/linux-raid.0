Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58307343890
	for <linux-raid@vger.kernel.org>; Mon, 25 May 2026 01:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779674148; cv=none; b=kSKouf8V91N3iCRAZ13h7e0/Ao+kNDWf51YUD0ZRgsTkhVUNYHELxXyzQsXIjoADyTXbreEwRjoiFzPrwKE5Ki29Tr3s7NrVPnI/Yvj+j68dy5UyRg6ivOT1uYeMOmrJpupQaho4IaxPcYNMn0StaFsOqRLasPjC2BPAIe9bf/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779674148; c=relaxed/simple;
	bh=dM8iXq2DfZWpt+uJuTJTttU/PN+OhSXC7Ieeiw35748=;
	h=Message-Id:Mime-Version:Cc:From:Subject:Date:Content-Type:To; b=rhIgptorXqy7jKbax+B6D6z4eeDeORYOMiX4n5u/N4OU+dmFUDYi7zHo8ccy4fQJOeEsKL5fW9J/w2q1Bb4wNf++Tp9aDysXQ70lvVDYSUPfI8LcsnkkGcXDWIEEHX2XpK7A/FnW3FJE4HkbFKkQlFLr5uf8QgwtIdXHXjpwusk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=QBKNscJf; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="QBKNscJf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1779674136;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=YGkdgFaUWQtfE9l3Cq8p9cufQpnERd3G2lsJbta8k8U=;
 b=QBKNscJfpYmIK1szrkiNhUmfR1RtOzpfTV+bT6NXm2EfXtkbg0ZRfM5HmVaDbtt1ppmqO1
 sVaIkwc/dhJSyF74Audy7FvUFLCTm6Bm19Ox329ey5Bj8fnKad9WZ9uAvfZNse5fQCXQUi
 t+DRCRK/+FEUeE3F7nchEOQ6zDTT86r59ZrbTEIdpx3GscJuoOWTMhoJGSzbwfw1TmpHD5
 g0TCZrhGe2prQNQ6QqslGVhZtCt5+sFm3+2qkln0dhGP2RWwmkwEvPHwM40bOdXkPdjn53
 N7WHNMS9bckQECYXJb+cjF7vmuJ33Ee+27TGuRrFyDwALoGjAquHuE8Nq+iLbw==
Message-Id: <20260525015520.2565423-1-chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com
X-Lms-Return-Path: <lba+26a13ac16+16e726+vger.kernel.org+chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0
Content-Transfer-Encoding: 7bit
Cc: "Chen Cheng" <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: [PATCH v3 0/2] md/raid10: fix r10bio width mismatches across reshape
Date: Mon, 25 May 2026 09:55:18 +0800
Received: from localhost.localdomain ([113.111.141.72]) by smtp.feishu.cn with ESMTPS; Mon, 25 May 2026 09:55:33 +0800
Content-Type: text/plain; charset=UTF-8
To: "Yu Kuai" <yukuai@fnnas.com>, <linux-raid@vger.kernel.org>

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

Chen Cheng (2):
  md/raid10: make r10bio_pool use fixed-size objects
  md/raid10: bound reused r10bio devs[] walks by used_nr_devs

 drivers/md/raid10.c | 65 ++++++++++++++++++++++++++++++++++-----------
 drivers/md/raid10.h |  4 ++-
 2 files changed, 53 insertions(+), 16 deletions(-)

-- 
2.54.0
