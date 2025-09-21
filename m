Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CAF173
	for <linux-raid@vger.kernel.org>; Sun, 21 Sep 2025 07:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758441275; cv=none; b=SBZDiu6g7DR/BjpJxzyuEuCD1mp9WhlfbadzLTQGRX3Xb9t25KCWKe+4wWjlcJZDQOgnrmiLB8oS2FZ3zKE59QjDIaHufLnl5CAk05aLWe35doQtQELZPFg50mMijSgRFIbzsh2CeVp0xVEpfILh4pD5jnKsSxnzm2azwV++EcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758441275; c=relaxed/simple;
	bh=OM++W2tvoWr4xpIh7C03sZKKcfCBrCu3CfjnU7GC6Xc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RxwzSRscPWQhhQ25rmbgtlgSMIxf/8+6yr1XfrWJ3HfPpyGhAEtCXDZP0HDtsrwaLwXKgXkaXqI/AP4SwchN6RJC7fRYECvBFWH9tGvznan7np8ZHO1NstCw005HqYHwBj5u7e5jD/2g9GtLgvCf4EBckm2ltrxQk0E50MVThnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ETj60H3d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ETj60H3d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758441272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6R9T58pVe+Vn0xdle5P0g+ub08sP83iIsEw1F+TkNJo=;
	b=ETj60H3df7CpckDpRniG4DMhAMqHGc2FWSMW6lYCjCOwNJC1WPNVHJtD+O1Ek6mhIJjq5C
	Myip32CxGGvtvInRJRL4fNJro5dkW+0USIABjcVK0+4UrjBHFMIqWDS16e5vt5mzzGZup7
	dqAicpjhItN5aiY4RBR9o890PgIDuI8=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-GMRwymeYNseV_M1zkrNEKA-1; Sun, 21 Sep 2025 03:54:30 -0400
X-MC-Unique: GMRwymeYNseV_M1zkrNEKA-1
X-Mimecast-MFC-AGG-ID: GMRwymeYNseV_M1zkrNEKA_1758441269
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-57b35e176afso660260e87.3
        for <linux-raid@vger.kernel.org>; Sun, 21 Sep 2025 00:54:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758441269; x=1759046069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6R9T58pVe+Vn0xdle5P0g+ub08sP83iIsEw1F+TkNJo=;
        b=X9/miZMalzB3SqpBpzYSFqV/k2osiLOZSpC13gex+4XybAV6h1WBZ7B0xV3xK65pKj
         LRY9HI8/JIxw4VBQgq95n9rGkp2Y3fEcBsA1ETr2kOPC/jSGJWTXx4hh7JSIstf478sa
         z6gHFFhQLVlUncVGOR7yQdUbbfbQ3GEmkeWLypypQHXupzaWDatVcAZfCCjwnwn5NYmB
         slbDOq3Euyi74SkcEi6ppLInnOw6BOpUngYGl5RBWDjbcNjHk4jvG3rKnvJkViJBXm1M
         V/k6zfBBnsd6sEteWVN+O373w452Ozrh/bRCliWEm2IG8H01TA6otvfQjy+HVnvMfCXQ
         ITwg==
X-Forwarded-Encrypted: i=1; AJvYcCW+ol0CSZYcgKCILU+h3yPtvbYdYFnYCHtX7Olh7ciTCqoLs4mC/CQ30CMcx5hQw8xPxM2YumbjnVui@vger.kernel.org
X-Gm-Message-State: AOJu0YwXOG0OvRE2qXf7op8rEP2TyOBjM+wouzMZ1ZfSFLADXXcQSahl
	aS4p1kxxzn4n3f48B2Qjr3f29rKUC1mhh8YFP0gpFDTxIQGscR1NngXMU5jXvALGE4ackTilTo5
	eBFcp+ZMUiUyHJXvxI3TJ04RkadksmKA3DQqql2f4+hD6tVLOwYjT/d13xc1g2kZcLchRoi+nYy
	kcHHOnd6SsPnxTTu07jV5Uqg5laUA2EsreirxRdw==
X-Gm-Gg: ASbGncuv2y/8MdoX7CGoHXPYaUuitJyi97QDU8Z33QsFxMLcnHfZPLl/Ww+ge7DTusN
	TyXdTZG5BYaQw9aG2lvA0rdJPHNF4LVTqpoVLUfl419NAoM+Ob2Z5mh2Pi5Ay9uEZttFZD/JaY8
	RLjOWvuRBDLM537rTpD1Fwsg==
X-Received: by 2002:a05:6512:15a4:b0:57c:578e:c84e with SMTP id 2adb3069b0e04-57c578eca1bmr724015e87.21.1758441268901;
        Sun, 21 Sep 2025 00:54:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHVlm2Sz5lVeaBGU8Yz6r8reme2P8kIxzwwu60k5b+nm8Nvvn7cfcC9dBOUDJOTKsKkHzPwJikG9EhmW17sOOw=
X-Received: by 2002:a05:6512:15a4:b0:57c:578e:c84e with SMTP id
 2adb3069b0e04-57c578eca1bmr724006e87.21.1758441268364; Sun, 21 Sep 2025
 00:54:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250915034210.8533-1-k@mgml.me> <20250915034210.8533-2-k@mgml.me>
In-Reply-To: <20250915034210.8533-2-k@mgml.me>
From: Xiao Ni <xni@redhat.com>
Date: Sun, 21 Sep 2025 15:54:16 +0800
X-Gm-Features: AS18NWDLPb-587uhjm6P_WeoLi_luX-BsxF_I_HdUVMPOUBUCRMIQPzYJK9dQJs
Message-ID: <CALTww2_XBBBP3NHRjxrxsJ3eqjJ_bB8SmCeHFocun1hQiUedkA@mail.gmail.com>
Subject: Re: [PATCH v4 1/9] md/raid1,raid10: Set the LastDev flag when the
 configuration changes
To: Kenta Akagi <k@mgml.me>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	Mariusz Tkaczyk <mtkaczyk@kernel.org>, Shaohua Li <shli@fb.com>, Guoqing Jiang <jgq516@gmail.com>, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kenta

On Mon, Sep 15, 2025 at 11:44=E2=80=AFAM Kenta Akagi <k@mgml.me> wrote:
>
> Currently, the LastDev flag is set on an rdev that failed a failfast
> metadata write and called md_error, but did not become Faulty. It is
> cleared when the metadata write retry succeeds. This has problems for
> the following reasons:
>
> * Despite its name, the flag is only set during a metadata write window.
> * Unlike when LastDev and Failfast was introduced, md_error on the last
>   rdev of a RAID1/10 array now sets MD_BROKEN. Thus when LastDev is set,
>   the array is already unwritable.
>
> A following commit will prevent failfast bios from breaking the array,
> which requires knowing from outside the personality whether an rdev is
> the last one. For that purpose, LastDev should be set on rdevs that must
> not be lost.
>
> This commit ensures that LastDev is set on the indispensable rdev in a
> degraded RAID1/10 array.
>
> Signed-off-by: Kenta Akagi <k@mgml.me>
> ---
>  drivers/md/md.c     |  4 +---
>  drivers/md/md.h     |  6 +++---
>  drivers/md/raid1.c  | 34 +++++++++++++++++++++++++++++++++-
>  drivers/md/raid10.c | 34 +++++++++++++++++++++++++++++++++-
>  4 files changed, 70 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4e033c26fdd4..268410b66b83 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1007,10 +1007,8 @@ static void super_written(struct bio *bio)
>                 if (!test_bit(Faulty, &rdev->flags)
>                     && (bio->bi_opf & MD_FAILFAST)) {
>                         set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
> -                       set_bit(LastDev, &rdev->flags);
>                 }
> -       } else
> -               clear_bit(LastDev, &rdev->flags);
> +       }
>
>         bio_put(bio);
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 51af29a03079..ec598f9a8381 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -281,9 +281,9 @@ enum flag_bits {
>                                  * It is expects that no bad block log
>                                  * is present.
>                                  */
> -       LastDev,                /* Seems to be the last working dev as
> -                                * it didn't fail, so don't use FailFast
> -                                * any more for metadata
> +       LastDev,                /* This is the last working rdev.
> +                                * so don't use FailFast any more for
> +                                * metadata.
>                                  */
>         CollisionCheck,         /*
>                                  * check if there is collision between ra=
id1
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index bf44878ec640..32ad6b102ff7 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1733,6 +1733,33 @@ static void raid1_status(struct seq_file *seq, str=
uct mddev *mddev)
>         seq_printf(seq, "]");
>  }
>
> +/**
> + * update_lastdev - Set or clear LastDev flag for all rdevs in array
> + * @conf: pointer to r1conf
> + *
> + * Sets LastDev if the device is In_sync and cannot be lost for the arra=
y.
> + * Otherwise, clear it.
> + *
> + * Caller must hold ->device_lock.
> + */
> +static void update_lastdev(struct r1conf *conf)
> +{
> +       int i;
> +       int alive_disks =3D conf->raid_disks - conf->mddev->degraded;
> +
> +       for (i =3D 0; i < conf->raid_disks; i++) {
> +               struct md_rdev *rdev =3D conf->mirrors[i].rdev;
> +
> +               if (rdev) {
> +                       if (test_bit(In_sync, &rdev->flags) &&
> +                           alive_disks =3D=3D 1)
> +                               set_bit(LastDev, &rdev->flags);
> +                       else
> +                               clear_bit(LastDev, &rdev->flags);
> +               }
> +       }
> +}
> +
>  /**
>   * raid1_error() - RAID1 error handler.
>   * @mddev: affected md device.
> @@ -1767,8 +1794,10 @@ static void raid1_error(struct mddev *mddev, struc=
t md_rdev *rdev)
>                 }
>         }
>         set_bit(Blocked, &rdev->flags);
> -       if (test_and_clear_bit(In_sync, &rdev->flags))
> +       if (test_and_clear_bit(In_sync, &rdev->flags)) {
>                 mddev->degraded++;
> +               update_lastdev(conf);
> +       }
>         set_bit(Faulty, &rdev->flags);
>         spin_unlock_irqrestore(&conf->device_lock, flags);
>         /*
> @@ -1864,6 +1893,7 @@ static int raid1_spare_active(struct mddev *mddev)
>                 }
>         }
>         mddev->degraded -=3D count;
> +       update_lastdev(conf);

update_lastdev is called in raid1_spare_active, raid1_run and
raid1_reshape. Could you explain the reason why it needs to call this
function? Is it the reason you want to clear LastDev flag? If so, is
it a right place to do it? As your commit message says, it will be
cleared after retry metadata successfully. In raid1, is it the right
place that fixes read/write successfully?

Best Regards
Xiao

>         spin_unlock_irqrestore(&conf->device_lock, flags);
>
>         print_conf(conf);
> @@ -3290,6 +3320,7 @@ static int raid1_run(struct mddev *mddev)
>         rcu_assign_pointer(conf->thread, NULL);
>         mddev->private =3D conf;
>         set_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
> +       update_lastdev(conf);
>
>         md_set_array_sectors(mddev, raid1_size(mddev, 0, 0));
>
> @@ -3427,6 +3458,7 @@ static int raid1_reshape(struct mddev *mddev)
>
>         spin_lock_irqsave(&conf->device_lock, flags);
>         mddev->degraded +=3D (raid_disks - conf->raid_disks);
> +       update_lastdev(conf);
>         spin_unlock_irqrestore(&conf->device_lock, flags);
>         conf->raid_disks =3D mddev->raid_disks =3D raid_disks;
>         mddev->delta_disks =3D 0;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index b60c30bfb6c7..dc4edd4689f8 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1983,6 +1983,33 @@ static int enough(struct r10conf *conf, int ignore=
)
>                 _enough(conf, 1, ignore);
>  }
>
> +/**
> + * update_lastdev - Set or clear LastDev flag for all rdevs in array
> + * @conf: pointer to r10conf
> + *
> + * Sets LastDev if the device is In_sync and cannot be lost for the arra=
y.
> + * Otherwise, clear it.
> + *
> + * Caller must hold ->reconfig_mutex or ->device_lock.
> + */
> +static void update_lastdev(struct r10conf *conf)
> +{
> +       int i;
> +       int raid_disks =3D max(conf->geo.raid_disks, conf->prev.raid_disk=
s);
> +
> +       for (i =3D 0; i < raid_disks; i++) {
> +               struct md_rdev *rdev =3D conf->mirrors[i].rdev;
> +
> +               if (rdev) {
> +                       if (test_bit(In_sync, &rdev->flags) &&
> +                           !enough(conf, i))
> +                               set_bit(LastDev, &rdev->flags);
> +                       else
> +                               clear_bit(LastDev, &rdev->flags);
> +               }
> +       }
> +}
> +
>  /**
>   * raid10_error() - RAID10 error handler.
>   * @mddev: affected md device.
> @@ -2013,8 +2040,10 @@ static void raid10_error(struct mddev *mddev, stru=
ct md_rdev *rdev)
>                         return;
>                 }
>         }
> -       if (test_and_clear_bit(In_sync, &rdev->flags))
> +       if (test_and_clear_bit(In_sync, &rdev->flags)) {
>                 mddev->degraded++;
> +               update_lastdev(conf);
> +       }
>
>         set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>         set_bit(Blocked, &rdev->flags);
> @@ -2102,6 +2131,7 @@ static int raid10_spare_active(struct mddev *mddev)
>         }
>         spin_lock_irqsave(&conf->device_lock, flags);
>         mddev->degraded -=3D count;
> +       update_lastdev(conf);
>         spin_unlock_irqrestore(&conf->device_lock, flags);
>
>         print_conf(conf);
> @@ -4159,6 +4189,7 @@ static int raid10_run(struct mddev *mddev)
>         md_set_array_sectors(mddev, size);
>         mddev->resync_max_sectors =3D size;
>         set_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
> +       update_lastdev(conf);
>
>         if (md_integrity_register(mddev))
>                 goto out_free_conf;
> @@ -4567,6 +4598,7 @@ static int raid10_start_reshape(struct mddev *mddev=
)
>          */
>         spin_lock_irq(&conf->device_lock);
>         mddev->degraded =3D calc_degraded(conf);
> +       update_lastdev(conf);
>         spin_unlock_irq(&conf->device_lock);
>         mddev->raid_disks =3D conf->geo.raid_disks;
>         mddev->reshape_position =3D conf->reshape_progress;
> --
> 2.50.1
>
>

