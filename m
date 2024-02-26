Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EAB129A70
	for <linux-raid@vger.kernel.org>; Mon, 26 Feb 2024 13:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708955228; cv=none; b=Faf58XaWl5GhFONJfcaa7f5xlWS2gfTF5KhxVbtfiUCGwwpW7Q2IhbhWtBSDHJ5r0NWLeFPhMji6WkOyaNUXzLB/9Oem+zs94Lx5IzathMaGpABg8N5XwZWTqip4q9vHhJmVrydeN5hKxQ+etVV6uw68ArkQl4eiG7fp27W3rRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708955228; c=relaxed/simple;
	bh=81sdhCcN9wporVYbJerD7h86zygDNdYtXMFH1Wo/mCU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cUm40pgEm2GduwnjL+6TOFx1vJjJmDBMcWSSyX5iOCWHkit4LOVSR/EomzT0wKtFDCabw284L772Qa8MtMDm+BwGMtkLJPiKHSA8aaHhde28iR9uxl8N2McCfinw3qbH7aFNWjBySELZrScY973wiReRs6yuhWDdRSF+4yF0p00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eepDTaBq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eepDTaBq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708955224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=USZoAZmeJUCkk8eKkEZ4nGh7Q9sDulz8ByqxvL+GExk=;
	b=eepDTaBqwgQ176Lgzb5axDNvOK0H2VtvBKqveHgAcQ4lcWAmxrmYa2wSzuAOE71Mzmn1oq
	Btpztr/W7PXsvMAQbe+gQVSkS83aPj+0lam/SJpD1z1Z9Fd7NgbRowmMhbk8tuxgQRa+Kx
	TEid6sKF1bQbk7W8QS7vE7GQcNfLOwI=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-CwWErl28OmGzs2RGdiExcg-1; Mon, 26 Feb 2024 08:47:02 -0500
X-MC-Unique: CwWErl28OmGzs2RGdiExcg-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1dcabe5b779so5826555ad.0
        for <linux-raid@vger.kernel.org>; Mon, 26 Feb 2024 05:47:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708955221; x=1709560021;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=USZoAZmeJUCkk8eKkEZ4nGh7Q9sDulz8ByqxvL+GExk=;
        b=HAn8kH7dn8/lOBTD/TpUpGKimxV+WfmgePdCGQ95a0+/fM+hTO2YolcgLlNlyIkqJ8
         nDdQ8+sj6+w2rFJVw999ruke626nJx2mXeEpiW9IKBmTJBmIA1pC0pWcay9jAopbAV+X
         L9Ex65OeXuVtQm1DZwnRoFLAt752wUn+KOdHX98VJQsTSu1UT1+qRM+tKOEut9Ey1Est
         vd1sqrd9qENIu/jBckRIBTRxsZbZQONfawiVyBkvSEngSrEEBtzpjzQT3YaTawkfh/6m
         2pEvYPB5EfGBOtBTP66tRL5buCGmOOdQN7+pjRiewp3GY/vflXsgAujIlLiJuNyP8qAV
         5DtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWztnOihZkthj2rXAofuxrgdQnXRvV9r0IB5oFlAGpnjSa9WY6fLmoMArqf8zeXQk+LgaDO3IeYIgaWySKWYs8ka8YC94q71irSlg==
X-Gm-Message-State: AOJu0YwwCh7vMTQEgbUriD5egMbcaDY8N2sZNU+BMNlSgbshXAvcGh3J
	HB6RjyNjR6uejeZmkbdutU0j5ZfiL4CidVb4OPWBV0kK1kfYMHa/AhN5Po6J+dClOnHGDDq5Hfm
	v6iSTmgLikMyMe0zJKb/0PWp6T0L2TEsggeAyMUHyFzV96RFOBV4AtJmISQRr+KjPJHgu4ccYmT
	ddyoqpVEWYx27WkrVfJ+tThKPwQOhMgCr7GZmrsij6q7sg
X-Received: by 2002:a17:902:ec82:b0:1dc:7719:7095 with SMTP id x2-20020a170902ec8200b001dc77197095mr11309437plg.60.1708955221375;
        Mon, 26 Feb 2024 05:47:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF3wu1znA06e66UTQp6LckmdvIqmqkOe3t5EVXB0YykdFUD+gBcwlUT/cbbm9iOl+jzbZbULqAKTii64tztJm8=
X-Received: by 2002:a17:902:ec82:b0:1dc:7719:7095 with SMTP id
 x2-20020a170902ec8200b001dc77197095mr11309407plg.60.1708955221062; Mon, 26
 Feb 2024 05:47:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222075806.1816400-1-yukuai1@huaweicloud.com> <20240222075806.1816400-6-yukuai1@huaweicloud.com>
In-Reply-To: <20240222075806.1816400-6-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 26 Feb 2024 21:46:49 +0800
Message-ID: <CALTww28NoA4bF=gRYVEE_yYwXMdhYC4hwP2Fo0Tbgv7zAp1bwA@mail.gmail.com>
Subject: Re: [PATCH md-6.9 05/10] md/raid1-10: factor out a new helper raid1_should_read_first()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: paul.e.luse@linux.intel.com, song@kernel.org, neilb@suse.com, shli@fb.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, 
	yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 22, 2024 at 4:05=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> If resync is in progress, read_balance() should find the first usable
> disk, otherwise, data could be inconsistent after resync is done. raid1
> and raid10 implement the same checking, hence factor out the checking
> to make code cleaner.
>
> Noted that raid1 is using 'mddev->recovery_cp', which is updated after
> all resync IO is done, while raid10 is using 'conf->next_resync', which
> is inaccurate because raid10 update it before submitting resync IO.
> Fortunately, raid10 read IO can't concurrent with resync IO, hence there
> is no problem. And this patch also switch raid10 to use
> 'mddev->recovery_cp'.
>
> Co-developed-by: Paul Luse <paul.e.luse@linux.intel.com>
> Signed-off-by: Paul Luse <paul.e.luse@linux.intel.com>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/raid1-10.c | 20 ++++++++++++++++++++
>  drivers/md/raid1.c    | 15 ++-------------
>  drivers/md/raid10.c   | 13 ++-----------
>  3 files changed, 24 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index 9bc0f0022a6c..2ea1710a3b70 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -276,3 +276,23 @@ static inline int raid1_check_read_range(struct md_r=
dev *rdev,
>         *len =3D first_bad + bad_sectors - this_sector;
>         return 0;
>  }
> +
> +/*
> + * Check if read should choose the first rdev.
> + *
> + * Balance on the whole device if no resync is going on (recovery is ok)=
 or
> + * below the resync window. Otherwise, take the first readable disk.
> + */
> +static inline bool raid1_should_read_first(struct mddev *mddev,
> +                                          sector_t this_sector, int len)
> +{
> +       if ((mddev->recovery_cp < this_sector + len))
> +               return true;
> +
> +       if (mddev_is_clustered(mddev) &&
> +           md_cluster_ops->area_resyncing(mddev, READ, this_sector,
> +                                          this_sector + len))
> +               return true;
> +
> +       return false;
> +}
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index d0bc67e6d068..8089c569e84f 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -605,11 +605,6 @@ static int read_balance(struct r1conf *conf, struct =
r1bio *r1_bio, int *max_sect
>         struct md_rdev *rdev;
>         int choose_first;
>
> -       /*
> -        * Check if we can balance. We can balance on the whole
> -        * device if no resync is going on, or below the resync window.
> -        * We take the first readable disk when above the resync window.
> -        */
>   retry:
>         sectors =3D r1_bio->sectors;
>         best_disk =3D -1;
> @@ -618,16 +613,10 @@ static int read_balance(struct r1conf *conf, struct=
 r1bio *r1_bio, int *max_sect
>         best_pending_disk =3D -1;
>         min_pending =3D UINT_MAX;
>         best_good_sectors =3D 0;
> +       choose_first =3D raid1_should_read_first(conf->mddev, this_sector=
,
> +                                              sectors);
>         clear_bit(R1BIO_FailFast, &r1_bio->state);
>
> -       if ((conf->mddev->recovery_cp < this_sector + sectors) ||
> -           (mddev_is_clustered(conf->mddev) &&
> -           md_cluster_ops->area_resyncing(conf->mddev, READ, this_sector=
,
> -                   this_sector + sectors)))
> -               choose_first =3D 1;
> -       else
> -               choose_first =3D 0;
> -
>         for (disk =3D 0 ; disk < conf->raid_disks * 2 ; disk++) {
>                 sector_t dist;
>                 sector_t first_bad;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 1f6693e40e12..22bcc3ce11d3 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -747,17 +747,8 @@ static struct md_rdev *read_balance(struct r10conf *=
conf,
>         best_good_sectors =3D 0;
>         do_balance =3D 1;
>         clear_bit(R10BIO_FailFast, &r10_bio->state);
> -       /*
> -        * Check if we can balance. We can balance on the whole
> -        * device if no resync is going on (recovery is ok), or below
> -        * the resync window. We take the first readable disk when
> -        * above the resync window.
> -        */
> -       if ((conf->mddev->recovery_cp < MaxSector
> -            && (this_sector + sectors >=3D conf->next_resync)) ||
> -           (mddev_is_clustered(conf->mddev) &&
> -            md_cluster_ops->area_resyncing(conf->mddev, READ, this_secto=
r,
> -                                           this_sector + sectors)))
> +
> +       if (raid1_should_read_first(conf->mddev, this_sector, sectors))
>                 do_balance =3D 0;
>
>         for (slot =3D 0; slot < conf->copies ; slot++) {
> --
> 2.39.2
>
>

This patch looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

