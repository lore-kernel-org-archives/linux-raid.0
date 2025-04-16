Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5951C28373
	for <linux-raid@vger.kernel.org>; Wed, 16 Apr 2025 05:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744781551; cv=none; b=ljjHfdpkONuhOiw56tCmgGNc0uSvMLzXPjlVjjlqkW+gnauXwljtnUgtKDaEdBBaBsvIhZ3Kg1Iu//GoaSK/2P1QAnXAVpnIJbFuw/S5WLzCwavm5cuBOD5WPC3c/39oavzYeleTrC4X+dUF+YTzt4mlEHtiUJHyBONei5xvZiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744781551; c=relaxed/simple;
	bh=2AX8eHN304eez/lPBhrNmSK3jADYbtAxlj1qGYGX+Rw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JGOMNdkvZr2nJRKxZVbWIxvTx2w6gDWcCa6wIm3GquPaFSMjPSbBvCCjps/VqUeMw6Ifbva+4XzpsjeGbpz1uCV5ZIJUo2rd3SIYYM19CIdN8mCtxC1e47uC05VAqoG51l56/RWiNfCE3nGALLt4kbuQNlr1kNctLgTr4o0yzN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LZHWEr50; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LZHWEr50"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744781547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7DUKNPYms5ndImHtnx/7SOlMI/tokulKdqziuD6CP6w=;
	b=LZHWEr50ggUe3XaYlAAM/nwr6gDDYffCozgj9QRM/9kU65qVqddQTJ5U+OU5n5dHnpMlGg
	f3fLdAz5QkKnQEbn22mFgUTNFLlIomxSSyp0Mw7vwm8GsMXwKKjwLLDNgFqXLyCCurJNWC
	wBhUkGBECiK/Do7uE1uGfOlZHxvXDtc=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-341-wVHUg0iBNGWMIAVJis8MFw-1; Wed, 16 Apr 2025 01:32:25 -0400
X-MC-Unique: wVHUg0iBNGWMIAVJis8MFw-1
X-Mimecast-MFC-AGG-ID: wVHUg0iBNGWMIAVJis8MFw_1744781543
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-30bfee3663dso1833691fa.0
        for <linux-raid@vger.kernel.org>; Tue, 15 Apr 2025 22:32:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744781543; x=1745386343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7DUKNPYms5ndImHtnx/7SOlMI/tokulKdqziuD6CP6w=;
        b=ARK76Keh5Iq/YGDB/RMtL6u+0cmVju98PA0OezE+s3OhZQ8DOiTcL4yjWWeQivrc0S
         8cFexXV7G3Wa+UKMZbczTnfSt2XavE1w2DgENyE0beQAMqTXPaFZioO9OsXFuARhcRF/
         d5nDQtK4sRsgdxJHNpjt5ZV2GSAgiIghzkM/lfCHa+K9uu82N2+KoEFmE5eksypXyh6m
         HDR3aYuL0dHe0BnGn6kHQqdkL4gAgnzYOR7NNwiJyUCoKCllIk0QPdhUfRNxDJhFpBRA
         OcVQkR+KAYlf44TEmsIC2pRk3Flry6X9vUFqQMlpcrPZnSEHu2BBSW086umLidLN+jLW
         +Mdw==
X-Forwarded-Encrypted: i=1; AJvYcCWoEDsgC9aCI/ovCfiMqfQUfGx56X443AVUtS6oFaKIE0YCG7etYl2P5yr6SZi1BB/w/unS1OhNoSVq@vger.kernel.org
X-Gm-Message-State: AOJu0YxoDSkJgguU3AeDIT6jSkmpTf23DBMh6VPYPOSJeah/Rt7YX5s0
	Ak/lexRWHNdGUSBCdO1jyMrgVvScB8+wbMzUnTRbI4RB1I7SsPZaN1GXNnG+q4IF/OLFzqne+j0
	i4Gcm5qLb9Fv5A6RfiJEUJfQt7bw3b+RGdiNsd4nmIqElW+lLTAzcq49UOKifaxuY5lYebMjfX/
	GLHO1xCx/PoDt39MbqNni+4CmNRQ5VQ+o3bQ==
X-Gm-Gg: ASbGnctVhacjr5qiCEF+hoNBvGcgPHCwwRSDnx/cJBex7/vkR7XCZTCz3Js3jYR2VQ3
	BOLMR+550kPVNHjZq2kd8yFortv1vGPqA9LWLme9Ar8/pGohWLyKpCCk1XuQ6Y6kNtga9dQ==
X-Received: by 2002:a2e:9d95:0:b0:30b:e73e:e472 with SMTP id 38308e7fff4ca-3107f7315afmr968661fa.14.1744781543171;
        Tue, 15 Apr 2025 22:32:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLbi6QE/QRI84aIym068DYXE/CVVg2Kz3XVfyKFMsraJnM2JWNTAROz5tOhUqbo4yNhATTZ04nqK5gh+t16qk=
X-Received: by 2002:a2e:9d95:0:b0:30b:e73e:e472 with SMTP id
 38308e7fff4ca-3107f7315afmr968541fa.14.1744781542747; Tue, 15 Apr 2025
 22:32:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250412073202.3085138-1-yukuai1@huaweicloud.com> <20250412073202.3085138-3-yukuai1@huaweicloud.com>
In-Reply-To: <20250412073202.3085138-3-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 16 Apr 2025 13:32:10 +0800
X-Gm-Features: ATxdqUFy4q7mCNpWVDO9Q5MlVBJY6husumN8-kP6cD49hX_vFh_TaZt2rTI8_kE
Message-ID: <CALTww29xMyNq0SpPGvVqp6YPmCVu+N+d_neeJD_mogiviiZpYw@mail.gmail.com>
Subject: Re: [PATCH 2/4] md: add a new api sync_io_depth
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 12, 2025 at 3:39=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Currently if sync speed is above speed_min and below speed_max,
> md_do_sync() will wait for all sync IOs to be done before issuing new
> sync IO, means sync IO depth is limited to just 1.
>
> This limit is too low, in order to prevent sync speed drop conspicuously
> after fixing is_mddev_idle() in the next patch, add a new api for
> limiting sync IO depth, the default value is 32.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 103 +++++++++++++++++++++++++++++++++++++++---------
>  drivers/md/md.h |   1 +
>  2 files changed, 85 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 438e71e45c16..8966c4afc62a 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -111,32 +111,42 @@ static void md_wakeup_thread_directly(struct md_thr=
ead __rcu *thread);
>  /* Default safemode delay: 200 msec */
>  #define DEFAULT_SAFEMODE_DELAY ((200 * HZ)/1000 +1)
>  /*
> - * Current RAID-1,4,5 parallel reconstruction 'guaranteed speed limit'
> - * is 1000 KB/sec, so the extra system load does not show up that much.
> - * Increase it if you want to have more _guaranteed_ speed. Note that
> - * the RAID driver will use the maximum available bandwidth if the IO
> - * subsystem is idle. There is also an 'absolute maximum' reconstruction
> - * speed limit - in case reconstruction slows down your system despite
> - * idle IO detection.

These comments are useful. They only describe the meaning of those
control values. Is it good to keep them?

> + * Background sync IO speed control:
>   *
> - * you can change it via /proc/sys/dev/raid/speed_limit_min and _max.
> - * or /sys/block/mdX/md/sync_speed_{min,max}
> + * - below speed min:
> + *   no limit;
> + * - above speed min and below speed max:
> + *   a) if mddev is idle, then no limit;
> + *   b) if mddev is busy handling normal IO, then limit inflight sync IO
> + *   to sync_io_depth;
> + * - above speed max:
> + *   sync IO can't be issued;
> + *
> + * Following configurations can be changed via /proc/sys/dev/raid/ for s=
ystem
> + * or /sys/block/mdX/md/ for one array.
>   */
> -
>  static int sysctl_speed_limit_min =3D 1000;
>  static int sysctl_speed_limit_max =3D 200000;
> -static inline int speed_min(struct mddev *mddev)
> +static int sysctl_sync_io_depth =3D 32;
> +
> +static int speed_min(struct mddev *mddev)
>  {
>         return mddev->sync_speed_min ?
>                 mddev->sync_speed_min : sysctl_speed_limit_min;
>  }
>
> -static inline int speed_max(struct mddev *mddev)
> +static int speed_max(struct mddev *mddev)
>  {
>         return mddev->sync_speed_max ?
>                 mddev->sync_speed_max : sysctl_speed_limit_max;
>  }
>
> +static int sync_io_depth(struct mddev *mddev)
> +{
> +       return mddev->sync_io_depth ?
> +               mddev->sync_io_depth : sysctl_sync_io_depth;
> +}
> +
>  static void rdev_uninit_serial(struct md_rdev *rdev)
>  {
>         if (!test_and_clear_bit(CollisionCheck, &rdev->flags))
> @@ -293,14 +303,21 @@ static const struct ctl_table raid_table[] =3D {
>                 .procname       =3D "speed_limit_min",
>                 .data           =3D &sysctl_speed_limit_min,
>                 .maxlen         =3D sizeof(int),
> -               .mode           =3D S_IRUGO|S_IWUSR,
> +               .mode           =3D 0644,

Is it better to use macro rather than number directly here?

>                 .proc_handler   =3D proc_dointvec,
>         },
>         {
>                 .procname       =3D "speed_limit_max",
>                 .data           =3D &sysctl_speed_limit_max,
>                 .maxlen         =3D sizeof(int),
> -               .mode           =3D S_IRUGO|S_IWUSR,
> +               .mode           =3D 0644,
> +               .proc_handler   =3D proc_dointvec,
> +       },
> +       {
> +               .procname       =3D "sync_io_depth",
> +               .data           =3D &sysctl_sync_io_depth,
> +               .maxlen         =3D sizeof(int),
> +               .mode           =3D 0644,
>                 .proc_handler   =3D proc_dointvec,
>         },
>  };
> @@ -5091,7 +5108,7 @@ static ssize_t
>  sync_min_show(struct mddev *mddev, char *page)
>  {
>         return sprintf(page, "%d (%s)\n", speed_min(mddev),
> -                      mddev->sync_speed_min ? "local": "system");
> +                      mddev->sync_speed_min ? "local" : "system");
>  }
>
>  static ssize_t
> @@ -5100,7 +5117,7 @@ sync_min_store(struct mddev *mddev, const char *buf=
, size_t len)
>         unsigned int min;
>         int rv;
>
> -       if (strncmp(buf, "system", 6)=3D=3D0) {
> +       if (strncmp(buf, "system", 6) =3D=3D 0) {
>                 min =3D 0;
>         } else {
>                 rv =3D kstrtouint(buf, 10, &min);
> @@ -5120,7 +5137,7 @@ static ssize_t
>  sync_max_show(struct mddev *mddev, char *page)
>  {
>         return sprintf(page, "%d (%s)\n", speed_max(mddev),
> -                      mddev->sync_speed_max ? "local": "system");
> +                      mddev->sync_speed_max ? "local" : "system");
>  }
>
>  static ssize_t
> @@ -5129,7 +5146,7 @@ sync_max_store(struct mddev *mddev, const char *buf=
, size_t len)
>         unsigned int max;
>         int rv;
>
> -       if (strncmp(buf, "system", 6)=3D=3D0) {
> +       if (strncmp(buf, "system", 6) =3D=3D 0) {
>                 max =3D 0;
>         } else {
>                 rv =3D kstrtouint(buf, 10, &max);
> @@ -5145,6 +5162,35 @@ sync_max_store(struct mddev *mddev, const char *bu=
f, size_t len)
>  static struct md_sysfs_entry md_sync_max =3D
>  __ATTR(sync_speed_max, S_IRUGO|S_IWUSR, sync_max_show, sync_max_store);
>
> +static ssize_t
> +sync_io_depth_show(struct mddev *mddev, char *page)
> +{
> +       return sprintf(page, "%d (%s)\n", sync_io_depth(mddev),
> +                      mddev->sync_io_depth ? "local" : "system");
> +}
> +
> +static ssize_t
> +sync_io_depth_store(struct mddev *mddev, const char *buf, size_t len)
> +{
> +       unsigned int max;
> +       int rv;
> +
> +       if (strncmp(buf, "system", 6) =3D=3D 0) {
> +               max =3D 0;
> +       } else {
> +               rv =3D kstrtouint(buf, 10, &max);
> +               if (rv < 0)
> +                       return rv;
> +               if (max =3D=3D 0)
> +                       return -EINVAL;
> +       }
> +       mddev->sync_io_depth =3D max;
> +       return len;
> +}
> +
> +static struct md_sysfs_entry md_sync_io_depth =3D
> +__ATTR_RW(sync_io_depth);
> +
>  static ssize_t
>  degraded_show(struct mddev *mddev, char *page)
>  {
> @@ -5671,6 +5717,7 @@ static struct attribute *md_redundancy_attrs[] =3D =
{
>         &md_mismatches.attr,
>         &md_sync_min.attr,
>         &md_sync_max.attr,
> +       &md_sync_io_depth.attr,
>         &md_sync_speed.attr,
>         &md_sync_force_parallel.attr,
>         &md_sync_completed.attr,
> @@ -8927,6 +8974,23 @@ static sector_t md_sync_position(struct mddev *mdd=
ev, enum sync_action action)
>         }
>  }
>
> +static bool sync_io_within_limit(struct mddev *mddev)
> +{
> +       int io_sectors;
> +
> +       /*
> +        * For raid456, sync IO is stripe(4k) per IO, for other levels, i=
t's
> +        * RESYNC_PAGES(64k) per IO.
> +        */
> +       if (mddev->level =3D=3D 4 || mddev->level =3D=3D 5 || mddev->leve=
l =3D=3D 6)
> +               io_sectors =3D 8;
> +       else
> +               io_sectors =3D 128;
> +
> +       return atomic_read(&mddev->recovery_active) <
> +               io_sectors * sync_io_depth(mddev);
> +}
> +
>  #define SYNC_MARKS     10
>  #define        SYNC_MARK_STEP  (3*HZ)
>  #define UPDATE_FREQUENCY (5*60*HZ)
> @@ -9195,7 +9259,8 @@ void md_do_sync(struct md_thread *thread)
>                                 msleep(500);
>                                 goto repeat;
>                         }
> -                       if (!is_mddev_idle(mddev, 0)) {
> +                       if (!sync_io_within_limit(mddev) &&
> +                           !is_mddev_idle(mddev, 0)) {
>                                 /*
>                                  * Give other IO more of a chance.
>                                  * The faster the devices, the less we wa=
it.
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 1cf00a04bcdd..63be622467c6 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -483,6 +483,7 @@ struct mddev {
>         /* if zero, use the system-wide default */
>         int                             sync_speed_min;
>         int                             sync_speed_max;
> +       int                             sync_io_depth;
>
>         /* resync even though the same disks are shared among md-devices =
*/
>         int                             parallel_resync;
> --
> 2.39.2
>

This part looks good to me.

Acked-by: Xiao Ni <xni@redhat.com>

