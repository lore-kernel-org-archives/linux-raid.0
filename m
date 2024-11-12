Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C895BE6C
	for <linux-raid@vger.kernel.org>; Tue, 12 Nov 2024 02:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731377060; cv=none; b=GbUt9IR5KFtxlMJ13ReiCRNqmCxbBGpE4FEYci9KP7OsM7/XNSbZfb3VoXuACBxztx9KNHHjNXG8i11jxHqGG8BDuRkjOQDQ+Pkt1ILFp+ouRaVbQ068Pb8NWaGsXjCiWXdPPkGqOfOQh40DTxutcLYWqUUxWTVLi5IcSLKBmZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731377060; c=relaxed/simple;
	bh=13+nI5iuglO2quHlb2pJNRDna5R5O/AROMb9HeEvleQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fuXDSi6ZkrIDjGUVNpJCIxflAo0Vi5Nwtoevx/L9X6EShIV72E8jQ1K3hJOidV/ISIqg06qBgew0WaB8vqZ2ocRAAJprqepBvxfPqEpXKRDqduvMmZcxUC4sjRnk6KvQkD4FDJwKWMtOR/PLrwIUa1aASn46P+eL4Oknm6e9inE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HQxouPDP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HQxouPDP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731377057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hsAhTYcHFoZZm5JwdpUgcGBgnkZa0oZ7sQMlKz8eLr0=;
	b=HQxouPDPn6r8WvZ8Cvj2u5VVBzXqn09xwZcSOaJ7ojzn3/JI8sQa8FJCD5O4++p0SZWdMo
	n985wPd0aqWORK+qc5xMEaQK6Xd6HGLnV16YeWoCSfvd8mmzWxVVcnwHi4kwpozpXjJZB/
	n/C80QJ0FYU7MkQyunYlNVeBAGSjjnA=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-Wth_X3XFPOyN5ARHuOQ2Fw-1; Mon, 11 Nov 2024 21:04:15 -0500
X-MC-Unique: Wth_X3XFPOyN5ARHuOQ2Fw-1
X-Mimecast-MFC-AGG-ID: Wth_X3XFPOyN5ARHuOQ2Fw
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-539e91e12bbso3722915e87.2
        for <linux-raid@vger.kernel.org>; Mon, 11 Nov 2024 18:04:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731377054; x=1731981854;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hsAhTYcHFoZZm5JwdpUgcGBgnkZa0oZ7sQMlKz8eLr0=;
        b=aaRUU+gxCjcxgPYOEQ/MapsrypZ7dML7kWnLmVlhAoVR+8N1zcAFqegrnLTiB2ZiWw
         fFz45mJa0cH7B/0nXUH5UeJAsarVcUgn0THiplc+Aer7fwQCOfR2UmCHBwkgYeLfji+/
         WeJEC2Lk6G2nPdWBvhmWvrkF/N+7fGTHwZiOxlzDfO6hZlLhyNc3HWVAyGRkBWgADiIN
         mIHYlhOZnUJ1Wbkfl9OkHq4taDNnH4NHXjpxwzRedQVT861Aq6PsJ37SJyWWGqG0zwKT
         C+kISISkVcirtuiAaHf8slD8aCPfqL/jiiUro+w7kGo+R23FuBbfBb9WHSFZWPBAp+Ql
         R6jg==
X-Forwarded-Encrypted: i=1; AJvYcCUjZ9u2U2rn4bqwv5TV/KqSLzriWE6bAMJXzZL/GjtARNIDyUvVxv4TxT9Cg0WTfsk+lrEyd91Ko6h5@vger.kernel.org
X-Gm-Message-State: AOJu0YxGy8c57+NRRlLAajvNm1l0BK5pC+7Xmw8tFep9GZhOVW+28R6E
	+MSbDHsxNva7k4pRCryxx9mhIrslLnuaPd5flvupElfk0daE5e8x7WyngfsPp5Wb8FdqBGSdNFr
	K5E2BiF6S4iLsuEGgK//4ZY5CLM8+rbfNmHAWy6+ci4EQ/e0dsoWzJ+oPwYrrfwOPB/s+6duc3p
	Z7qzBKzw6VHT5fDbJtZvGzWOOaQpRQnAAXWg==
X-Received: by 2002:a05:6512:1583:b0:539:88f7:d3c4 with SMTP id 2adb3069b0e04-53d862e31dfmr6025506e87.29.1731377054098;
        Mon, 11 Nov 2024 18:04:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHLPsnpdvqYCBi0Y2QlKeeFiavVLD0JlVQ0mHUGdnqPR235q0WiEcD9OpA3AApLJRR/ZmkxlKT/F2lDjXgvTbE=
X-Received: by 2002:a05:6512:1583:b0:539:88f7:d3c4 with SMTP id
 2adb3069b0e04-53d862e31dfmr6025492e87.29.1731377053400; Mon, 11 Nov 2024
 18:04:13 -0800 (PST)
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
In-Reply-To: <CAJpMwyjPcLQ=HF5EOXgQFOy=bGHLDWZQJ5CwUV0UHMnyeSPM_g@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 12 Nov 2024 10:04:01 +0800
Message-ID: <CALTww2-ijsnnJhkm6pB4VMRfkhGkFWiPwN8gXtZS19oBBvfB4Q@mail.gmail.com>
Subject: Re: Experiencing md raid5 hang and CPU lockup on kernel v6.11
To: Haris Iqbal <haris.iqbal@ionos.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>, 
	linux-raid@vger.kernel.org, Jinpu Wang <jinpu.wang@ionos.com>, 
	=?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>, 
	"yangerkun@huawei.com" <yangerkun@huawei.com>, David Jeffery <djeffery@redhat.com>, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11, 2024 at 9:56=E2=80=AFPM Haris Iqbal <haris.iqbal@ionos.com>=
 wrote:
>
> On Mon, Nov 11, 2024 at 2:39=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com>=
 wrote:
> >
> > Hi,
> >
> > =E5=9C=A8 2024/11/11 21:29, Haris Iqbal =E5=86=99=E9=81=93:
> > > Hello,
> > >
> > > I gave both the patches a try, and here are my findings.
> > >
> >
> > Thanks for the test!
> >
> > > With the first patch by Yu, I did not see any hang or errors. I tried
> > > a number of bitmap chunk sizes, and ran fio for few hours, and there
> > > was no hang.
> >
> > This is good news! However, there is still a long road for my approch
> > to land, this requires a lot of other changes to work.
> > >
> > > With the second patch Xiao, I hit the following BUG_ON on the first
> > > minute of my fio run.

Hi Haris

What's the fio command do you use? I did some simple io and couldn't
trigger this.

Regards
Xiao
> > This is sad. :(
> > >
> > > [  113.902982] Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
> > > [  113.903315] CPU: 38 UID: 0 PID: 9767 Comm: kworker/38:3H Kdump:
> > > loaded Not tainted 6.11.5-storage
> > > #6.11.5-1+feature+v6.11+20241111.0643+cbe84cc3~deb12
> > > [  113.904120] Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.3 03/0=
3/2021
> > > [  113.904519] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> > > [  113.904888] RIP: 0010:__add_stripe_bio+0x23f/0x250 [raid456]
> >
> > Can you provide the addr2line of this?
> >
> > gdb raid456.ko
> > list *(__add_stripe_bio+0x23f)
>
> Sorry. I missed the first line while copying.
>
> [  113.902680] kernel BUG at drivers/md/raid5.c:3525!
> [  113.902982] Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
> [  113.903315] CPU: 38 UID: 0 PID: 9767 Comm: kworker/38:3H Kdump:
> loaded Not tainted 6.11.5-storage
> #6.11.5-1+feature+v6.11+20241111.0643+cbe84cc3~deb12
> [  113.904120] Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.3 03/03/20=
21
> [  113.904519] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> [  113.904888] RIP: 0010:__add_stripe_bio+0x23f/0x250 [raid456]
> [  113.905232] Code: 29 ff ff ff 41 8b 84 24 80 01 00 00 83 c0 01 89
> 45 54 f0 80 4d 49 02 e9 11 ff ff ff 45 85 c0 0f 84 4e fe ff ff e9 31
> ff ff ff <0f
> [  113.906352] RSP: 0018:ffffb5d30ed27aa0 EFLAGS: 00010006
> [  113.906661] RAX: ffff992cb9549818 RBX: 0000000000000000 RCX: 000000000=
0000001
> [  113.907086] RDX: ffff992c989c3158 RSI: ffff992c989c3a58 RDI: 000000000=
0000000
> [  113.907511] RBP: ffff991d19e923a0 R08: 0000000000000000 R09: 000000000=
0000160
> [  113.907936] R10: 0000000000000007 R11: ffffb5d30ed27b70 R12: ffff991d0=
854b800
> [  113.908361] R13: 0000000000000001 R14: ffff991d19e92718 R15: 000000000=
0000001
> [  113.908786] FS:  0000000000000000(0000) GS:ffff993c3fc80000(0000)
> knlGS:0000000000000000
> [  113.909267] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  113.909609] CR2: 00007f21b85473d8 CR3: 000000145d82c001 CR4: 000000000=
01706f0
> [  113.910034] Call Trace:
> [  113.910181]  <TASK
> [  113.910304]  ? die+0x36/0x90
> [  113.910478]  ? do_trap+0xdd/0x100
> [  113.910675]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> [  113.910979]  ? do_error_trap+0x65/0x80
> [  113.911200]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> [  113.911503]  ? exc_invalid_op+0x50/0x70
> [  113.911731]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> [  113.912033]  ? asm_exc_invalid_op+0x1a/0x20
> [  113.912283]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> [  113.912586]  raid5_make_request+0x35f/0x1210 [raid456]
> [  113.912896]  ? submit_bio_noacct+0x47/0x4c0
> [  113.913145]  ? __pfx_woken_wake_function+0x10/0x10
> [  113.913430]  ? bio_split_rw+0x143/0x290
> [  113.913659]  md_handle_request+0x156/0x270
> [  113.913905]  __submit_bio+0x15c/0x1f0
> [  113.914126]  submit_bio_noacct_nocheck+0x19a/0x3c0
> [  113.914412]  ? submit_bio_noacct+0x47/0x4c0
> [  113.914662]  rnbd_srv_rdma_ev+0x501/0xf70 [rnbd_server]
> [  113.914976]  ? rtrs_post_recv_empty+0x5d/0x80 [rtrs_core]
> [  113.930375]  process_io_req+0x169/0x4e0 [rtrs_server]
> [  113.945660]  __ib_process_cq+0x7b/0x170 [ib_core]
>
> >
> > Thanks,
> > Kuai
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
> >
>

