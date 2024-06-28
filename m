Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE50A1BF326
	for <linux-raid@vger.kernel.org>; Fri, 28 Jun 2024 14:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719584554; cv=none; b=BflwSDwgV/kGppnVkO1xEE2IKAjtB8+IVK7neK2gtcj/4HkLr8VWLAtCvcYVutE5LH9+9zeTGem3KFArtdUcPmSxbAmVhOfP7UEZmxVSS1vjDCCTjCpOkwctrMkoqWbqB7UqykNcq5eszTEusQP6QtuxyxEdNJMjqYOlI3ZZWh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719584554; c=relaxed/simple;
	bh=mn/tP+ea9jyZDlzXvLfJR4ghtoCEVEJX/b95DaxAI74=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=T7cvoPtOZkToxk95Ls/uR1K/hoKdaeCPnPsLgDT89WDNOBpSG8u/Y+bYUoBmPZH7x5h5An+6m33yuh+Gd5im4V+59PGDasBpK7cIBw5T4qLJ+IqydTQujWgM5DYjhZowRNsCAwGLv9VKxCuYXHH+Dq1LKTLYTA9lLByl1ltfwv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BynudozX; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BynudozX"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6ae093e8007so1921496d6.3
        for <linux-raid@vger.kernel.org>; Fri, 28 Jun 2024 07:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719584551; x=1720189351; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ojuERQveqTvadC9APNOWFP8e1uoxy/v/9YADhxBjIUY=;
        b=BynudozX9m5qEJBM9eThkltiAnbf8JxyReDTzZ0LH4z2OKfxh1/PXwhW82/L5dFs0J
         Io/Ew/7mLugeV78rS268I/hcKIxDQbDFEkM+rkbCAJ5Sv4K/UsjK968wIqrnkby7CaMq
         B5dxdu/nBk5D2/9fJYWLGQZbqXOIxWP1c5nBg0V389TJitwbl8Tx81fqZsP84sxj1RhB
         D1qf6aH8Wcc5f4rrScOqfO3iLbPB0C9Oqo7scGZodu5uiVeu7BeYexVMCBwiOgcJqFWM
         Ra+P7HthZ5IJ+fuka0qvz2/gcLuJSfERiqyx0ljxBkGDQyEZsvpDAn1fPirCNbrVQLgF
         dOEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719584551; x=1720189351;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ojuERQveqTvadC9APNOWFP8e1uoxy/v/9YADhxBjIUY=;
        b=iqUvsdXNEn6g2pWnXSjMfI25jKRchCXplZxiPH2cJEXGieImMxoV3ySPCkJ7sDxC43
         HNwaOrTzUiKz7z4A7ginanLKQx9FZ78jf+WqTtJmgdqJCcsqJRacKRo1XAR9hex4wC8Q
         Tirc1Y2u/jFLTy4kw8zCD3/0qw6tVZLytscPzmpfk8GzzYkPma4p3uYZcBUk1Ujbajhk
         SLEaDnKIqid2pyc15Ezi1jOiqdafGTqRwzZaM1CL9CV3jVHL3OfGBU/QwlddtHk4pfMt
         aPGftx4DiF5BEC2zuvR8iDDk7Vm6stooVFy8J1s18httqbHhmtIf+QfWwU62369uJcLH
         z6kA==
X-Gm-Message-State: AOJu0Yx0fazh3vzgmQMHwMD7JSIBxMbASNZqBmFA7SQg9hreXxslhEfg
	0PPFmBVx0rzidS0Zj00CUrYDZJkeLtbt1D8CvJVtNtr+w0K0EQnFwfCz7ZGjOm/h+M2azCU8Hov
	DLtTuTklxrD+gWfmOpsM6gipL/8v8BAFJ
X-Google-Smtp-Source: AGHT+IHTixKB5cURj5zqu4iW2eE/zC/jAIJsX85d7jmUsJp9nZuMwDNBI/5YwTPvF7TohYBUvPASAfqVphKu+7B9SbY=
X-Received: by 2002:ad4:43cb:0:b0:6b2:d6f3:1c1d with SMTP id
 6a1803df08f44-6b58d38e9c1mr63610816d6.11.1719584551177; Fri, 28 Jun 2024
 07:22:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALc6PW4A6Q4q3tU7AMA3MArpiRwkTwXrb__2k2Xwzy3=-XE+7A@mail.gmail.com>
 <CALc6PW7eUNDDT0+iD7b=ZK5PJX0D0XoStubLYmdW3SsbGBLZdA@mail.gmail.com> <CALc6PW6rntE012P-mhYFRAywXFahLnBrj3BUQkDijuvSHKTg5A@mail.gmail.com>
In-Reply-To: <CALc6PW6rntE012P-mhYFRAywXFahLnBrj3BUQkDijuvSHKTg5A@mail.gmail.com>
From: William Morgan <therealbrewer@gmail.com>
Date: Fri, 28 Jun 2024 09:22:20 -0500
Message-ID: <CALc6PW6LRwTx-ZHqg7gFTsuWcyRnQ-Lw_QMO=4uYBNnpZpM=DA@mail.gmail.com>
Subject: Re: reshape seems to have gotten stuck
To: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Well, not hearing any response I had to try something, I rebooted and
the reshape initially picked up again. But after a couple of minutes,
it hung again. This time I got the same dmesg messages about the
reshape, but also a fsck hang and kworker as well. I'm not sure how
kworker is related - maybe someone can provide some insight.

[  246.970484] INFO: task kworker/u32:6:106 blocked for more than 122 secon=
ds.
[  246.970506]       Tainted: G           OE      6.9.3-060903-generic
#202405300957
[  246.970514] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  246.970521] task:kworker/u32:6   state:D stack:0     pid:106
tgid:106   ppid:2      flags:0x00004000
[  246.970536] Workqueue: writeback wb_workfn (flush-9:2)
[  246.970555] Call Trace:
[  246.970561]  <TASK>
[  246.970570]  __schedule+0x279/0x6a0
[  246.970586]  schedule+0x29/0xd0
[  246.970597]  wait_barrier.part.0+0x180/0x1e0 [raid10]
[  246.970624]  ? __pfx_autoremove_wake_function+0x10/0x10
[  246.970647]  wait_barrier+0x70/0xc0 [raid10]
[  246.970667]  regular_request_wait+0x42/0x1d0 [raid10]
[  246.970686]  ? bio_associate_blkg_from_css+0xf8/0x330
[  246.970696]  ? __kmalloc+0x1c0/0x4e0
[  246.970706]  raid10_write_request+0x164/0x5f0 [raid10]
[  246.970725]  ? r10bio_pool_alloc+0x28/0x40 [raid10]
[  246.970743]  ? r10bio_pool_alloc+0x28/0x40 [raid10]
[  246.970763]  raid10_make_request+0xea/0x1a0 [raid10]
[  246.970783]  md_handle_request+0x15d/0x280
[  246.970797]  md_submit_bio+0x63/0xb0
[  246.970807]  __submit_bio+0xe7/0x1c0
[  246.970815]  __submit_bio_noacct+0x91/0x220
[  246.970823]  submit_bio_noacct_nocheck+0x205/0x240
[  246.970832]  submit_bio_noacct+0x162/0x5a0
[  246.970840]  submit_bio+0xb1/0x110
[  246.970847]  submit_bh_wbc+0x15e/0x190
[  246.970855]  __block_write_full_folio+0x1e3/0x420
[  246.970864]  ? __pfx_blkdev_get_block+0x10/0x10
[  246.970873]  ? __pfx_blkdev_get_block+0x10/0x10
[  246.970881]  block_write_full_folio+0x150/0x180
[  246.970887]  ? __pfx_blkdev_get_block+0x10/0x10
[  246.970895]  ? __pfx_blkdev_get_block+0x10/0x10
[  246.970901]  ? __pfx_block_write_full_folio+0x10/0x10
[  246.970907]  write_cache_pages+0x63/0xb0
[  246.970918]  blkdev_writepages+0x57/0x90
[  246.970927]  do_writepages+0x7e/0x270
[  246.970936]  ? update_sd_lb_stats.constprop.0+0x88/0x400
[  246.970946]  __writeback_single_inode+0x44/0x290
[  246.970953]  ? inode_to_bdi+0x3c/0x50
[  246.970961]  writeback_sb_inodes+0x227/0x530
[  246.970977]  __writeback_inodes_wb+0x54/0x100
[  246.970984]  ? queue_io+0x113/0x120
[  246.970991]  wb_writeback+0x28a/0x300
[  246.970999]  wb_do_writeback+0x223/0x2a0
[  246.971008]  wb_workfn+0x4c/0x150
[  246.971015]  process_one_work+0x18d/0x3f0
[  246.971023]  worker_thread+0x304/0x440
[  246.971030]  ? __pfx_worker_thread+0x10/0x10
[  246.971036]  kthread+0xe4/0x110
[  246.971045]  ? __pfx_kthread+0x10/0x10
[  246.971053]  ret_from_fork+0x47/0x70
[  246.971061]  ? __pfx_kthread+0x10/0x10
[  246.971069]  ret_from_fork_asm+0x1a/0x30
[  246.971079]  </TASK>

[  246.971093] INFO: task md2_reshape:263 blocked for more than 122 seconds=
.
[  246.971100]       Tainted: G           OE      6.9.3-060903-generic
#202405300957
[  246.971106] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  246.971110] task:md2_reshape     state:D stack:0     pid:263
tgid:263   ppid:2      flags:0x00004000
[  246.971121] Call Trace:
[  246.971124]  <TASK>
[  246.971128]  __schedule+0x279/0x6a0
[  246.971140]  schedule+0x29/0xd0
[  246.971148]  wait_barrier.part.0+0x180/0x1e0 [raid10]
[  246.971165]  ? __pfx_autoremove_wake_function+0x10/0x10
[  246.971175]  wait_barrier+0x70/0xc0 [raid10]
[  246.971192]  raid10_sync_request+0x177e/0x19e3 [raid10]
[  246.971210]  ? __schedule+0x281/0x6a0
[  246.971221]  md_do_sync+0xa36/0x1390
[  246.971229]  ? __pfx_autoremove_wake_function+0x10/0x10
[  246.971242]  ? __pfx_md_thread+0x10/0x10
[  246.971249]  md_thread+0xa5/0x1a0
[  246.971257]  ? __pfx_md_thread+0x10/0x10
[  246.971263]  kthread+0xe4/0x110
[  246.971271]  ? __pfx_kthread+0x10/0x10
[  246.971279]  ret_from_fork+0x47/0x70
[  246.971286]  ? __pfx_kthread+0x10/0x10
[  246.971294]  ret_from_fork_asm+0x1a/0x30
[  246.971304]  </TASK>

[  246.971310] INFO: task fsck.ext4:800 blocked for more than 122 seconds.
[  246.971365]       Tainted: G           OE      6.9.3-060903-generic
#202405300957
[  246.971372] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  246.971376] task:fsck.ext4       state:D stack:0     pid:800
tgid:800   ppid:790    flags:0x00004002
[  246.971386] Call Trace:
[  246.971389]  <TASK>
[  246.971394]  __schedule+0x279/0x6a0
[  246.971405]  schedule+0x29/0xd0
[  246.971414]  wait_barrier.part.0+0x180/0x1e0 [raid10]
[  246.971431]  ? __pfx_autoremove_wake_function+0x10/0x10
[  246.971441]  wait_barrier+0x70/0xc0 [raid10]
[  246.971459]  regular_request_wait+0x42/0x1d0 [raid10]
[  246.971475]  ? __kmalloc+0x1c0/0x4e0
[  246.971483]  raid10_write_request+0x164/0x5f0 [raid10]
[  246.971500]  ? r10bio_pool_alloc+0x28/0x40 [raid10]
[  246.971515]  ? r10bio_pool_alloc+0x28/0x40 [raid10]
[  246.971533]  raid10_make_request+0xea/0x1a0 [raid10]
[  246.971551]  md_handle_request+0x15d/0x280
[  246.971560]  md_submit_bio+0x63/0xb0
[  246.971568]  __submit_bio+0xe7/0x1c0
[  246.971576]  __submit_bio_noacct+0x91/0x220
[  246.971584]  submit_bio_noacct_nocheck+0x205/0x240
[  246.971594]  submit_bio_noacct+0x162/0x5a0
[  246.971602]  submit_bio+0xb1/0x110
[  246.971609]  submit_bh_wbc+0x15e/0x190
[  246.971617]  __block_write_full_folio+0x1e3/0x420
[  246.971626]  ? __pfx_blkdev_get_block+0x10/0x10
[  246.971634]  ? __pfx_blkdev_get_block+0x10/0x10
[  246.971642]  block_write_full_folio+0x150/0x180
[  246.971648]  ? __pfx_blkdev_get_block+0x10/0x10
[  246.971656]  ? __pfx_blkdev_get_block+0x10/0x10
[  246.971663]  ? __pfx_block_write_full_folio+0x10/0x10
[  246.971669]  write_cache_pages+0x63/0xb0
[  246.971679]  blkdev_writepages+0x57/0x90
[  246.971689]  do_writepages+0x7e/0x270
[  246.971700]  filemap_fdatawrite_wbc+0x75/0xb0
[  246.971707]  __filemap_fdatawrite_range+0x6d/0xa0
[  246.971723]  file_write_and_wait_range+0x5d/0xc0
[  246.971731]  blkdev_fsync+0x39/0x70
[  246.971739]  vfs_fsync_range+0x4b/0xa0
[  246.971748]  ? __pfx_read_tsc+0x10/0x10
[  246.971756]  __x64_sys_fsync+0x3c/0x70
[  246.971765]  x64_sys_call+0x2485/0x25c0
[  246.971773]  do_syscall_64+0x7e/0x180
[  246.971785]  ? tick_program_event+0x43/0xa0
[  246.971798]  ? hrtimer_interrupt+0x121/0x250
[  246.971808]  ? irqentry_exit_to_user_mode+0x76/0x270
[  246.971821]  ? irqentry_exit+0x43/0x50
[  246.971831]  ? sysvec_apic_timer_interrupt+0x57/0xc0
[  246.971842]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  246.971852] RIP: 0033:0x70c85631ede4
[  246.971883] RSP: 002b:00007ffed1aa0258 EFLAGS: 00000202 ORIG_RAX:
000000000000004a
[  246.971893] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000070c8563=
1ede4
[  246.971899] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000=
00003
[  246.971903] RBP: 00007ffed1aa0270 R08: 000059f82e125d80 R09: 00000000000=
00000
[  246.971907] R10: 000059f82e128b74 R11: 0000000000000202 R12: 000059f82e1=
25d80
[  246.971911] R13: 00000000000002c2 R14: 0000000000000000 R15: 000059f82e1=
28780
[  246.971919]  </TASK>

Really could use some help here. I don't have any idea where to look
for logs etc. that may provide some clues.
Thanks,
Bill

On Wed, Jun 26, 2024 at 6:33=E2=80=AFAM William Morgan <therealbrewer@gmail=
.com> wrote:
>
> Is --freeze-reshape of any use here?
>
> Obviously the reshape has crashed, I just want to know what is the
> ideal way to resolve this. I would like to hear your opinions before
> doing anything.
>
> Bill
>
> On Tue, Jun 25, 2024 at 5:18=E2=80=AFPM William Morgan <therealbrewer@gma=
il.com> wrote:
> >
> > Additional info:
> >
> > bill@bill-desk:~$ sudo cat /proc/242508/stack
> > [<0>] wait_barrier.part.0+0x180/0x1e0 [raid10]
> > [<0>] wait_barrier+0x70/0xc0 [raid10]
> > [<0>] raid10_sync_request+0x177e/0x19e3 [raid10]
> > [<0>] md_do_sync+0xa36/0x1390
> > [<0>] md_thread+0xa5/0x1a0
> > [<0>] kthread+0xe4/0x110
> > [<0>] ret_from_fork+0x47/0x70
> > [<0>] ret_from_fork_asm+0x1a/0x30
