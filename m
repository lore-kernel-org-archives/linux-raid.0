Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1F342B31A
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783688977; cv=pass; b=CC9KyTdU6qCSQiUccHvVa9TdivfLamNYpPilCZbrgxfzZX86yojYBTtZfQv2YH/F4r6qIuae+jVKuRnamo8zHGF+3a5/wrvcPkugf7LE08k8qYj+iRcIcnuEsoK1nxPrUdIb6Y4w9KJWuFbLk+S8SZdh8rJhw7qDTYl9MLYQ/fI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783688977; c=relaxed/simple;
	bh=YE8JEEzlu87H2vNNxftF95I5XRgwYyQHgSyvlkjbktY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mso6qJOTs6Y7fR3BdZLPpPuO+0TnvmUoVXg4urXO9l3+0wOzA2XtUnX8QPRY9ri4EMuyJSHF7nvBT+9BLus55EmPTdZ8L9OWYFLJ5/AS+kDMZptPxWSQHJefXNva/5XUieJOh/ZmiTHTqUu6P9FH48dj4n2TOXvtldcvgiaE1Co=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H8f4ENJV; arc=pass smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H8f4ENJV"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c9eefcf9175so678680a12.3
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 06:09:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783688975; cv=none;
        d=google.com; s=arc-20260327;
        b=Aq3qiBgUvTOKKg6tMikp5Z157RI/cBKjhJJXapEyg95fHQZpLu3m1vrjoBWYjOsJbh
         5fljQJ3qvqzOSJEGCtWhvFq1/34Q4dK9lan5ApKJyHZUvyPW64cBp4CTvpLlk6bn6K/B
         7EF/frAPQ8XVN+HqtJWUzx+vhuKBMOskhymGVjsitCd/VMTftTVP5ObMn7j4soappwt9
         0YE9nBmX44C6CrCguVsBKEmrrNBSFqLWsEOlELMdfuBwsaJL8ASwf9LUkaLlCVcTfLyc
         j6fznGAsPHQqoP399h++XBs1QfYdgQ3RRYyU+JJFCkHNkr4V15Xrld/zFJtR6B7FNbLr
         PWqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rLKOP/shS+AHbtHYABHQpI1rASYgkBUQVXQ3j/Wr1mU=;
        fh=Ji5sSb9CYyicvTF+hPrUJRj38Vd+S925Z4/m35tKcUU=;
        b=DSOvUW1AB/hbJeLVNdFakeKMjjl4VDk2K2MzQGnfZn01c81mSCZWLsfYwRJSunzBR9
         N+1EWJqckRuqeLgyCSakV5SBhrDbpfKBzISmZuNYmHmePxol3pkEf11dBZ9LzMsW3JFg
         OemlaEiyG3ovGYvtwMCHcUNaCbEP4nUDw+DHxPQGesGZ6hRjKw9zQr9r7aAKpin8HuGX
         byS5wSNv3j0MweoSqKGxeFuBT1+36GtyBrFr4pvD56VSOEKPxko259R64dQNi2FYADPV
         NDHqcEpV6fPlN8r0jESOJ6NVd0iltTmaWNcbpiapclfGsZhX35DKOp2+OuYCVQR+iWqX
         cGPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783688975; x=1784293775; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rLKOP/shS+AHbtHYABHQpI1rASYgkBUQVXQ3j/Wr1mU=;
        b=H8f4ENJV3M9OMcQlBpVN//m6lMh+k17rNK5bgwA5YFXDDFy43BqSpu3p4wg3LTOhr4
         Ka0HKMrmtOm7XQrLKc53cJQaa62/RQ+nthoOGt2gcvKIJhkWAphdZf6LPEcuK1uU9guk
         i8CdHIZ4c7tKc56dW6G5tE5NeaklBgo6emt3k0b/mbqErTsPl2uN6Alk9VZjbAenBbjm
         sKEyE3hyT1VpGAr7GqlcP4Gvt38vB/rV/jiHBzu0C7SpmjaOqgk3gdUDe0rzxJssZUWr
         LO/Q1HeFRz8JYC1y5nbxV5UOjGV8sqk0aHy+xd/yiCyxmfE9GZTJ/5RXguwW4aKr8oZR
         D/4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783688975; x=1784293775;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rLKOP/shS+AHbtHYABHQpI1rASYgkBUQVXQ3j/Wr1mU=;
        b=RDnQPjVAOgrfUbSHrSfawWIulT+FtkSKB5qlR8ikdDrrEHJdjRdZI9voNe9Z302WWe
         m9cEi4YV4GFsa7vH8fw3Iq1ZD4MOes10M0s5x+EHj7MVSPOivG+7ab/lqNIfLmZaduCQ
         MnKzp8sffXGIr1Ow+ZNBSTBI6KpwoZxnsvqNs8NZCJOZyhotJkWu9/710JpvZDcL6f1P
         3kSI4B7t9PUu8rFw6jFKtjp1DrOpTfQDndOAo99JXtX2VaTdgMmzkP7O6Ab12EOHbQUM
         A+0BGlc8+8tPddD3pCDhfO/Nwz0A8pUZ9HtMurn3yR3+Ax3OZ9t3U6g/9yB3YZmbtvzz
         2ynQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp9ztUBJhI1XMlklzJR+I/vS2sDNZA5blx8ehcbYBANY1vOgTXIPsiSWN5IFZnKaTcUG1RKUmCQ7vhS@vger.kernel.org
X-Gm-Message-State: AOJu0YwGi56ND2Jhk8S9CiEYEijloCX0bIzO+ga5/+modKFx5DiQmZ6X
	lYO4ls1vzaqYxZNh8griASlyw86l90GtF2XM9z3S2TTUzFMqYrQH9YOfQz+IMsg/1V5p+xk7BrX
	7enG3qDMRbZceN0NOEFXxdkRrOuqh55A=
X-Gm-Gg: AfdE7cn9zpJpJekpQ99ttBSYwoU9UUKehGuRcb9H3XXUJzTFkzGhIQLw9WGTmzDDJa8
	hsoeXSQgqc+SjdKDvTTYIByKnI5+ye8CO85oQwX4H0icjWqTlAN5IzTx8YdAUHc5nNw1L2SY6w5
	UAsBVy+mwTnuaYUJusRHD/wjIwKHDSEJFXvtY65/oaYUkgLPI+dOI106vHtyjgUmfG7KVlTFZXz
	VOiFAuqjvMGI1PZRoyDMj9bGxB+yyif9FWvVB0g9ZphQO+cn2BD5yopBq0yXPK/L2O4TYT3Gup5
	I6sI/PFEFPmMKbNd7A2BzYsEANrYuOzztqfK64Y9N2L4mmtzodmYLLPTJcKq0Ua2TKHelI3D33a
	o1/EB5ImqDGY5AvXuMGZS+zw=
X-Received: by 2002:a05:6a20:1587:b0:3bf:6c08:2840 with SMTP id
 adf61e73a8af0-3c0bd1a8091mr14368115637.47.1783688975372; Fri, 10 Jul 2026
 06:09:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624155452.211646-1-nishidafmly@gmail.com> <aa24dd05-f231-4657-8fef-8201138da65f@fygo.io>
In-Reply-To: <aa24dd05-f231-4657-8fef-8201138da65f@fygo.io>
From: Hiroshi Nishida <nishidafmly@gmail.com>
Date: Fri, 10 Jul 2026 06:09:19 -0700
X-Gm-Features: AVVi8CdGjkqlvTaLCRblNqwOKcZqZnqRh6uG-Ytq_1xEQV7jZuwb3pgfZCsx7F4
Message-ID: <CAE1ksKTLcamf2jX6s6vaV5keXwS1pmJa_cV7nPZ84CNUSQRZxw@mail.gmail.com>
Subject: Re: [PATCH 0/8] md/raid5: scalability and rebuild-path improvements
To: yukuai@fygo.io
Cc: Song Liu <song@kernel.org>, Li Nan <magiclinan@didiglobal.com>, 
	Xiao Ni <xiao@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Yu Kuai,

Thanks again for the review, and in particular for:

> I can accept make those values configurable, but not direct
> modifications.

I've reworked the tunables along exactly those lines and will send them as
a separate, self-contained series, "md/raid5: size stripe-cache and worker
tuning from the hardware".

Rather than raising any fixed constant, each value now derives a default
from the hardware and stays overridable:

  - the stripe-cache hash lock count (was a fixed 8) is sized from the CPU
    count, clamped to 8..32;
  - the stripe_cache_size ceiling (was a fixed 32768) scales with memory,
    but never drops below 32768;
  - the initial stripe_cache_size (was a fixed 256) scales gently with
    memory, 256..4096;
  - the default group_thread_cnt (was 0, i.e. single-threaded) is derived
    from the CPU count (half the online CPUs per NUMA node, capped);
  - the stripe batch size (was a fixed 8) is exposed as a parameter.

Ahead of those, the series opens with a one-line prerequisite fix:
alloc_thread_groups() sizes the per-node worker_groups[] array by
num_possible_nodes() but indexes it by cpu_to_node(), so a sparse NUMA node
map can index off the end -- reachable once the worker-group default (the
last patch) is on.  It is Fixes:-tagged and can be taken on its own.

The key point for the consumer-NAS concern you raised: each default only
rises on hardware that can back it -- the lock and worker counts scale with
the core count, the cache sizes with RAM -- so a genuinely small system (a
few cores and a few GB) keeps today's values and footprint. And each one is
overridable via a module parameter (group_thread_cnt also via its existing
sysfs attribute), including all the way back to today's behaviour. So nothi=
ng is
imposed; the default simply tracks the machine instead of a constant, and
a wide array on a large host no longer needs a recompile or manual
per-array tuning to use the memory and cores it has.

And on performance -- on real NVMe this time, not a ramdisk: on a 16-disk
raid6 array (a 32-vCPU / 16-core host, steady state, interleaved runs) the
hardware-derived defaults run 2.1-3.2x the stock defaults (4K random write
~39k -> ~100k IOPS), essentially all of it from patch 6 turning on the
worker groups.  Patches 2-5 (the cache and lock sizing) are
throughput-neutral on real SSD, as you'd expect -- they earn their place as
configurability and sane defaults, not a speed claim.  And there is no
regression at the small end: a 4-CPU box derives 2 workers and is never
slower on any workload, and a box with two or fewer CPUs derives 0 and is
byte-for-byte unchanged.

It has been through KASAN + lockdep + DEBUG_LIST on RAID5
(create/rebuild/scrub, plus the bitmap add/remove that drives the
lock-all-hash-locks quiesce path), at both the derived defaults and pinned
values including nr_stripe_hash_locks=3D32.

The two unrelated parts of the original series -- the type-widening /
correctness fixes and the resync/recovery dispatch changes -- I'll send as
their own small series, as discussed.

Thanks,

2026=E5=B9=B47=E6=9C=885=E6=97=A5(=E6=97=A5) 19:56 yu kuai <yukuai@fygo.io>=
:
>
> Hi,
>
> =E5=9C=A8 2026/6/24 23:54, Hiroshi Nishida =E5=86=99=E9=81=93:
> > This series collects small, individually low-risk md/raid5 changes for
> > large, many-core, many-disk arrays.  Their common theme is reducing
> > per-stripe and stripe-cache contention, so the benefit appears mainly
> > when the raid5 stripe-handling worker threads are in use
> > (group_thread_cnt > 0); at the default group_thread_cnt =3D 0 (a single
> > handling thread) the series is essentially neutral.
> >
> >   - patches 1-3 remove signed arithmetic from a hot-path divisor, lift =
an
> >     arbitrary stripe-cache size cap, and widen a badblock length argume=
nt
> >     that currently truncates large ranges;
> >   - patch 4 raises NR_STRIPE_HASH_LOCKS (8 -> 32) to spread stripe-hash
> >     contention on high core-count systems;
> >   - patches 5 and 8 reduce per-stripe overhead in the resync/recovery
> >     path and bound the share of the stripe cache a rebuild may hold whi=
le
> >     user I/O is competing;
> >   - patch 6 allocates each worker group's array on its own NUMA node;
> >   - patch 7 raises MAX_STRIPE_BATCH (8 -> 32).
> >
> > Measured effect, treatment vs baseline, % change in mean IOPS (N=3D3),
> > swept over group_thread_cnt (RAID6 4+2, 22-core host, ramdisk members):
>
> Testing with ramdisk does serve as a useful reference, but it does not re=
flect
> real world usage.
>
> >
> >    workload                       gtc=3D0   gtc=3D2   gtc=3D4   gtc=3D8
> >    random 4K write (RMW)          +4.2%   +8.1%  +17.4%   +6.5%
> >    DB mixed 75/25 8K              +0.4%   +4.2%  +10.3%   +4.7%
> >    high-concurrency 70/30 4K      +3.9%   +1.2%  +10.0%   +0.2%
> >    OLTP 70/30 16K                 -0.3%   +4.7%  +10.1%   +9.3%
> >    partial-stripe write 8K        +1.1%   +4.8%  +11.2%  +14.2%
>
> With a quick review I saw many static configurations is changed, I agree
> these changes can improve arrays with ssd/nvme and a system with large
> memory available. However, we already tested with hdd and about 8G memory
> available, these changes will not improve performance at all, with the
> extra memory overhead.
>
> I can accept make those values configurable, but not direct modifications=
.
> As validation is required for numerous scenarios. Memory resources are pr=
ecious
> especially for most consumer NAS devices.
>
> >
> > At the default single handling thread (group_thread_cnt =3D 0) the seri=
es is
> > neutral (no regression).  As worker threads are added the gain grows,
> > peaking broadly around group_thread_cnt =3D 4 at roughly +10-17% across=
 the
> > whole mix; at gtc =3D 8 the write-heavy workloads keep gaining while th=
e
> > read-heavy high-concurrency case has saturated.  (Per-run cv was <1%
> > except the random-write test, ~5-9%, from a cold first run.)
> >
> > These numbers are on a ramdisk, which removes device latency and so
> > overstates the CPU-side contention effect relative to a real device;
> > they show the direction and the group_thread_cnt dependence, not an
> > absolute speedup.  The stripe-hash/batch patches (4, 7) and the cache c=
ap
> > (2) drive this; patch 6 only matters on multi-socket systems (not
> > exercised above) and patches 5/8 act on the resync/recovery path rather
> > than this steady-state workload.
> >
> > Reproduction (stock mdadm + fio):
> >    mdadm --create /dev/md0 --level=3D6 --raid-devices=3D6 --chunk=3D512=
 \
> >          --assume-clean <6 members>
> >    echo 16384 > /sys/block/md0/md/stripe_cache_size
> >    echo N     > /sys/block/md0/md/group_thread_cnt      # N =3D 0,2,4,8
> >    fio --filename=3D/dev/md0 --direct=3D1 --ioengine=3Dlibaio --group_r=
eporting \
> >        --time_based --runtime=3D15 --name=3Dw <per-workload opts>:
> >      random write   : --rw=3Drandwrite              --bs=3D4k  --numjob=
s=3D4  --iodepth=3D32
> >      DB mixed       : --rw=3Drandrw --rwmixread=3D75  --bs=3D8k  --numj=
obs=3D8  --iodepth=3D16
> >      high-concur.   : --rw=3Drandrw --rwmixread=3D70  --bs=3D4k  --numj=
obs=3D16 --iodepth=3D8
> >      OLTP           : --rw=3Drandrw --rwmixread=3D70  --bs=3D16k --numj=
obs=3D6  --iodepth=3D16
> >      partial-stripe : --rw=3Drandwrite              --bs=3D8k  --numjob=
s=3D4  --iodepth=3D32
> >
> > Each patch stands on its own; I am happy to drop or defer any that is n=
ot
> > justified on its own merit.
> >
> > Functional testing on RAID5 and RAID6: create, fail a member, rebuild
> > onto a spare / re-add, full data read-back verified, and scrub
> > ("check") reporting mismatch_cnt =3D=3D 0.  The series was also exercis=
ed
> > with KASAN and lockdep enabled -- including heavy group_thread_cnt
> > churn on a multi-node setup to stress the per-NUMA-node worker
> > allocation and the raid5_quiesce hash-lock-all path -- with no reports.
> >
> > Hiroshi Nishida (8):
> >    md: change chunk_sectors and stripe cache counts to unsigned int
> >    md/raid5: raise stripe cache limit from 32768 to 262144
> >    md: widen badblock sectors param from int to sector_t
> >    md/raid5: raise NR_STRIPE_HASH_LOCKS from 8 to 32
> >    md/raid5: submit a window of stripes during resync/recovery
> >    md/raid5: allocate worker groups per NUMA node
> >    md/raid5: raise MAX_STRIPE_BATCH from 8 to 32
> >    md/raid5: reserve stripe cache for user I/O during rebuild
> >
> >   drivers/md/md.c    |   4 +-
> >   drivers/md/md.h    |  10 ++--
> >   drivers/md/raid5.c | 129 ++++++++++++++++++++++++++++++++------------=
-
> >   drivers/md/raid5.h |  33 ++++++++----
> >   4 files changed, 121 insertions(+), 55 deletions(-)
> >
> > base-commit: 55b77337bdd088c77461588e5ec094421b89911b
> >
> --
> Thanks,
> Kuai



--=20
Hiroshi Nishida
nishidafmly@gmail.com
