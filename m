Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443A5232395
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783691159; cv=pass; b=oopFG+Ms1NSi7Il1r0uLDTJPUewLaUA0VSKEaGaPuJliLNXlDHjh7oyCcdsAe8fOnS9PbicHTElpoDouptCRXy+JFvslhEvkxk0uNsk4zbRDYaoka0EIn35982NNLlmD6i1DJWgrk2mv9edgIuHd881AwEfOvJPQOSQM4k0PCzQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783691159; c=relaxed/simple;
	bh=XMjat+GJFmOuxx/tZqWFZDbkCpkXJBJMWn2sRRDqoAM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=epeJcPIMuUJzCqsGrVnRn1k7/nroqgUHAbMm36dgJui7X3jsyCPajO60DKJv0e9x2A8/s7TLMChUJCiYaFTlmWPOc4t80QA2aw16pp5NaKb7SkgETekXVCSf2P4truaniYMKe4j1wG9clgbnfk+QViVg4JqBQRaRgWyuT8eIN7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JPmW9k3a; arc=pass smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JPmW9k3a"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-37df72c9984so1560024a91.3
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 06:45:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783691156; cv=none;
        d=google.com; s=arc-20260327;
        b=KGVpAN7LXA+FN0ayMZ77JqZ+7dpLNcqLMaqUmnpBP/WA+e0huffSi7n7HMFj3LkWVS
         Pn5xWbZHh5Md0CCpNuBnPb5dly/+5Dp2MtJjVa8WIcM3xx4D4DM+1i6lYxxo4DsksQKU
         ftqGZZR/FDpaSBDRe0Hncpe0GT8aW/0qHwPTB2DfqY/ea2huqR3nl6J/IXagFZM/y8f+
         K9j4KkJWYhClRp06rPXe50ZdpL+XC3wF4hXc+JbWMPlUzsPce6z7a6aWi02EGWxr0+LR
         TVA2dg78EE6gEo/gegqU27znyo2Q9T7VsJtxMFWNkAydXLzCe0K8KZFIET42zqbYP4J8
         UfmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A//RGSy8nInJ6aXei5lZlqZm3OiUIgCddVYcoDkt4t0=;
        fh=brG3TXoTFFUtmdsxWZI+sf/0TU5X8eQanfR7evi203E=;
        b=oiqkmkSVHkgXROkhNIOYVUxqzPQeZcnfyid/L3hjVeL4NpVkVRghZj20A7tkB/yN3k
         sfuaeaprYFJIR5zARJ3KZzeZXPZVx+t8Q/7aMVrAffJHi7BIJlHDtKl6evIeRTcBp+q4
         vIEeX27G7RtnOCKl37sn3wTr3B3DGLrq/RmjnH0MIyHdN7Up5750kJgKfgz33/qXnBGu
         1xOPkJq0YciqrgL0Lv8/DVgJQrJlBMK1p/FiK0Rl/+Abw0K3ZDZUFZFsmEOOxAw8EfU3
         yA6EUsn/NU1dVCGTEkWMStsHHZTFoI/tyARg0YwBwvCaUJsU+OqrFMfzUg71unUMIN60
         Lifw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783691156; x=1784295956; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A//RGSy8nInJ6aXei5lZlqZm3OiUIgCddVYcoDkt4t0=;
        b=JPmW9k3aN00t9jmtBbCcfV1qAvrM3JUEpSYMMbA5K7TxrMRz74UhEQK4KrwegL80hq
         JmgOkJUHdFmKeZOn/BYr2Iw3RG7b3NTLN6fuE9EMxKf30CNTvlOfv93R4SOIy08TGT5L
         EZ2yRRDvFks+SOYKV6hU35uJX9l34wsOs4UonvTXJcF4Y58JbG7y6PG8hhEecK58Bb9l
         2Uw1oanP5FVZ45+6xiVUe9g8i6pon+kN4LELFMsrH3jFvxUDkUYRh+qQAnk9kv+YlKGd
         WU94y3weHVwevnG2uczhQ2oMcsYfkNq5dc2Kc335CRs7j0Sok8EMnKUjSZJbdzd0mX24
         mI0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783691156; x=1784295956;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A//RGSy8nInJ6aXei5lZlqZm3OiUIgCddVYcoDkt4t0=;
        b=YOQJPUC+OmGGMREGsEESZNYN78PBPUaVeUYtQGEDVnW+loy5ack80ad7mO0TM3uOtK
         4jScUDw/wp4RH08jyBfrgFY5IbJuj7j4is60EFMCSpWyiOn6BtvyJ/ZxLA5wosnY3Wjf
         EsaONoTxIJeXxfoOBl8EXWqjhmsy3hPByICv6yk+1uU4nACz6zKpGcA4eZSeOj1gvBIZ
         XnBv73WCZQqz+uN8Wj7ayOK9QjDta/rnsyyr/Z574aVjFKAe5fuvQ4zkPSFsiQ0e+60T
         id+yVNpDHiyEhpNpedObnwppJzYeXELuH6r3FX1n6CHf1WjVQCYz0lQoeAFDR8Z/aEUq
         oMjg==
X-Forwarded-Encrypted: i=1; AHgh+Rr9TB33OHBLT0ZeKG2bk+is1G5fAGEWArjMTvJLPFgL0laOzUCbPbHuBi0dCn2N4ybXLXToeyMM1DY3@vger.kernel.org
X-Gm-Message-State: AOJu0YxBJG747/YgL+DsXBOBl4GMSSn/nUMbR/XtyNKdUx6YLJQJZUDz
	MwRoJpUilQc5uue/+oyEFlSO1mQdNHHHal9Pji5Wv+X/zDWRp/TO5GyOD/itjsBKK5vNviEB8fE
	0ZHDifPPtvvxJVpW+ZtdrGHujXGanif0=
X-Gm-Gg: AfdE7cllf9q2qWofp+zo+zgdCoSlLazCC1oU/kLyUmjzcLN3jO05lRS3SHgpgehATDw
	Vq1vLrD8czGrNsxSakQzc6Qt3Oyf5JzqYrRNsAlahL7uADUB/MhXlrWGG9XoiYuUpbQ5E0IXsJB
	kBpR+BH59znsGZWH+ApjnkVt8Zc63gOf6viYs1lSKPGm2YDf/NX+pToEPyCNTXJHTkpjluB5sxw
	O7Ro16JH5SrSTbZgxG3E0DNvwiTiFotb5Av3z1/ph53KkK4UIgRAl+uQwv4Ek+iGYHGTXGIT3I3
	aqDeUjpqEGf4C8CU72X4X/S0olcFi0ITRKICRb3M2KNkptwwlRmpnKWyATBTIBCKOg0dMNya5Ir
	DebUw+zQVKLv8
X-Received: by 2002:a17:90b:5190:b0:380:83fc:4315 with SMTP id
 98e67ed59e1d1-38941cc77b5mr12382457a91.21.1783691155542; Fri, 10 Jul 2026
 06:45:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624155452.211646-1-nishidafmly@gmail.com>
 <aa24dd05-f231-4657-8fef-8201138da65f@fygo.io> <CAE1ksKTLcamf2jX6s6vaV5keXwS1pmJa_cV7nPZ84CNUSQRZxw@mail.gmail.com>
In-Reply-To: <CAE1ksKTLcamf2jX6s6vaV5keXwS1pmJa_cV7nPZ84CNUSQRZxw@mail.gmail.com>
From: Hiroshi Nishida <nishidafmly@gmail.com>
Date: Fri, 10 Jul 2026 06:45:37 -0700
X-Gm-Features: AVVi8Cfb6T3XOK1zIl5giC0oOicysW7-fKVBbLOOAHUBttI3BI7TzXZR-PTyUbk
Message-ID: <CAE1ksKTpN-ye+MOZEvJEJMi8VZC09wbH5yKCfT7G=S_JrVuBDQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] md/raid5: scalability and rebuild-path improvements
To: yukuai@fygo.io
Cc: Song Liu <song@kernel.org>, Li Nan <magiclinan@didiglobal.com>, 
	Xiao Ni <xiao@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The cover quotes the 2.1-3.2x headline; here is the full per-workload data
behind it, in case it helps review.

The same raid456.ko is used in both arms -- only the module parameters
differ at array-create -- so this isolates the *defaults*, not code changes=
.
Real NVMe SSDs, not a ramdisk.

Setup: GCP n2-standard-32 -- 32 vCPUs =3D 16 physical cores (a vCPU is one
hyperthread), 2 NUMA nodes, 125 GB RAM, 16x 375 GB local NVMe. Kernel: full
build of the 6-patch series (base 55b77337), non-debug. raid6, 64k chunk,
bitmap=3Dnone, --assume-clean. Workloads: a 5-test fio suite (direct=3D1,
libaio, 30 s each): 4K random write (RMW), DB-mixed 75/25 8K,
high-concurrency 70/30 4K, OLTP 70/30 16K, partial-stripe 8K.

AUTO =3D all defaults left auto (the hardware-derived values); STOCK =3D th=
e
historical fixed values (hash 8 / ceiling 32768 / batch 8 / cache 256 /
group_thread_cnt 0). On this host AUTO resolves to group_thread_cnt=3D8,
stripe_cache_size~3886, 32 hash locks.

1) Wide 16-disk raid6 (14+2), steady state, interleaved N=3D5 (STOCK and AU=
TO
   alternate each round so SSD drift cancels; cv 1-8%):

     Workload             STOCK IOPS    AUTO IOPS    AUTO/STOCK
     4K random write          39,147      100,069        2.56x
     DB mixed 75/25 8K        88,040      208,284        2.37x
     High-conc 70/30 4K      122,765      257,952        2.10x
     OLTP 70/30 16K           39,597      100,033        2.53x
     Partial-stripe 8K        20,491       64,511        3.15x

2) Low-end 4-CPU / 8 GB, 6-disk raid6 (4+2), N=3D3 -- no-regression control=
.
   4 online CPUs + 8 GB, single node (num_online_cpus()=3D4 -> gtc=3D2); th=
e
   cache stays 256 and the hash count stays 8, so AUTO differs from STOCK
   only in group_thread_cnt (2 vs 0):

     Workload             STOCK IOPS    AUTO IOPS    AUTO/STOCK
     4K random write          52,017       81,132        1.56x
     DB mixed                125,043      126,188        1.01x
     High-conc               180,570      217,074        1.20x
     OLTP                     54,308       55,840        1.03x
     Partial-stripe           27,060       42,751        1.58x

   No regression on any workload; modest write gains even here. A
   slower-disk NAS is more device-bound (the gains flatten) but still shows
   no regression, and a box with <=3D2 online CPUs derives gtc=3D0 =3D
   byte-for-byte stock.

The gain is essentially patch 6 (worker groups on by default); patches 2-5
(cache and lock sizing) are throughput-neutral on real SSD and earn their
place as configurability plus sane defaults, not a speed claim. Patch 1 is
the NUMA-sizing prerequisite and does not affect throughput.

Thanks,

2026=E5=B9=B47=E6=9C=8810=E6=97=A5(=E9=87=91) 6:09 Hiroshi Nishida <nishida=
fmly@gmail.com>:
>
> Hi Yu Kuai,
>
> Thanks again for the review, and in particular for:
>
> > I can accept make those values configurable, but not direct
> > modifications.
>
> I've reworked the tunables along exactly those lines and will send them a=
s
> a separate, self-contained series, "md/raid5: size stripe-cache and worke=
r
> tuning from the hardware".
>
> Rather than raising any fixed constant, each value now derives a default
> from the hardware and stays overridable:
>
>   - the stripe-cache hash lock count (was a fixed 8) is sized from the CP=
U
>     count, clamped to 8..32;
>   - the stripe_cache_size ceiling (was a fixed 32768) scales with memory,
>     but never drops below 32768;
>   - the initial stripe_cache_size (was a fixed 256) scales gently with
>     memory, 256..4096;
>   - the default group_thread_cnt (was 0, i.e. single-threaded) is derived
>     from the CPU count (half the online CPUs per NUMA node, capped);
>   - the stripe batch size (was a fixed 8) is exposed as a parameter.
>
> Ahead of those, the series opens with a one-line prerequisite fix:
> alloc_thread_groups() sizes the per-node worker_groups[] array by
> num_possible_nodes() but indexes it by cpu_to_node(), so a sparse NUMA no=
de
> map can index off the end -- reachable once the worker-group default (the
> last patch) is on.  It is Fixes:-tagged and can be taken on its own.
>
> The key point for the consumer-NAS concern you raised: each default only
> rises on hardware that can back it -- the lock and worker counts scale wi=
th
> the core count, the cache sizes with RAM -- so a genuinely small system (=
a
> few cores and a few GB) keeps today's values and footprint. And each one =
is
> overridable via a module parameter (group_thread_cnt also via its existin=
g
> sysfs attribute), including all the way back to today's behaviour. So not=
hing is
> imposed; the default simply tracks the machine instead of a constant, and
> a wide array on a large host no longer needs a recompile or manual
> per-array tuning to use the memory and cores it has.
>
> And on performance -- on real NVMe this time, not a ramdisk: on a 16-disk
> raid6 array (a 32-vCPU / 16-core host, steady state, interleaved runs) th=
e
> hardware-derived defaults run 2.1-3.2x the stock defaults (4K random writ=
e
> ~39k -> ~100k IOPS), essentially all of it from patch 6 turning on the
> worker groups.  Patches 2-5 (the cache and lock sizing) are
> throughput-neutral on real SSD, as you'd expect -- they earn their place =
as
> configurability and sane defaults, not a speed claim.  And there is no
> regression at the small end: a 4-CPU box derives 2 workers and is never
> slower on any workload, and a box with two or fewer CPUs derives 0 and is
> byte-for-byte unchanged.
>
> It has been through KASAN + lockdep + DEBUG_LIST on RAID5
> (create/rebuild/scrub, plus the bitmap add/remove that drives the
> lock-all-hash-locks quiesce path), at both the derived defaults and pinne=
d
> values including nr_stripe_hash_locks=3D32.
>
> The two unrelated parts of the original series -- the type-widening /
> correctness fixes and the resync/recovery dispatch changes -- I'll send a=
s
> their own small series, as discussed.
>
> Thanks,
>
> 2026=E5=B9=B47=E6=9C=885=E6=97=A5(=E6=97=A5) 19:56 yu kuai <yukuai@fygo.i=
o>:
> >
> > Hi,
> >
> > =E5=9C=A8 2026/6/24 23:54, Hiroshi Nishida =E5=86=99=E9=81=93:
> > > This series collects small, individually low-risk md/raid5 changes fo=
r
> > > large, many-core, many-disk arrays.  Their common theme is reducing
> > > per-stripe and stripe-cache contention, so the benefit appears mainly
> > > when the raid5 stripe-handling worker threads are in use
> > > (group_thread_cnt > 0); at the default group_thread_cnt =3D 0 (a sing=
le
> > > handling thread) the series is essentially neutral.
> > >
> > >   - patches 1-3 remove signed arithmetic from a hot-path divisor, lif=
t an
> > >     arbitrary stripe-cache size cap, and widen a badblock length argu=
ment
> > >     that currently truncates large ranges;
> > >   - patch 4 raises NR_STRIPE_HASH_LOCKS (8 -> 32) to spread stripe-ha=
sh
> > >     contention on high core-count systems;
> > >   - patches 5 and 8 reduce per-stripe overhead in the resync/recovery
> > >     path and bound the share of the stripe cache a rebuild may hold w=
hile
> > >     user I/O is competing;
> > >   - patch 6 allocates each worker group's array on its own NUMA node;
> > >   - patch 7 raises MAX_STRIPE_BATCH (8 -> 32).
> > >
> > > Measured effect, treatment vs baseline, % change in mean IOPS (N=3D3)=
,
> > > swept over group_thread_cnt (RAID6 4+2, 22-core host, ramdisk members=
):
> >
> > Testing with ramdisk does serve as a useful reference, but it does not =
reflect
> > real world usage.
> >
> > >
> > >    workload                       gtc=3D0   gtc=3D2   gtc=3D4   gtc=
=3D8
> > >    random 4K write (RMW)          +4.2%   +8.1%  +17.4%   +6.5%
> > >    DB mixed 75/25 8K              +0.4%   +4.2%  +10.3%   +4.7%
> > >    high-concurrency 70/30 4K      +3.9%   +1.2%  +10.0%   +0.2%
> > >    OLTP 70/30 16K                 -0.3%   +4.7%  +10.1%   +9.3%
> > >    partial-stripe write 8K        +1.1%   +4.8%  +11.2%  +14.2%
> >
> > With a quick review I saw many static configurations is changed, I agre=
e
> > these changes can improve arrays with ssd/nvme and a system with large
> > memory available. However, we already tested with hdd and about 8G memo=
ry
> > available, these changes will not improve performance at all, with the
> > extra memory overhead.
> >
> > I can accept make those values configurable, but not direct modificatio=
ns.
> > As validation is required for numerous scenarios. Memory resources are =
precious
> > especially for most consumer NAS devices.
> >
> > >
> > > At the default single handling thread (group_thread_cnt =3D 0) the se=
ries is
> > > neutral (no regression).  As worker threads are added the gain grows,
> > > peaking broadly around group_thread_cnt =3D 4 at roughly +10-17% acro=
ss the
> > > whole mix; at gtc =3D 8 the write-heavy workloads keep gaining while =
the
> > > read-heavy high-concurrency case has saturated.  (Per-run cv was <1%
> > > except the random-write test, ~5-9%, from a cold first run.)
> > >
> > > These numbers are on a ramdisk, which removes device latency and so
> > > overstates the CPU-side contention effect relative to a real device;
> > > they show the direction and the group_thread_cnt dependence, not an
> > > absolute speedup.  The stripe-hash/batch patches (4, 7) and the cache=
 cap
> > > (2) drive this; patch 6 only matters on multi-socket systems (not
> > > exercised above) and patches 5/8 act on the resync/recovery path rath=
er
> > > than this steady-state workload.
> > >
> > > Reproduction (stock mdadm + fio):
> > >    mdadm --create /dev/md0 --level=3D6 --raid-devices=3D6 --chunk=3D5=
12 \
> > >          --assume-clean <6 members>
> > >    echo 16384 > /sys/block/md0/md/stripe_cache_size
> > >    echo N     > /sys/block/md0/md/group_thread_cnt      # N =3D 0,2,4=
,8
> > >    fio --filename=3D/dev/md0 --direct=3D1 --ioengine=3Dlibaio --group=
_reporting \
> > >        --time_based --runtime=3D15 --name=3Dw <per-workload opts>:
> > >      random write   : --rw=3Drandwrite              --bs=3D4k  --numj=
obs=3D4  --iodepth=3D32
> > >      DB mixed       : --rw=3Drandrw --rwmixread=3D75  --bs=3D8k  --nu=
mjobs=3D8  --iodepth=3D16
> > >      high-concur.   : --rw=3Drandrw --rwmixread=3D70  --bs=3D4k  --nu=
mjobs=3D16 --iodepth=3D8
> > >      OLTP           : --rw=3Drandrw --rwmixread=3D70  --bs=3D16k --nu=
mjobs=3D6  --iodepth=3D16
> > >      partial-stripe : --rw=3Drandwrite              --bs=3D8k  --numj=
obs=3D4  --iodepth=3D32
> > >
> > > Each patch stands on its own; I am happy to drop or defer any that is=
 not
> > > justified on its own merit.
> > >
> > > Functional testing on RAID5 and RAID6: create, fail a member, rebuild
> > > onto a spare / re-add, full data read-back verified, and scrub
> > > ("check") reporting mismatch_cnt =3D=3D 0.  The series was also exerc=
ised
> > > with KASAN and lockdep enabled -- including heavy group_thread_cnt
> > > churn on a multi-node setup to stress the per-NUMA-node worker
> > > allocation and the raid5_quiesce hash-lock-all path -- with no report=
s.
> > >
> > > Hiroshi Nishida (8):
> > >    md: change chunk_sectors and stripe cache counts to unsigned int
> > >    md/raid5: raise stripe cache limit from 32768 to 262144
> > >    md: widen badblock sectors param from int to sector_t
> > >    md/raid5: raise NR_STRIPE_HASH_LOCKS from 8 to 32
> > >    md/raid5: submit a window of stripes during resync/recovery
> > >    md/raid5: allocate worker groups per NUMA node
> > >    md/raid5: raise MAX_STRIPE_BATCH from 8 to 32
> > >    md/raid5: reserve stripe cache for user I/O during rebuild
> > >
> > >   drivers/md/md.c    |   4 +-
> > >   drivers/md/md.h    |  10 ++--
> > >   drivers/md/raid5.c | 129 ++++++++++++++++++++++++++++++++----------=
---
> > >   drivers/md/raid5.h |  33 ++++++++----
> > >   4 files changed, 121 insertions(+), 55 deletions(-)
> > >
> > > base-commit: 55b77337bdd088c77461588e5ec094421b89911b
> > >
> > --
> > Thanks,
> > Kuai
>
>
>
> --
> Hiroshi Nishida
> nishidafmly@gmail.com



--=20
Hiroshi Nishida
nishidafmly@gmail.com
