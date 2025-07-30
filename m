Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB95287270
	for <linux-raid@vger.kernel.org>; Wed, 30 Jul 2025 07:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753862184; cv=none; b=oe5gWs3gsUgTX8RbLZ+NTaVgEBG7ZRchAVDpHablGA2WXu0FdWKAOTWPJDNWPBsZfsLvZz0jb0G16Bc1uDj4M/mV5Mw4hrAXRyld7yaxJ5zvFZfmumpXmbpcQNbpPRclGthEqlDGQzO5Gl6cFF+PTAKCb8wW4pzfzhBUtAN8vEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753862184; c=relaxed/simple;
	bh=SuN47byAthyv6iJdSiSm3XcP3i63e6LM6boRfco+DWs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VDBPUPOqBg5cPx5M2fxBOoU8fPUs/poLA+r4TUQvA0y3or4bkTCIQrPpXiGMwUg+J4vyWN0LBqnK1MX3EO9rBMdIo8tubxndlNFkeglukCbepzCw7bKxuhwKIfRx8x4OsvxVTVNLQYU0zmEgKP4paCx0jaR4EiaJpJtgFaWiWtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g1uHE8L/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g1uHE8L/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753862181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mges3aFw0nNxUJUhav3brRvu8FlZVekMDOOAYiIFIiM=;
	b=g1uHE8L/zuom6ix3I6DseoYRyAvvk37pKVhOuiZDQUVFvv2SozqTuS4ekKdCSTgUjAa7un
	Rz2HKuI58O+nifo6VK3PvyLZj9MJBLf094dS8iYVl/E2e4aHFBEWJXzlVmAQdlerl5Tvbm
	u/ay4tiGW9olp067BM1e/DI5OecORec=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502-E46q3ywGMYiFL4oQfAeqOA-1; Wed, 30 Jul 2025 03:56:19 -0400
X-MC-Unique: E46q3ywGMYiFL4oQfAeqOA-1
X-Mimecast-MFC-AGG-ID: E46q3ywGMYiFL4oQfAeqOA_1753862178
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-55a25c3d400so3350903e87.2
        for <linux-raid@vger.kernel.org>; Wed, 30 Jul 2025 00:56:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753862177; x=1754466977;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mges3aFw0nNxUJUhav3brRvu8FlZVekMDOOAYiIFIiM=;
        b=WQoW+iY1m5XiVIO8GsF0xysYfMG8Op9JERoUolhcDDFh5OdcMh5xqnzCKYbOHaIPwT
         pIMYsvLFbR/DAvuMCOrQhui2GezMEPZEDkuD3M5TV/dOSNcfzYcyGGOZEpt0Le/Jnrw3
         jnmJey+ZQ6iwkcrIvNjUcwyTs7M8gzNQUvNjOIu56ok+U6TdeLBMJuTDeMn+9YCj8e4z
         r7PLosN6hDA1/On1xLxTzsUH2OydTAVY3qYXgAlD3Z8Ze17TAah4MmeELEt9fPuyDzyv
         ElZGt3oRASiDQwKlcMGVvEuuUqceknECoBtr756SKjsRMqb2JUagSBjMUwbyZyafVsla
         fQCg==
X-Forwarded-Encrypted: i=1; AJvYcCXAYMe8NDUoo6EYHGuQj2DrupByNWsNdmdwI92TY1FqeHM8lJg3jI5U64qErhGs4b7cIZF6Ty/+cRHH@vger.kernel.org
X-Gm-Message-State: AOJu0YxN0+JkKAvqUYdCeC/MaATucaUqcITqusXKTfsCWw72CqzdtrRW
	f5YxF76QxIpacqg5Qa3Eor0/eLEw4uy8sNE13NO0T4JhMApdU/RLG/cW5jyMrCaWULgFws/8pGc
	HK0qIHDdiywlKWhwEXljoZe+mmDmTW8spAJTPhoqJCv1mXjyG023mJvQygxR2hAkwoZKYjZsnv4
	e38vIf7wNOP2rDvGoEJNkyMyQ8N5B4Rjv8CeuOiQ==
X-Gm-Gg: ASbGncsRKLpjngSFCZrP4Pfawf/gIitFm+a8+68cTcVMY0qaVqqgixEybXdvRJTpKux
	Bx9PA9N0dX0ye3sdWwkkUMfgKVzLzgz/JBomLhpn34f1FhuC3jNSZiqJmEE3BhXpfisKZBdF4Ax
	dw6CD178GX7M7rRhvMz/w8vg==
X-Received: by 2002:a05:6512:3d28:b0:553:3407:eee0 with SMTP id 2adb3069b0e04-55b7bffbdc2mr1001101e87.4.1753862177382;
        Wed, 30 Jul 2025 00:56:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESTI1a6kk0yt+h/hjD2gSzvOmJjmDWARDZLTIKOLFsg85k/XH7stv4opStbSdyGBd1qpDU0IiXGfiznHniw0M=
X-Received: by 2002:a05:6512:3d28:b0:553:3407:eee0 with SMTP id
 2adb3069b0e04-55b7bffbdc2mr1001089e87.4.1753862176939; Wed, 30 Jul 2025
 00:56:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250730073321.2583158-1-yukuai1@huaweicloud.com>
In-Reply-To: <20250730073321.2583158-1-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 30 Jul 2025 15:56:04 +0800
X-Gm-Features: Ac12FXzYTSZcxvxIHazLoTMZzQ0rv9webYymyVm-iH8Hrg4Cy08MUcQVJUtvlx0
Message-ID: <CALTww2-iYqWhKJED1tCOEtQL9f1_4NC=1=s=zwM7WK0mu6+COw@mail.gmail.com>
Subject: Re: [PATCH] md: fix create on open mddev lifetime regression
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: contact@arnaud-lcm.com, hdanton@sina.com, song@kernel.org, 
	yukuai3@huawei.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2025 at 3:40=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Commit 9e59d609763f ("md: call del_gendisk in control path") move
> setting MD_DELETED from __mddev_put() to do_md_stop(), however, for the
> case create on open, mddev can be freed without do_md_stop():
>
> 1) open
>
> md_probe
>  md_alloc_and_put
>   md_alloc
>    mddev_alloc
>    atomic_set(&mddev->active, 1);
>    mddev->hold_active =3D UNTIL_IOCTL
>   mddev_put
>    atomic_dec_and_test(&mddev->active)
>     if (mddev->hold_active)
>     -> active is 0, hold_active is set
> md_open
>  mddev_get
>   atomic_inc(&mddev->active);
>
> 2) ioctl that is not STOP_ARRAY, for example, GET_ARRAY_INFO:
>
> md_ioctl
>  mddev->hold_active =3D 0
>
> 3) close
>
> md_release
>  mddev_put(mddev);
>   atomic_dec_and_lock(&mddev->active, &all_mddevs_lock)
>   __mddev_put
>   -> hold_active is cleared, mddev will be freed
>   queue_work(md_misc_wq, &mddev->del_work)
>
> Now that MD_DELETED is not set, before mddev is freed by
> mddev_delayed_delete(), md_open can still succeed and break mddev
> lifetime, causing mddev->kobj refcount underflow or mddev uaf
> problem.
>
> Fix this problem by setting MD_DELETED before queuing del_work.
>
> Reported-by: syzbot+9921e319bd6168140b40@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68894408.a00a0220.26d0e1.0012.GAE@goo=
gle.com/
> Reported-by: syzbot+fa3a12519f0d3fd4ec16@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68894408.a00a0220.26d0e1.0013.GAE@goo=
gle.com/
> Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 046fe85c76fe..5289dcc3a6af 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -636,6 +636,12 @@ static void __mddev_put(struct mddev *mddev)
>             mddev->ctime || mddev->hold_active)
>                 return;
>
> +       /*
> +        * If array is freed by stopping array, MD_DELETED is set by
> +        * do_md_stop(), MD_DELETED is still set here in cause mddev is f=
reed
> +        * directly by closing a mddev that is created by create_on_open.
> +        */
> +       set_bit(MD_DELETED, &mddev->flags);
>         /*
>          * Call queue_work inside the spinlock so that flush_workqueue() =
after
>          * mddev_find will succeed in waiting for the work to be done.
> --
> 2.39.2
>
Hi Kuai

Thanks for figuring out this problem so quicily.

Looks good to me
Reviewed-by: Xiao Ni <xni@redhat.com>

