Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055854430
	for <linux-raid@vger.kernel.org>; Mon, 27 Jan 2025 12:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737981186; cv=none; b=O4hgqqMALS3EfVIcGM9E3BpvRzWlDYqYU+2Y08mTu8LGwwQ+NBZj7FdeW9ycWP0PZfofTBnW/umRqNYRwmT5m3ejdE96gc7p4AHaQP4uXflGr9FEQSZVfGC14CLbvxiRVQPRk5nwVPu2SHtPllwXPlw4sReuq2p35DyryTfRfaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737981186; c=relaxed/simple;
	bh=ZxSf1CJJi0zD68ArDlZXPuYP5YWOVg3S2ePvfD+Vh1I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ETVAW+Dyyq1CihXWr7A6kcmQ+FcJtge8EezyyHpEdoYn3c2mihNE8dy6aEGRbqEzQpuzumBgiE5FHpJQfJOW3h4nr1QPCqmoBCunKJ70K+JECYLPo+tQOhyYTNLUYFbhOdw/Ddh4hA50suFkvHhxCJ3jgYu0NfeNirr8GwXcGK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bOfB6pXC; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bOfB6pXC"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e3c8ae3a3b2so5791337276.0
        for <linux-raid@vger.kernel.org>; Mon, 27 Jan 2025 04:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737981184; x=1738585984; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SUmiovJRP6i0xl1HCrXpPDrernpzhXqtxfsFPOl3MlE=;
        b=bOfB6pXCL6shCIaMGYiHP/SmbgaGsZhNomvWB/IIvgZgBLXb0mQSZWcT3IHzzx2wVd
         NLrVGIoKTLTMywePIy7hAMnjsNirH57Qgjje4Q34PmD8MykEc8zm8KQ8ZTtaUsj945yq
         V0m/2pWhXGxdD1EMEDkxUowpUhwKIBR+uf1MLTtPmABt7BtL0C4d6yjrjiSsAbT8Vw//
         PpWG0uvNTdVddSpMPooiRwKJMHucJk8n4klcww/pDqU8LawHn8peF4JcnM0h3injd13P
         mQJr2QDZFN+G50Fxnk9mxi1nEOGIt0MCBhRdzqnobv1/T+HJZM/AEhgZiL7uaIvR10ym
         JgSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737981184; x=1738585984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SUmiovJRP6i0xl1HCrXpPDrernpzhXqtxfsFPOl3MlE=;
        b=InnnbDw7QkFc1UEnovILbblS/VtbD/s1cQ545oVk1hbw6hy2PERW8l0QzCJ/NZwVyY
         Wp4hHiY3w//bIsb3qebViN6iiyx5xT9I9fpUpL7Q79rMbziq9w8lCR+hv0oS4tzambJm
         iR8/wiSMtm+2uscYEDe3GW7TlS8lsIytYhB26Moy71QUzvV/LWSqn0/0fbkPbhj1dYp5
         aIrTOxsEJAfWZMHdJYb0kobxyYnpoF43Ot6aDSA+zVP9RRx8LjqVWxc9/sUzy2Umvrho
         UG4lCaOFL0kI9v5u55SrlIP6hhMR9tWuAwxKYUS1UbvZp+uETYxkJX3pUUUeC2+0C8rg
         oAgg==
X-Forwarded-Encrypted: i=1; AJvYcCV3EmDv+fvGNPnfAHCzwKQPUTadzw8RBuIiMkdY7rc99Ten0MGD/v0TCqRf3xG8XfK4uLy6EHzEj4AS@vger.kernel.org
X-Gm-Message-State: AOJu0YwKhJRe7vxylI28vId91TP0Ysb1W9+rzt188dWqsNHlqp8VIQPL
	l345e2qhpViDKbLodf6qjCEg6U122/GIHcWICJwhcaHM9AU7/DaXDIu9TL32aSzN/vjoTdOfb07
	FrNDRzArzvX6icWMIe3C4Eva5EMENHOfy
X-Gm-Gg: ASbGncuzf+2cG5img+qnWGfeHGVxBvy9BxWvDqm/0ACw5PeFjDt0CCvQlSenURisijc
	JWgBsq9IlWLCVI606lLX4NjO7G/0mTSZqqEqJH8v6NVo1aff8lDQt+SmJ12hnx6A=
X-Google-Smtp-Source: AGHT+IHZw/2v3rvBfCcJFJTXdVoDORjy2tAWnkQfpWSVq491zTHCyo4AmSDEC11n8vm0vS/cdazRGKj1eeRT53wwtow=
X-Received: by 2002:a05:6902:1502:b0:e25:ca37:b669 with SMTP id
 3f1490d57ef6-e57b10983ebmr27361437276.24.1737981183823; Mon, 27 Jan 2025
 04:33:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAiJnjqFwETu8ZwE44jdNWk=UYbdoNJr0W7pjkgjkTy0ff8grA@mail.gmail.com>
 <CAPhsuW56KORS78c-buACrq0TWJ+qewwh+QUmC-ePJO3LVVjeyQ@mail.gmail.com>
 <CAAiJnjpTAXz8TyhKD4DmpgYJ21CRJh-bLEOqZUitWYONumggAw@mail.gmail.com> <CAPhsuW7gjyCRdHp3cRFgNxMO2kXAjMOYgW+ekqBMX18d4657Yg@mail.gmail.com>
In-Reply-To: <CAPhsuW7gjyCRdHp3cRFgNxMO2kXAjMOYgW+ekqBMX18d4657Yg@mail.gmail.com>
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Mon, 27 Jan 2025 14:32:52 +0200
X-Gm-Features: AWEUYZnH9-geMPIAujPr1ojcVdfcCjPtEQi5B9ylqPUk7cPJN9KBIIMcrHXdwTs
Message-ID: <CAAiJnjqLLK5PY84q6Ni_uZYQXwxDcQCum2-_=FAkkxOmh-VCPg@mail.gmail.com>
Subject: Re: Huge lock contention during raid5 build time
To: Song Liu <song@kernel.org>
Cc: Shushu Yi <firnyee@gmail.com>, yukuai3@huawei.com, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Yes, group_thread_cnt sometimes (usually?) causes more lock
> contention and lower performance.

[root@memverge2 anton]# /home/anton/mdadm/mdadm --version
mdadm - v4.4-15-g21e4efb1 - 2025-01-27

/home/anton/mdadm/mdadm --create --verbose /dev/md0 --level=3D5
--raid-devices=3D4 /dev/nvme0n1 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1

Without group_thread_cnt (with sync_speed_max=3D3600000 only) it is not
1.4 GB/s, 1 GB/s

[root@memverge2 anton]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 nvme4n1[4] nvme3n1[2] nvme2n1[1] nvme0n1[0]
      4688044032 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [U=
UU_]
      [>....................]  recovery =3D  3.2% (50134272/1562681344)
finish=3D24.5min speed=3D1027434K/sec
      bitmap: 0/12 pages [0KB], 65536KB chunk

> Could you please run perf-report on the perf.data? I won't be
> able to see all the symbols without your kernel.

[root@memverge2 anton]# perf record -g
^C[ perf record: Woken up 36 times to write data ]
[ perf record: Captured and wrote 9.632 MB perf.data (61989 samples) ]

[root@memverge2 anton]# perf report

Samples: 61K of event 'cycles:P', Event count (approx.): 61959249145
  Children      Self  Command          Shared Object
          Symbol
+   79.59%     0.00%  md0_raid5        [kernel.kallsyms]
          [k] ret_from_fork_asm
+   79.59%     0.00%  md0_raid5        [kernel.kallsyms]
          [k] ret_from_fork
+   79.59%     0.00%  md0_raid5        [kernel.kallsyms]
          [k] kthread
+   79.59%     0.00%  md0_raid5        [kernel.kallsyms]
          [k] md_thread
+   79.59%     0.06%  md0_raid5        [kernel.kallsyms]
          [k] raid5d
+   74.47%     0.67%  md0_raid5        [kernel.kallsyms]
          [k] handle_active_stripes.isra
+   68.27%     4.84%  md0_raid5        [kernel.kallsyms]
          [k] handle_stripe
+   27.47%     0.11%  md0_raid5        [kernel.kallsyms]
          [k] raid_run_ops
+   27.36%     0.25%  md0_raid5        [kernel.kallsyms]
          [k] ops_run_compute5
+   27.10%     0.07%  md0_raid5        [kernel.kallsyms]
          [k] async_xor_offs
+   26.42%     0.16%  md0_raid5        [kernel.kallsyms]
          [k] do_sync_xor_offs
+   21.94%     7.87%  md0_raid5        [kernel.kallsyms]
          [k] ops_run_io
+   19.34%    18.19%  md0_raid5        [kernel.kallsyms]
          [k] xor_avx_4
+   13.35%     0.00%  md0_resync       [kernel.kallsyms]
          [k] ret_from_fork_asm
+   13.35%     0.00%  md0_resync       [kernel.kallsyms]
          [k] ret_from_fork
+   13.35%     0.00%  md0_resync       [kernel.kallsyms]
          [k] kthread
+   13.35%     0.00%  md0_resync       [kernel.kallsyms]
          [k] md_thread
+   13.35%     0.55%  md0_resync       [kernel.kallsyms]
          [k] md_do_sync.cold
+   12.41%     0.69%  md0_resync       [kernel.kallsyms]
          [k] raid5_sync_request
+   12.18%     0.35%  md0_raid5        [kernel.kallsyms]
          [k] submit_bio_noacct_nocheck
+   11.67%     0.54%  md0_raid5        [kernel.kallsyms]
          [k] __submit_bio
+   11.06%     0.79%  md0_raid5        [kernel.kallsyms]
          [k] blk_mq_submit_bio
+   10.76%     9.83%  md0_raid5        [kernel.kallsyms]
          [k] analyse_stripe
+   10.46%     0.29%  md0_resync       [kernel.kallsyms]
          [k] raid5_get_active_stripe
+    6.84%     6.49%  md0_raid5        [kernel.kallsyms]
          [k] memset_orig
+    6.59%     0.00%  swapper          [kernel.kallsyms]
          [k] common_startup_64
+    6.59%     0.01%  swapper          [kernel.kallsyms]
          [k] cpu_startup_entry
+    6.58%     0.03%  swapper          [kernel.kallsyms]
          [k] do_idle
+    6.44%     0.00%  swapper          [kernel.kallsyms]
          [k] start_secondary          =E2=96=92
+    5.55%     0.01%  md0_raid5        [kernel.kallsyms]
          [k] asm_common_interrupt     =E2=96=92
+    5.53%     0.01%  md0_raid5        [kernel.kallsyms]
          [k] common_interrupt         =E2=96=92
+    5.45%     0.01%  md0_raid5        [kernel.kallsyms]
          [k] blk_add_rq_to_plug       =E2=96=92
+    5.44%     0.02%  swapper          [kernel.kallsyms]
          [k] cpuidle_idle_call        =E2=96=92
+    5.44%     0.01%  md0_raid5        [kernel.kallsyms]
          [k] blk_mq_flush_plug_list   =E2=96=92
+    5.43%     0.17%  md0_raid5        [kernel.kallsyms]
          [k] blk_mq_dispatch_plug_list=E2=96=92
+    5.41%     0.01%  md0_raid5        [kernel.kallsyms]
          [k] __common_interrupt       =E2=96=92
+    5.40%     0.03%  md0_raid5        [kernel.kallsyms]
          [k] handle_edge_irq          =E2=96=92
+    5.32%     0.01%  md0_raid5        [kernel.kallsyms]
          [k] handle_irq_event         =E2=96=92
+    5.25%     0.01%  md0_raid5        [kernel.kallsyms]
          [k] __handle_irq_event_percpu=E2=96=92
+    5.25%     0.01%  md0_raid5        [kernel.kallsyms]
          [k] nvme_irq                 =E2=96=92
+    5.18%     0.14%  md0_raid5        [kernel.kallsyms]
          [k] blk_mq_insert_requests   =E2=96=92
+    5.15%     0.00%  swapper          [kernel.kallsyms]
          [k] cpuidle_enter            =E2=96=92
+    5.15%     0.03%  swapper          [kernel.kallsyms]
          [k] cpuidle_enter_state      =E2=96=92
+    5.05%     1.29%  md0_raid5        [kernel.kallsyms]
          [k] release_stripe_list      =E2=96=92
+    5.00%     0.01%  md0_raid5        [kernel.kallsyms]
          [k] blk_mq_try_issue_list_dir=E2=96=92
+    4.98%     0.00%  md0_raid5        [kernel.kallsyms]
          [k] __blk_mq_issue_directly  =E2=96=92
+    4.97%     0.03%  md0_raid5        [kernel.kallsyms]
          [k] nvme_queue_rq            =E2=96=92
+    4.86%     1.03%  md0_resync       [kernel.kallsyms]
          [k] init_stripe              =E2=96=92
+    4.80%     0.07%  md0_raid5        [kernel.kallsyms]
          [k] nvme_prep_rq.part.0      =E2=96=92
+    4.57%     0.03%  md0_raid5        [kernel.kallsyms]
          [k] nvme_map_data
+    4.17%     0.17%  md0_raid5        [kernel.kallsyms]
          [k] blk_mq_end_request_batch =E2=96=92
+    3.52%     3.49%  swapper          [kernel.kallsyms]
          [k] poll_idle                =E2=96=92
+    3.51%     1.67%  md0_resync       [kernel.kallsyms]
          [k] raid5_compute_blocknr    =E2=96=92
+    3.21%     0.47%  md0_raid5        [kernel.kallsyms]
          [k] blk_attempt_plug_merge   =E2=96=92
+    3.13%     3.13%  md0_resync       [kernel.kallsyms]
          [k] find_get_stripe          =E2=96=92
+    3.01%     0.01%  md0_raid5        [kernel.kallsyms]
          [k] __dma_map_sg_attrs       =E2=96=92
+    3.01%     0.00%  md0_raid5        [kernel.kallsyms]
          [k] dma_map_sgtable          =E2=96=92
+    3.00%     2.37%  md0_raid5        [kernel.kallsyms]
          [k] dma_direct_map_sg        =E2=96=92
+    2.59%     2.13%  md0_raid5        [kernel.kallsyms]
          [k] do_release_stripe        =E2=96=92
+    2.45%     1.45%  md0_raid5        [kernel.kallsyms]
          [k] __get_priority_stripe    =E2=96=92
+    2.15%     2.14%  md0_resync       [kernel.kallsyms]
          [k] raid5_compute_sector     =E2=96=92
+    2.14%     0.35%  md0_raid5        [kernel.kallsyms]
          [k] bio_attempt_back_merge   =E2=96=92
+    1.99%     1.93%  md0_raid5        [kernel.kallsyms]
          [k] raid5_end_read_request   =E2=96=92
+    1.38%     1.00%  md0_raid5        [kernel.kallsyms]
          [k] fetch_block              =E2=96=92
+    1.35%     0.14%  md0_raid5        [kernel.kallsyms]
          [k] release_inactive_stripe_l=E2=96=92
+    1.35%     0.40%  md0_raid5        [kernel.kallsyms]
          [k] ll_back_merge_fn         =E2=96=92
+    1.27%     1.25%  md0_resync       [kernel.kallsyms]
          [k] _raw_spin_lock_irq       =E2=96=92
+    1.11%     1.11%  md0_raid5        [kernel.kallsyms]
          [k] llist_reverse_order      =E2=96=92
+    1.10%     0.70%  md0_raid5        [kernel.kallsyms]
          [k] raid5_release_stripe     =E2=96=92
+    1.05%     1.00%  md0_raid5        [kernel.kallsyms]
          [k] md_wakeup_thread         =E2=96=92
+    1.02%     0.97%  swapper          [kernel.kallsyms]
          [k] intel_idle_irq           =E2=96=92
+    0.99%     0.01%  md0_raid5        [kernel.kallsyms]
          [k] __blk_rq_map_sg          =E2=96=92
+    0.97%     0.84%  md0_raid5        [kernel.kallsyms]
          [k] __blk_bios_map_sg        =E2=96=92
+    0.91%     0.04%  md0_raid5        [kernel.kallsyms]
          [k] __wake_up                =E2=96=92
+    0.84%     0.74%  md0_raid5        [kernel.kallsyms]
          [k] _raw_spin_lock_irqsave

Anton

=D0=BF=D1=82, 24 =D1=8F=D0=BD=D0=B2. 2025=E2=80=AF=D0=B3. =D0=B2 23:48, Son=
g Liu <song@kernel.org>:
>
> On Fri, Jan 24, 2025 at 12:00=E2=80=AFAM Anton Gavriliuk <antosha20xx@gma=
il.com> wrote:
> >
> > > We need major work to make it faster so that we can keep up with
> > > the speed of modern SSDs.
> >
> > Glad to know that this in your roadmap.
> > This is very important for storage server solutions, when you can add
> > ten's NVMe SSDs Gen 4/5 in 2U server.
> > I'm not a developer, but I can assist you in the testing as much as req=
uired.
> >
> > > Could you please do a perf-record with '-g' so that we can see
> > > which call paths hit the lock contention? This will help us
> > > understand whether Shushu's bitmap optimization can help.
> >
> > default raid5 build performance
> >
> > [root@memverge2 ~]# cat /proc/mdstat
> > Personalities : [raid6] [raid5] [raid4]
> > md0 : active raid5 nvme0n1[4] nvme2n1[2] nvme3n1[1] nvme4n1[0]
> >       4688044032 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3=
] [UUU_]
> >       [>....................]  recovery =3D  0.3% (5601408/1562681344)
> > finish=3D125.0min speed=3D207459K/sec
> >       bitmap: 0/12 pages [0KB], 65536KB chunk
> >
> > after set
> >
> > [root@memverge2 md]# echo 8 > group_thread_cnt
>
> Yes, group_thread_cnt sometimes (usually?) causes more lock
> contention and lower performance.
>
> > [root@memverge2 md]# echo 3600000 > sync_speed_max
> >
> > [root@memverge2 ~]# cat /proc/mdstat
> > Personalities : [raid6] [raid5] [raid4]
> > md0 : active raid5 nvme0n1[4] nvme2n1[2] nvme3n1[1] nvme4n1[0]
> >       4688044032 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3=
] [UUU_]
> >       [=3D>...................]  recovery =3D  7.9% (124671408/15626813=
44)
> > finish=3D16.6min speed=3D1435737K/sec
> >       bitmap: 0/12 pages [0KB], 65536KB chunk
> >
> > perf.data.gz attached.
>
> Could you please run perf-report on the perf.data? I won't be
> able to see all the symbols without your kernel.
>
> Thanks,
> Song
