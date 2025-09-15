Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CD46F305
	for <linux-raid@vger.kernel.org>; Mon, 15 Sep 2025 00:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757896420; cv=none; b=tS0mk837OFEqRb3OjVU/frcQ6Op3BE2J6bLiX2fyjCKiU3cRnnDuDOS0mvsqddPAr0Eqs+1lw4VJ5PSzhBCEhUMLX9G/XS1920QDmR5zbLyGFAHPjuMykgYqeirHT1mtTWBWE4TkWqTFZCFzxfeNU5i5RhTCCQRHkvUOl9zdv7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757896420; c=relaxed/simple;
	bh=qX866UujfUMh2usMLlxwIilBS63If5k/x+YqGp7Ezlg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BQ5NpG+GksLrtZQaqAVJFjLJ/R5c1iNqIJCUyQxVsur2VtEcuttimKlHr/y8U6FHok1tVzqB1pj0OEFFbR+VhJSX9BCrP33nDTApxGQz8ObJCpcd8R3qR/qkw4oQ0lb9poNLK5MYVSv+mdyihRT3aA6LnnlzeVdAG8kptKzSc4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aZ2q0fls; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aZ2q0fls"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757896417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tv+FE1ET0lfCXvwziye6Xvvm89/ScdWxbdg0BcdCwCo=;
	b=aZ2q0flsJvPNskz9UAVnzbCjl6jXhpTjpHMmr0D1CTgsEnqRtRuOUL1lMbetSp+aXWdD0P
	KxjEq1BJi+9lpoRu0b4+84Ou3RsngmIR6QWDHwlhsxJL3mvjT3BMpuNBFyTgFkfpZJ6zd6
	EgBg/zFHN4hjUcpu9yxRq8CcMKeBbyY=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-J915pC50PYKcOm7nFvKDtQ-1; Sun, 14 Sep 2025 20:33:34 -0400
X-MC-Unique: J915pC50PYKcOm7nFvKDtQ-1
X-Mimecast-MFC-AGG-ID: J915pC50PYKcOm7nFvKDtQ_1757896412
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-337ec9ab203so13830001fa.1
        for <linux-raid@vger.kernel.org>; Sun, 14 Sep 2025 17:33:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757896412; x=1758501212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tv+FE1ET0lfCXvwziye6Xvvm89/ScdWxbdg0BcdCwCo=;
        b=UnIJRkPvwSD1b3c9hm0LSUXmqH5gaOLB1GxzMNFdkX+2E+5Ay544jAFMbFF9GPYtSf
         ozFo3Qh7qYevyyibLGtLMgIe6bn0d55HbKFNlrUTrrDPRsD9tKPYn+8hlOzEeYLpfoGc
         3f0nbWd66HLbm4fBYUWgwYU0S4KvhfYNFJ1JGbIQptCQ4N0YNBN8DSjyKMm09AA7GBv8
         1I3tqHxW8BuOZT1d4TnQ9CrkL8Evvx85SUXrPuDvUpAUSTZQy3+AKr8fL46Axq8B2tqT
         9Z6tEpQbi/ISdpUHXXnlmWWX6wV5x1ekru0hcYFOR2YWbPKqkJ3+Sm3iXMk5slCKa+F4
         rq0w==
X-Forwarded-Encrypted: i=1; AJvYcCXmaMKj1BtlrJeaONsUt2hXDKZG4lggGoPGIo5HnvrRrGTxoi+JX6F/OEsgYTMm2nM6kG9BXUEtFo3i@vger.kernel.org
X-Gm-Message-State: AOJu0Yzrh4YZsmO7b4GrXhmoqjz1Khl7MuDg/aTDDbbRcJNo+3xeb4es
	11bDhqsoo+osLHjimhcxkJILoS+nzYZzI/ogPOFKmxoy6I2+MelV/uOfAQ3Ss9N/cJgmNIys9iN
	PE6+Tw68uhQy3Dxb/y5JNrOjSuaqNOwZwuO7BkJlAWcB+l1t0KoEWX+cO/dw5qW+VisoSVaNLQE
	CY56K7+G1Hh7Y4hzBTGwxQM59cejOnIULF36q2eQ==
X-Gm-Gg: ASbGnctqUlUK4k5Fetc82i8vGVcbuFTj+FtqMBXPw4gQ0fj0BqXf9723lIzZSL5CFn/
	yXlcLKvL4TZlvx5OW8/TyIEYeA4P62OuUfTyOc4P3G0tKT7cVCUN3y48FkOV7KpspjFwkjDGuxR
	DK9wXz/byScJNYxJ1bFu/HTA==
X-Received: by 2002:a2e:b896:0:b0:336:c9be:c164 with SMTP id 38308e7fff4ca-35142005a54mr27467031fa.45.1757896412012;
        Sun, 14 Sep 2025 17:33:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVnaSGGnxdMenpLu3BklRoJfQQPbVd0XWiLR9QTKgfTXftVxHek4IfsLABN9rRGDhnKvLs6cdjV7cWkqQjYgc=
X-Received: by 2002:a2e:b896:0:b0:336:c9be:c164 with SMTP id
 38308e7fff4ca-35142005a54mr27466951fa.45.1757896411539; Sun, 14 Sep 2025
 17:33:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250911073144.42160-1-linan666@huaweicloud.com> <20250911073144.42160-3-linan666@huaweicloud.com>
In-Reply-To: <20250911073144.42160-3-linan666@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 15 Sep 2025 08:33:19 +0800
X-Gm-Features: Ac12FXyJvz4WK5MtepX0dPCC6SxTee8sxOJ3sSRvi18-vjhbqHXWFJesarJOrpY
Message-ID: <CALTww2_z7UGXJ+ppYXrkAY8bpVrV9O3z0VfoaTOZtmX1-DXiZA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] md: allow configuring logical_block_size
To: linan666@huaweicloud.com
Cc: corbet@lwn.net, song@kernel.org, yukuai3@huawei.com, linan122@huawei.com, 
	hare@suse.de, martin.petersen@oracle.com, bvanassche@acm.org, 
	filipe.c.maia@gmail.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Nan

On Thu, Sep 11, 2025 at 3:41=E2=80=AFPM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> Previously, raid array used the maximum logical_block_size (LBS) of
> all member disks. Adding a larger LBS during disk at runtime could
> unexpectedly increase RAID's LBS, risking corruption of existing
> partitions.

Could you describe more about the problem? It's better to give some
test steps that can be used to reproduce this problem.
>
> Simply restricting larger-LBS disks is inflexible. In some scenarios,
> only disks with 512 LBS are available currently, but later, disks with
> 4k LBS may be added to the array.
>
> Making LBS configurable is the best way to solve this scenario.
> After this patch, the raid will:
>   - stores LBS in disk metadata.
>   - add a read-write sysfs 'mdX/logical_block_size'.
>
> Future mdadm should support setting LBS via metadata field during RAID
> creation and the new sysfs. Though the kernel allows runtime LBS changes,
> users should avoid modifying it after creating partitions or filesystems
> to prevent compatibility issues.

Because it only allows setting when creating an array. Can this be
done automatically in kernel space?

Best Regards
Xiao
>
> Note that many RAID paths rely on PAGE_SIZE alignment, including for
> metadata I/O. A logical_block_size larger than PAGE_SIZE will result in
> metadata reads/writes failures. So this config should be prevented.
>
> Only 1.x meta supports configurable logical_block_size. 0.90 meta init
> all fields to default at auto-detect. Supporting 0.90 would require more
> extensive changes and no such use case has been observed.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>  Documentation/admin-guide/md.rst |  7 +++
>  drivers/md/md.h                  |  1 +
>  include/uapi/linux/raid/md_p.h   |  3 +-
>  drivers/md/md-linear.c           |  1 +
>  drivers/md/md.c                  | 75 ++++++++++++++++++++++++++++++++
>  drivers/md/raid0.c               |  1 +
>  drivers/md/raid1.c               |  1 +
>  drivers/md/raid10.c              |  1 +
>  drivers/md/raid5.c               |  1 +
>  9 files changed, 90 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide=
/md.rst
> index 1c2eacc94758..f5c81fad034a 100644
> --- a/Documentation/admin-guide/md.rst
> +++ b/Documentation/admin-guide/md.rst
> @@ -238,6 +238,13 @@ All md devices contain:
>       the number of devices in a raid4/5/6, or to support external
>       metadata formats which mandate such clipping.
>
> +  logical_block_size
> +     Configures the array's logical block size in bytes. This attribute
> +     is only supported for RAID1, RAID5, RAID10 with 1.x meta. The value
> +     should be written before starting the array. The final array LBS
> +     will use the max value between this configuration and all rdev's LB=
S.
> +     Note that LBS cannot exceed PAGE_SIZE.
> +
>    reshape_position
>       This is either ``none`` or a sector number within the devices of
>       the array where ``reshape`` is up to.  If this is set, the three
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index afb25f727409..b0147b98c8d3 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -432,6 +432,7 @@ struct mddev {
>         sector_t                        array_sectors; /* exported array =
size */
>         int                             external_size; /* size managed
>                                                         * externally */
> +       unsigned int                    logical_block_size;
>         __u64                           events;
>         /* If the last 'event' was simply a clean->dirty transition, and
>          * we didn't write it to the spares, then it is safe and simple
> diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_=
p.h
> index ac74133a4768..310068bb2a1d 100644
> --- a/include/uapi/linux/raid/md_p.h
> +++ b/include/uapi/linux/raid/md_p.h
> @@ -291,7 +291,8 @@ struct mdp_superblock_1 {
>         __le64  resync_offset;  /* data before this offset (from data_off=
set) known to be in sync */
>         __le32  sb_csum;        /* checksum up to devs[max_dev] */
>         __le32  max_dev;        /* size of devs[] array to consider */
> -       __u8    pad3[64-32];    /* set to 0 when writing */
> +       __le32  logical_block_size;     /* same as q->limits->logical_blo=
ck_size */
> +       __u8    pad3[64-36];    /* set to 0 when writing */
>
>         /* device state information. Indexed by dev_number.
>          * 2 bytes per device
> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> index 5d9b08115375..da8babb8da59 100644
> --- a/drivers/md/md-linear.c
> +++ b/drivers/md/md-linear.c
> @@ -72,6 +72,7 @@ static int linear_set_limits(struct mddev *mddev)
>
>         md_init_stacking_limits(&lim);
>         lim.max_hw_sectors =3D mddev->chunk_sectors;
> +       lim.logical_block_size =3D mddev->logical_block_size;
>         lim.max_write_zeroes_sectors =3D mddev->chunk_sectors;
>         lim.io_min =3D mddev->chunk_sectors << 9;
>         err =3D mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRIT=
Y);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 40f56183c744..e0184942c8ec 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1963,6 +1963,7 @@ static int super_1_validate(struct mddev *mddev, st=
ruct md_rdev *freshest, struc
>                 mddev->layout =3D le32_to_cpu(sb->layout);
>                 mddev->raid_disks =3D le32_to_cpu(sb->raid_disks);
>                 mddev->dev_sectors =3D le64_to_cpu(sb->size);
> +               mddev->logical_block_size =3D le32_to_cpu(sb->logical_blo=
ck_size);
>                 mddev->events =3D ev1;
>                 mddev->bitmap_info.offset =3D 0;
>                 mddev->bitmap_info.space =3D 0;
> @@ -2172,6 +2173,7 @@ static void super_1_sync(struct mddev *mddev, struc=
t md_rdev *rdev)
>         sb->chunksize =3D cpu_to_le32(mddev->chunk_sectors);
>         sb->level =3D cpu_to_le32(mddev->level);
>         sb->layout =3D cpu_to_le32(mddev->layout);
> +       sb->logical_block_size =3D cpu_to_le32(mddev->logical_block_size)=
;
>         if (test_bit(FailFast, &rdev->flags))
>                 sb->devflags |=3D FailFast1;
>         else
> @@ -5900,6 +5902,66 @@ static struct md_sysfs_entry md_serialize_policy =
=3D
>  __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
>         serialize_policy_store);
>
> +static int mddev_set_logical_block_size(struct mddev *mddev,
> +                               unsigned int lbs)
> +{
> +       int err =3D 0;
> +       struct queue_limits lim;
> +
> +       if (queue_logical_block_size(mddev->gendisk->queue) >=3D lbs) {
> +               pr_err("%s: incompatible logical_block_size %u, can not s=
et\n",
> +                      mdname(mddev), lbs);
> +               return -EINVAL;
> +       }
> +
> +       lim =3D queue_limits_start_update(mddev->gendisk->queue);
> +       lim.logical_block_size =3D lbs;
> +       pr_info("%s: logical_block_size is changed, data may be lost\n",
> +               mdname(mddev));
> +       err =3D queue_limits_commit_update(mddev->gendisk->queue, &lim);
> +       if (err)
> +               return err;
> +
> +       mddev->logical_block_size =3D lbs;
> +       return 0;
> +}
> +
> +static ssize_t
> +lbs_show(struct mddev *mddev, char *page)
> +{
> +       return sprintf(page, "%u\n", mddev->logical_block_size);
> +}
> +
> +static ssize_t
> +lbs_store(struct mddev *mddev, const char *buf, size_t len)
> +{
> +       unsigned int lbs;
> +       int err =3D -EBUSY;
> +
> +       /* Only 1.x meta supports configurable LBS */
> +       if (mddev->major_version =3D=3D 0)
> +               return -EINVAL;
> +
> +       if (mddev->pers)
> +               return -EBUSY;
> +
> +       err =3D kstrtouint(buf, 10, &lbs);
> +       if (err < 0)
> +               return -EINVAL;
> +
> +       err =3D mddev_lock(mddev);
> +       if (err)
> +               goto unlock;
> +
> +       err =3D mddev_set_logical_block_size(mddev, lbs);
> +
> +unlock:
> +       mddev_unlock(mddev);
> +       return err ?: len;
> +}
> +
> +static struct md_sysfs_entry md_logical_block_size =3D
> +__ATTR(logical_block_size, S_IRUGO|S_IWUSR, lbs_show, lbs_store);
>
>  static struct attribute *md_default_attrs[] =3D {
>         &md_level.attr,
> @@ -5933,6 +5995,7 @@ static struct attribute *md_redundancy_attrs[] =3D =
{
>         &md_scan_mode.attr,
>         &md_last_scan_mode.attr,
>         &md_mismatches.attr,
> +       &md_logical_block_size.attr,
>         &md_sync_min.attr,
>         &md_sync_max.attr,
>         &md_sync_io_depth.attr,
> @@ -6052,6 +6115,17 @@ int mddev_stack_rdev_limits(struct mddev *mddev, s=
truct queue_limits *lim,
>                         return -EINVAL;
>         }
>
> +       /*
> +        * Before RAID adding folio support, the logical_block_size
> +        * should be smaller than the page size.
> +        */
> +       if (lim->logical_block_size > PAGE_SIZE) {
> +               pr_err("%s: logical_block_size must not larger than PAGE_=
SIZE\n",
> +                       mdname(mddev));
> +               return -EINVAL;
> +       }
> +       mddev->logical_block_size =3D lim->logical_block_size;
> +
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(mddev_stack_rdev_limits);
> @@ -6690,6 +6764,7 @@ static void md_clean(struct mddev *mddev)
>         mddev->chunk_sectors =3D 0;
>         mddev->ctime =3D mddev->utime =3D 0;
>         mddev->layout =3D 0;
> +       mddev->logical_block_size =3D 0;
>         mddev->max_disks =3D 0;
>         mddev->events =3D 0;
>         mddev->can_decrease_events =3D 0;
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index f1d8811a542a..705889a09fc1 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -382,6 +382,7 @@ static int raid0_set_limits(struct mddev *mddev)
>         md_init_stacking_limits(&lim);
>         lim.max_hw_sectors =3D mddev->chunk_sectors;
>         lim.max_write_zeroes_sectors =3D mddev->chunk_sectors;
> +       lim.logical_block_size =3D mddev->logical_block_size;
>         lim.io_min =3D mddev->chunk_sectors << 9;
>         lim.io_opt =3D lim.io_min * mddev->raid_disks;
>         lim.chunk_sectors =3D mddev->chunk_sectors;
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index d0f6afd2f988..de0c843067dc 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3223,6 +3223,7 @@ static int raid1_set_limits(struct mddev *mddev)
>
>         md_init_stacking_limits(&lim);
>         lim.max_write_zeroes_sectors =3D 0;
> +       lim.logical_block_size =3D mddev->logical_block_size;
>         lim.features |=3D BLK_FEAT_ATOMIC_WRITES;
>         err =3D mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRIT=
Y);
>         if (err)
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index c3cfbb0347e7..68c8148386b0 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4005,6 +4005,7 @@ static int raid10_set_queue_limits(struct mddev *md=
dev)
>
>         md_init_stacking_limits(&lim);
>         lim.max_write_zeroes_sectors =3D 0;
> +       lim.logical_block_size =3D mddev->logical_block_size;
>         lim.io_min =3D mddev->chunk_sectors << 9;
>         lim.chunk_sectors =3D mddev->chunk_sectors;
>         lim.io_opt =3D lim.io_min * raid10_nr_stripes(conf);
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index c32ffd9cffce..ff0daa22df65 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7747,6 +7747,7 @@ static int raid5_set_limits(struct mddev *mddev)
>         stripe =3D roundup_pow_of_two(data_disks * (mddev->chunk_sectors =
<< 9));
>
>         md_init_stacking_limits(&lim);
> +       lim.logical_block_size =3D mddev->logical_block_size;
>         lim.io_min =3D mddev->chunk_sectors << 9;
>         lim.io_opt =3D lim.io_min * (conf->raid_disks - conf->max_degrade=
d);
>         lim.features |=3D BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
> --
> 2.39.2
>

