Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC361367
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 03:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767668696; cv=none; b=Uo6xJGuj1xQ8TCUmFvFcijxlxaB+xfmgstugkPmH84zboiJh9+2kliJNo9dyrqvHqavyQRMY5HbgnzKGJQTvxWS3kmHs5GGFYZvYc9SLL7AjB5cqlbkyTh49Ve4t3KyTeOflQoNyGH7dhP4A8jnvamZ6daWu+F3P5BIKmGSBXL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767668696; c=relaxed/simple;
	bh=P0e176PwLbKDu3rkHg0xuFTRyL4LQ+VIyfdY81Ikv70=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DyUWWXWFD8+EFCZCAoRvHuWVPwA6coU5vDOhJuRxvku3vMPPehbGoocB1ZrHP4jvxleYeBrDx2Xldx2ff4J4IGQwtIUojEWGo+Sg4FFkpZ6zsvHQN2hu91eiBSBb5gKT19XxGQrrwd2wvuJyvYam3E07Xqr1kwFvRH0cJ3FewAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XRRdicjj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=A0R+2sLl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XRRdicjj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="A0R+2sLl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767668693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lg8uIeL698Qac2RKdgaS7mmI8iqvUdn28UF5jmA/pEk=;
	b=XRRdicjj+4fvbiPP5mGgHX2LqYEyFxZNqlapViUF5E60iVxfGnvoxU6I8dzjZ50sEHmjKv
	1NC5K2Q/M4P/E7KsqD0agKYmOGQZ1Kawf0P7X1gxIcrJ2JeaSgpgQI+CReB4F6e0OhcS9S
	vyjcmGeq1UM1rubyUjRt5SbmPuTdUEs=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-wy4pj0XVMpq5wk0svoV1dw-1; Mon, 05 Jan 2026 22:04:52 -0500
X-MC-Unique: wy4pj0XVMpq5wk0svoV1dw-1
X-Mimecast-MFC-AGG-ID: wy4pj0XVMpq5wk0svoV1dw_1767668691
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-37a4fb06b1fso3211461fa.2
        for <linux-raid@vger.kernel.org>; Mon, 05 Jan 2026 19:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767668690; x=1768273490; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lg8uIeL698Qac2RKdgaS7mmI8iqvUdn28UF5jmA/pEk=;
        b=A0R+2sLlSYg69WpjMqQu4j05JGC6LkJ+d1ez+VxkSPKdX0LCKiBA+v57oo4/NSJ5MI
         3yLhSeoSf8EqhQiEKJbMp9U9hV3p9lzk7TG0oyw4gpwFE6QCq7yQX672uiBhC7vQv8nH
         cqcR81Fyau+T2W15TYIT8AUQmzVt/Ob7jHHPWk0BHewrXjO1tPL/xPZ6hkynrAfrZStp
         lohd0RZs09iXvaVt0F83GN2X33uMMd8ObCuHPsICGj6uCQw+xDML3Zn9/gyJJ7LyjK07
         NnudfhxNa1iUVFkWY2bw/tjpC4Dr+v/FC21IFXf+Rs/uSspIx3KhuQdnPnVxxalXF6vf
         8fmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767668690; x=1768273490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lg8uIeL698Qac2RKdgaS7mmI8iqvUdn28UF5jmA/pEk=;
        b=GTqw6ORFD9ich4f0erY/JoY7Qanl0bPhNn7l/dpyVUNu80AeCwwRLjcrLYgYqBpDm7
         ASVDJ/ugPZhOwNSMV99CjKEJs8yZzKfpoijPJbTYjIRciNLDDgMHPGfVeZXclsmJrYh/
         0fQ9rxC6aLBwEfymVF8X9NIgjq49PvSuJzekr8WMkueOgZydlp+ZnnxWjIu5bsDlfTae
         eywXbnfzUpo+u9gcc18n9UuT0zUAFp0z7GfASoJATtKPwC4zfebzJu9cVCacc3o1NnQc
         MTQrjh3UCws68TYN6iDOvYQoaFJx2J7wg5p+VkAgz6gdFTeBgS/Dog7fYQRvecg5v2pP
         3bNA==
X-Gm-Message-State: AOJu0YyTiTp4bfzArtZsCJrFIFBEIzUzr/DJfEm9CC2HalMu80SK4vDI
	xlaQAA8QtNQZjDt6s9iYGeP5gQYKqTRYv9ZnspeEdzSMvEJcZaI7Yett7PF9u9CQO4fIARqx0wH
	Wm+tH2BQpuT/3n7+8drYqPHhN32px0+rvXU+Y3PXAZ5MtZcMJcw9FbJdQ8DvJAU5l4rIT27AB42
	u0nmKBrrz53JQR9kpv2jCP9OyPnMl8e+xheDgM/A==
X-Gm-Gg: AY/fxX6nbcu7lmpxm17rx6s23LoPwdsWrOhvHqipkYYPzHsuFnX5JcbIqdY0znRnxzJ
	Gr4iMpkABibNC/7eRJTNK/rZEszKb9i6gVKZsEUPtIIYfnecXVXkhOZP8JO20NpNCV9X5CCKfZH
	HuhQ1z7UQS2QVkb1kZlZStI4EuGMTw+Zo8YlLHuZyyrLs20ZmTmzHd68GrU8wpkK1EgOJ1fCxCY
	Br+wZwjexMMaBauSR/TIntAZZJcZV8KrhMp3PO9FW0sQnqYUzCnLDSmjIXXPLDclt3jlA==
X-Received: by 2002:a05:6512:3d0f:b0:594:2f72:2f7f with SMTP id 2adb3069b0e04-59b65279f22mr562047e87.6.1767668690448;
        Mon, 05 Jan 2026 19:04:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHTd41nddLnOn7aKp0p8nWQRV1aKVcZdTXVEzHX6dytAUoEo88eh/UheAVnyMcqFdTTCy/xPVRcuN48ksL5i7Q=
X-Received: by 2002:a05:6512:3d0f:b0:594:2f72:2f7f with SMTP id
 2adb3069b0e04-59b65279f22mr562043e87.6.1767668690021; Mon, 05 Jan 2026
 19:04:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260103154543.832844-1-yukuai@fnnas.com> <20260103154543.832844-7-yukuai@fnnas.com>
In-Reply-To: <20260103154543.832844-7-yukuai@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 6 Jan 2026 11:04:38 +0800
X-Gm-Features: AQt7F2pEn2UO_dyQKZbIZVpgqlPdFo98EhUCO1sfniO2CuIJzynPhcooQY51u2Q
Message-ID: <CALTww29zCpqQf2oNcWwps=eVuM+UdLvY7+FqNcGMkTYDzS8kGw@mail.gmail.com>
Subject: Re: [PATCH v2 06/11] md: support to align bio to limits
To: Yu Kuai <yukuai@fnnas.com>
Cc: linux-raid@vger.kernel.org, colyli@fnnas.com, linan122@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 3, 2026 at 11:46=E2=80=AFPM Yu Kuai <yukuai@fnnas.com> wrote:
>
> For personalities that report optimal IO size, it's indicate that users

Hi Kuai

type error here
s/it's indicate/it indicates/g

Regards
Xiao

> can get the best IO bandwidth if they issue IO with this size. However
> there is also an implicit condition that IO should also be aligned to the
> optimal IO size.
>
> Currently, bio will only be split by limits, if bio offset is not aligned
> to limits, then all split bio will not be aligned. This patch add a new
> feature to align bio to limits first, and following patches will support
> this for each personality if necessary.
>
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>  drivers/md/md.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/md/md.h |  2 ++
>  2 files changed, 48 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 21b0bc3088d2..7292aedef01b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -428,6 +428,48 @@ bool md_handle_request(struct mddev *mddev, struct b=
io *bio)
>  }
>  EXPORT_SYMBOL(md_handle_request);
>
> +static struct bio *__md_bio_align_to_limits(struct mddev *mddev,
> +                                           struct bio *bio)
> +{
> +       unsigned int max_sectors =3D mddev->gendisk->queue->limits.max_se=
ctors;
> +       sector_t start =3D bio->bi_iter.bi_sector;
> +       sector_t align_start =3D roundup(start, max_sectors);
> +       sector_t end;
> +       sector_t align_end;
> +
> +       /* already aligned */
> +       if (align_start =3D=3D start)
> +               return bio;
> +
> +       end =3D start + bio_sectors(bio);
> +       align_end =3D rounddown(end, max_sectors);
> +
> +       /* bio is too small to split */
> +       if (align_end <=3D align_start)
> +               return bio;
> +
> +       return bio_submit_split_bioset(bio, align_start - start,
> +                                      &mddev->gendisk->bio_split);
> +}
> +
> +static struct bio *md_bio_align_to_limits(struct mddev *mddev, struct bi=
o *bio)
> +{
> +       if (!test_bit(MD_BIO_ALIGN, &mddev->flags))
> +               return bio;
> +
> +       /* atomic write can't split */
> +       if (bio->bi_opf & REQ_ATOMIC)
> +               return bio;
> +
> +       switch (bio_op(bio)) {
> +       case REQ_OP_READ:
> +       case REQ_OP_WRITE:
> +               return __md_bio_align_to_limits(mddev, bio);
> +       default:
> +               return bio;
> +       }
> +}
> +
>  static void md_submit_bio(struct bio *bio)
>  {
>         const int rw =3D bio_data_dir(bio);
> @@ -443,6 +485,10 @@ static void md_submit_bio(struct bio *bio)
>                 return;
>         }
>
> +       bio =3D md_bio_align_to_limits(mddev, bio);
> +       if (!bio)
> +               return;
> +
>         bio =3D bio_split_to_limits(bio);
>         if (!bio)
>                 return;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b8c5dec12b62..e7aba83b708b 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -347,6 +347,7 @@ struct md_cluster_operations;
>   * @MD_HAS_SUPERBLOCK: There is persistence sb in member disks.
>   * @MD_FAILLAST_DEV: Allow last rdev to be removed.
>   * @MD_SERIALIZE_POLICY: Enforce write IO is not reordered, just used by=
 raid1.
> + * @MD_BIO_ALIGN: Bio issued to the array will align to io_opt before sp=
lit.
>   *
>   * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is add=
ed
>   */
> @@ -366,6 +367,7 @@ enum mddev_flags {
>         MD_HAS_SUPERBLOCK,
>         MD_FAILLAST_DEV,
>         MD_SERIALIZE_POLICY,
> +       MD_BIO_ALIGN,
>  };
>
>  enum mddev_sb_flags {
> --
> 2.51.0
>
>

