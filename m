Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E7051033
	for <linux-raid@vger.kernel.org>; Mon, 20 May 2024 10:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716202089; cv=none; b=qgd3a3XYZNg8OKuEAmY6p114Ag4zb3QLkS7neEEZN8eESMQyvc7Ca3pOxsKmm0sfM/eIKYRyUP1A6pWKgAaG6GdgYF1jOgrr2EATAMWSeZSYZV9zz7CUegOwVnDNn3HRxcuF6Hw/Z6gVBh4kzost1cnxy3ZEgc416S7gFUdrRlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716202089; c=relaxed/simple;
	bh=xmWY4f02X7qlcH4yGMxFNj65fKAvO9snaQuM4/zb9oM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IRGknQ1ofshiJk6oAUdG4Jxr7G3B2lQk+MERgX8+oGWXQ8ysQcg+cMeVHPLhYck8zslaxe1Ig/PhaatCT6FxasDZS1ddFzQ2TXytHnfHncN7WH5FmZfBwWciEGeubFpKZbL1SsMdilOeW3Z/iOfWpAw7cDjFJqWKkaA5IIB5xGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WhM5TjbS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WhM5TjbS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716202087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NNz3U5QZm8AZDLJeucZLL1YyhyAVTs0xS8svaas4LQI=;
	b=WhM5TjbSvzfV62IgMXUrVnbR8g7UspZ4Pr4EdceLDcGtYTMXQRHvN4UIyiAcYWrhdCr+Lf
	5IkffdLKRRqXa7+XkISf+faZdxCVS/bMCRuwLwXHaE1N/fPk6EIMeuaFwS2mbO4CXqEWyY
	hyqs6hXKa5rBGVCD4CjSXOSWiDkkmMs=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-q5-M8UqSPLyl5Dc8sKckVQ-1; Mon, 20 May 2024 06:48:05 -0400
X-MC-Unique: q5-M8UqSPLyl5Dc8sKckVQ-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2bd843fce7cso575559a91.2
        for <linux-raid@vger.kernel.org>; Mon, 20 May 2024 03:48:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716202084; x=1716806884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NNz3U5QZm8AZDLJeucZLL1YyhyAVTs0xS8svaas4LQI=;
        b=OCpcFM6iF9Qxi4Wi2SFIGSGw25l2xx/AcuGJ4yPj9DeXV76lhkRlcTluvE7r8StAdA
         5sRGHbOvl9vyUFUIDtbmiYOa2mu/fH2EYlgZeACK4T67v86YV98f6bHfCzsI/tdy7q1W
         2WCOL68Z34aBf6LjwddEAof0LaL21APFwfxA3sF8Hahl+By2yY4fQ6suxujyYwOJ9eUN
         qSaEYX5T48TTnNdHlbpDAnNl38sDcpz7pvWmtpS34fBzpmQNWJ4UUNS3BW7ihO6QBlPL
         EhdOjZeITrOI6tnlUINacsfZZ6NPLf/PDE+xMSv/ACvHOFqpTohjfw5kvQWoZOM502iG
         i5/g==
X-Forwarded-Encrypted: i=1; AJvYcCXsPNfsnJzRIRtORKWOxYoGKM1ebR+VpqxQw8wSTAZq1YhdydD7AizJUEuy0HN+cLZqIhQPRI7BtlpGHvoUhCkqvSsH1w+z3GCesw==
X-Gm-Message-State: AOJu0YwcqpsE9IyKkD9djC6ZFccOYmenDJdMKvybAMapHKDJBAUDT05I
	Glf+XYkncpTw0rUsEb6+tvOi8KVll2wG0DM6rPyW0ePMl3Es2WrmNRrdjPTish5j91ciCSHLdfs
	7iJW/P5eWbtxIaJ6bfUT5MHP1/eyHPkO8T8yJ7B43zI0Rup+99ilXBDtNl55fLJ37bttO2pJfhJ
	nqusmbDTqQukdkkl/lgf9hXJUc8U7WCoI8ZA==
X-Received: by 2002:a17:90a:b785:b0:29d:dd93:5865 with SMTP id 98e67ed59e1d1-2b6ccef64bdmr23756824a91.46.1716202084520;
        Mon, 20 May 2024 03:48:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyQGJnqu6O926v2TqMkiej0ZHycTo1wX8iox6govhRW4orIuHx7fPcI35fo68r09zetjgxB17k9Nl2jO9geDA=
X-Received: by 2002:a17:90a:b785:b0:29d:dd93:5865 with SMTP id
 98e67ed59e1d1-2b6ccef64bdmr23756795a91.46.1716202083833; Mon, 20 May 2024
 03:48:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGVVp+Xsmzy2G9YuEatfMT6qv1M--YdOCQ0g7z7OVmcTbBxQAg@mail.gmail.com>
 <ZkXsOKV5d4T0Hyqu@fedora> <9b340157-dc0c-6e6a-3d92-f2c65b515461@huaweicloud.com>
 <CAGVVp+XtThX7=bZm441VxyVd-wv_ycdqMU=19a2pa4wUkbkJ3g@mail.gmail.com>
 <1b35a177-670a-4d2f-0b68-6eda769af37d@huaweicloud.com> <CAGVVp+WQVeV0PE12RvpojFTRB4rHXh6Lk01vLmdStw1W9zUACg@mail.gmail.com>
 <CAGVVp+WGyPS5nOQYhWtgJyQnXwUb-+Hui14pXqxd+-ZUjWpTrA@mail.gmail.com>
 <f1c98dd1-a62c-6857-3773-e05b80e6a763@huaweicloud.com> <ca29a4b1-4b4a-3b1c-4981-6e05e0bb24be@huaweicloud.com>
In-Reply-To: <ca29a4b1-4b4a-3b1c-4981-6e05e0bb24be@huaweicloud.com>
From: Changhui Zhong <czhong@redhat.com>
Date: Mon, 20 May 2024 18:47:52 +0800
Message-ID: <CAGVVp+W=MKwytCH+skL=hUsxHzz21O8qv_eeXfwKQEnLiuf3VA@mail.gmail.com>
Subject: Re: [bug report] INFO: task mdX_resync:42168 blocked for more than
 122 seconds
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Ming Lei <ming.lei@redhat.com>, Linux Block Devices <linux-block@vger.kernel.org>, 
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, 
	Xiao Ni <xni@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 20, 2024 at 3:27=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/05/20 10:55, Yu Kuai =E5=86=99=E9=81=93:
> > Hi, Changhui
> >
> > =E5=9C=A8 2024/05/20 8:39, Changhui Zhong =E5=86=99=E9=81=93:
> >> [czhong@vm linux-block]$ git bisect bad
> >> 060406c61c7cb4bbd82a02d179decca9c9bb3443 is the first bad commit
> >> commit 060406c61c7cb4bbd82a02d179decca9c9bb3443
> >> Author: Yu Kuai<yukuai3@huawei.com>
> >> Date:   Thu May 9 20:38:25 2024 +0800
> >>
> >>      block: add plug while submitting IO
> >>
> >>      So that if caller didn't use plug, for example,
> >> __blkdev_direct_IO_simple()
> >>      and __blkdev_direct_IO_async(), block layer can still benefit
> >> from caching
> >>      nsec time in the plug.
> >>
> >>      Signed-off-by: Yu Kuai<yukuai3@huawei.com>
> >>
> >> Link:https://lore.kernel.org/r/20240509123825.3225207-1-yukuai1@huawei=
cloud.com
> >>
> >>      Signed-off-by: Jens Axboe<axboe@kernel.dk>
> >>
> >>   block/blk-core.c | 6 ++++++
> >>   1 file changed, 6 insertions(+)
> >
> > Thanks for the test!
> >
> > I was surprised to see this blamed commit, and after taking a look at
> > raid1 barrier code, I found that there are some known problems, fixed i=
n
> > raid10, while raid1 still unfixed. So I wonder this patch maybe just
> > making the exist problem easier to reporduce.
> >
> > I'll start cooking patches to sync raid10 fixes to raid1, meanwhile,
> > can you change your script to test raid10 as well, if raid10 is fine,
> > I'll give you these patches later to test raid1.
>
> Hi,
>
> Sorry to ask, but since I can't reporduce the problem, and based on
> code reiview, there are multiple potential problems, can you also
> reporduce the problem with following debug patch(just add some debug
> info, no functional changes). So that I can make sure of details of
> the problem.
>

Hi=EF=BC=8CKuai

yeah=EF=BC=8C I can test your patch=EF=BC=8C
but I hit a problem when applying the patch, please help check it, and
I will test it again after you fix it.

```
patching file drivers/md/raid1.c
patch: **** malformed patch at line 42: idx, nr, RESYNC_DEPTH);
```

Thanks,
Changhui

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 113135e7b5f2..b35b847a9e8b 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -936,6 +936,45 @@ static void flush_pending_writes(struct r1conf *conf=
)
>                  spin_unlock_irq(&conf->device_lock);
>   }
>
> +static bool waiting_barrier(struct r1conf *conf, int idx)
> +{
> +       int nr =3D atomic_read(&conf->nr_waiting[idx]);
> +
> +       if (nr) {
> +               printk("%s: idx %d nr_waiting %d\n", __func__, idx, nr);
> +               return true;
> +       }
> +
> +       return false;
> +}
> +
> +static bool waiting_pending(struct r1conf *conf, int idx)
> +{
> +       int nr;
> +
> +       if (test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery))
> +               return false;
> +
> +       if (conf->array_frozen) {
> +               printk("%s: array is frozen\n", __func__);
> +               return true;
> +       }
> +
> +       nr =3D atomic_read(&conf->nr_pending[idx]);
> +       if (nr) {
> +               printk("%s: idx %d nr_pending %d\n", __func__, idx, nr);
> +               return true;
> +       }
> +
> +       nr =3D atomic_read(&conf->barrier[idx]);
> +       if (nr >=3D RESYNC_DEPTH) {
> +               printk("%s: idx %d barrier %d exceeds %d\n", __func__,
> idx, nr, RESYNC_DEPTH);
> +               return true;
> +       }
> +
> +       return false;
> +}
> +
>   /* Barriers....
>    * Sometimes we need to suspend IO while we do something else,
>    * either some resync/recovery, or reconfigure the array.
> @@ -967,8 +1006,7 @@ static int raise_barrier(struct r1conf *conf,
> sector_t sector_nr)
>          spin_lock_irq(&conf->resync_lock);
>
>          /* Wait until no block IO is waiting */
> -       wait_event_lock_irq(conf->wait_barrier,
> -                           !atomic_read(&conf->nr_waiting[idx]),
> +       wait_event_lock_irq(conf->wait_barrier, !waiting_barrier(conf, id=
x),
>                              conf->resync_lock);
>
>          /* block any new IO from starting */
> @@ -990,11 +1028,7 @@ static int raise_barrier(struct r1conf *conf,
> sector_t sector_nr)
>           * C: while conf->barrier[idx] >=3D RESYNC_DEPTH, meaning reache=
s
>           *    max resync count which allowed on current I/O barrier buck=
et.
>           */
> -       wait_event_lock_irq(conf->wait_barrier,
> -                           (!conf->array_frozen &&
> -                            !atomic_read(&conf->nr_pending[idx]) &&
> -                            atomic_read(&conf->barrier[idx]) <
> RESYNC_DEPTH) ||
> -                               test_bit(MD_RECOVERY_INTR,
> &conf->mddev->recovery),
> +       wait_event_lock_irq(conf->wait_barrier, !waiting_pending(conf, id=
x),
>                              conf->resync_lock);
>
>          if (test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
>
> Thanks,
> Kuai
>
> >
> > Thanks,
> > Kuai
> >
> > .
> >
>

