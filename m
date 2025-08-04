Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B311923ABBD
	for <linux-raid@vger.kernel.org>; Mon,  4 Aug 2025 09:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754298932; cv=none; b=JT+pSAkQlth1RQrf1aeGwqYQ9yaCCr8MFhVy1AAqnMRH/aPFME1hxf39mUU+MmoVDGFRm4xvt/MSJn2R5T54NO+g9fjx8JBD3dDWdtPQ2n+R57A3fdLFvEFfYjbp5jpDwaOGxo6UDTERVXLeprF4XfcxBMos9tweg5fhbPwT9ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754298932; c=relaxed/simple;
	bh=BEDoRg6ey4p+H93HmM+g9//xUXfjK/SSJ2MK7UJHSHQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nIqWFxNCM8gnoSqmEQtINCR3dTUt3oIr69sXnOB1UQE9x15XIoMGD1/o8zAFAEwOHs4fjyexVyJ+P3ss3gO8kmeGWLRF3ZgJKtG+Ya0BHG/5paCnXTLdypeqtG+CGAuO8xaE8t6syS7rfBwslgxEiG6z8n/jojZC99vdpkLLWlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WOwoSuRT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WOwoSuRT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754298929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mkrRfjQYaOOOEfT/VLhNTKOF6Rg64aCH11W96IXXEYo=;
	b=WOwoSuRTJ40Gzw3r2zd/0v7oeANpScJaB5r5BralOuee5bKr+5FuFJlYDXXGU/+DnZRc55
	WlkTAyrMfNrmHEPD7v4VkWvzfFwFKQrR6bjalPAgYqDKQ7JHpX6+S2SPzSMbbhe7k6cTeD
	tNiZ2VtNCo9q62XufP+932hfMNI0Jqw=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-hLfm6d6XPZ6sbzAxac0rWg-1; Mon, 04 Aug 2025 05:15:27 -0400
X-MC-Unique: hLfm6d6XPZ6sbzAxac0rWg-1
X-Mimecast-MFC-AGG-ID: hLfm6d6XPZ6sbzAxac0rWg_1754298926
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-33228f0cdc6so18178851fa.2
        for <linux-raid@vger.kernel.org>; Mon, 04 Aug 2025 02:15:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754298926; x=1754903726;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mkrRfjQYaOOOEfT/VLhNTKOF6Rg64aCH11W96IXXEYo=;
        b=S7++yrrguYzw3492L4hIU0aTcwIG/ltKNyBJXnwoYr3sdJ6SDU0eGUairKwHooQORq
         jXM2Voyzpf23iEkNCR6cH1x+rxx+lJapJErhwCuRawArd50pAzzVPBDBJd/3M+EuzLUL
         ad/jAkIIeK5EhUiF1VtiJQ49dqjOCVy/ulwElLT87Gxz4iKeTcQfz/bXZQm7JO/Z21/Z
         yryNUmwjPBSdIre91T/sstnKs9+hDXJkoHbVNjnkQPHVAPxo6x5sNLFIyFtSsYhWE1mk
         Vkil74NdyTOCys5GvrKaEovyrgRk5MNyQ6houos/GPRADadD2qd4p6H5Khb63YvXosdh
         52aw==
X-Forwarded-Encrypted: i=1; AJvYcCUMtAuETzz7An2+7lbuVjUwRKLs/aDuo0fIv5ibH7Ds+v8fXhU7mCczM3MFK4buRQ2hY58sUb8CMsP+@vger.kernel.org
X-Gm-Message-State: AOJu0YxBxF70EWDLYK2yH8Rp6zL0wS2WbojDNbw7fMVXT9avZg7Uj60x
	zBP/4J4eeQ2TbYye60nXuiFosv/rsYeMdeSfPQhE/rR+O+d6xtnXo9AcX1N3BNjlWBPsoZQp9r2
	7HXbL+56M+XmvVie6stTkdADEwjrv2OGQGjOb+3NZEkgUBgdbSlDh+w8XrWdqrmq2Vkq0QDe2LE
	91jRuXps4L1XKeojcWLSPqRxADhwkKG04PEr9CkQ==
X-Gm-Gg: ASbGncvzqj4R4zFZ9KUMal2Rta8QuAz7VvOPCVxHBeFfdJbMB5QrRsBzp44epqBR32X
	z13Lqhi2iEK9Hm0zavvXypsJ1aR5xzTWAgDy1bfDTaWvSkY8zbMZa4LR65nIR2FYKt2Hd/3dnpL
	9ciVmff8y0aX6JU3hbmmL5sQ==
X-Received: by 2002:a2e:a99f:0:b0:32b:585e:30bd with SMTP id 38308e7fff4ca-33256796299mr20549691fa.21.1754298926113;
        Mon, 04 Aug 2025 02:15:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7Zwzb8Bs3ToflSuXf+vDmP1MKwtiLfLZJfBga+fvkMIc6FE1GCmyPNIydhZ63d/5VOWgeN4D5RUceAM9Vz9c=
X-Received: by 2002:a2e:a99f:0:b0:32b:585e:30bd with SMTP id
 38308e7fff4ca-33256796299mr20549421fa.21.1754298925623; Mon, 04 Aug 2025
 02:15:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801070346.4127558-1-yukuai1@huaweicloud.com> <20250801070346.4127558-9-yukuai1@huaweicloud.com>
In-Reply-To: <20250801070346.4127558-9-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 4 Aug 2025 17:15:12 +0800
X-Gm-Features: Ac12FXyaMbAWff4USZHAGnpvA7aTVhdXKLgXXyJMJPJQzZPpqs3vokhbOz_BtZc
Message-ID: <CALTww2_jcDJf-55AEvK2fzf2PLnnOfBw5dG4bQG65B9eFw8Xmg@mail.gmail.com>
Subject: Re: [PATCH v5 08/11] md/md-bitmap: add a new method blocks_synced()
 in bitmap_operations
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, corbet@lwn.net, song@kernel.org, yukuai3@huawei.com, 
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, linan122@huawei.com, 
	hare@suse.de, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, yi.zhang@huawei.com, 
	yangerkun@huawei.com, johnny.chenyi@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kuai

I found one thing. The interface ->blocks_synced doesn't work in the
write io path. So there is a risk of data corruption. For example:

mdadm -CR /dev/md0 -l5 -n5 /dev/loop[0-4] --bitmap=3Dlockless (all bits
are unwritten because lazy initial recovery)
1. D1 D2 D3 D4 P1, a small write hits D2. rmw is 2 (need to read old
data of D2 and P1), rcw is 3 (need to read D1 D3 and D4).
2. D2 disk fails
3. read data from disk2. It needs to calculate the data from other
disks. But the result is not the real data which was written to D2

So ->blocks_synced needs to be checked in handle_stripe_dirtying.

Best Regards
Xiao

On Fri, Aug 1, 2025 at 3:11=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Currently, raid456 must perform a whole array initial recovery to build
> initail xor data, then IO to the array won't have to read all the blocks
> in underlying disks.
>
> This behavior will affect IO performance a lot, and nowadays there are
> huge disks and the initial recovery can take a long time. Hence llbitmap
> will support lazy initial recovery in following patches. This method is
> used to check if data blocks is synced or not, if not then IO will still
> have to read all blocks for raid456.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Xiao Ni <xni@redhat.com>
> Reviewed-by: Li Nan <linan122@huawei.com>
> ---
>  drivers/md/md-bitmap.h | 1 +
>  drivers/md/raid5.c     | 6 ++++++
>  2 files changed, 7 insertions(+)
>
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index 95453696c68e..5f41724cbcd8 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -90,6 +90,7 @@ struct bitmap_operations {
>         md_bitmap_fn *end_discard;
>
>         sector_t (*skip_sync_blocks)(struct mddev *mddev, sector_t offset=
);
> +       bool (*blocks_synced)(struct mddev *mddev, sector_t offset);
>         bool (*start_sync)(struct mddev *mddev, sector_t offset,
>                            sector_t *blocks, bool degraded);
>         void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *=
blocks);
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 5285e72341a2..2121f0ff5e30 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3748,6 +3748,7 @@ static int want_replace(struct stripe_head *sh, int=
 disk_idx)
>  static int need_this_block(struct stripe_head *sh, struct stripe_head_st=
ate *s,
>                            int disk_idx, int disks)
>  {
> +       struct mddev *mddev =3D sh->raid_conf->mddev;
>         struct r5dev *dev =3D &sh->dev[disk_idx];
>         struct r5dev *fdev[2] =3D { &sh->dev[s->failed_num[0]],
>                                   &sh->dev[s->failed_num[1]] };
> @@ -3762,6 +3763,11 @@ static int need_this_block(struct stripe_head *sh,=
 struct stripe_head_state *s,
>                  */
>                 return 0;
>
> +       /* The initial recover is not done, must read everything */
> +       if (mddev->bitmap_ops && mddev->bitmap_ops->blocks_synced &&
> +           !mddev->bitmap_ops->blocks_synced(mddev, sh->sector))
> +               return 1;
> +
>         if (dev->toread ||
>             (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)))
>                 /* We need this block to directly satisfy a request */
> --
> 2.39.2
>

