Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22311E7C32
	for <linux-raid@vger.kernel.org>; Tue, 22 Apr 2025 07:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745307130; cv=none; b=CKp6G199BFJHIHQ3mg2OKvP2op3C00NtNL5c10cq/QBntwgNH13nuFfLd+I5891S6aoLPUCeyuyiL7L1/gfVzBKV2FU6ntOC4wYl5YR2USLBX3s2m/zC03CQuI4QO52ySu62uzu6lVeNKwU7HecCLMcP39h8BRMHYlk0FvC+bhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745307130; c=relaxed/simple;
	bh=GYT9ccNLAhOPgXWakNekwub13YLf8xv/hNB6McE5ogo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bn6U39NZdHXGGFJo6HlbyfHMYYvxTOzIsJD+CMiP6SGUjF++tKKaWdRraHcd3cPNiHNYPEFFgWSbLNJ3t9JNtPex0Zqq8PlCIpLJg1NrIsxWdYsB/lX1KC7nqFK+E+dsD8C22tYKG97XWkLEtllpUOyYsryPmE1HwtgjJ69gxio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DN1D+Yq6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DN1D+Yq6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745307127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7/BJawxJ7XwkRNuiOUZrLd4smJPIndmTLfot43zDM+o=;
	b=DN1D+Yq6ir1UXoAFrnUoXkLyHDaKmRO+hVO7ESMLqTKdnbzQs4okBjUYc6m16Akxir9l9l
	oEVwdgYVBm2ERUsbdqM/Rlfrmlia5YH94JOx/nxt08EL+1qUBrD7vQwEqWP3Y5CtGC7Dyf
	oaRSpRz4aIynwWIcY7CfY+Sm63gZWnQ=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-eLGLACMYN7OmLosboanKyA-1; Tue, 22 Apr 2025 03:32:05 -0400
X-MC-Unique: eLGLACMYN7OmLosboanKyA-1
X-Mimecast-MFC-AGG-ID: eLGLACMYN7OmLosboanKyA_1745307124
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-54d68c2bc97so1687846e87.1
        for <linux-raid@vger.kernel.org>; Tue, 22 Apr 2025 00:32:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745307124; x=1745911924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7/BJawxJ7XwkRNuiOUZrLd4smJPIndmTLfot43zDM+o=;
        b=EYcSJm9Cs6WBboK9GwHNs2fUWVBA9LcNe/+voZZYyYSfigSgh1FHukTpCOfb0mYGBn
         91oQNczGtx0rL/2ES/w4+8Jk1eo/gLzfIDukCiy9uwXvLZkBd/QBQVcm4g9C7vKBaPuo
         SXO6Uz3MTbZXrbR8uSxaRFT6w8Siy2r7h6Wvx1j8ckXJtq0RiuwAd1hjv8Chd2eN5FVV
         LpKeELPpIJv97FgM/yXzZrTS+sODVQWyEo3afsm4ZqEX1SD3w4BwHPEFjZRT+vs1MBFN
         88ScWFDh44MIrcnuyfeoApoMF1dlwV/TccanDYGiCLM7GUnzf2nY5V5pn4Sc+GWpgD1g
         rjWg==
X-Gm-Message-State: AOJu0YxUOGKqqqft1r3G98K49qtGP/UWOfPKv7i8LfdhXMcBHIqyNkAB
	Qulu429RDh2eBDP3F3H3hByQCcmED6ofE5lzuqEdnA1lANo0IIgeVZ/NjCXCaEdM3UAl8nRr17b
	J//GtMq3m39RZH7yuxfyb/o/ry3K5yvrCJAD5SXYr/e6Br5Lt5fflFs2/a0ObWZF5x/Q4yJX5Ou
	YBlbA/SSYyyz1xDO74Pl7Ev7Mtj3o8g/ldJA==
X-Gm-Gg: ASbGncvYuaBIYs5qcD+pbgHd72XWistwMDXzcR1A2Gn7iE14wO6O+ZAmv6TL/TDCqV8
	MXzGAq/jCN4BP/VZMC8C7Oi7F8IszO7mXof0p8vkdchvD27rtj6Vthj2CuKY6UMslr5dLRw==
X-Received: by 2002:a05:6512:2386:b0:545:f9c:a80f with SMTP id 2adb3069b0e04-54d6e61a370mr4294021e87.1.1745307123668;
        Tue, 22 Apr 2025 00:32:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEHGt0g02hJ4OHceSltz1p256eQgCZgJ6Cd09wgml9j5hGRW9WYFaifR5foK5qkWshD1T5fvW48Mw6pkgh7Jk=
X-Received: by 2002:a05:6512:2386:b0:545:f9c:a80f with SMTP id
 2adb3069b0e04-54d6e61a370mr4294016e87.1.1745307123274; Tue, 22 Apr 2025
 00:32:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422032403.63057-1-xni@redhat.com> <707e58e8-12c4-ea92-393f-9fc707e097ac@huaweicloud.com>
In-Reply-To: <707e58e8-12c4-ea92-393f-9fc707e097ac@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 22 Apr 2025 15:31:50 +0800
X-Gm-Features: ATxdqUGbZIw7abcA8onK11n-V3YOLeC4BjcTMQ3rMH2ugrah1fd969fR4VRNaf0
Message-ID: <CALTww2-84ALP7mXcO9erO+wto1Ur_mae4K+dRD9pXdizi7EOSw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] md: delete gendisk in ioctl path
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org, hch@lst.de, 
	ming.lei@redhat.com, ncroxon@redhat.com, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2025 at 2:21=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2025/04/22 11:24, Xiao Ni =E5=86=99=E9=81=93:
> > commit 777d0961ff95b ("fs: move the bdex_statx call to vfs_getattr_nose=
c")
> > introduces a regression problem, like this:
> > [ 1479.474440] INFO: task kdevtmpfs:506 blocked for more than 491 secon=
ds.
> > [ 1479.478569]  __wait_for_common+0x99/0x1c0
> > [ 1479.478823]  ? __pfx_schedule_timeout+0x10/0x10
> > [ 1479.479466]  __flush_workqueue+0x138/0x400
> > [ 1479.479684]  md_alloc+0x21/0x370 [md_mod]
> > [ 1479.479926]  md_probe+0x24/0x50 [md_mod]
> > [ 1479.480150]  blk_probe_dev+0x62/0x90
> > [ 1479.480368]  blk_request_module+0xf/0x70
> > [ 1479.480604]  blkdev_get_no_open+0x5e/0xa0
> > [ 1479.480809]  bdev_statx+0x1f/0xf0
> > [ 1479.481364]  vfs_getattr_nosec+0x10a/0x120
> > [ 1479.481602]  handle_remove+0x68/0x290
> > [ 1479.481812]  ? __update_idle_core+0x23/0xb0
> > [ 1479.482023]  devtmpfs_work_loop+0x10d/0x2a0
> > [ 1479.482231]  ? __pfx_devtmpfsd+0x10/0x10
> > [ 1479.482464]  devtmpfsd+0x2f/0x30
> >
> > [ 1479.485397] INFO: task kworker/33:1:532 blocked for more than 491 se=
conds.
> > [ 1479.535380]  __wait_for_common+0x99/0x1c0
> > [ 1479.566876]  ? __pfx_schedule_timeout+0x10/0x10
> > [ 1479.591156]  devtmpfs_submit_req+0x6e/0x90
> > [ 1479.591389]  devtmpfs_delete_node+0x60/0x90
> > [ 1479.591631]  ? process_sysctl_arg+0x270/0x2f0
> > [ 1479.592256]  device_del+0x315/0x3d0
> > [ 1479.592839]  ? mutex_lock+0xe/0x30
> > [ 1479.593455]  del_gendisk+0x216/0x320
> > [ 1479.593672]  md_kobj_release+0x34/0x40 [md_mod]
> > [ 1479.594317]  kobject_cleanup+0x3a/0x130
> > [ 1479.594562]  process_one_work+0x19d/0x3d0
> >
> > Now del_gendisk and put_disk are called asynchronously in workqueue wor=
k.
> > del_gendisk deletes device node by devtmpfs. devtmpfs tries to open thi=
s
> > array again and it flush the workqueue at the bigging of open process. =
So
> > a deadlock happens.
> >
> > The asynchronous way also has a problem that the device node can still
> > exist after mdadm --stop command returns in a short window. So udev rul=
e
> > can open this device node and create the struct mddev in kernel again.
> >
> > So put del_gendisk in ioctl path and still leave put_disk in
> > md_kobj_release to avoid uaf.
> >
> > Fixes: 777d0961ff95 ("fs: move the bdex_statx call to vfs_getattr_nosec=
")
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   drivers/md/md.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 9daa78c5fe33..c3f793296ccc 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -5746,7 +5746,6 @@ static void md_kobj_release(struct kobject *ko)
> >       if (mddev->sysfs_level)
> >               sysfs_put(mddev->sysfs_level);
> >
> > -     del_gendisk(mddev->gendisk);
> >       put_disk(mddev->gendisk);
> >   }
> >
> > @@ -6597,6 +6596,8 @@ static int do_md_stop(struct mddev *mddev, int mo=
de)
> >               md_clean(mddev);
> >               if (mddev->hold_active =3D=3D UNTIL_STOP)
> >                       mddev->hold_active =3D 0;
> > +
> > +             del_gendisk(mddev->gendisk);
>
> I'm still trying to understand the problem here, however, this change
> will break sysfs api md/array_state, do_md_stop will be called as well,
> del_gendisk in this context will deadlock, because it will wait for all
> sysfs writers, include itself, to be done.

Thanks for pointing out this.

Is it ok to remove the support of md_probe now? Now all the things
that are difficult to handle is that array can be created again when
opening the block device node.

78b6350dcaadb03b4a2970b16387227ba6744876 ("md: support disabling of
create-on-open semantics.") tries to disable create-on-open. And the
probe method will be removed too
(451f0b6f4c44d7b649ae609157b114b71f6d7875 block: default
BLOCK_LEGACY_AUTOLOAD to y). To make things easy, we can remove the
support of md_probe. md_probe is used for system without udev
environment. So it needs to create a device node by mknod and open the
device node to create the array.  I guess no system doesn't have udev
environment, right?

Regards
Xiao
>
> Thanks,
> Kuai
>
> >       }
> >       md_new_event();
> >       sysfs_notify_dirent_safe(mddev->sysfs_state);
> >
>

