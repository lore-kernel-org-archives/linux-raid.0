Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D2319C552
	for <linux-raid@vger.kernel.org>; Mon, 11 Nov 2024 13:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731333386; cv=none; b=hoZ6pY1Q24gfbo8ey8SG3ayk+c2yNyJuAzsZMYJjThqj4D2JhJZoX3KGTd74h+9yfMpXN0G2syVdxuJ6UWVKdGVaRwA9n6r05VH5jKs/SX2ljVxuosoOZvVm0mDXLsumlSqG4km+mb6CbarvBMj9qcTuLE2amR1uZKYZSvz9KLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731333386; c=relaxed/simple;
	bh=6YuEWkEyk3NNQ77O3r0WDyoicOA33rMq9JXQZ+UYKig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dXlKeDlUpjbtJJmMayIwIBekEr7/5lPTiAIM8sdaphWlQgdzkqTeZQNUutaDrREoGYXIc9tezR/I3hkW3y4UV/SBbGJXfCx8wo3UEO/DOHG7hywvQsSldqjuiCx8L9b5UfOVNiVt0jghWlkaYfmmcFiKz87q74PPbx2/iEoKagk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=DjVGvBSF; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="DjVGvBSF"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2fb57f97d75so41580531fa.2
        for <linux-raid@vger.kernel.org>; Mon, 11 Nov 2024 05:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1731333381; x=1731938181; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VTq6bSzgL3Q7iocfAncPXeQ3adW0DbEPJr5vNC/0qGc=;
        b=DjVGvBSFCTXx+OFGrt+CnITtd1i9bvAw5k0A2O110LGulxzm93Vy/Cm7URlFKtzUOt
         NbHphtGDXI05a4r4v/nPj4ZXyQic+YLWAyPf5qKColvKb9VRQzYrCRhjKmrifKlXqPHz
         nc6ovJQPgJarGVLn40voCFoFeSp8EBHhhYtQJ4adCRNFh11KcfRQGyxtlZjRaxPJpwin
         gP2IXP+KmhXEzxj2A4Wk2LIgwqQYBRV5sa71n36thzPgAAdG4GHvng0JE/y2gQOW5jPh
         VarXiH0PXOYHpCNAx+OVDygdOd8wfW8RHYV4yw4KU3YC+LaeRioYNRBQ8jUPjnX3i210
         CnlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731333381; x=1731938181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VTq6bSzgL3Q7iocfAncPXeQ3adW0DbEPJr5vNC/0qGc=;
        b=ggOn5Yl5Tcy0oYYww6ErZaYgd7BvKjUTh/pD7LADrFp4K0dPHRf0QYXWrda0I0e7Xv
         1bJvCeMDS2Me33X9FyYhWHqGFDXWfF2Y/s/nuhAfAQ8W6K0ZftcjmvQWmTMZtwzoOyvZ
         EA7wo681Df/7mWQ2ozBbF6RZ8uRM9A96bmyZ8RDQ8LvOScmkq8hZqLjytayfq4/e8+Ms
         x3Z0hk0NUZ3qwX7Ht7wuTvhbLBHHnaN9QtF46pi2Jcu6vfRyLlZDxYc/x1unAGfWTPFC
         oTCCUFLPBxUuq6wLDRUI8+rq3GimYQqn8WHdcBZQ1sLNi3TTawOS9hgILwNgOvGEk5ct
         5CQw==
X-Forwarded-Encrypted: i=1; AJvYcCWsl0TkzeEwjIaWcv0lA/Oss4UA5q+0Ej6iPJz1Gqt5Irg18fclGCYcVMHLBdARGnjpDodDVtfB46a9@vger.kernel.org
X-Gm-Message-State: AOJu0YxEYvfeCqUBOxmhjRMPPnknMdsvUyTYy5oAbUDJdJZ4ET0ie3iL
	kONUewWOyonarKLzJDl/UbkzXL1+xVMgjKlF92L+nCeo7mtcX0ia4Tr+s4lHgxSoh53t2SfYrHV
	OcNI0dYB18dnS37glGimcb/4NE/5DuEKoaMObuw==
X-Google-Smtp-Source: AGHT+IG5g91dclEoeaa0E2hhot+L8T6tIoG5vI4rYgk1Egeawu7GOLokpXbrWNDLFHddQDqmc3mnz9KMH8Tlb/q+FdE=
X-Received: by 2002:a2e:a5c3:0:b0:2fb:4c08:be08 with SMTP id
 38308e7fff4ca-2ff2017287dmr63838471fa.11.1731333381342; Mon, 11 Nov 2024
 05:56:21 -0800 (PST)
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
 <CAJpMwyiR3B0ismDXXyqS-HSzyiiVDj7YYE85m91oDvB9apnB6g@mail.gmail.com> <8f7173c6-8847-129c-c5ed-27eb3b8a8458@huaweicloud.com>
In-Reply-To: <8f7173c6-8847-129c-c5ed-27eb3b8a8458@huaweicloud.com>
From: Haris Iqbal <haris.iqbal@ionos.com>
Date: Mon, 11 Nov 2024 14:56:10 +0100
Message-ID: <CAJpMwyjPcLQ=HF5EOXgQFOy=bGHLDWZQJ5CwUV0UHMnyeSPM_g@mail.gmail.com>
Subject: Re: Experiencing md raid5 hang and CPU lockup on kernel v6.11
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Xiao Ni <xni@redhat.com>, =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>, 
	linux-raid@vger.kernel.org, Jinpu Wang <jinpu.wang@ionos.com>, 
	=?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>, 
	"yangerkun@huawei.com" <yangerkun@huawei.com>, David Jeffery <djeffery@redhat.com>, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11, 2024 at 2:39=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/11/11 21:29, Haris Iqbal =E5=86=99=E9=81=93:
> > Hello,
> >
> > I gave both the patches a try, and here are my findings.
> >
>
> Thanks for the test!
>
> > With the first patch by Yu, I did not see any hang or errors. I tried
> > a number of bitmap chunk sizes, and ran fio for few hours, and there
> > was no hang.
>
> This is good news! However, there is still a long road for my approch
> to land, this requires a lot of other changes to work.
> >
> > With the second patch Xiao, I hit the following BUG_ON on the first
> > minute of my fio run.
>
> This is sad. :(
> >
> > [  113.902982] Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
> > [  113.903315] CPU: 38 UID: 0 PID: 9767 Comm: kworker/38:3H Kdump:
> > loaded Not tainted 6.11.5-storage
> > #6.11.5-1+feature+v6.11+20241111.0643+cbe84cc3~deb12
> > [  113.904120] Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.3 03/03/=
2021
> > [  113.904519] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> > [  113.904888] RIP: 0010:__add_stripe_bio+0x23f/0x250 [raid456]
>
> Can you provide the addr2line of this?
>
> gdb raid456.ko
> list *(__add_stripe_bio+0x23f)

Sorry. I missed the first line while copying.

[  113.902680] kernel BUG at drivers/md/raid5.c:3525!
[  113.902982] Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
[  113.903315] CPU: 38 UID: 0 PID: 9767 Comm: kworker/38:3H Kdump:
loaded Not tainted 6.11.5-storage
#6.11.5-1+feature+v6.11+20241111.0643+cbe84cc3~deb12
[  113.904120] Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.3 03/03/2021
[  113.904519] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
[  113.904888] RIP: 0010:__add_stripe_bio+0x23f/0x250 [raid456]
[  113.905232] Code: 29 ff ff ff 41 8b 84 24 80 01 00 00 83 c0 01 89
45 54 f0 80 4d 49 02 e9 11 ff ff ff 45 85 c0 0f 84 4e fe ff ff e9 31
ff ff ff <0f
[  113.906352] RSP: 0018:ffffb5d30ed27aa0 EFLAGS: 00010006
[  113.906661] RAX: ffff992cb9549818 RBX: 0000000000000000 RCX: 00000000000=
00001
[  113.907086] RDX: ffff992c989c3158 RSI: ffff992c989c3a58 RDI: 00000000000=
00000
[  113.907511] RBP: ffff991d19e923a0 R08: 0000000000000000 R09: 00000000000=
00160
[  113.907936] R10: 0000000000000007 R11: ffffb5d30ed27b70 R12: ffff991d085=
4b800
[  113.908361] R13: 0000000000000001 R14: ffff991d19e92718 R15: 00000000000=
00001
[  113.908786] FS:  0000000000000000(0000) GS:ffff993c3fc80000(0000)
knlGS:0000000000000000
[  113.909267] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  113.909609] CR2: 00007f21b85473d8 CR3: 000000145d82c001 CR4: 00000000001=
706f0
[  113.910034] Call Trace:
[  113.910181]  <TASK
[  113.910304]  ? die+0x36/0x90
[  113.910478]  ? do_trap+0xdd/0x100
[  113.910675]  ? __add_stripe_bio+0x23f/0x250 [raid456]
[  113.910979]  ? do_error_trap+0x65/0x80
[  113.911200]  ? __add_stripe_bio+0x23f/0x250 [raid456]
[  113.911503]  ? exc_invalid_op+0x50/0x70
[  113.911731]  ? __add_stripe_bio+0x23f/0x250 [raid456]
[  113.912033]  ? asm_exc_invalid_op+0x1a/0x20
[  113.912283]  ? __add_stripe_bio+0x23f/0x250 [raid456]
[  113.912586]  raid5_make_request+0x35f/0x1210 [raid456]
[  113.912896]  ? submit_bio_noacct+0x47/0x4c0
[  113.913145]  ? __pfx_woken_wake_function+0x10/0x10
[  113.913430]  ? bio_split_rw+0x143/0x290
[  113.913659]  md_handle_request+0x156/0x270
[  113.913905]  __submit_bio+0x15c/0x1f0
[  113.914126]  submit_bio_noacct_nocheck+0x19a/0x3c0
[  113.914412]  ? submit_bio_noacct+0x47/0x4c0
[  113.914662]  rnbd_srv_rdma_ev+0x501/0xf70 [rnbd_server]
[  113.914976]  ? rtrs_post_recv_empty+0x5d/0x80 [rtrs_core]
[  113.930375]  process_io_req+0x169/0x4e0 [rtrs_server]
[  113.945660]  __ib_process_cq+0x7b/0x170 [ib_core]

>
> Thanks,
> Kuai
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
>
