Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B9B9460
	for <linux-raid@vger.kernel.org>; Mon,  3 Nov 2025 03:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762139529; cv=none; b=nDLrgGbWZUKcFk7SdisY1gwWk4KiODQfdbYXHPXnLPpqfhSF31kqh3w5JqPz2jaBfI4xk38gz186JdfTu9t80z4MC/nMfaYFEO1qYZJjPVOFE0ZXkDbhj2z/oxomuhW0AxYOHsNfnKuX59JFP5nwI0G9qvliEZbrzckNCg2/x3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762139529; c=relaxed/simple;
	bh=1otINNRv810w1D+0fow2novvAGWKARRkpnbVQCDa9Jc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gWwBHehpN/RUq2l7REIhd4ZbRf8qNCMSehyloPDugTbQrCqCKQ7MYdUdkilzgQtFN/dd3dyJpveQFEmOCzo0kbY5y/jdRaZQ7yiG8folwf+a57ZifXNdP8RPpUki+JPWJSD8AJKTgLkiqd55Bzq8whBBcEMWEw5W0tN+0G3zoQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LC9p4SQc; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VPwfzjZ1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LC9p4SQc";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VPwfzjZ1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762139523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9q9NB7J33f7YfQtT3FCN3sb4VVb8oeAZXiK7o1NqPH8=;
	b=LC9p4SQcub+WThkLDNEgaDYfOeEiRtXxmpYh6ZsQlPPw4WZ8tMjG+F6KEbZFcLNxPHLduW
	xX0LceJTpEXj7kRZEc+G/kpvn+l7fZ0O6OcBjTgvGgV8acjaYg3tkmBcCXj2F4Fgj49kII
	XYPJr1MX+1NteMHdCHNcm30ULsWhB5o=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-6aWLodkEPp60ZXcqz8IiQg-1; Sun, 02 Nov 2025 22:12:02 -0500
X-MC-Unique: 6aWLodkEPp60ZXcqz8IiQg-1
X-Mimecast-MFC-AGG-ID: 6aWLodkEPp60ZXcqz8IiQg_1762139521
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-585b3594d16so2187118e87.0
        for <linux-raid@vger.kernel.org>; Sun, 02 Nov 2025 19:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762139521; x=1762744321; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9q9NB7J33f7YfQtT3FCN3sb4VVb8oeAZXiK7o1NqPH8=;
        b=VPwfzjZ1+eHKr0iqRp/ZP9Ke6dhNY2BBZnQOlVXTHn5+9h26IaQGeviX8aTm34ViCW
         vEnln7sNZvg6uceWYzDM/2PWwEyVxKyE8P7yUbJN8I+2yGZDpoVLm8um2ER1JFCpEY0m
         L+d3LFmNBR+Wep49RpxvQPhHrf+4+NSpQyV6wVFBgetb+pBMkF7NXdlLr81mjOUcIrnE
         J8hqj757Uwec9n9Ho79pMMKJC/9YIpLY18fTpH0kOaf3+jKFiHkEEuKxVLiD4LFn5wUa
         b8iHUxtkv0pyi1stOQ1rXUYM7dWecOp2eF7gs4gK20sDt0MDuYkrtWO/StlBKCz2YHls
         cmLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762139521; x=1762744321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9q9NB7J33f7YfQtT3FCN3sb4VVb8oeAZXiK7o1NqPH8=;
        b=BHxJFJzBau9N56aGM2i39LyMrdR5EPVh+zHpRrSnhZ4e0Otk97okgUyoiTfsFRPGTT
         cUX6Rs9FZV30U6iB5Et4kf7Cn0wv0B83kuvO6Im4dmAe4vcryOS0jlJa/L5tvcdh8HJH
         OOGBtEJU1rEJ/pORluLx29UpRwsFKnjDWrnlnIpyld3I072rJzFOqc7/CAxt4vEt8GP/
         hnl/ATBo7qsRU9mXDd0BbELP57HQZn69Sm6Kza76uT8wGHw0Nrm/dQXEZGMfMt6atsGo
         JoGO5f6OCnpprSZy7TjfU4fl1x5GFZlVlyrj+/wy3WPB7Y3p8oD1neWpsFa8aKRrfgUL
         6S7A==
X-Forwarded-Encrypted: i=1; AJvYcCVTWUs5GfYJSGQzvoV/hEq30ZCUi9kZT8dTfBrnseW0m83Ei14HINQt3pMWJw/XT5WJyLFktAGeO6lx@vger.kernel.org
X-Gm-Message-State: AOJu0YzoGflZU0TZSkRy4w9ET34CZYZF7dvL471Ryhpe7QLYYv/pDm9C
	PNMzRzS47h6LxFUKW/rkFKLr8HNOu8BgMuMicuoSGlkBnp+HnoZRvRtfzB+BUTOgHh1aHwN0ixS
	tevZqG0cdGDKDMxikPil4Z/ohLV+55QVz0LjeFZ3inWuD6jrkvVwBIjMnuRyERdlzOzwNLW9uSC
	ZA6eqctq5GcEpQO9xoqlL3bXYRyO5JY173dvpT3A==
X-Gm-Gg: ASbGncsTsFian247UbRGtzWj4HP5hfz2Upqh1G+Awr90yuejVPCOpyz6BBg+CX8rESY
	V/+cv2ykwGdTzOo4r8eKsTtkLDKRQIXMDsQE8WEqY/OTY7u/XOEnTgLLZQAN2hIonsnlM8AyBur
	FSaf1X4u30cGQo5uBhGnMI1ZHJTvCTvcW4RiqYBZedDexj+iB5ka/e744=
X-Received: by 2002:a05:6512:3d92:b0:594:2f72:2f73 with SMTP id 2adb3069b0e04-5942f7234ebmr77688e87.25.1762139520553;
        Sun, 02 Nov 2025 19:12:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHafufFEhaRmrw9x1BEeN9R/m6MPrZ2EUX7gwO4XJcCY4vxclzIKjX/1k7ptgmMQoSbFUEfiiMdyGoqhNKUOHI=
X-Received: by 2002:a05:6512:3d92:b0:594:2f72:2f73 with SMTP id
 2adb3069b0e04-5942f7234ebmr77674e87.25.1762139520032; Sun, 02 Nov 2025
 19:12:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251030062807.1515356-1-linan666@huaweicloud.com> <20251030062807.1515356-5-linan666@huaweicloud.com>
In-Reply-To: <20251030062807.1515356-5-linan666@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 3 Nov 2025 11:11:48 +0800
X-Gm-Features: AWmQ_blr6RzGPDBcLwF-uexl5T5cZT9NDedag9UWdBROfAjkGk49JSN6biUbmKk
Message-ID: <CALTww28r_bicJ_4jcxQ7MB2hLVX5nAZkY3tuM7q7HY_D2beHFA@mail.gmail.com>
Subject: Re: [PATCH v8 4/4] md: allow configuring logical block size
To: linan666@huaweicloud.com
Cc: corbet@lwn.net, song@kernel.org, yukuai@fnnas.com, linan122@huawei.com, 
	hare@suse.de, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2025 at 2:36=E2=80=AFPM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> Previously, raid array used the maximum logical block size (LBS)
> of all member disks. Adding a larger LBS disk at runtime could
> unexpectedly increase RAID's LBS, risking corruption of existing
> partitions. This can be reproduced by:
>
> ```
>   # LBS of sd[de] is 512 bytes, sdf is 4096 bytes.
>   mdadm -CRq /dev/md0 -l1 -n3 /dev/sd[de] missing --assume-clean
>
>   # LBS is 512
>   cat /sys/block/md0/queue/logical_block_size
>
>   # create partition md0p1
>   parted -s /dev/md0 mklabel gpt mkpart primary 1MiB 100%
>   lsblk | grep md0p1
>
>   # LBS becomes 4096 after adding sdf
>   mdadm --add -q /dev/md0 /dev/sdf
>   cat /sys/block/md0/queue/logical_block_size
>
>   # partition lost
>   partprobe /dev/md0
>   lsblk | grep md0p1
> ```
>
> Simply restricting larger-LBS disks is inflexible. In some scenarios,
> only disks with 512 bytes LBS are available currently, but later, disks
> with 4KB LBS may be added to the array.
>
> Making LBS configurable is the best way to solve this scenario.
> After this patch, the raid will:
>   - store LBS in disk metadata
>   - add a read-write sysfs 'mdX/logical_block_size'
>
> Future mdadm should support setting LBS via metadata field during RAID
> creation and the new sysfs. Though the kernel allows runtime LBS changes,
> users should avoid modifying it after creating partitions or filesystems
> to prevent compatibility issues.
>
> Only 1.x metadata supports configurable LBS. 0.90 metadata inits all
> fields to default values at auto-detect. Supporting 0.90 would require
> more extensive changes and no such use case has been observed.
>
> Note that many RAID paths rely on PAGE_SIZE alignment, including for
> metadata I/O. A larger LBS than PAGE_SIZE will result in metadata
> read/write failures. So this config should be prevented.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>  Documentation/admin-guide/md.rst |  7 +++
>  drivers/md/md.h                  |  1 +
>  include/uapi/linux/raid/md_p.h   |  3 +-
>  drivers/md/md-linear.c           |  1 +
>  drivers/md/md.c                  | 77 ++++++++++++++++++++++++++++++++
>  drivers/md/raid0.c               |  1 +
>  drivers/md/raid1.c               |  1 +
>  drivers/md/raid10.c              |  1 +
>  drivers/md/raid5.c               |  1 +
>  9 files changed, 92 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide=
/md.rst
> index 1c2eacc94758..0f143acd2db7 100644
> --- a/Documentation/admin-guide/md.rst
> +++ b/Documentation/admin-guide/md.rst
> @@ -238,6 +238,13 @@ All md devices contain:
>       the number of devices in a raid4/5/6, or to support external
>       metadata formats which mandate such clipping.
>
> +  logical_block_size
> +     Configure the array's logical block size in bytes. This attribute
> +     is only supported for 1.x meta. The value should be written before
> +     starting the array. The final array LBS will use the max value
> +     between this configuration and all combined device's LBS. Note that
> +     LBS cannot exceed PAGE_SIZE before RAID supports folio.
> +
>    reshape_position
>       This is either ``none`` or a sector number within the devices of
>       the array where ``reshape`` is up to.  If this is set, the three
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 38a7c2fab150..a6b3cb69c28c 100644
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
> index 7033d982d377..50d4a419a16e 100644
> --- a/drivers/md/md-linear.c
> +++ b/drivers/md/md-linear.c
> @@ -72,6 +72,7 @@ static int linear_set_limits(struct mddev *mddev)
>
>         md_init_stacking_limits(&lim);
>         lim.max_hw_sectors =3D mddev->chunk_sectors;
> +       lim.logical_block_size =3D mddev->logical_block_size;
>         lim.max_write_zeroes_sectors =3D mddev->chunk_sectors;
>         lim.max_hw_wzeroes_unmap_sectors =3D mddev->chunk_sectors;
>         lim.io_min =3D mddev->chunk_sectors << 9;
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index dffc6a482181..d78e9e52c951 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1993,6 +1993,7 @@ static int super_1_validate(struct mddev *mddev, st=
ruct md_rdev *freshest, struc
>                 mddev->layout =3D le32_to_cpu(sb->layout);
>                 mddev->raid_disks =3D le32_to_cpu(sb->raid_disks);
>                 mddev->dev_sectors =3D le64_to_cpu(sb->size);
> +               mddev->logical_block_size =3D le32_to_cpu(sb->logical_blo=
ck_size);
>                 mddev->events =3D ev1;
>                 mddev->bitmap_info.offset =3D 0;
>                 mddev->bitmap_info.space =3D 0;
> @@ -2202,6 +2203,7 @@ static void super_1_sync(struct mddev *mddev, struc=
t md_rdev *rdev)
>         sb->chunksize =3D cpu_to_le32(mddev->chunk_sectors);
>         sb->level =3D cpu_to_le32(mddev->level);
>         sb->layout =3D cpu_to_le32(mddev->layout);
> +       sb->logical_block_size =3D cpu_to_le32(mddev->logical_block_size)=
;
>         if (test_bit(FailFast, &rdev->flags))
>                 sb->devflags |=3D FailFast1;
>         else
> @@ -5930,6 +5932,68 @@ static struct md_sysfs_entry md_serialize_policy =
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
> +               pr_err("%s: Cannot set LBS smaller than mddev LBS %u\n",
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
> +       /* New lbs will be written to superblock after array is running *=
/
> +       set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
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
> +__ATTR(logical_block_size, 0644, lbs_show, lbs_store);
>
>  static struct attribute *md_default_attrs[] =3D {
>         &md_level.attr,
> @@ -5952,6 +6016,7 @@ static struct attribute *md_default_attrs[] =3D {
>         &md_consistency_policy.attr,
>         &md_fail_last_dev.attr,
>         &md_serialize_policy.attr,
> +       &md_logical_block_size.attr,
>         NULL,
>  };
>
> @@ -6082,6 +6147,17 @@ int mddev_stack_rdev_limits(struct mddev *mddev, s=
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
> @@ -6693,6 +6769,7 @@ static void md_clean(struct mddev *mddev)
>         mddev->chunk_sectors =3D 0;
>         mddev->ctime =3D mddev->utime =3D 0;
>         mddev->layout =3D 0;
> +       mddev->logical_block_size =3D 0;
>         mddev->max_disks =3D 0;
>         mddev->events =3D 0;
>         mddev->can_decrease_events =3D 0;
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index fbf763401521..47aee1b1d4d1 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -380,6 +380,7 @@ static int raid0_set_limits(struct mddev *mddev)
>         lim.max_hw_sectors =3D mddev->chunk_sectors;
>         lim.max_write_zeroes_sectors =3D mddev->chunk_sectors;
>         lim.max_hw_wzeroes_unmap_sectors =3D mddev->chunk_sectors;
> +       lim.logical_block_size =3D mddev->logical_block_size;
>         lim.io_min =3D mddev->chunk_sectors << 9;
>         lim.io_opt =3D lim.io_min * mddev->raid_disks;
>         lim.chunk_sectors =3D mddev->chunk_sectors;
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 64bfe8ca5b38..167768edaec1 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3212,6 +3212,7 @@ static int raid1_set_limits(struct mddev *mddev)
>         md_init_stacking_limits(&lim);
>         lim.max_write_zeroes_sectors =3D 0;
>         lim.max_hw_wzeroes_unmap_sectors =3D 0;
> +       lim.logical_block_size =3D mddev->logical_block_size;
>         lim.features |=3D BLK_FEAT_ATOMIC_WRITES;
>         err =3D mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRIT=
Y);
>         if (err)
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 6b2d4b7057ae..71bfed3b798d 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4000,6 +4000,7 @@ static int raid10_set_queue_limits(struct mddev *md=
dev)
>         md_init_stacking_limits(&lim);
>         lim.max_write_zeroes_sectors =3D 0;
>         lim.max_hw_wzeroes_unmap_sectors =3D 0;
> +       lim.logical_block_size =3D mddev->logical_block_size;
>         lim.io_min =3D mddev->chunk_sectors << 9;
>         lim.chunk_sectors =3D mddev->chunk_sectors;
>         lim.io_opt =3D lim.io_min * raid10_nr_stripes(conf);
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index aa404abf5d17..92473850f381 100644
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

Hi Li Nan

The problem can't be fixed if there is no user space (mdadm) patch, right?

The patch Looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

