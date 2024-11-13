Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864BF14AD20
	for <linux-raid@vger.kernel.org>; Wed, 13 Nov 2024 16:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731516419; cv=none; b=XKwGu5ox8ZPmUuBnh8KKHd5QmcGLqzkvmqwwZ3wSAT9I8azLtj0z7AgiP3PiMu59IgycB1qVuqOhSjzaBN+NL6ICxoZOIsCbRM3Cb+IkJJFVq2nzZvIwdGlzklvDdcZ+L1+l0ZrK/UWs1a+KlaBS+xzs4/jUjrnLWFel8w5v48U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731516419; c=relaxed/simple;
	bh=4b0sdhze+R7dKPXpaNEVhG5Lw4GYTMV4pSxvhPyH08s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VLxmKa7Em1LmgN85+4JBm0q6t9Ljf6Z6t+t9KE3ul3fAzQuwZ8lGuyz/t9j7ZHEo+n2k+nzJHAPXEBFirOsYm+7fxIA69DhVxBO+Ht4lZvqRHa3YLA8qZH7yJ3jKHfESqHZz9Nnny7pp4/ljbvH6h/AUvr4qBxTbsChAF7VsWwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=QHloXUGW; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="QHloXUGW"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2ff3232ee75so39168191fa.0
        for <linux-raid@vger.kernel.org>; Wed, 13 Nov 2024 08:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1731516414; x=1732121214; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z9nf2d3fzKr2217wG5pxIa4QjAF73l+SsGsnhtvBgxg=;
        b=QHloXUGWxsqosTKnuGbDiWX3EECZX52x/gO7Z0zgFB54UBAaT/pYoCXQz+9vS+REKq
         Hl15OncQWlvO7enMI+VeZbzWIFbZUofzE1KoHjR2h8z7CMXatRccV9GJ9T0SeuVSfed/
         IIgV9J/d+XR9pqsIHjQnAzLELOHO1yWcgWc0U0bTjOaEklKVZD8F54AdBjSp2ZxsxwWb
         In+0MRsoOghe8UzPYv+Q8rrt6xubKEx8Zi8owTfsWAx98BpnTHydq78Gi3q+nw5fo+go
         hWMekcJ//kUrcBiyw+dAMdBWtrURCsRyoZ3NHck4qFa9Uy5LcDJYsspNGI0q4M/dKgZ7
         lXdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731516414; x=1732121214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z9nf2d3fzKr2217wG5pxIa4QjAF73l+SsGsnhtvBgxg=;
        b=GD68PxICxtrt7nI5YHMl4HuAqTxd8vzudZOaqQ9cJKl4FPUQhJTOV5edr8qmskFJqq
         7WXkNL9IFv5Xvh8Ib1VQTUOiPmL1peqRMC+7Bp9Hdh914WzBYLkuMye3rWv4Pv7tx+H9
         iasdaEZzmeq9rIsf011kRJsimm5GQ33FKvF/vTMVE/zVxxlvYgBcWJScwt0KQi+9y9Yp
         VKOhpIEDA3y38cax2CI/bw1OVvHlMJFYq9eAK5KIAoOvbx6EezZ193W4S9krIYgoJGzv
         47jUmJkwMxvhwenm5WWpOxK1YaJSYquKiIkGgXkcOTvnxdkvFTj0VbbOmiKjAWcmwZYI
         1f3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXOxKYsPSt01OeF9r6nTumD33HpKxH9m/h/BZSW7Tff7vz5OUH6CYgH8fieBwX8IRfDI76bZSr0E7cO@vger.kernel.org
X-Gm-Message-State: AOJu0YyOxt7yIZQ3PSdXxWr1iSn4UMsa0aaH5jTnJDvC3WUh40nuPzcy
	EWVdAw6Vd37J6otzIvF8oqvcx47OaPP7MtJgSoP6npl/UWb5KU+9THRjoCDNV2DrzlkZzH41lcL
	IHo7YshPl2cWHog8+PHtLX4b2EvX9uh88rn+l6Q==
X-Google-Smtp-Source: AGHT+IGkxnR2I2N6KRV2p3RPacqq4Q2lVDNiZQp5jzjyrqGR6726HfFPmn5eenRUGzZeTSrr+tD0pQMBWV0XF59LMfo=
X-Received: by 2002:a05:651c:88e:b0:2fb:599a:a900 with SMTP id
 38308e7fff4ca-2ff20185828mr100529111fa.15.1731516414409; Wed, 13 Nov 2024
 08:46:54 -0800 (PST)
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
 <fb9db285-dff0-681c-1dcf-7f01350ccb48@huaweicloud.com>
In-Reply-To: <fb9db285-dff0-681c-1dcf-7f01350ccb48@huaweicloud.com>
From: Haris Iqbal <haris.iqbal@ionos.com>
Date: Wed, 13 Nov 2024 17:46:42 +0100
Message-ID: <CAJpMwyi8v2LvdVG2nJ-aJOHDpw79tcwGfPbgV--4xH67NC2B3Q@mail.gmail.com>
Subject: Re: Experiencing md raid5 hang and CPU lockup on kernel v6.11
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Xiao Ni <xni@redhat.com>, =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>, 
	linux-raid@vger.kernel.org, Jinpu Wang <jinpu.wang@ionos.com>, 
	=?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>, 
	"yangerkun@huawei.com" <yangerkun@huawei.com>, David Jeffery <djeffery@redhat.com>, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 13, 2024 at 8:46=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/11/11 21:56, Haris Iqbal =E5=86=99=E9=81=93:
> > On Mon, Nov 11, 2024 at 2:39=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.co=
m> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2024/11/11 21:29, Haris Iqbal =E5=86=99=E9=81=93:
> >>> Hello,
> >>>
> >>> I gave both the patches a try, and here are my findings.
> >>>
> >>
> >> Thanks for the test!
> >>
> >>> With the first patch by Yu, I did not see any hang or errors. I tried
> >>> a number of bitmap chunk sizes, and ran fio for few hours, and there
> >>> was no hang.
> >>
> >> This is good news! However, there is still a long road for my approch
> >> to land, this requires a lot of other changes to work.
> >>>
> >>> With the second patch Xiao, I hit the following BUG_ON on the first
> >>> minute of my fio run.
> >>
> >> This is sad. :(
> >>>
> >>> [  113.902982] Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
> >>> [  113.903315] CPU: 38 UID: 0 PID: 9767 Comm: kworker/38:3H Kdump:
> >>> loaded Not tainted 6.11.5-storage
> >>> #6.11.5-1+feature+v6.11+20241111.0643+cbe84cc3~deb12
> >>> [  113.904120] Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.3 03/0=
3/2021
> >>> [  113.904519] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> >>> [  113.904888] RIP: 0010:__add_stripe_bio+0x23f/0x250 [raid456]
> >>
> >> Can you provide the addr2line of this?
> >>
> >> gdb raid456.ko
> >> list *(__add_stripe_bio+0x23f)
> >
> > Sorry. I missed the first line while copying.
> >
> > [  113.902680] kernel BUG at drivers/md/raid5.c:3525!
>
> Can you give the following patch a test again, on the top of Xiao's
> patch.
>
> Thanks,
> Kuai
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 6e318598a7b6..189f784aed00 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3516,7 +3516,7 @@ static void __add_stripe_bio(struct stripe_head
> *sh, struct bio *bi,
>                  bip =3D &sh->dev[dd_idx].toread;
>          }
>
> -       while (*bip && (*bip)->bi_iter.bi_sector < bi->bi_iter.bi_sector)
> +       while (*bip && (*bip)->bi_iter.bi_sector <=3D bi->bi_iter.bi_sect=
or)
>                  bip =3D &(*bip)->bi_next;
>
>          if (!forwrite || previous)

Still hangs. Following is the stack trace.

[   22.702034] netconsole-setup: Test log message to verify netconsole
configuration.
[  134.949923] Oops: general protection fault, probably for
non-canonical address 0x761acac3b7d57b17: 0000 [#1] PREEMPT SMP PTI
[  134.950621] CPU: 35 UID: 0 PID: 833 Comm: md300_raid5 Kdump: loaded
Not tainted 6.11.5-storage
#6.11.5-1+feature+v6.11+20241113.0858+ed8e31b5~deb12
[  134.951414] Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.3 03/03/2021
[  134.951814] RIP: 0010:rnbd_dev_bi_end_io+0x1b/0x70 [rnbd_server]
[  134.952185] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3
0f 1e fa 0f 1f 44 00 00 55 b8 ff ff ff ff 53 48 8b 6f 40 48 89 fb 48
8b 55 08 <f0
[  134.953311] RSP: 0018:ffffb5b94818fb80 EFLAGS: 00010282
[  134.953624] RAX: 00000000ffffffff RBX: ffff96e6a1d8aa80 RCX: 00000000802=
a0016
[  134.954051] RDX: 761acac3b7d57aa7 RSI: 00000000802a0016 RDI: ffff96e6a1d=
8aa80
[  134.954476] RBP: ffff96d705c7d8b0 R08: 0000000000000001 R09: 00000000000=
00001
[  134.954901] R10: ffff96d730c59d40 R11: 0000000000000000 R12: ffff96d71b3=
e5000
[  134.955326] R13: 0000000000000000 R14: ffff96d730c589d8 R15: ffff96d7158=
82e20
[  134.955752] FS:  0000000000000000(0000) GS:ffff96f63fbc0000(0000)
knlGS:0000000000000000
[  134.956237] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  134.956578] CR2: 00007fb5962bbe00 CR3: 000000060882c006 CR4: 00000000001=
706f0
[  134.957003] Call Trace:
[  134.957151]  <TASK
[  134.957274]  ? die_addr+0x36/0x90
[  134.957480]  ? exc_general_protection+0x1bc/0x3c0
[  134.957762]  ? asm_exc_general_protection+0x26/0x30
[  134.958054]  ? rnbd_dev_bi_end_io+0x1b/0x70 [rnbd_server]
[  134.958377]  md_end_clone_io+0x42/0xa0
[  134.958602]  md_end_clone_io+0x42/0xa0
[  134.958826]  handle_stripe_clean_event+0x240/0x430 [raid456]
[  134.959168]  handle_stripe+0x783/0x1cb0 [raid456]
[  134.959452]  ? common_interrupt+0x13/0xa0
[  134.959690]  handle_active_stripes.constprop.0+0x353/0x540 [raid456]
[  134.960073]  raid5d+0x41a/0x600 [raid456]

Maybe the same BIO handled twice - and so the clone (for IO-acct) got
put again (somehow) into md_account_bio()?

>
>
> > [  113.902982] Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
> > [  113.903315] CPU: 38 UID: 0 PID: 9767 Comm: kworker/38:3H Kdump:
> > loaded Not tainted 6.11.5-storage
> > #6.11.5-1+feature+v6.11+20241111.0643+cbe84cc3~deb12
> > [  113.904120] Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.3 03/03/=
2021
> > [  113.904519] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> > [  113.904888] RIP: 0010:__add_stripe_bio+0x23f/0x250 [raid456]
> > [  113.905232] Code: 29 ff ff ff 41 8b 84 24 80 01 00 00 83 c0 01 89
> > 45 54 f0 80 4d 49 02 e9 11 ff ff ff 45 85 c0 0f 84 4e fe ff ff e9 31
> > ff ff ff <0f
> > [  113.906352] RSP: 0018:ffffb5d30ed27aa0 EFLAGS: 00010006
> > [  113.906661] RAX: ffff992cb9549818 RBX: 0000000000000000 RCX: 0000000=
000000001
> > [  113.907086] RDX: ffff992c989c3158 RSI: ffff992c989c3a58 RDI: 0000000=
000000000
> > [  113.907511] RBP: ffff991d19e923a0 R08: 0000000000000000 R09: 0000000=
000000160
> > [  113.907936] R10: 0000000000000007 R11: ffffb5d30ed27b70 R12: ffff991=
d0854b800
> > [  113.908361] R13: 0000000000000001 R14: ffff991d19e92718 R15: 0000000=
000000001
> > [  113.908786] FS:  0000000000000000(0000) GS:ffff993c3fc80000(0000)
> > knlGS:0000000000000000
> > [  113.909267] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  113.909609] CR2: 00007f21b85473d8 CR3: 000000145d82c001 CR4: 0000000=
0001706f0
> > [  113.910034] Call Trace:
> > [  113.910181]  <TASK
> > [  113.910304]  ? die+0x36/0x90
> > [  113.910478]  ? do_trap+0xdd/0x100
> > [  113.910675]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > [  113.910979]  ? do_error_trap+0x65/0x80
> > [  113.911200]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > [  113.911503]  ? exc_invalid_op+0x50/0x70
> > [  113.911731]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > [  113.912033]  ? asm_exc_invalid_op+0x1a/0x20
> > [  113.912283]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > [  113.912586]  raid5_make_request+0x35f/0x1210 [raid456]
> > [  113.912896]  ? submit_bio_noacct+0x47/0x4c0
> > [  113.913145]  ? __pfx_woken_wake_function+0x10/0x10
> > [  113.913430]  ? bio_split_rw+0x143/0x290
> > [  113.913659]  md_handle_request+0x156/0x270
> > [  113.913905]  __submit_bio+0x15c/0x1f0
> > [  113.914126]  submit_bio_noacct_nocheck+0x19a/0x3c0
> > [  113.914412]  ? submit_bio_noacct+0x47/0x4c0
> > [  113.914662]  rnbd_srv_rdma_ev+0x501/0xf70 [rnbd_server]
> > [  113.914976]  ? rtrs_post_recv_empty+0x5d/0x80 [rtrs_core]
> > [  113.930375]  process_io_req+0x169/0x4e0 [rtrs_server]
> > [  113.945660]  __ib_process_cq+0x7b/0x170 [ib_core]
> >
> >>
> >> Thanks,
> >> Kuai
> >>> [  113.905232] Code: 29 ff ff ff 41 8b 84 24 80 01 00 00 83 c0 01 89
> >>> 45 54 f0 80 4d 49 02 e9 11 ff ff ff 45 85 c0 0f 84 4e fe ff ff e9 31
> >>> ff ff ff <0f
> >>> [  113.906352] RSP: 0018:ffffb5d30ed27aa0 EFLAGS: 00010006
> >>> [  113.906661] RAX: ffff992cb9549818 RBX: 0000000000000000 RCX: 00000=
00000000001
> >>> [  113.907086] RDX: ffff992c989c3158 RSI: ffff992c989c3a58 RDI: 00000=
00000000000
> >>> [  113.907511] RBP: ffff991d19e923a0 R08: 0000000000000000 R09: 00000=
00000000160
> >>> [  113.907936] R10: 0000000000000007 R11: ffffb5d30ed27b70 R12: ffff9=
91d0854b800
> >>> [  113.908361] R13: 0000000000000001 R14: ffff991d19e92718 R15: 00000=
00000000001
> >>> [  113.908786] FS:  0000000000000000(0000) GS:ffff993c3fc80000(0000)
> >>> knlGS:0000000000000000
> >>> [  113.909267] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>> [  113.909609] CR2: 00007f21b85473d8 CR3: 000000145d82c001 CR4: 00000=
000001706f0
> >>> [  113.910034] Call Trace:
> >>> [  113.910181]  <TASK
> >>> [  113.910304]  ? die+0x36/0x90
> >>> [  113.910478]  ? do_trap+0xdd/0x100
> >>> [  113.910675]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> >>> [  113.910979]  ? do_error_trap+0x65/0x80
> >>> [  113.911200]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> >>> [  113.911503]  ? exc_invalid_op+0x50/0x70
> >>> [  113.911731]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> >>> [  113.912033]  ? asm_exc_invalid_op+0x1a/0x20
> >>> [  113.912283]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> >>> [  113.912586]  raid5_make_request+0x35f/0x1210 [raid456]
> >>> [  113.912896]  ? submit_bio_noacct+0x47/0x4c0
> >>> [  113.913145]  ? __pfx_woken_wake_function+0x10/0x10
> >>> [  113.913430]  ? bio_split_rw+0x143/0x290
> >>> [  113.913659]  md_handle_request+0x156/0x270
> >>> [  113.913905]  __submit_bio+0x15c/0x1f0
> >>> [  113.914126]  submit_bio_noacct_nocheck+0x19a/0x3c0
> >>> [  113.914412]  ? submit_bio_noacct+0x47/0x4c0
> >>> [  113.914662]  rnbd_srv_rdma_ev+0x501/0xf70 [rnbd_server]
> >>> [  113.914976]  ? rtrs_post_recv_empty+0x5d/0x80 [rtrs_core]
> >>> [  113.930375]  process_io_req+0x169/0x4e0 [rtrs_server]
> >>> [  113.945660]  __ib_process_cq+0x7b/0x170 [ib_core]
> >>
> > .
> >
>
