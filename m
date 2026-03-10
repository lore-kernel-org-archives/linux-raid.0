Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A714175A78
	for <linux-raid@vger.kernel.org>; Tue, 10 Mar 2026 01:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773104815; cv=pass; b=LZB7zfK3cbYFeJKnBlVveaoH/DykCVRXI4MVVbk0wUHck6Yw6LBqv4CPmN41SY5ailH5cXMdYFB1ajWGlEZcB5p6KfO/CR68E9PbCoB0jzs//LBBvPlVBtDfgpGd7U920VLxju3i5fam+DBZWJqUhGLxPOoyUaxm2cJM46sgJOI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773104815; c=relaxed/simple;
	bh=bRvRTrDxKLycC+M/85XctRx1lZ+Am+POG0w+a2Rg4sI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qBTaqX/WZLhkcX0lsR8uI/XkgNXqfelwTwilSk/VdpLbq+3T4/O4wDmcWpxsZS2R87+xmErmtDrPE3xaSGBuOZagfVVWBwTxiS+bwNUNx+bQOn7wsg9ieGYzizPWmXQ4ljyeSv05/lt+psCxSu6lYVC0bvmUI90vzmY6xKu5irs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G/odAq6W; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YkNMfQa8; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G/odAq6W";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YkNMfQa8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773104813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WGBtFSyfYJHKIjwDIzsN6E9uUCpP2EsCk2AYnCXvlVc=;
	b=G/odAq6WbocaVETPGhd+j9/u5j3k/NMXleQN2edRXz6gxXK7Qu1tNc4gAC60LIRcdaJSfA
	7wLOwsaXNpYyACTae1wd0V57JINXgYK3B5sDNxRFXINRg4lShdD2xrR8czys3rdbv8qxTy
	TziBqQnDqUND+L9b3S7N6uTl/+LhVCw=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-O8V7WOw-OcSIu_3UE7DIEg-1; Mon, 09 Mar 2026 21:06:51 -0400
X-MC-Unique: O8V7WOw-OcSIu_3UE7DIEg-1
X-Mimecast-MFC-AGG-ID: O8V7WOw-OcSIu_3UE7DIEg_1773104810
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-38a4bad9985so6700991fa.0
        for <linux-raid@vger.kernel.org>; Mon, 09 Mar 2026 18:06:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773104810; cv=none;
        d=google.com; s=arc-20240605;
        b=Bs5WKWhZZXPrEvwzyy8gXVPV5gHT7QxAVi2XgTvikrzkRcMfAK4+iddFzxuerdjqkH
         U3JCAPEArFkYaR6WcF3uLrgNK3Nqa0Meze5p27c44BOsgNoklcKG7Nhb2Fi0C+zAL2cd
         9nbG+yq8E3a7Yhq62926EzSft8DAwnWAdgJHsvE1gbztGEBz21Yg6W1vkAbckEFZF1pa
         g2Xh2DtO2z71H0f/ue74Vk3FYpV5VTC9ZATsaWEgLuSmWqwT+fywPHyqhP74HMkXv5hT
         kgsqja7RHgdbGdFfnrxAnOEbSLiu6q+LxrQMUzuJVUvWaG5nywPe11mMGeO5G+DlcpKj
         aYHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WGBtFSyfYJHKIjwDIzsN6E9uUCpP2EsCk2AYnCXvlVc=;
        fh=6kJZi+soObaVnno/HJOCh43NCK5a+vdGd9/W2wRHJCY=;
        b=eV9ypCICsNfu7qx1czu9fh4qvj7ycw1yPaIJ0E1nLc/MEwuhilCukeq6HbOqhqu+nR
         e1HHgEY/sEdXx1IDlh6zYPgBkOzQaqdEBKYDlrJarzWiD/Lq6E+1f4Q2CwtsfoRy9Uzg
         KkzASrNqdl2nT5Uux8GevXGtPIVHNPNpdIr/elgnHs/bdloy0yo6rb292XNr7QCzv/Cn
         c4xlsNZlGzsXlBOG/ydNWtD6zWaYusiVa77s5i/MbhphSEbYQEIrE+HXEHx+Mw5LOM4H
         C2souuFX/UkDb3rKtUnvY+6++AgKvskJPMxF2qUJzHX0At2fW/9mpJJ7EjXkophhD5gW
         UA5w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773104810; x=1773709610; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WGBtFSyfYJHKIjwDIzsN6E9uUCpP2EsCk2AYnCXvlVc=;
        b=YkNMfQa8/s9ADAjHFsXo5xJ3MOb6oE07UPt7qjiNtJexJeZzcp6Il8ZdK5/979uLoj
         ajp5CJQgBYOBvbO12eiLmeyAuocWjgXbyjdSyfMdbP4KSPm40loyzPC8Kv/io1sn5/Rs
         JRQeuf89fRYn+p38JKiVAxzD4YWwYwtmOtj5IqnwRcvq+RyRGx6OM9kuY9IZD5Tl1o/3
         AkrDo7b13bVBM3C4+sHdhTq9RhiWHUdaaKuDLtY7pj3z0QM1y2siUBvL5k5x+vQscafC
         eTRPgamUF4iSoHxbH4mDizumSVbI7usouO9roBvDFC2lG5P3i6vocU4QqsVDHidm1Rxc
         oRqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773104810; x=1773709610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WGBtFSyfYJHKIjwDIzsN6E9uUCpP2EsCk2AYnCXvlVc=;
        b=AMPItlPusVkYmLU98o1WofBsl53RvrG3AWyWte3Wwz7Jx0unpjP6QYmbwgtFYNHKOf
         4NwzDbYBFoS51lDyNJt9y0OYk8cObtEnkDcmDvVKK5mYkQTf4cZ0KsHg4T9jmC4kmVa6
         Dbc+lC1jE7DcgppKwzVubJDivzuxXkIPOK5lu0cJrpFIvRf8H17Mbk8NL4KIPJUaIHA1
         I+yN68RY2M0khPWoW7vc0WhnU7ecc/49mvYk/kxCeAleQtxG6M8IIvTtRJTlLNQ/6Z8l
         6pC2EFrFlziaGSJN0UKHgmp+SQhDPNUqKODhja9DkYioHd+SUHRKznxxZt7QUaDRAGu9
         3m/g==
X-Forwarded-Encrypted: i=1; AJvYcCVOZpa08TVkAjhUY5KsOiQ1LgH1vHDV+qe0FPvV1asdREcdF2u9CYUWcRAJwKtkH5za87BaPupf0vZC@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0LuFeJsVoS4sePtyi5IEVof5ccH2zlglLTOq5aoV+plinf1eu
	4/DYsY6wVivEUF7d3Z3AdGGZBoB5m2DjMmkwQUcnVTzRoNFe+l9OguGg564ROJVVrBPBTp/hxnh
	3nVUSV7Xa0QNbnjnCX+KvGoOc/K/A/InaiVGwhxTZ23sHpjGXdRv+UZGpkDOY6Qj7yVTwltrTz7
	8KcO90EnfqXU8lYsa6xM2MBPobDsXL2mrJfvm8gw==
X-Gm-Gg: ATEYQzwOr4aW/shWbCXuggDZrq3HHoVjTuOMDsOv7ifUxsdilV/4SQhsW6gBUkYiaoP
	LnG4Z+jaCZKXFLkxGStEGLMrB81q4HBKuhDHEvhmFKfZN1w4Mm2dLrdO112f98F7fe6z0tSZyMx
	JVvlepvkImvymJmP6jRlXqfra6/q15to8m9VrTOkIroIa+Y41E+lmWemtOh9t6hlg7zMejWTzr4
	3CLOYMfPj7EoS+5/k2ewzk9aHqx0WURhHy7O1kayOseg9Je65q7lA56diK+3LVK0Pf2RHdUW5lw
	DciFog==
X-Received: by 2002:a05:6512:3b2b:b0:5a1:18a7:e149 with SMTP id 2adb3069b0e04-5a14e4a0445mr500127e87.24.1773104809982;
        Mon, 09 Mar 2026 18:06:49 -0700 (PDT)
X-Received: by 2002:a05:6512:3b2b:b0:5a1:18a7:e149 with SMTP id
 2adb3069b0e04-5a14e4a0445mr500118e87.24.1773104809506; Mon, 09 Mar 2026
 18:06:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260223024038.3084853-1-yukuai@fnnas.com> <20260223024038.3084853-4-yukuai@fnnas.com>
In-Reply-To: <20260223024038.3084853-4-yukuai@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 10 Mar 2026 09:06:37 +0800
X-Gm-Features: AaiRm52dr-NseNTB6h_lby7afTn1qZbN3wHE_aUyBTB9cbNzXjIR-iCbM4z3AjY
Message-ID: <CALTww28rtki9J=_GB1zf4N5FBcdz+vzSvB1bNb-O2-AgrUzgSA@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] md: add fallback to correct bitmap_ops on version mismatch
To: Yu Kuai <yukuai@fnnas.com>
Cc: song@kernel.org, linan122@huawei.com, colyli@fnnas.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2026 at 10:43=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>
> If default bitmap version and on-disk version doesn't match, and mdadm
> is not the latest version to set bitmap_type, set bitmap_ops based on
> the disk version.

Hi Kuai

How can I do test to check if this patch works?

1. Create array with llbitmap
2. Stop the array
3. uninstall mdadm with llbitmap support and install mdadm without llbitmap
4. assemble the array

Is it the case you want to fix?

Regards
Xiao
>
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>  drivers/md/md.c | 111 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 110 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 72a1c7267851..245785ad0ffd 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6447,15 +6447,124 @@ static void md_safemode_timeout(struct timer_lis=
t *t)
>
>  static int start_dirty_degraded;
>
> +/*
> + * Read bitmap superblock and return the bitmap_id based on disk version=
.
> + * This is used as fallback when default bitmap version and on-disk vers=
ion
> + * doesn't match, and mdadm is not the latest version to set bitmap_type=
.
> + */
> +static enum md_submodule_id md_bitmap_get_id_from_sb(struct mddev *mddev=
)
> +{
> +       struct md_rdev *rdev;
> +       struct page *sb_page;
> +       bitmap_super_t *sb;
> +       enum md_submodule_id id =3D ID_BITMAP_NONE;
> +       sector_t sector;
> +       u32 version;
> +
> +       if (!mddev->bitmap_info.offset)
> +               return ID_BITMAP_NONE;
> +
> +       sb_page =3D alloc_page(GFP_KERNEL);
> +       if (!sb_page) {
> +               pr_warn("md: %s: failed to allocate memory for bitmap\n",
> +                       mdname(mddev));
> +               return ID_BITMAP_NONE;
> +       }
> +
> +       sector =3D mddev->bitmap_info.offset;
> +
> +       rdev_for_each(rdev, mddev) {
> +               u32 iosize;
> +
> +               if (!test_bit(In_sync, &rdev->flags) ||
> +                   test_bit(Faulty, &rdev->flags) ||
> +                   test_bit(Bitmap_sync, &rdev->flags))
> +                       continue;
> +
> +               iosize =3D roundup(sizeof(bitmap_super_t),
> +                                bdev_logical_block_size(rdev->bdev));
> +               if (sync_page_io(rdev, sector, iosize, sb_page, REQ_OP_RE=
AD,
> +                                true))
> +                       goto read_ok;
> +       }
> +       pr_warn("md: %s: failed to read bitmap from any device\n",
> +               mdname(mddev));
> +       goto out;
> +
> +read_ok:
> +       sb =3D kmap_local_page(sb_page);
> +       if (sb->magic !=3D cpu_to_le32(BITMAP_MAGIC)) {
> +               pr_warn("md: %s: invalid bitmap magic 0x%x\n",
> +                       mdname(mddev), le32_to_cpu(sb->magic));
> +               goto out_unmap;
> +       }
> +
> +       version =3D le32_to_cpu(sb->version);
> +       switch (version) {
> +       case BITMAP_MAJOR_LO:
> +       case BITMAP_MAJOR_HI:
> +       case BITMAP_MAJOR_CLUSTERED:
> +               id =3D ID_BITMAP;
> +               break;
> +       case BITMAP_MAJOR_LOCKLESS:
> +               id =3D ID_LLBITMAP;
> +               break;
> +       default:
> +               pr_warn("md: %s: unknown bitmap version %u\n",
> +                       mdname(mddev), version);
> +               break;
> +       }
> +
> +out_unmap:
> +       kunmap_local(sb);
> +out:
> +       __free_page(sb_page);
> +       return id;
> +}
> +
>  static int md_bitmap_create(struct mddev *mddev)
>  {
> +       enum md_submodule_id orig_id =3D mddev->bitmap_id;
> +       enum md_submodule_id sb_id;
> +       int err;
> +
>         if (mddev->bitmap_id =3D=3D ID_BITMAP_NONE)
>                 return -EINVAL;
>
>         if (!mddev_set_bitmap_ops(mddev))
>                 return -ENOENT;
>
> -       return mddev->bitmap_ops->create(mddev);
> +       err =3D mddev->bitmap_ops->create(mddev);
> +       if (!err)
> +               return 0;
> +
> +       /*
> +        * Create failed, if default bitmap version and on-disk version
> +        * doesn't match, and mdadm is not the latest version to set
> +        * bitmap_type, set bitmap_ops based on the disk version.
> +        */
> +       mddev_clear_bitmap_ops(mddev);
> +
> +       sb_id =3D md_bitmap_get_id_from_sb(mddev);
> +       if (sb_id =3D=3D ID_BITMAP_NONE || sb_id =3D=3D orig_id)
> +               return err;
> +
> +       pr_info("md: %s: bitmap version mismatch, switching from %d to %d=
\n",
> +               mdname(mddev), orig_id, sb_id);
> +
> +       mddev->bitmap_id =3D sb_id;
> +       if (!mddev_set_bitmap_ops(mddev)) {
> +               mddev->bitmap_id =3D orig_id;
> +               return -ENOENT;
> +       }
> +
> +       err =3D mddev->bitmap_ops->create(mddev);
> +       if (err) {
> +               mddev_clear_bitmap_ops(mddev);
> +               mddev->bitmap_id =3D orig_id;
> +       }
> +
> +       return err;
>  }
>
>  static void md_bitmap_destroy(struct mddev *mddev)
> --
> 2.51.0
>
>

