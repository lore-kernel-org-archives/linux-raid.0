Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6592B2DCC1F
	for <linux-raid@vger.kernel.org>; Sun, 31 May 2026 10:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780224415; cv=none; b=l/VFeFqRsPMKqEvRFHWg67Yxj8lFcpoyILCj+juSJ5rgGuVGcqabH2RFIoZOV9EN6/LEutnUB3O4T1RmVEZtGskusbfaJVV8XNCZ5A0dOCqOvdtLisRhZxJVnQQ8ThBtgc+JK6bGB/Js3uQ8F9EyUanpBE+Jt2btbOxxzOfwH9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780224415; c=relaxed/simple;
	bh=B7TUTn++0BtvnEmzBYwfrkqbelB0qFceoj0Y0YYtGK8=;
	h=From:Date:Content-Type:To:Cc:References:Subject:Message-Id:
	 In-Reply-To:Mime-Version; b=l0GfiO44aQsw6JXJqEtTrW9lhBv5koKk36IIlb1c6gOuL6ltR/nnIPnEgPWBA1y+PxPII8mNQL4Kxahi9Fw5qQd+pse9lxZQWe1AehjjQ752PrSHE+OxlSFzfI7Y0ySEUGNVhjM0gw4IZqTNygPRowMqjKUaiKZpO++Jvdc/+F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=INwNACzl; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="INwNACzl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1780224406;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Gfz/sln2j37tkPHhGTkPJflq5JlNeFOPCAN4Y/Uupso=;
 b=INwNACzleCfYk1CF9j9uQ0+LKN2eXM++fc9lddWsVfH/iCB46Zp/cjdNhFU/VFrw9dD4Zy
 6+QGB/3IaHiC2hATAIQ+DtJYpL3tKJkJ/CYppE0Wyk9YaKGtr06/sBAAZhY3wFosMt97KU
 RqUMfVa8C/gKpbPpw2PSv1x6Hxxji9E/Ag5lBmj2EvNOg56gOb/duIroMKk3+rO2vR4fCk
 2EwoYFD1tUEOh7eYO0x6ZX0PkjfA7Tq5StfmeXYGACENMmY6cnwzRecCJZcO/MBxtjnWkz
 fqIOtHs2RVMRJa3SuxzbN9Vb1YWHpNtyOz0SCwdnIDfG9WseEvX2gxxmNNvNBw==
From: "Yu Kuai" <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Date: Sun, 31 May 2026 18:46:43 +0800
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fygo.io
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.ko>
Cc: <linux-kernel@vger.kernel.org>
References: <20260525015520.2565423-1-chencheng@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.134]) by smtp.larksuite.com with ESMTPS; Sun, 31 May 2026 10:46:45 +0000
Subject: Re: [PATCH v3 0/2] md/raid10: fix r10bio width mismatches across reshape
Message-Id: <09944b37-dfb9-4c0c-a5a4-16e0698f6b29@fygo.io>
In-Reply-To: <20260525015520.2565423-1-chencheng@fnnas.com>
Content-Language: en-US
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a1c1195+f767bd+vger.kernel.org+yukuai@fygo.io>
X-Original-From: Yu Kuai <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/5/25 9:55, Chen Cheng =E5=86=99=E9=81=93:
> From: Chen Cheng <chencheng@fnnas.com>
>
> Hi,
>
> This series fixes slab out-of-bounds accesses in raid10 when reshape chan=
ges
> the number of raid disks while regular I/O is still reusing r10bio object=
s
> allocated under the previous geometry.
>
> The bug is reproducible with a simple 4-disk to 5-disk reshape under writ=
e
> load, for example:
>
>    mdadm -C /dev/md777 -l10 -n4 /dev/sda /dev/sdb /dev/sdc /dev/sdd
>    mkfs.ext4 /dev/md777
>    mount /dev/md777 /mnt/test
>    fsstress -d /mnt/test -n 24000 -p 8 -l 24 &
>    mdadm /dev/md777 --add /dev/sde
>    mdadm --grow /dev/md777 --raid-devices=3D5 \
>      --backup-file=3D/tmp/md-reshape-backup
>
> Without these changes, an r10bio allocated under the old geometry can lat=
er be
> reused, initialized, or freed after conf->geo.raid_disks has switched to =
the
> new geometry. This creates width mismatches between the object and the cu=
rrent
> devs[] walk/initialization width, which can trigger KASAN reports such as
> slab-out-of-bounds in __make_request(), put_all_bios(), or find_bio_disk(=
).
>
> This series addresses the problem in two steps:
>
>    1. make the regular r10bio pool fixed-size across reshape transitions,=
 and
>       move the pool rebuild into the freeze window before the live geomet=
ry
>       switch;
>
>    2. track the number of valid devs[] entries in each reused r10bio and =
use
>       that recorded width when walking devs[] after reshape.
>
>
> Changes in v3:
>     - Replace freeze_array()/unfreeze_array() in raid10_start_reshape() w=
ith
>       mddev_suspend_and_lock_nointr()/mddev_unlock_and_resume(). freeze_a=
rray()
>       returns when nr_pending =3D=3D nr_queued, which still allows retry-=
list items
>       to hold pool objects; mddev_suspend() provides the correct upper-la=
yer
>       quiesce interface. (Suggested by Yu Kuai)
>
>
> Changes in v2:
>    - add this cover letter
>    - convert r10bio_pool to a fixed-size kmalloc mempool
>    - rebuild r10bio_pool inside the freeze window before switching live r=
eshape
>      geometry
>    - switch raid10_quiesce() to freeze_array()/unfreeze_array()
>
>
> Testing:
>    - reproduced the original KASAN slab-out-of-bounds on 4-disk -> 5-disk
>      raid10 reshape with fsstress
>    - verified that this series fixes that reproducer
>    - exercised the 5-disk -> 4-disk reshape direction as well
>
> Thanks,
> Chen Cheng
>
> Chen Cheng (2):
>    md/raid10: make r10bio_pool use fixed-size objects
>    md/raid10: bound reused r10bio devs[] walks by used_nr_devs
>
>   drivers/md/raid10.c | 65 ++++++++++++++++++++++++++++++++++-----------
>   drivers/md/raid10.h |  4 ++-
>   2 files changed, 53 insertions(+), 16 deletions(-)

This patch does not apply cleanly on md-7.2, please rebase first.

>
--=20
Thansk,
Kuai
