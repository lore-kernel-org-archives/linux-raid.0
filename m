Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9816914B942
	for <linux-raid@vger.kernel.org>; Wed, 13 Nov 2024 06:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731477686; cv=none; b=QrirqcpIf2zQKR2R10pkqfhd/G6AC+rodlPAvQyPjKTc76cSdpMXYl4c8iY/pwYWkKFSyFg7rTr7iVZc5A58KFNoXY2hCucKYa8G7qijligLiGpvnHGc77oIT3y2mMB1rcON68cfw5+WywpM5Gg6P7arn3R4qD2iAw7j54MN4m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731477686; c=relaxed/simple;
	bh=I6AowoU9O3AJc443RMaPDETwF1314Zz60FkfylUTZGw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nAEMYPzeivV8OaQkl/yXvmwwIYW2Of6Bm5Gt0M0SUD7CxRqdN0hlq3oMyJJFTcxPjYLlM/rTtqFgmeZOdNCpmHX2tj4fMWeZzG/b6hgWJYbBP0c/8AScoUNnYXoATWhISqeaxkXEvH2TcY50xVuJ6jtW8eOvErV2TAtllqvAQ5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hJAn+oMK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hJAn+oMK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731477683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iXIAnJfR9fdb771YHcLnHMkC+wV+3pEHLPy/qPG2FQM=;
	b=hJAn+oMK8QQGCnzY/VPwlg2WOwqdifQD6IBVjwMTbw9Z07YaCNmkVEQMZwNcVMC3O9yykZ
	p1Q0dJbjYFHNV45oUH2TxdfkvYpw0VsEmbo2vZw9o5DktrzT4O8LkQyxGgNJ9WS1k4nMH8
	kkvwVdEJx15XpNbos/SL+5fHMI0SQNo=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-r3-zZu5XORGaKWSZ1UTYXA-1; Wed, 13 Nov 2024 01:01:21 -0500
X-MC-Unique: r3-zZu5XORGaKWSZ1UTYXA-1
X-Mimecast-MFC-AGG-ID: r3-zZu5XORGaKWSZ1UTYXA
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-539eeb63cc3so4644624e87.2
        for <linux-raid@vger.kernel.org>; Tue, 12 Nov 2024 22:01:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731477680; x=1732082480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iXIAnJfR9fdb771YHcLnHMkC+wV+3pEHLPy/qPG2FQM=;
        b=Z+1mZrz9xL8x3Fp/GudlSVRFFWzvpNad2ZBnXdPZT6BVFYTRoZKxudZYLHpiVDgPaP
         QSjO/fQBRd1Lyx5WEIXK6EOy32puWJbqWh5Vcn6oEVC7sMme/MUMQWd2K4+f6gfB7r+F
         /S/kOeqn1Xqxin9HYNQFL83f08cCR88xig0tQOW9eOyBmCW/fAqfpHy9BF15I8lT7vWx
         LY9GIXWT9PiyrWf9XsxBV5isfZPb+0hC/I9+UW0WGCmZIKApdnQLhYrVRTquIH10z9JL
         R3wgG1QNjBr/t9q3QnD6IHuxriLJihqZj5qhfhufL7ahutt3IIJqlTVGNUnK9sQFYEpd
         MQZQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6p5no+0wobj8Ku/yo+GNBrVBDwjD00XAWwbxm/d+PJDafNfh8xOsyF9Q5MsFVrRoT/oO7IRaMQNXb@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1LFlNvDnaAJ4K49BgkjHQ6hSkFGUWpK/Gl0WOUZSj/41bau39
	1g/QHf9ntsF8eOm/cjAlQS2slobXuPsYmUEwH8dxfX/CY4sYHT2HVTQlfG6xR9mvAx6JJbQrFax
	vcfOlvWuFFIDchP+EHec1Zd8bMzWI0L1Wo8kH9YuiO+p2lI3u2dt6YXAmGQF7GKYbQ7F6BOW+oY
	5NQubzXTwB/NaEd6it0lunv6LAToSUsnDKZg==
X-Received: by 2002:a05:6512:280c:b0:539:d428:fbf2 with SMTP id 2adb3069b0e04-53d9a40b5c5mr2901053e87.13.1731477679885;
        Tue, 12 Nov 2024 22:01:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFr+MWOyLb0wua948N1EgbhAdZkn93a4vtlSHrGjLxU2chq9g9of6UgWk9J7KjDQzfo6i1etuvAaZxepKKmctM=
X-Received: by 2002:a05:6512:280c:b0:539:d428:fbf2 with SMTP id
 2adb3069b0e04-53d9a40b5c5mr2901034e87.13.1731477679411; Tue, 12 Nov 2024
 22:01:19 -0800 (PST)
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
 <CALTww2-ijsnnJhkm6pB4VMRfkhGkFWiPwN8gXtZS19oBBvfB4Q@mail.gmail.com> <CAJpMwyhdguSzss9emc5zO0eX9eX5Ex_gzU=WPu6kOzVKWArNqQ@mail.gmail.com>
In-Reply-To: <CAJpMwyhdguSzss9emc5zO0eX9eX5Ex_gzU=WPu6kOzVKWArNqQ@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 13 Nov 2024 14:01:07 +0800
Message-ID: <CALTww29aTQ6HT8LU-caxZeNy5zH5zwB6rK_znrMkwFLK0YXSKw@mail.gmail.com>
Subject: Re: Experiencing md raid5 hang and CPU lockup on kernel v6.11
To: Haris Iqbal <haris.iqbal@ionos.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>, 
	linux-raid@vger.kernel.org, Jinpu Wang <jinpu.wang@ionos.com>, 
	=?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>, 
	"yangerkun@huawei.com" <yangerkun@huawei.com>, David Jeffery <djeffery@redhat.com>, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2024 at 5:46=E2=80=AFPM Haris Iqbal <haris.iqbal@ionos.com>=
 wrote:
>
> On Tue, Nov 12, 2024 at 3:04=E2=80=AFAM Xiao Ni <xni@redhat.com> wrote:
> >
> > On Mon, Nov 11, 2024 at 9:56=E2=80=AFPM Haris Iqbal <haris.iqbal@ionos.=
com> wrote:
> > >
> > > On Mon, Nov 11, 2024 at 2:39=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.=
com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > =E5=9C=A8 2024/11/11 21:29, Haris Iqbal =E5=86=99=E9=81=93:
> > > > > Hello,
> > > > >
> > > > > I gave both the patches a try, and here are my findings.
> > > > >
> > > >
> > > > Thanks for the test!
> > > >
> > > > > With the first patch by Yu, I did not see any hang or errors. I t=
ried
> > > > > a number of bitmap chunk sizes, and ran fio for few hours, and th=
ere
> > > > > was no hang.
> > > >
> > > > This is good news! However, there is still a long road for my appro=
ch
> > > > to land, this requires a lot of other changes to work.
> > > > >
> > > > > With the second patch Xiao, I hit the following BUG_ON on the fir=
st
> > > > > minute of my fio run.
> >
> > Hi Haris
> >
> > What's the fio command do you use? I did some simple io and couldn't
> > trigger this.
>
> I use the following fio config,
>
> [global]
> description=3DEmulation of Storage Server Access Pattern
> bssplit=3D512/20:1k/16:2k/9:4k/12:8k/19:16k/10:32k/8:64k/4
> fadvise_hint=3D0
> rw=3Drandrw:2
> direct=3D1
> random_distribution=3Dzipf:1.2
> time_based=3D1
> runtime=3D600
> ramp_time=3D1
> ioengine=3Dlibaio
> iodepth=3D128
> iodepth_batch_submit=3D128
> iodepth_batch_complete_min=3D1
> iodepth_batch_complete_max=3D128
> numjobs=3D10
> group_reporting
>
> [job1]
> filename=3D/dev/rnbd0
> do_verify=3D1

I tried this pattern against the raid5 array directly with 6.11.0 and
it can run successfully.

Regards
Xiao



>
>
> >
> > Regards
> > Xiao
> > > > This is sad. :(
> > > > >
> > > > > [  113.902982] Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
> > > > > [  113.903315] CPU: 38 UID: 0 PID: 9767 Comm: kworker/38:3H Kdump=
:
> > > > > loaded Not tainted 6.11.5-storage
> > > > > #6.11.5-1+feature+v6.11+20241111.0643+cbe84cc3~deb12
> > > > > [  113.904120] Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.3 =
03/03/2021
> > > > > [  113.904519] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> > > > > [  113.904888] RIP: 0010:__add_stripe_bio+0x23f/0x250 [raid456]
> > > >
> > > > Can you provide the addr2line of this?
> > > >
> > > > gdb raid456.ko
> > > > list *(__add_stripe_bio+0x23f)
> > >
> > > Sorry. I missed the first line while copying.
> > >
> > > [  113.902680] kernel BUG at drivers/md/raid5.c:3525!
> > > [  113.902982] Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
> > > [  113.903315] CPU: 38 UID: 0 PID: 9767 Comm: kworker/38:3H Kdump:
> > > loaded Not tainted 6.11.5-storage
> > > #6.11.5-1+feature+v6.11+20241111.0643+cbe84cc3~deb12
> > > [  113.904120] Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.3 03/0=
3/2021
> > > [  113.904519] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> > > [  113.904888] RIP: 0010:__add_stripe_bio+0x23f/0x250 [raid456]
> > > [  113.905232] Code: 29 ff ff ff 41 8b 84 24 80 01 00 00 83 c0 01 89
> > > 45 54 f0 80 4d 49 02 e9 11 ff ff ff 45 85 c0 0f 84 4e fe ff ff e9 31
> > > ff ff ff <0f
> > > [  113.906352] RSP: 0018:ffffb5d30ed27aa0 EFLAGS: 00010006
> > > [  113.906661] RAX: ffff992cb9549818 RBX: 0000000000000000 RCX: 00000=
00000000001
> > > [  113.907086] RDX: ffff992c989c3158 RSI: ffff992c989c3a58 RDI: 00000=
00000000000
> > > [  113.907511] RBP: ffff991d19e923a0 R08: 0000000000000000 R09: 00000=
00000000160
> > > [  113.907936] R10: 0000000000000007 R11: ffffb5d30ed27b70 R12: ffff9=
91d0854b800
> > > [  113.908361] R13: 0000000000000001 R14: ffff991d19e92718 R15: 00000=
00000000001
> > > [  113.908786] FS:  0000000000000000(0000) GS:ffff993c3fc80000(0000)
> > > knlGS:0000000000000000
> > > [  113.909267] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [  113.909609] CR2: 00007f21b85473d8 CR3: 000000145d82c001 CR4: 00000=
000001706f0
> > > [  113.910034] Call Trace:
> > > [  113.910181]  <TASK
> > > [  113.910304]  ? die+0x36/0x90
> > > [  113.910478]  ? do_trap+0xdd/0x100
> > > [  113.910675]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > > [  113.910979]  ? do_error_trap+0x65/0x80
> > > [  113.911200]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > > [  113.911503]  ? exc_invalid_op+0x50/0x70
> > > [  113.911731]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > > [  113.912033]  ? asm_exc_invalid_op+0x1a/0x20
> > > [  113.912283]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > > [  113.912586]  raid5_make_request+0x35f/0x1210 [raid456]
> > > [  113.912896]  ? submit_bio_noacct+0x47/0x4c0
> > > [  113.913145]  ? __pfx_woken_wake_function+0x10/0x10
> > > [  113.913430]  ? bio_split_rw+0x143/0x290
> > > [  113.913659]  md_handle_request+0x156/0x270
> > > [  113.913905]  __submit_bio+0x15c/0x1f0
> > > [  113.914126]  submit_bio_noacct_nocheck+0x19a/0x3c0
> > > [  113.914412]  ? submit_bio_noacct+0x47/0x4c0
> > > [  113.914662]  rnbd_srv_rdma_ev+0x501/0xf70 [rnbd_server]
> > > [  113.914976]  ? rtrs_post_recv_empty+0x5d/0x80 [rtrs_core]
> > > [  113.930375]  process_io_req+0x169/0x4e0 [rtrs_server]
> > > [  113.945660]  __ib_process_cq+0x7b/0x170 [ib_core]
> > >
> > > >
> > > > Thanks,
> > > > Kuai
> > > > > [  113.905232] Code: 29 ff ff ff 41 8b 84 24 80 01 00 00 83 c0 01=
 89
> > > > > 45 54 f0 80 4d 49 02 e9 11 ff ff ff 45 85 c0 0f 84 4e fe ff ff e9=
 31
> > > > > ff ff ff <0f
> > > > > [  113.906352] RSP: 0018:ffffb5d30ed27aa0 EFLAGS: 00010006
> > > > > [  113.906661] RAX: ffff992cb9549818 RBX: 0000000000000000 RCX: 0=
000000000000001
> > > > > [  113.907086] RDX: ffff992c989c3158 RSI: ffff992c989c3a58 RDI: 0=
000000000000000
> > > > > [  113.907511] RBP: ffff991d19e923a0 R08: 0000000000000000 R09: 0=
000000000000160
> > > > > [  113.907936] R10: 0000000000000007 R11: ffffb5d30ed27b70 R12: f=
fff991d0854b800
> > > > > [  113.908361] R13: 0000000000000001 R14: ffff991d19e92718 R15: 0=
000000000000001
> > > > > [  113.908786] FS:  0000000000000000(0000) GS:ffff993c3fc80000(00=
00)
> > > > > knlGS:0000000000000000
> > > > > [  113.909267] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > [  113.909609] CR2: 00007f21b85473d8 CR3: 000000145d82c001 CR4: 0=
0000000001706f0
> > > > > [  113.910034] Call Trace:
> > > > > [  113.910181]  <TASK
> > > > > [  113.910304]  ? die+0x36/0x90
> > > > > [  113.910478]  ? do_trap+0xdd/0x100
> > > > > [  113.910675]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > > > > [  113.910979]  ? do_error_trap+0x65/0x80
> > > > > [  113.911200]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > > > > [  113.911503]  ? exc_invalid_op+0x50/0x70
> > > > > [  113.911731]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > > > > [  113.912033]  ? asm_exc_invalid_op+0x1a/0x20
> > > > > [  113.912283]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> > > > > [  113.912586]  raid5_make_request+0x35f/0x1210 [raid456]
> > > > > [  113.912896]  ? submit_bio_noacct+0x47/0x4c0
> > > > > [  113.913145]  ? __pfx_woken_wake_function+0x10/0x10
> > > > > [  113.913430]  ? bio_split_rw+0x143/0x290
> > > > > [  113.913659]  md_handle_request+0x156/0x270
> > > > > [  113.913905]  __submit_bio+0x15c/0x1f0
> > > > > [  113.914126]  submit_bio_noacct_nocheck+0x19a/0x3c0
> > > > > [  113.914412]  ? submit_bio_noacct+0x47/0x4c0
> > > > > [  113.914662]  rnbd_srv_rdma_ev+0x501/0xf70 [rnbd_server]
> > > > > [  113.914976]  ? rtrs_post_recv_empty+0x5d/0x80 [rtrs_core]
> > > > > [  113.930375]  process_io_req+0x169/0x4e0 [rtrs_server]
> > > > > [  113.945660]  __ib_process_cq+0x7b/0x170 [ib_core]
> > > >
> > >
> >
>

