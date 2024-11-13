Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277F516DEA2
	for <linux-raid@vger.kernel.org>; Wed, 13 Nov 2024 16:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731516621; cv=none; b=NO3sMnq10JfoLwPal78ybAYQTU5/aA9OjuFD2emWuRJiTMCoHUshLy+7TkhO8rKXsnvoY7H9Q2zDYLEmPEoCWfDCH8zDbEU/MCRrMpl3X5yxdHr5TQ6W1UMohv2fyY3c7VwIHXJC+dXA1gDDh36sODKJTwV3FVznGu5rNrG7XE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731516621; c=relaxed/simple;
	bh=C///lFVkk/Q3qpy9nO44N1Vvo0pf4nYCfky5/yF/Ce8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m+xm4ROj9SrS+Wvr2Qk0EEKQMmclt4s5cpnb3oATDOI0mCQs5kFa6vYFRsrW5xttoTM23tE5E3iDOtIOEnO39RC8ec09jXxCVA7X/P/WtMh1TSC+YQbc9He/0XVcqXvg/ICS9BejgyzwvLgJqpW6dQYtBh+uI5hhH8HY1nriW18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=NrtSvvPQ; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="NrtSvvPQ"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2fb51e00c05so86389811fa.0
        for <linux-raid@vger.kernel.org>; Wed, 13 Nov 2024 08:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1731516616; x=1732121416; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mi2BCr9/A8K3BTAhrmsn6D9xzZNB/RRmerdFs1hNrd0=;
        b=NrtSvvPQ9ADRyT4Q6113OdpSYq+JBxqqR2b/GinHtP8z9LJL2ECBBJbj12z0HtFqzz
         KtUjYq1lDxXNXVv5Y18/T2FlApE7T7PPLmGzmyRsI3/kMmRRMaMw0H7a3ip1NM+EFsMH
         3qJBZoIblT/dv/TlrKCp2JuAHEWFkj4Hv1CiU4R/oHDYapV12xW23tng5u27P706pDAb
         6Y/IJywRJZgtDn7Z5d6C1HBDsGLecamXOzF44k/p+lzzipq280T4Fu1c3pYJtBYM9KI4
         uebyQoLk0ZkpZ/pPJP9rwvBHJfwP5p4FS6ySmNVbJvfP3XK0kDV8Eh4yICwq9j5ySvp0
         bdKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731516616; x=1732121416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mi2BCr9/A8K3BTAhrmsn6D9xzZNB/RRmerdFs1hNrd0=;
        b=D59RIvPGB51dYalQTLk21yH5EfdZ7zjDHFj5IBQ3hqVFMLvnQFcvOR+wKFZZ2gax4y
         /HhTuCQScYh/K35VH4vDmIW5T96P6uPgoYxVVE5z+ga66alUyq8kXgKCmqkcaOPEdzKC
         56wOX+CSVnVQ6NpvsCUk/TtUMQphT7+cU3E1d77qBLySBCSs+/P+7GuYl3Hik4314Sey
         jCw35Eh6EsaUu0nLwMT/w5CdiiV0S4i3BXri5Y0KN3zlvCKsSqsIX4y/C8a9HA7X74Fs
         5JF4Ixq7wvCyQncxWk2z82O+e/IwYrKNc2Nq22NMj+WLn+RdSxjGGXCW2DP7HJr0/H4A
         HXmw==
X-Forwarded-Encrypted: i=1; AJvYcCVX9E6yOnj+F6UJIcGukUsj5KasRzR5Y/YdXCQhBMfHsq/FuNv6+zKMwRqMi/UMEKMRNKNPgPp3ukFF@vger.kernel.org
X-Gm-Message-State: AOJu0YzNysnB4BMAFKqrg5rx8C5AJRRVbxi+JvRO7P7Tl4ImL3xg9cbw
	bETViet29xgg6GoN6Tp/IahfZTEgaLNob7eIWj15WuOGSXzuyFdN5Te16O/DrL+sZhO2WvI6sbh
	0qecnsH5/1oddu7owAbHUUhsgjC3cRBrJmWLBXw==
X-Google-Smtp-Source: AGHT+IFAftyDVn04KAL4fFPSHpXnI6/Pqq6wkzcJlE9lI2N+LC2m6WNX9m3w59ZnDx+X7LNMwUtLW6NTq7HSlRiV+28=
X-Received: by 2002:a05:651c:158d:b0:2fb:3df8:6a8c with SMTP id
 38308e7fff4ca-2ff20207a10mr146732011fa.23.1731516616222; Wed, 13 Nov 2024
 08:50:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com>
 <CALtW_ahYbP71XPM=ZGoqyBd14wVAtUyGGgXK0gxk52KjJZUk4A@mail.gmail.com>
 <CAJpMwyjG61FjozvbG1oSej2ytRxnRpj3ga=V7zTLrjXKeDYZ_Q@mail.gmail.com>
 <4a914bc9-0d4e-e7c8-bed8-7b781f585587@huaweicloud.com> <CALTww297-iYB1m2Y0_ceHn1Y43nB-RZdw67QSm6zWZ3hGEtkig@mail.gmail.com>
 <CAJpMwyiR3B0ismDXXyqS-HSzyiiVDj7YYE85m91oDvB9apnB6g@mail.gmail.com>
 <8f7173c6-8847-129c-c5ed-27eb3b8a8458@huaweicloud.com> <CAJpMwyjPcLQ=HF5EOXgQFOy=bGHLDWZQJ5CwUV0UHMnyeSPM_g@mail.gmail.com>
 <CALTww2-ijsnnJhkm6pB4VMRfkhGkFWiPwN8gXtZS19oBBvfB4Q@mail.gmail.com>
 <CAJpMwyhdguSzss9emc5zO0eX9eX5Ex_gzU=WPu6kOzVKWArNqQ@mail.gmail.com> <CALTww29aTQ6HT8LU-caxZeNy5zH5zwB6rK_znrMkwFLK0YXSKw@mail.gmail.com>
In-Reply-To: <CALTww29aTQ6HT8LU-caxZeNy5zH5zwB6rK_znrMkwFLK0YXSKw@mail.gmail.com>
From: Haris Iqbal <haris.iqbal@ionos.com>
Date: Wed, 13 Nov 2024 17:50:04 +0100
Message-ID: <CAJpMwygbv8wMZ7px_BVW_MpZeUzqA+jzK_B0x5oq_AbgKMxCpg@mail.gmail.com>
Subject: Re: Experiencing md raid5 hang and CPU lockup on kernel v6.11
To: Xiao Ni <xni@redhat.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>, 
	linux-raid@vger.kernel.org, Jinpu Wang <jinpu.wang@ionos.com>, 
	=?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>, 
	"yangerkun@huawei.com" <yangerkun@huawei.com>, David Jeffery <djeffery@redhat.com>, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 13, 2024 at 7:01=E2=80=AFAM Xiao Ni <xni@redhat.com> wrote:
>
> On Tue, Nov 12, 2024 at 5:46=E2=80=AFPM Haris Iqbal <haris.iqbal@ionos.co=
m> wrote:
> >
> > On Tue, Nov 12, 2024 at 3:04=E2=80=AFAM Xiao Ni <xni@redhat.com> wrote:
> > >
> > > On Mon, Nov 11, 2024 at 9:56=E2=80=AFPM Haris Iqbal <haris.iqbal@iono=
s.com> wrote:
> > > >
> > > > On Mon, Nov 11, 2024 at 2:39=E2=80=AFPM Yu Kuai <yukuai1@huaweiclou=
d.com> wrote:
> > > > >
> > > > > Hi,
> > > > >
> > > > > =E5=9C=A8 2024/11/11 21:29, Haris Iqbal =E5=86=99=E9=81=93:
> > > > > > Hello,
> > > > > >
> > > > > > I gave both the patches a try, and here are my findings.
> > > > > >
> > > > >
> > > > > Thanks for the test!
> > > > >
> > > > > > With the first patch by Yu, I did not see any hang or errors. I=
 tried
> > > > > > a number of bitmap chunk sizes, and ran fio for few hours, and =
there
> > > > > > was no hang.
> > > > >
> > > > > This is good news! However, there is still a long road for my app=
roch
> > > > > to land, this requires a lot of other changes to work.
> > > > > >
> > > > > > With the second patch Xiao, I hit the following BUG_ON on the f=
irst
> > > > > > minute of my fio run.
> > >
> > > Hi Haris
> > >
> > > What's the fio command do you use? I did some simple io and couldn't
> > > trigger this.
> >
> > I use the following fio config,
> >
> > [global]
> > description=3DEmulation of Storage Server Access Pattern
> > bssplit=3D512/20:1k/16:2k/9:4k/12:8k/19:16k/10:32k/8:64k/4
> > fadvise_hint=3D0
> > rw=3Drandrw:2
> > direct=3D1
> > random_distribution=3Dzipf:1.2
> > time_based=3D1
> > runtime=3D600
> > ramp_time=3D1
> > ioengine=3Dlibaio
> > iodepth=3D128
> > iodepth_batch_submit=3D128
> > iodepth_batch_complete_min=3D1
> > iodepth_batch_complete_max=3D128
> > numjobs=3D10
> > group_reporting
> >
> > [job1]
> > filename=3D/dev/rnbd0
> > do_verify=3D1
>
> I tried this pattern against the raid5 array directly with 6.11.0 and
> it can run successfully.

In my setup, I am running this over an RDMA block device.
The RDMA mapping is through the RNBD/RTRS kernel module, in which RTRS
provides the RDMA transport, and RNBD creates the virtual block device
layer on the client side.
The md400 device is mapped through RNBD/RTRS and on the client side
the above fio profile is ran on the /dev/rnbd0

$ cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md400 : active raid0 md300[0] md302[2] md301[1]
      19688371968 blocks super 1.2 128k chunks

md302 : active raid5 sds[0] sdz[7] sdy[6] sdx[5] sdw[4] sdv[3] sdu[2] sdt[1=
]
      6562922800 blocks super 1.2 level 5, 16k chunk, algorithm 2
[8/8] [UUUUUUUU]
      bitmap: 0/1 pages [0KB], 524288KB chunk

md301 : active raid5 sdk[0] sdr[7] sdq[6] sdp[5] sdo[4] sdn[3] sdm[2] sdl[1=
]
      6562922800 blocks super 1.2 level 5, 16k chunk, algorithm 2
[8/8] [UUUUUUUU]
      bitmap: 0/1 pages [0KB], 524288KB chunk

md300 : active raid5 sda[0] sdh[7] sdg[6] sdf[5] sde[4] sdd[3] sdc[2] sdb[1=
]
      6562922800 blocks super 1.2 level 5, 16k chunk, algorithm 2
[8/8] [UUUUUUUU]
      bitmap: 0/1 pages [0KB], 524288KB chunk

>
> Regards
> Xiao
>
>
>
> >
> >
> > >
> > > Regards
> > > Xiao
> > > > > This is sad. :(
> > > > > >
> > > > > > [  113.902982] Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
> > > > > > [  113.903315] CPU: 38 UID: 0 PID: 9767 Comm: kworker/38:3H Kdu=
mp:
> > > > > > loaded Not tainted 6.11.5-storage
> > > > > > #6.11.5-1+feature+v6.11+20241111.0643+cbe84cc3~deb12
> > > > > > [  113.904120] Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.=
3 03/03/2021
> > > > > > [  113.904519] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> > > > > > [  113.904888] RIP: 0010:__add_stripe_bio+0x23f/0x250 [raid456]
> > > > >
> > > > > Can you provide the addr2line of this?
> > > > >
> > > > > gdb raid456.ko
> > > > > list *(__add_stripe_bio+0x23f)
> > > >
> > > > Sorry. I missed the first line while copying.
> > > >
> > > > [  113.902680] kernel BUG at drivers/md/raid5.c:3525!
> > > > [  113.902982] Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
> > > > [  113.903315] CPU: 38 UID: 0 PID: 9767 Comm: kworker/38:3H Kdump:
> > > > loaded Not tainted 6.11.5-storage
> > > > #6.11.5-1+feature+v6.11+20241111.0643+cbe84cc3~deb12
> > > > [  113.904120] Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.3 03=
/03/2021
> > > > [  113.904519] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> > > > [  113.904888] RIP: 0010:__add_stripe_bio+0x23f/0x250 [raid456]
> > > > [  113.905232] Code: 29 ff ff ff 41 8b 84 24 80 01 00 00 83 c0 01 8=
9
> > > > 45 54 f0 80 4d 49 02 e9 11 ff ff ff 45 85 c0 0f 84 4e fe ff ff e9 3=
1
> > > > ff ff ff <0f
> > > > [  113.906352] RSP: 0018:ffffb5d30ed27aa0 EFLAGS: 00010006
> > > > [  113.906661] RAX: ffff992cb9549818 RBX: 0000000000000000 RCX: 000=
0000000000001
> > > > [  113.907086] RDX: ffff992c989c3158 RSI: ffff992c989c3a58 RDI: 000=
0000000000000
> > > > [  113.907511] RBP: ffff991d19e923a0 R08: 0000000000000000 R09: 000=
0000000000160
> > > > [  113.907936] R10: 0000000000000007 R11: ffffb5d30ed27b70 R12: fff=
f991d0854b800
> > > > [  113.908361] R13: 0000000000000001 R14: ffff991d19e92718 R15: 000=
0000000000001
> > > > [  113.908786] FS:  0000000000000000(0000) GS:ffff993c3fc80000(0000=
)
> > > > knlGS:0000000000000000
> > > > [  113.909267] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > [  113.909609] CR2: 00007f21b85473d8 CR3: 000000145d82c001 CR4: 000=
00000001706f0
> > > > [  113.910034] Call Trace:
> > > > [  113.910181]  <TASK
> > > > [  113.910304]  ? die+0x36/0x90
> > > > [  113.910478]  ? do_trap+0xdd/0x100
> > > > [  113.910675]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > > > [  113.910979]  ? do_error_trap+0x65/0x80
> > > > [  113.911200]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > > > [  113.911503]  ? exc_invalid_op+0x50/0x70
> > > > [  113.911731]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > > > [  113.912033]  ? asm_exc_invalid_op+0x1a/0x20
> > > > [  113.912283]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > > > [  113.912586]  raid5_make_request+0x35f/0x1210 [raid456]
> > > > [  113.912896]  ? submit_bio_noacct+0x47/0x4c0
> > > > [  113.913145]  ? __pfx_woken_wake_function+0x10/0x10
> > > > [  113.913430]  ? bio_split_rw+0x143/0x290
> > > > [  113.913659]  md_handle_request+0x156/0x270
> > > > [  113.913905]  __submit_bio+0x15c/0x1f0
> > > > [  113.914126]  submit_bio_noacct_nocheck+0x19a/0x3c0
> > > > [  113.914412]  ? submit_bio_noacct+0x47/0x4c0
> > > > [  113.914662]  rnbd_srv_rdma_ev+0x501/0xf70 [rnbd_server]
> > > > [  113.914976]  ? rtrs_post_recv_empty+0x5d/0x80 [rtrs_core]
> > > > [  113.930375]  process_io_req+0x169/0x4e0 [rtrs_server]
> > > > [  113.945660]  __ib_process_cq+0x7b/0x170 [ib_core]
> > > >
> > > > >
> > > > > Thanks,
> > > > > Kuai
> > > > > > [  113.905232] Code: 29 ff ff ff 41 8b 84 24 80 01 00 00 83 c0 =
01 89
> > > > > > 45 54 f0 80 4d 49 02 e9 11 ff ff ff 45 85 c0 0f 84 4e fe ff ff =
e9 31
> > > > > > ff ff ff <0f
> > > > > > [  113.906352] RSP: 0018:ffffb5d30ed27aa0 EFLAGS: 00010006
> > > > > > [  113.906661] RAX: ffff992cb9549818 RBX: 0000000000000000 RCX:=
 0000000000000001
> > > > > > [  113.907086] RDX: ffff992c989c3158 RSI: ffff992c989c3a58 RDI:=
 0000000000000000
> > > > > > [  113.907511] RBP: ffff991d19e923a0 R08: 0000000000000000 R09:=
 0000000000000160
> > > > > > [  113.907936] R10: 0000000000000007 R11: ffffb5d30ed27b70 R12:=
 ffff991d0854b800
> > > > > > [  113.908361] R13: 0000000000000001 R14: ffff991d19e92718 R15:=
 0000000000000001
> > > > > > [  113.908786] FS:  0000000000000000(0000) GS:ffff993c3fc80000(=
0000)
> > > > > > knlGS:0000000000000000
> > > > > > [  113.909267] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
> > > > > > [  113.909609] CR2: 00007f21b85473d8 CR3: 000000145d82c001 CR4:=
 00000000001706f0
> > > > > > [  113.910034] Call Trace:
> > > > > > [  113.910181]  <TASK
> > > > > > [  113.910304]  ? die+0x36/0x90
> > > > > > [  113.910478]  ? do_trap+0xdd/0x100
> > > > > > [  113.910675]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > > > > > [  113.910979]  ? do_error_trap+0x65/0x80
> > > > > > [  113.911200]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > > > > > [  113.911503]  ? exc_invalid_op+0x50/0x70
> > > > > > [  113.911731]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > > > > > [  113.912033]  ? asm_exc_invalid_op+0x1a/0x20
> > > > > > [  113.912283]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > > > > > [  113.912586]  raid5_make_request+0x35f/0x1210 [raid456]
> > > > > > [  113.912896]  ? submit_bio_noacct+0x47/0x4c0
> > > > > > [  113.913145]  ? __pfx_woken_wake_function+0x10/0x10
> > > > > > [  113.913430]  ? bio_split_rw+0x143/0x290
> > > > > > [  113.913659]  md_handle_request+0x156/0x270
> > > > > > [  113.913905]  __submit_bio+0x15c/0x1f0
> > > > > > [  113.914126]  submit_bio_noacct_nocheck+0x19a/0x3c0
> > > > > > [  113.914412]  ? submit_bio_noacct+0x47/0x4c0
> > > > > > [  113.914662]  rnbd_srv_rdma_ev+0x501/0xf70 [rnbd_server]
> > > > > > [  113.914976]  ? rtrs_post_recv_empty+0x5d/0x80 [rtrs_core]
> > > > > > [  113.930375]  process_io_req+0x169/0x4e0 [rtrs_server]
> > > > > > [  113.945660]  __ib_process_cq+0x7b/0x170 [ib_core]
> > > > >
> > > >
> > >
> >
>
