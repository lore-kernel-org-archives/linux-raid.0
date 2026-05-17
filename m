Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9493D47D3
	for <linux-raid@vger.kernel.org>; Sun, 17 May 2026 22:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779057281; cv=pass; b=Y8qH1d4BEtS51Mwigihnuv3hTmEEmeS20LuHeEMbPBi08RdFMq4tvc2JcMJ+3nz1IE4msynOhuFoJJAIkunXw/Xe/jlxpPN2dRKCKN4YkSMMSZv+KHicMN0r/gGMR5BrAwqQqg0MMbA2Dt/oZviSYP74/1Jybw3WAFgPf17aN8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779057281; c=relaxed/simple;
	bh=pH7I+bNZ+H2bfRjIa356NrYYGA0fsgnUE3iSoHZtMaU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ROHAJHKjDumTTsgvSo9TEslhfIk3DEaSMj2Ltc2v8+8W71dOhJkOYqOgtfxoL4w68x3zIUANLm2hM38CKTSBc9r0h5Hwx62UnK7ihTvtUHi9X3FtuG0oAQj4aXhQyP9iaWE7srFntLmTZrngFMfOCy2I7G4cB1x0P0tP9TZ3YF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YQN+ug3L; arc=pass smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YQN+ug3L"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-38e9653b53cso3374151fa.3
        for <linux-raid@vger.kernel.org>; Sun, 17 May 2026 15:34:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779057277; cv=none;
        d=google.com; s=arc-20240605;
        b=lUblMQUhkixMkwfOl/9WfdNi+dPi+BlRdTKuIgi9vnGzz7kNwGdAnlBpa9wIU5Nvs3
         UC7WgzM/LBFv8LcVHyAaz2RxNVNK/AXfoT7VahZgusc9Hr3ahgnf+GXF+/MEFfidaVn8
         aeozMU9PQBgmRaXmJFcvTIr4U+yqMyMaucy69CjV+VkAvW/YhQ5/MCHwGEDiYoQXPuiD
         lrsm9oxWX9oWwI2g7f2fuALhWRkHnfmwhrZsNfS5S05Ub8MCaNMvN5J/jluzOzX2LrWr
         d6Z0Z3QD6ZeCdGS2fGVM0v/s7RkczDtN7g2ARux2WcwZHhYz2IIpUbc2UGicD2uJzC1E
         HwIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O/MQlLLBDXSTdeD7xZqTG/PCJ9KXZ9mlqodjpYu4cBM=;
        fh=rOYWJ5Y86O5cv15a+GjVAvYt1VShL7UtbVE8mw+c6b4=;
        b=Y6iAw+MZ8a0kkGJpepVIutemu2GxVBKMqqM7DmfRF42XoafFZo+OeLFUicpnaq3wVu
         d2QyGP4S0Tu9/ILXOkGXLk5iPpIbLmpANzd2Q9CpBnm1HGX74bZCt5tBo2vyEYID0JXU
         PD3k1uWL5zDEmhW8ceWgLt5gFqPQCb0fgA0Eg/Jb0k+fr3LG+3MEIC2krp+bd0jJ4JkD
         3WsWEmO+vDd5S5cGr9qqm5/AD4qgSijRJCECAGaEdPDVQQgZuG9G4V5tU9aogVmEvcH1
         kEFcpUslG5dQ3FnpAnAANIqei6Yp2Vqvi8LoxHTdZSPEYdf89t5wB9uijBaR7YPt1OVQ
         l88Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779057277; x=1779662077; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O/MQlLLBDXSTdeD7xZqTG/PCJ9KXZ9mlqodjpYu4cBM=;
        b=YQN+ug3LvagY98MnKhAkJXXUP7P2WSMWJdbma3CBRoNFRBerdQzsvHWctiwBNaf1k/
         LNH5GaCJFETDEnoBsnfppj4zvHKAKZfbitPljnbnJ65S7gyHUR6uX46Zj3xFD7U8tV3h
         b7LOxyxLSsOF6Fs0mBEqqs/j4K5VUiDc9IufDWjU2FC0XE5m0wuxz4990HU/aBf/2K/Z
         +8CTBHGtEo4I5T39uIfaALshIjzHWiyiW8iPzLH5Y3mr+QEJImQpsLgIZYbg8x4h2EVt
         4xASUoSYfjTGcSsZWtZ6WOB56ziCKl5ou9BtESQSKt2XhvGk3e6HPmhcwHFKm+owCoom
         313g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779057277; x=1779662077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O/MQlLLBDXSTdeD7xZqTG/PCJ9KXZ9mlqodjpYu4cBM=;
        b=ZIaBM/6F5S1Foz6gqRt+psPEVqtD79egbGGg+GYnKreDy3odvV38npK6wNM24WEtth
         1ZWc7/VTKMX1DDzTleTenEdVZNMBSRwlts7MeHaXxNvyl0i++9BFSLPwjSJe1r1bF6Cs
         XDLucrO+Fy1RRPCgmVJ8wYjlBsixPwSzF0Z0W+fTU/PgHxoPAG3RPyaAyC5UHJBTFxwG
         RnV2sZ9WnHC5kB9NCMOTQKiIilxVBAexBeXTafgkr8qM1bcniRKT/UxRSvR3Iu9QzKrG
         6l7KFZMXK/QnSRHi1xzTCUiohopXcH9156R5UyZeQikGm6M9r48QBz8Kh2hb7P5xFmXR
         s12Q==
X-Forwarded-Encrypted: i=1; AFNElJ/4ugTlUtXHtIps05KnWsJZSr0Ew4/AHo41HsQxMUKB5Z54K+LxB3DgoCUNnW7/gFi/sd5XLD70Dh8G@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9S7s3DY0iZUIpk3be44XNaZmvU/rMuov2T79WC6dU1ZM14FAx
	AlZSSev5dMFPjKPVQNCPyfXpIOj1frv+8bXgEPcJwhh4gQg+AKJmVRwe6bv4b/u8r3kikyUXBVZ
	x/a/Df6WRVFD+jXjlPnA6dGgHjcxyFBI=
X-Gm-Gg: Acq92OGZGpA1BIfGWuVZ6vVpHV6Ks7xSHTlqmChkli13MfD5eXthO68F5TbSaUOLoKb
	3PCMD81oWhKBvqfR+O/Uuy6O3KLgTZLP95HfMKkgetLPqBjikmStFwfG4iB1ESJQJYEBuGP8oKb
	/3aXvHL/YMg0rTvgag6rR+cyLYUNmhkXuayR4j+lRnHn8Jimc07Ue7XYFIblMNwN556DdLE0r2K
	Z1y9KD4GZEIt0CROegWcraX1PnIzgsUe0fYUAC/zeRXS96JBQZ43wFJd/+6nFg+bWQDoY3hafT/
	rVIi/LMr4yzMEBK1MpZ2+aLbhddu
X-Received: by 2002:a05:6512:31c4:b0:5a4:11b0:fad7 with SMTP id
 2adb3069b0e04-5aa0e619d6amr1672043e87.2.1779057277025; Sun, 17 May 2026
 15:34:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAC_j7i1R7oy+nRhxEjCTba=DUgn02w9X+p94DCu0aHv5+5tKnQ@mail.gmail.com>
 <c3e576c8-f548-4ee4-87de-cb9151f8a061@leemhuis.info>
In-Reply-To: <c3e576c8-f548-4ee4-87de-cb9151f8a061@leemhuis.info>
From: Vjaceslavs Klimovs <vklimovs@gmail.com>
Date: Sun, 17 May 2026 15:34:25 -0700
X-Gm-Features: AVHnY4IqVaFrB5wz53o74Aa6juPbaca2mW3cmxSanoIxrR8TtY6H1MsdZzNhJHI
Message-ID: <CAC_j7i0iL9tPSuCxxUH_F_Ph7jy=6LcXA5=ZPoFU0jUo2P4fag@mail.gmail.com>
Subject: Re: [REGRESSION] block: virtio-blk + LVM raid1 spurious sector-0 read
 failures on libaio/threads submit since 5ff3f74e145a ("block: simplify direct
 io validity check")
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Yes, that was exactly it. The patch works for raid1 logical volumes
but, for obvious reasons (these are dm raid) this still oopses on
legacy mirror logical volumes:

[    2.168054] device-mapper: raid1: Mirror read failed from 252:0.
Trying alternative device.
  [    2.169241] BUG: unable to handle page fault for address: fffff580045f=
4bc8
  [    2.170256] #PF: supervisor read access in kernel mode
  [    2.170997] #PF: error_code(0x0000) - not-present page
  [    2.171706] PGD 7ff9d067 P4D 7ff9d067 PUD 7ff9c067 PMD 0
  [    2.172433] Oops: Oops: 0000 [#1] SMP PTI
  [    2.173003] CPU: 0 UID: 0 PID: 11 Comm: kworker/0:1 Not tainted
6.18.29+ #19 PREEMPT(lazy)
  [    2.174118] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS 1.16.3-20250108_150619-localhost 04/01/2014
  [    2.175472] Workqueue: kmirrord do_mirror
  [    2.176040] RIP: 0010:bio_add_page+0x8c/0x340
  [    2.176676] Code: 07 4d 8b 48 08 41 f6 c1 01 0f 85 d6 01 00 00 0f
1f 44 00 00 4d 89 c1 49 8b 11 48 c1 ea 33 83 e2 07 83 fa 04 0f 84 bf
00 00 00 <48> 8b 56 08 4c 8d 4a ff f6 c2 01 75
  08 0f 1f 44 00 00 49 89 f1 49
  [    2.179169] RSP: 0018:ffffcea500063bc8 EFLAGS: 00010293
  [    2.179933] RAX: 0000000000000001 RBX: ffff8d53149af400 RCX:
0000000000000580
  [    2.180947] RDX: 0000000000000001 RSI: fffff580045f4bc0 RDI:
ffff8d53149af488
  [    2.181969] RBP: 0000000000000000 R08: fffff580005f4c00 R09:
fffff580005f4c00
  [    2.182978] R10: ffffcea500063c14 R11: 0000000000000a80 R12:
ffff8d5303192a80
  [    2.183997] R13: ffffcea500063c20 R14: 0000000000000001 R15:
ffffcea500063cf8
  [    2.185022] FS:  0000000000000000(0000) GS:ffff8d53ed4d5000(0000)
knlGS:0000000000000000
  [    2.186180] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [    2.187035] CR2: fffff580045f4bc8 CR3: 0000000002c44002 CR4:
0000000000372ef0
  [    2.188047] Call Trace:
  [    2.188417]  <TASK>
  [    2.188756]  do_region+0x21d/0x270
  [    2.189313]  dispatch_io+0xf1/0x150
  [    2.189832]  ? __pfx_bio_get_page+0x10/0x10
  [    2.190424]  ? __pfx_bio_next_page+0x10/0x10
  [    2.191046]  dm_io+0x136/0x240
  [    2.191503]  ? __pfx_read_callback+0x10/0x10
  [    2.192108]  ? __pfx_bio_get_page+0x10/0x10
  [    2.192708]  ? __pfx_bio_next_page+0x10/0x10
  [    2.193319]  do_reads+0x13e/0x210
  [    2.193807]  ? __pfx_read_callback+0x10/0x10
  [    2.194411]  do_mirror+0x117/0x2a0
  [    2.194912]  process_one_work+0x18d/0x340
  [    2.195508]  worker_thread+0x196/0x300
  [    2.196022]  ? __pfx_worker_thread+0x10/0x10
  [    2.196617]  kthread+0xfc/0x240
  [    2.197073]  ? __pfx_kthread+0x10/0x10
  [    2.197606]  ? __pfx_kthread+0x10/0x10
  [    2.198116]  ret_from_fork+0x158/0x170
  [    2.198645]  ? __pfx_kthread+0x10/0x10
  [    2.199161]  ret_from_fork_asm+0x1a/0x30
  [    2.199736]  </TASK>
  [    2.200053] Modules linked in:
  [    2.200493] CR2: fffff580045f4bc8
  [    2.200951] ---[ end trace 0000000000000000 ]---
  [    2.201599] RIP: 0010:bio_add_page+0x8c/0x340
  [    2.202193] Code: 07 4d 8b 48 08 41 f6 c1 01 0f 85 d6 01 00 00 0f
1f 44 00 00 4d 89 c1 49 8b 11 48 c1 ea 33 83 e2 07 83 fa 04 0f 84 bf
00 00 00 <48> 8b 56 08 4c 8d 4a ff f6 c2 01 75
  08 0f 1f 44 00 00 49 89 f1 49
  [    2.204690] RSP: 0018:ffffcea500063bc8 EFLAGS: 00010293
  [    2.205390] RAX: 0000000000000001 RBX: ffff8d53149af400 RCX:
0000000000000580
  [    2.206368] RDX: 0000000000000001 RSI: fffff580045f4bc0 RDI:
ffff8d53149af488
  [    2.207333] RBP: 0000000000000000 R08: fffff580005f4c00 R09:
fffff580005f4c00
  [    2.208297] R10: ffffcea500063c14 R11: 0000000000000a80 R12:
ffff8d5303192a80
  [    2.209257] R13: ffffcea500063c20 R14: 0000000000000001 R15:
ffffcea500063cf8
  [    2.210265] FS:  0000000000000000(0000) GS:ffff8d53ed4d5000(0000)
knlGS:0000000000000000
  [    2.211391] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [    2.212201] CR2: fffff580045f4bc8 CR3: 0000000002c44002 CR4:
0000000000372ef0
  [    2.213196] Kernel panic - not syncing: Fatal exception
  [    2.214313] Kernel Offset: 0xc200000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
  [    2.215981] Rebooting in 10 seconds..

On Fri, May 15, 2026 at 10:10=E2=80=AFPM Thorsten Leemhuis
<regressions@leemhuis.info> wrote:
>
> On 5/15/26 18:52, Vjaceslavs Klimovs wrote:
> > Summary
> > -------
> > On v6.18, starting a libvirt/QEMU guest with virtio-blk backed by an
> > LVM "--type raid1" LV (drivers/md/dm-raid.c stacked on
> > drivers/md/raid1.c) makes md/raid1 register read failures at LV
> > sector 0 within seconds of "virsh start" and mark rimage_0 Faulty
> > once max_corrected_read_errors (default 20) is exceeded. Reads
> > succeed via the redirect path so guests boot, but every guest disk
> > ends up degraded on every VM start. Same workload on legacy
> > "--type mirror" (drivers/md/dm-raid1.c) crashes the host: a
> > zero-length READ reaches the NVMe controller, is rejected with
> > "Invalid Field in Command", and the dm-mirror recovery path oopses.
>
> That sounds somewhat like
> https://lore.kernel.org/all/2982107.4sosBPzcNG@electra/
>
> Have you tried latest 7.1-rc? It contains a fix for the problem
> mentioned in said thread: f7b24c7b41f23b ("md/raid1,raid10: don't fail
> devices for invalid IO errors") [v7.1-rc2]
>
> Ciao, Thorsten
>
> > Symptom on dm-raid raid1 (post --type raid1)
> > --------------------------------------------
> > Per LV, at virsh start, in host dmesg:
> >
> >   kernel: raid1_end_read_request: 95 callbacks suppressed
> >   kernel: raid1_read_request: 95 callbacks suppressed
> >   kernel: md/raid1:mdX: dm-58: rescheduling sector 0
> >   kernel: md/raid1:mdX: redirecting sector 0 to other mirror: dm-58
> >   kernel: md/raid1:mdX: dm-58: rescheduling sector 0
> >   kernel: md/raid1:mdX: redirecting sector 0 to other mirror: dm-58
> >   [... 10 rescheduling/redirecting pairs ...]
> >   kernel: md/raid1:mdX: dm-58: Raid device exceeded read_error
> > threshold [cur 21:max 20]
> >   kernel: md/raid1:mdX: dm-58: Failing raid device
> >   kernel: md/raid1:mdX: Disk failure on dm-58, disabling device.
> >   kernel: md/raid1:mdX: Operation continuing on 1 devices.
> >
> >   dmeventd: WARNING: Device #0 of raid1 array, vg0-iris_boot, has faile=
d.
> >   dmeventd: WARNING: Waiting for resynchronization to finish before
> > initiating repair on RAID device vg0-iris_boot.
> >   dmeventd: Use 'lvconvert --repair vg0/iris_boot' to replace failed de=
vice.
> >
> > Subsequent "lvs -a":
> >
> >   WARNING: RaidLV vg0/iris_boot needs to be refreshed!
> >   See character 'r' at position 9 in the RaidLV's attributes and its Su=
bLV(s).
> >
> > dmesg | grep nvme is EMPTY on this path. The NVMe driver is not
> > involved in producing the error; the failure originates between the
> > virtio-blk bio submission and raid1_end_read_request().
> >
> > Symptom on legacy dm-mirror (pre-conversion --type mirror)
> > ----------------------------------------------------------
> > Same workload on drivers/md/dm-raid1.c reaches the NVMe controller
> > as a zero-length READ and panics the host through dm-mirror's
> > recovery path:
> >
> >   kernel: operation not supported error, dev nvme1n1, sector 935446535
> > op 0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> >   kernel: nvme1n1: I/O Cmd(0x2) @ LBA 935446535, 0 blocks, I/O Error
> > (sct 0x0 / sc 0x2)
> >   [... 10+ identical bursts at same timestamp ...]
> >   dmeventd: Primary mirror device 252:58 read failed.
> >   dmeventd: vg0-iris_boot is now in-sync.
> >   [kernel oops in dm_mirror recovery path, full trace lost to console f=
lash]
> >
> > The "phys_seg 0", "0 blocks", "sct 0x0/sc 0x2" trio (NVMe Generic,
> > Invalid Field in Command, NVMe spec 4.1.1.2) is unambiguous: a bio
> > with bi_iter.bi_size =3D=3D 0 and bi_vcnt =3D=3D 0 left the block layer=
 and
> > hit the controller. dm-raid raid1 hides this by retrying on the
> > surviving leg, but the upstream-of-md trigger is identical.
> >
> > Bisect
> > ------
> > git bisect, v6.12..v6.18, 16 deterministic GOOD/BAD steps, no skips,
> > ~104 minutes:
> >
> >   5ff3f74e145adc79b49668adb8de276446acf6be is the first bad commit
> >   block: simplify direct io validity check
> >
> >   --- a/block/fops.c
> >   +++ b/block/fops.c
> >   @@ -38,8 +38,8 @@ static blk_opf_t dio_bio_write_op(struct kiocb *ioc=
b)
> >    static bool blkdev_dio_invalid(struct block_device *bdev, struct kio=
cb *iocb,
> >                                   struct iov_iter *iter)
> >    {
> >   -        return iocb->ki_pos & (bdev_logical_block_size(bdev) - 1) ||
> >   -                !bdev_iter_is_aligned(bdev, iter);
> >   +        return (iocb->ki_pos | iov_iter_count(iter)) &
> >   +                        (bdev_logical_block_size(bdev) - 1);
> >    }
> >
> > The dropped bdev_iter_is_aligned() used to walk the iov_iter and
> > reject per-segment misaligned/degenerate vectors at the blkdev fops
> > entry point. The replacement only validates ki_pos and total length
> > against the logical block size. Cases that now pass that no longer
> > get rejected:
> >
> >   - iter with iov_iter_count(iter) =3D=3D 0  (degenerate; total length =
is
> >     "sector-aligned" since 0 % 512 =3D=3D 0)
> >   - iter where total length is sector-aligned but a segment isn't
> >
> > The commit message justifies the removal with "The block layer
> > checks all the segments for validity later". This is true for the
> > io_uring submit path (which enters __blkdev_direct_IO directly and
> > does its own validation) but not for the libaio aio_read/write_iter
> > or the worker-pool sync read/write_iter paths that enter via
> > blkdev_{read,write}_iter() -> blkdev_dio_invalid(). For those paths,
> > the segment check has no replacement.
> >
> > Reproducing
> > ----------------------------------------------------------
> >
> > The trigger requires QEMU virtio-blk's specific submission shape AND
> > a non-io_uring submit. Userspace libaio alone, userspace
> > preadv-in-a-thread alone, and QEMU's raw-driver open probes (which
> > qemu-img info exercises identically) are all insufficient. The
> > combination that hits the bug is "guest-driven I/O through
> > virtio-blk-pci with cache.direct=3Don and aio in {native, threads}".
> >
> > #regzbot introduced: 5ff3f74e145adc79b49668adb8de276446acf6be
> >
> > Thanks,
> > Vjaceslavs Klimovs
> >
>
