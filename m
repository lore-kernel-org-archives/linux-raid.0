Received: from va-2-46.ptr.blmpb.com (va-2-46.ptr.blmpb.com [209.127.231.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9D52857F0
	for <linux-raid@vger.kernel.org>; Fri, 31 Jul 2026 00:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785458466; cv=none; b=B2Gq1h0nMemF6NQTEOvLQUcYwRefq0yvFOtjLjoNZW4vB7kEWbLaFRVU0y0OavpvFmKP9v5SPQ2ByLjrBNqyhhqB4oI4rFdRshwc5aMkeYEQ+qE5IeOSclXSGqcaQ+mB6DtoyYU3Z/uTDuNA1Gvf+MXbT54X+swWlZYZf8Cy/Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785458466; c=relaxed/simple;
	bh=IJcCuB+kPI+85uX7HDxfhLf4MiBlNxjNar4yMdXFCEw=;
	h=Subject:Date:Mime-Version:In-Reply-To:Cc:References:To:From:
	 Message-Id:Content-Type; b=azNDR4cO7xKY0FqRhccBLN0/GzX1V0+fHaLauLFv08DmvM+MiCEr540wxsYyS+639uqOEcr3BQKB7T/JNlDe9MKj6cESEGSiYC8YTBr0tX79uzTRAAFkbTuT2Gm4nFuWMF4xD5WZUQhCM4GmTU8r/2lYGjmgI9SaEh+z9ZoPFNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=ew4sC/yQ; arc=none smtp.client-ip=209.127.231.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="ew4sC/yQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785458450;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=woCNJXchD5lcjUAfm3SjoY2VX6y+TtTwfCtdAOi/Yq8=;
 b=ew4sC/yQ84+Xh+Ree/fG1URptATSav4N+qiUUhW9nktW5JEcRvdYcI+MVBJhmeujeXyPVD
 63MOFnvVUwQ4wxYMZObb3TFUBp4abk/QRjuGEiXuq/OWh6wVTv/55mJ1s5UHRF+KbV9ooW
 orVMTwWVIO/Su7RKxlt47CGlET9F6ZHk9sgEL08ULPSuIQj4+da3x5ykg+Fpwkg7PJgU0I
 bVsP+lG3zMd6KyeARmGEE/0swglRrLgBC80cO05ESUT6TdCeTzT0zoa+rlTjpIC1j+MSwO
 Y2k9+vWo1vVPDtORq/pwp5io7uzx4J9AUC/yZyjg40wOzKB3jwPq7HNdEFfRKg==
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Fri, 31 Jul 2026 00:40:49 +0000
Subject: Re: [PATCH v6 0/3] md/raid10: fix r10bio width mismatches across reshape
Date: Fri, 31 Jul 2026 08:40:46 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260711100352.425177-1-chencheng@fnnas.com>
Reply-To: yukuai@fygo.io
Cc: <linux-kernel@vger.kernel.org>, "Mykola Marzhan" <mykola@meshstor.io>
References: <20260711100352.425177-1-chencheng@fnnas.com>
X-Original-From: yu kuai <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26a6bef12+b425e3+vger.kernel.org+yukuai@fygo.io>
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <9199e9d4-4023-46dc-8eda-431ce3307c88@fygo.io>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable

Hi,

=E5=9C=A8 2026/7/11 18:03, Chen Cheng =E5=86=99=E9=81=93:
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
>
> KASAN report:
>
>    BUG: KASAN: slab-out-of-bounds in free_r10bio+0x1c4/0x260 [raid10]
>    Read of size 8 at addr ffff00008c2dfac8 by task ksoftirqd/0/15
>    free_r10bio
>    raid_end_bio_io
>    one_write_done
>    raid10_end_write_request
>
>
> This series addresses the problem in three steps:
>
>    1. ensure the sync_action=3Dreshape caller suspends and locks before s=
tart_reshape
>
>    2. resize r10bio_pool when reshape grows raid_disks
>
>    3. reorder the r10bio free flow before bio_endio in the regular and di=
scard
>       completion paths
>
> Changes in v7:
>     - patch #1, refactor out suspend from retry block
>     - patch #3, raid_end_bio_io() refactor to:
>          free(r10_bio) -> free(master_bio) -> allow_barrier
>
> Changes in v6:
>     - suspend the array in action_store() after flush_work()
>     - free r10bio before ending the discard master bio
>
> Changes in v5 (suggested by Yu Kuai):
>     - simplify patch 2
>     - switch patch 3 from bounding reused r10bio devs[] walks by used_nr_=
devs
>       to reordering the free/endio flow
>
> Changes in v4:
>     - make the sync_action=3Dreshape path invoke mddev_suspend_and_lock()=
 before
>       calling start_reshape()
>     - leave the md-cluster and dm-raid paths unchanged; they still reach
>       start_reshape() with the mddev locked but without suspend
>
> Changes in v3:
>     - replace freeze_array()/unfreeze_array() in raid10_start_reshape() w=
ith
>       mddev_suspend_and_lock_nointr()/mddev_unlock_and_resume(); freeze_a=
rray()
>       can return while retry-list items still hold pool objects, while
>       mddev_suspend() provides the correct upper-layer quiesce interface
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
>
>
> Chen Cheng (3):
>    md: suspend array when sync_action=3Dreshape
>    md/raid10: resize r10bio_pool for reshape
>    md/raid10: free r10bio before ending master_bio in raid_end_bio_io()
>      and raid_end_discard_bio()
>
>   drivers/md/md.c     | 17 +++++++++----
>   drivers/md/raid10.c | 61 ++++++++++++++++++++++++++++++++-------------
>   drivers/md/raid10.h |  2 +-
>   3 files changed, 56 insertions(+), 24 deletions(-)

Applied to md-7.3 with a few changes, please check the latest md-7.3 branch=
:

   - Patch 2: removed the redundant if (new_pool) before mempool_destroy(ne=
w_pool) to fix the
     strict checkpatch warning.

   - Patch 3: rewrote raid_end_bio_io() minimally so the existing R10BIO_* =
bit-test lines stay in
     place and checkpatch no longer flags CamelCase additions. This also pr=
eserves setting
     R10BIO_Returned in r10_bio->state before freeing.

   - Patch 3 commit message: corrected the listed final order to free_r10bi=
o() -> bio_endio() ->
     allow_barrier().

>
--=20
Thanks,
Kuai
