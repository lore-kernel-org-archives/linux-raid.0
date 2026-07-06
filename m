Received: from va-2-16.ptr.blmpb.com (va-2-16.ptr.blmpb.com [209.127.231.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6383738642C
	for <linux-raid@vger.kernel.org>; Mon,  6 Jul 2026 02:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783306602; cv=none; b=LR6U2Pg/UysEDvr/lywyXYSzW14QC32WVoZ8GRh+E8qJ78Bn/QnvwsHQYAiMRjNsAgZdKMqhOObRM38+x7HgeVXP10fauWyKW3mTZ1yIfGMDYwd+LWSqL+EHwgwLFsvg/NCeqnXXkiDYbbcSeYfVFQFYVWuKo1B2tFZoBLGhdFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783306602; c=relaxed/simple;
	bh=rq4CADBSRTsjxP9KSd23WMxx0+sck8rdPgKORP+x1mY=;
	h=In-Reply-To:Subject:Mime-Version:References:Message-Id:To:Cc:
	 Content-Type:From:Date; b=HTivY24Rz6w7VXfXgFyLUTNhy3xyiYx5yQhXxNTrHwC0eHGw87LMgS1mTMGChFiShs5W/bCWnRY9X565lsKEQ7lh7MIyNB6iM0xLo4MJ3vSD/wmHzp6dHY77r7SVzLzJvj7MJ0PfWuwd/2tks/B536kNJdY/FEzf+1LTM6SyV/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=WFBBoy0p; arc=none smtp.client-ip=209.127.231.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="WFBBoy0p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783306594;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=YNTxii3C5bkFszHGLOtjd4EbPnNTulBVLmkXkt0ziJU=;
 b=WFBBoy0pb/wv2GEWpsVu/q+ZP2Kl8z0W4t4RRd1bhD9ORK8ZMnEHz3IZvD5p9xrwYJ/MP2
 Cp/EiU34i0OiYeHEEtMCRaQDx9RXRKNQUEkombCUfnzdD2AT1GIQ1vHz7pEwXv+/JcQ0u5
 JdRhcvdDquM5fTsy5U+E7x5I7krRdJmN8+fAdzuXPXx/ATrpq56ehTmC/dEPF4cR1SDzv+
 u1hGuIyod5bux2jjVpuJ+U+3uHeM/Ll3vAPhql4zM1lg+fiYRFgW5Gt+klylRVXGtiH6eO
 /rKBb8hOoDjXqbt0oPpy92Hc2WeZ6lJ/ajfTPHhgJthf6COKtbSEDWJIQd+YyA==
In-Reply-To: <20260624155452.211646-1-nishidafmly@gmail.com>
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Mon, 06 Jul 2026 02:56:33 +0000
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 0/8] md/raid5: scalability and rebuild-path improvements
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260624155452.211646-1-nishidafmly@gmail.com>
X-Lms-Return-Path: <lba+26a4b1962+5f1ac4+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Message-Id: <aa24dd05-f231-4657-8fef-8201138da65f@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
To: "Hiroshi Nishida" <nishidafmly@gmail.com>, "Song Liu" <song@kernel.org>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
From: "yu kuai" <yukuai@fygo.io>
Date: Mon, 6 Jul 2026 10:56:29 +0800

Hi,

=E5=9C=A8 2026/6/24 23:54, Hiroshi Nishida =E5=86=99=E9=81=93:
> This series collects small, individually low-risk md/raid5 changes for
> large, many-core, many-disk arrays.  Their common theme is reducing
> per-stripe and stripe-cache contention, so the benefit appears mainly
> when the raid5 stripe-handling worker threads are in use
> (group_thread_cnt > 0); at the default group_thread_cnt =3D 0 (a single
> handling thread) the series is essentially neutral.
>
>   - patches 1-3 remove signed arithmetic from a hot-path divisor, lift an
>     arbitrary stripe-cache size cap, and widen a badblock length argument
>     that currently truncates large ranges;
>   - patch 4 raises NR_STRIPE_HASH_LOCKS (8 -> 32) to spread stripe-hash
>     contention on high core-count systems;
>   - patches 5 and 8 reduce per-stripe overhead in the resync/recovery
>     path and bound the share of the stripe cache a rebuild may hold while
>     user I/O is competing;
>   - patch 6 allocates each worker group's array on its own NUMA node;
>   - patch 7 raises MAX_STRIPE_BATCH (8 -> 32).
>
> Measured effect, treatment vs baseline, % change in mean IOPS (N=3D3),
> swept over group_thread_cnt (RAID6 4+2, 22-core host, ramdisk members):

Testing with ramdisk does serve as a useful reference, but it does not refl=
ect
real world usage.

>
>    workload                       gtc=3D0   gtc=3D2   gtc=3D4   gtc=3D8
>    random 4K write (RMW)          +4.2%   +8.1%  +17.4%   +6.5%
>    DB mixed 75/25 8K              +0.4%   +4.2%  +10.3%   +4.7%
>    high-concurrency 70/30 4K      +3.9%   +1.2%  +10.0%   +0.2%
>    OLTP 70/30 16K                 -0.3%   +4.7%  +10.1%   +9.3%
>    partial-stripe write 8K        +1.1%   +4.8%  +11.2%  +14.2%

With a quick review I saw many static configurations is changed, I agree
these changes can improve arrays with ssd/nvme and a system with large
memory available. However, we already tested with hdd and about 8G memory
available, these changes will not improve performance at all, with the
extra memory overhead.

I can accept make those values configurable, but not direct modifications.
As validation is required for numerous scenarios. Memory resources are prec=
ious
especially for most consumer NAS devices.

>
> At the default single handling thread (group_thread_cnt =3D 0) the series=
 is
> neutral (no regression).  As worker threads are added the gain grows,
> peaking broadly around group_thread_cnt =3D 4 at roughly +10-17% across t=
he
> whole mix; at gtc =3D 8 the write-heavy workloads keep gaining while the
> read-heavy high-concurrency case has saturated.  (Per-run cv was <1%
> except the random-write test, ~5-9%, from a cold first run.)
>
> These numbers are on a ramdisk, which removes device latency and so
> overstates the CPU-side contention effect relative to a real device;
> they show the direction and the group_thread_cnt dependence, not an
> absolute speedup.  The stripe-hash/batch patches (4, 7) and the cache cap
> (2) drive this; patch 6 only matters on multi-socket systems (not
> exercised above) and patches 5/8 act on the resync/recovery path rather
> than this steady-state workload.
>
> Reproduction (stock mdadm + fio):
>    mdadm --create /dev/md0 --level=3D6 --raid-devices=3D6 --chunk=3D512 \
>          --assume-clean <6 members>
>    echo 16384 > /sys/block/md0/md/stripe_cache_size
>    echo N     > /sys/block/md0/md/group_thread_cnt      # N =3D 0,2,4,8
>    fio --filename=3D/dev/md0 --direct=3D1 --ioengine=3Dlibaio --group_rep=
orting \
>        --time_based --runtime=3D15 --name=3Dw <per-workload opts>:
>      random write   : --rw=3Drandwrite              --bs=3D4k  --numjobs=
=3D4  --iodepth=3D32
>      DB mixed       : --rw=3Drandrw --rwmixread=3D75  --bs=3D8k  --numjob=
s=3D8  --iodepth=3D16
>      high-concur.   : --rw=3Drandrw --rwmixread=3D70  --bs=3D4k  --numjob=
s=3D16 --iodepth=3D8
>      OLTP           : --rw=3Drandrw --rwmixread=3D70  --bs=3D16k --numjob=
s=3D6  --iodepth=3D16
>      partial-stripe : --rw=3Drandwrite              --bs=3D8k  --numjobs=
=3D4  --iodepth=3D32
>
> Each patch stands on its own; I am happy to drop or defer any that is not
> justified on its own merit.
>
> Functional testing on RAID5 and RAID6: create, fail a member, rebuild
> onto a spare / re-add, full data read-back verified, and scrub
> ("check") reporting mismatch_cnt =3D=3D 0.  The series was also exercised
> with KASAN and lockdep enabled -- including heavy group_thread_cnt
> churn on a multi-node setup to stress the per-NUMA-node worker
> allocation and the raid5_quiesce hash-lock-all path -- with no reports.
>
> Hiroshi Nishida (8):
>    md: change chunk_sectors and stripe cache counts to unsigned int
>    md/raid5: raise stripe cache limit from 32768 to 262144
>    md: widen badblock sectors param from int to sector_t
>    md/raid5: raise NR_STRIPE_HASH_LOCKS from 8 to 32
>    md/raid5: submit a window of stripes during resync/recovery
>    md/raid5: allocate worker groups per NUMA node
>    md/raid5: raise MAX_STRIPE_BATCH from 8 to 32
>    md/raid5: reserve stripe cache for user I/O during rebuild
>
>   drivers/md/md.c    |   4 +-
>   drivers/md/md.h    |  10 ++--
>   drivers/md/raid5.c | 129 ++++++++++++++++++++++++++++++++-------------
>   drivers/md/raid5.h |  33 ++++++++----
>   4 files changed, 121 insertions(+), 55 deletions(-)
>
> base-commit: 55b77337bdd088c77461588e5ec094421b89911b
>
--=20
Thanks,
Kuai
