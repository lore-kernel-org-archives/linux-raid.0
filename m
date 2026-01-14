Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC226184
	for <linux-raid@vger.kernel.org>; Wed, 14 Jan 2026 03:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768360569; cv=none; b=bMJpvkSiVHF2sYUeazIapv/10+A4lbhJr752DF/UhnwUQ2mixKsInUvTK7wGismGZ0HU14CgA+bdIh+h0KLp+h38tX1a2U25sIYMHpUyk/TlBJB7ZXuzOw22VBwJmxDaFNgtYbOQ/2blveBMZ5lw/zWO8GGPUNQA9usw0zv1NBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768360569; c=relaxed/simple;
	bh=yNpwSqRJbLrQh2bhwy2s4+TUpL7GLFI1G/5cn2ConF8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jBNKbBRw11DIWkcweFVCzUx++tFTW57pH1d5DkWtCk0uPXs8kC6POWHTrgggASy9BFLidIqN0DkMBKwEEmpOfiBMCIxr0jKC/5NKaIhZXo2A+t0TytDEcQp+h93t3If0cE3mm6cdwHzds2HRtO4pAPbZeCZY6HecLRkMqNcODCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G7olIUfn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gsBXkueh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G7olIUfn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gsBXkueh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768360566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wyUMUhv+3uYdXb9kkgvlEOMDnjWGZVGEqTFQysWiJu4=;
	b=G7olIUfn5Jusgf0tKlB/GcyZKZWRJzDRfIdurRXmUIwVQbfU9K/S9N2L2rHF9I3f2WF8Hf
	fCRsUKCzyMFbFRnj/KnlR9sfszuBcFeHsJXa9CUTVzcZ8G1HJHJ8PtiPESn83srJ7up9v4
	nU+0EUoLhgdBAJ6AZEyByVmV8Ixgjyc=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-c4HQ5B2KOPKQEbsLeRj_kA-1; Tue, 13 Jan 2026 22:16:04 -0500
X-MC-Unique: c4HQ5B2KOPKQEbsLeRj_kA-1
X-Mimecast-MFC-AGG-ID: c4HQ5B2KOPKQEbsLeRj_kA_1768360563
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-59b7a803c5dso379833e87.0
        for <linux-raid@vger.kernel.org>; Tue, 13 Jan 2026 19:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768360563; x=1768965363; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wyUMUhv+3uYdXb9kkgvlEOMDnjWGZVGEqTFQysWiJu4=;
        b=gsBXkueh1hYFw3NvDJCNvKNRZ0xHLwB7jRE7ijul7GBhRijIi/yZYNT8wEGD8MKg0n
         jnHljAUY6PUTz2v8dEDFXrg/J40PIfUyzL6A2bJu59GOd2YszFfc6UL8OjVWX9lg9DB5
         H/cXjhjc9OY1i5eaob+aarHZG1k6xIlghw9K3aNND7O5msSrf6+gBYLtW8eTkqlZQoUf
         KyqfSvDStXpkW+X/4aMoI3ncXn260Fg0q+tsMbmxYfuOsO1U8JZ+e1ezqj4r2SbVQtCk
         ZKJRaJHcSlvJdB8PgxgNLONqueccdtOVJhedLc1xj4nevmwjwNCuYq1WXKVWXmb/acbG
         WmEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768360563; x=1768965363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wyUMUhv+3uYdXb9kkgvlEOMDnjWGZVGEqTFQysWiJu4=;
        b=sB6l0MQUK/LaYoePez6LQbdgsiEfyf0vF5mwLeewlIYUzKUetmD1tz+uE0vM4SW6ii
         R6QNqtnvomGOQZdinfa1F0sEmtmqCF/AjO+beWFdDjmdqHlqLn/ZrMpVhEO4WvyNcAxD
         YyX7B1cNBfzzX/PSI+gMVsmnIfJ3OnDEI0HCqH8eXZcHK14I42rsp7fMW6XwWSYz2Sz3
         rKd5RtN1ippmwu3/Bhd8iOgEpSYa6XS0asvcQr6OXrBWnk/XqG9NW0In26gQvfWFbPAn
         HyaAGBoLmRDfzVx9Zp0Lassl101u+xIbCn1ygm7egVyLvwYE+C53aW2cIWpv221kgQYT
         aFEg==
X-Gm-Message-State: AOJu0YzmDsVKrd+GhnCDxgel/p0aqy/mQyJQ5hja2ZWHaoREe51OzmRx
	c/JHBs4InijnbpSdB+UmmI22/prTy3soPUtSuoDYcfBLuXC6f/pTmrlowd9vjhvvQwWWF/fpbGG
	uBusUNC77zphMdyUN/uyM988i6pMXX1CnZV+hJD6d2vieaQ5taepnnIHzwTiuY6e2Q0PZzpom7z
	T8oaGWspMsxEELE1Q0xj1ZnxO+JZZRTtgBXogIew==
X-Gm-Gg: AY/fxX402RrWu45CFkGrAgdNS/yq/ap9+RH9an9fZyW7utmBqZUe0/tCHOz8lWzb+3V
	6/5cu7Ya3ZszSmGKzGYVuTFh73J7UzJLFqB7Uh4CS0tHqrAh2PhjQ0L+ZzY6QJwrNpu70jLSVW4
	ZoV92YEH5ucl+9r+aAG2zx7Su89aBrMHlANaPB8T48/gexYAS+jNwgNA13Aks7X8S0LQKFRIcLs
	53MIUg6QbHL7MG9XOw9t0qKH7+dWvF6r+VWaucIXQpYs91dM/Eb8GmQeixD/FS1iF2+MQ==
X-Received: by 2002:a05:6512:3da2:b0:59b:6c2c:caeb with SMTP id 2adb3069b0e04-59ba0ed7ccemr401856e87.16.1768360563166;
        Tue, 13 Jan 2026 19:16:03 -0800 (PST)
X-Received: by 2002:a05:6512:3da2:b0:59b:6c2c:caeb with SMTP id
 2adb3069b0e04-59ba0ed7ccemr401847e87.16.1768360562626; Tue, 13 Jan 2026
 19:16:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112042857.2334264-1-yukuai@fnnas.com> <20260112042857.2334264-12-yukuai@fnnas.com>
In-Reply-To: <20260112042857.2334264-12-yukuai@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 14 Jan 2026 11:15:51 +0800
X-Gm-Features: AZwV_QjiKr8I3GMnIqNaWbRZPtu4bVR9qIQvF-jGiIlUD-KpN0F-l1LvxZ2v0Rs
Message-ID: <CALTww29NcgrqK+VJTP++RWZt-=9xnqKjcYgVA7r7OAR5LSkVOw@mail.gmail.com>
Subject: Re: [PATCH v4 11/11] md: fix abnormal io_opt from member disks
To: Yu Kuai <yukuai@fnnas.com>
Cc: linux-raid@vger.kernel.org, linan122@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 12:30=E2=80=AFPM Yu Kuai <yukuai@fnnas.com> wrote:
>
> It's reported that mtp3sas can report abnormal io_opt, for consequence,
> md array will end up with abnormal io_opt as well, due to the
> lcm_not_zero() from blk_stack_limits().
>
> Some personalities will configure optimal IO size, and it's indicate that
> users can get the best IO bandwidth if they issue IO with this size, and
> we don't want io_opt to be covered by member disks with abnormal io_opt.
>
> Fix this problem by adding a new mddev flags MD_STACK_IO_OPT to indicate
> that io_opt configured by personalities is preferred over member disks
> or not.

Hi Kuai

In v4, it doesn't use MD_STACK_IO_OPT anymore. So the comment needs to
be modified.

The patch looks good to me.

Reviewed-by: Xiao Ni <xni@redhat.com>
>
> Reported-by: Filippo Giunchedi <filippo@debian.org>
> Closes: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1121006
> Reported-by: Coly Li <colyli@fnnas.com>
> Closes: https://lore.kernel.org/all/20250817152645.7115-1-colyli@kernel.o=
rg/
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>  drivers/md/md.c     | 28 +++++++++++++++++++++++++++-
>  drivers/md/md.h     |  3 ++-
>  drivers/md/raid1.c  |  2 +-
>  drivers/md/raid10.c |  4 ++--
>  4 files changed, 32 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 731ec800f5cb..6c0fb09c26dc 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6200,18 +6200,33 @@ static const struct kobj_type md_ktype =3D {
>
>  int mdp_major =3D 0;
>
> +static bool rdev_is_mddev(struct md_rdev *rdev)
> +{
> +       return rdev->bdev->bd_disk->fops =3D=3D &md_fops;
> +}
> +
>  /* stack the limit for all rdevs into lim */
>  int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *li=
m,
>                 unsigned int flags)
>  {
>         struct md_rdev *rdev;
> +       bool io_opt_configured =3D lim->io_opt;
>
>         rdev_for_each(rdev, mddev) {
> +               unsigned int io_opt =3D lim->io_opt;
> +
>                 queue_limits_stack_bdev(lim, rdev->bdev, rdev->data_offse=
t,
>                                         mddev->gendisk->disk_name);
>                 if ((flags & MDDEV_STACK_INTEGRITY) &&
>                     !queue_limits_stack_integrity_bdev(lim, rdev->bdev))
>                         return -EINVAL;
> +
> +               /*
> +                * If member disk is not mdraid array, keep the io_opt
> +                * from personality and ignore io_opt from member disk.
> +                */
> +               if (!rdev_is_mddev(rdev) && io_opt_configured)
> +                       lim->io_opt =3D io_opt;
>         }
>
>         /*
> @@ -6230,9 +6245,11 @@ int mddev_stack_rdev_limits(struct mddev *mddev, s=
truct queue_limits *lim,
>  EXPORT_SYMBOL_GPL(mddev_stack_rdev_limits);
>
>  /* apply the extra stacking limits from a new rdev into mddev */
> -int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
> +int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev,
> +                        bool io_opt_configured)
>  {
>         struct queue_limits lim;
> +       unsigned int io_opt;
>
>         if (mddev_is_dm(mddev))
>                 return 0;
> @@ -6245,6 +6262,8 @@ int mddev_stack_new_rdev(struct mddev *mddev, struc=
t md_rdev *rdev)
>         }
>
>         lim =3D queue_limits_start_update(mddev->gendisk->queue);
> +       io_opt =3D lim.io_opt;
> +
>         queue_limits_stack_bdev(&lim, rdev->bdev, rdev->data_offset,
>                                 mddev->gendisk->disk_name);
>
> @@ -6255,6 +6274,13 @@ int mddev_stack_new_rdev(struct mddev *mddev, stru=
ct md_rdev *rdev)
>                 return -ENXIO;
>         }
>
> +       /*
> +        * If member disk is not mdraid array, keep the io_opt from
> +        * personality and ignore io_opt from member disk.
> +        */
> +       if (!rdev_is_mddev(rdev) && io_opt_configured)
> +               lim.io_opt =3D io_opt;
> +
>         return queue_limits_commit_update(mddev->gendisk->queue, &lim);
>  }
>  EXPORT_SYMBOL_GPL(mddev_stack_new_rdev);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ddf989f2a139..80c527b3777d 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -1041,7 +1041,8 @@ int do_md_run(struct mddev *mddev);
>  #define MDDEV_STACK_INTEGRITY  (1u << 0)
>  int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *li=
m,
>                 unsigned int flags);
> -int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev);
> +int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev,
> +                        bool io_opt_configured);
>  void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes);
>
>  extern const struct block_device_operations md_fops;
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 1a957dba2640..f3f3086f27fa 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1944,7 +1944,7 @@ static int raid1_add_disk(struct mddev *mddev, stru=
ct md_rdev *rdev)
>         for (mirror =3D first; mirror <=3D last; mirror++) {
>                 p =3D conf->mirrors + mirror;
>                 if (!p->rdev) {
> -                       err =3D mddev_stack_new_rdev(mddev, rdev);
> +                       err =3D mddev_stack_new_rdev(mddev, rdev, false);
>                         if (err)
>                                 return err;
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 2c6b65b83724..a6edc91e7a9a 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2139,7 +2139,7 @@ static int raid10_add_disk(struct mddev *mddev, str=
uct md_rdev *rdev)
>                         continue;
>                 }
>
> -               err =3D mddev_stack_new_rdev(mddev, rdev);
> +               err =3D mddev_stack_new_rdev(mddev, rdev, true);
>                 if (err)
>                         return err;
>                 p->head_position =3D 0;
> @@ -2157,7 +2157,7 @@ static int raid10_add_disk(struct mddev *mddev, str=
uct md_rdev *rdev)
>                 clear_bit(In_sync, &rdev->flags);
>                 set_bit(Replacement, &rdev->flags);
>                 rdev->raid_disk =3D repl_slot;
> -               err =3D mddev_stack_new_rdev(mddev, rdev);
> +               err =3D mddev_stack_new_rdev(mddev, rdev, true);
>                 if (err)
>                         return err;
>                 conf->fullsync =3D 1;
> --
> 2.51.0
>
>

