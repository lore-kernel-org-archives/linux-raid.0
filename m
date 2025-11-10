Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B06416DEB1
	for <linux-raid@vger.kernel.org>; Mon, 10 Nov 2025 02:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762741881; cv=none; b=at1ThjcrcCYV7qPiQdQQeyjOyB/MChEkTjSrCDN26eG41JHtWV/UAXQHiB8XwQP2JiCmZg3kNX8cYvN0qrXXaSLTr6mIblNlf/VDAMzr8hgT0GHbRD1Vi2qh7SBcMhAACPJ6qekexxTM0u/4pSHSfVtFLyefqx2ta4GGxfJv9v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762741881; c=relaxed/simple;
	bh=agCrlEn+1UVxT4zTacRYF2se801n/68iQ70kdwJIdgQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P5+78kNVfbuaFeJn7hOw42cYnB+LtVE5UKRzlNa+rm3qj5eMJZfSjb0BIZchIRpumJMwUtp8IJWaxTgGGKseC7YQQ86H28ou7E97L8o7zogE32FBZfJ5gt2NhSR7QkjOBAmsw7CqIk3uzy+l1wQ7EY7JAu99eJa0wOGrANUm74Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JL8U+p3Y; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=TmcKf7qc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JL8U+p3Y";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="TmcKf7qc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762741877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EJjbMiht/N5P0FKj2UX16ocUflg4ct2JhS64yw2D2Qs=;
	b=JL8U+p3YidUhKPIa4PL//mwHVAD9Q6ZSAmVFt9+jaJ/KdFZTICvv2XsBfiZoAZ/oGv3k9V
	xHh82GIxBoPgPo/zLaMudPtcNTrY3loaRVt9+d97HtKoGbcBLq52jU0IxPjaCOYKs5B2uO
	4NPzC5OEVwjvtej0F8nQCwc01IRPNzA=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-ec4qSzKcO-qpGDgVtTKjmw-1; Sun, 09 Nov 2025 21:31:15 -0500
X-MC-Unique: ec4qSzKcO-qpGDgVtTKjmw-1
X-Mimecast-MFC-AGG-ID: ec4qSzKcO-qpGDgVtTKjmw_1762741875
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-787ee7b3ddfso7227187b3.1
        for <linux-raid@vger.kernel.org>; Sun, 09 Nov 2025 18:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762741875; x=1763346675; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJjbMiht/N5P0FKj2UX16ocUflg4ct2JhS64yw2D2Qs=;
        b=TmcKf7qcGjPbdh45C9zikTBq2ELLeRsUp1vcJ5q1EfjALlX8lo8PPG0aoQ3Rinasrp
         wOoEeXTcaxG4n9dc832YcFjhGyYxFdfVsPydT0y9/PO7UKrOKLYrNncdURxF8mpAyG6P
         u7Y+NMWgTxsxjHYp/yPNxhn434HD3QR6v3CFnGjUKs+eeA+hPwYxBnbrDwPLdNI6XnSC
         sh12HQ7XhaRgEFfnymEFCLo3noYxJmXnBee1iUqMdBCjM1l84bbzEPY3Mh7+7CnCa1CR
         ksynoLS8pmh6xyDBoMcqJ/ZMADbIIQ9NWWX88uxp99JMGZrrdQz/wp6Hrs+66RcYpe5X
         6zBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762741875; x=1763346675;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EJjbMiht/N5P0FKj2UX16ocUflg4ct2JhS64yw2D2Qs=;
        b=S0ZrJuQfDF55f43HQfV5eeXQXRHOM5cxDL/Gob4nl4Gvb0gSye2AtCIR33X/CzO/rN
         YQ0go7IxCL3hOhR9xQWFOln3LhzqGc/qOxsCDu+A5wcF07JLecoJeNUHTVxFuIGhjjO4
         NtXBMDB7BoqCGOUfTNFThQ2q/zHSZ3MJn4UlhOw9QXIYlnHeoVIOdXTSNFkOMKICCkLR
         4V8UnPubDeqOtZjk2LmC+nTCSLptHe5Zj4QOiAUxzJx6RUh/kXvzvLr/c8oQa01f5eyv
         NXZ/I9aiVT/dMHRYPRhSUZfO8dR1GzF6FkcMIHYCJQLGBynQs1Mt3x7Kw1rlQqKrF7fz
         5ANA==
X-Forwarded-Encrypted: i=1; AJvYcCVXu+315oEu7EFkKF/1tLT3itMBjrliEjZMfXrEt0Bd/ZWNWvBrhf2cG3YrFbHIGTt+wadiQdHdNGmH@vger.kernel.org
X-Gm-Message-State: AOJu0YxR3/Eg8cnzAuWLIsKOBjRE/dok2rlYhJBO+/4nfDPimP5uBP2+
	PTMahtnDGkSpftM6mUvPDb8vYtR9nn4wPvJaKv7NBkP4lDDwIHp2QiD2yAxcN6XS4s+1ENU2JVq
	w/yTbnyEM70gViAnFnIacyhwzJlnOmTpDUBH7AvutnDgQ5glYK3vPYVhubMnekYcBqVghMFN2nt
	+bpGKvgWDk2EkDjkI5gmnn1pk/8zg8rW6MXG3Vsg==
X-Gm-Gg: ASbGncupgfZIkJFgbF66GCm0m17sDN5Z8d9Kr4yLg0yhEx3V0pOweay/aGM+tfWDloW
	H+7e+iMJo8mZVCfiZv7HVfjfpXHDpyqj1ad/vYXDTFjTg+fZro9/pqhDDTm2++NcmMJmzAnu1vn
	O55T/WYUuN6GvKRA8bKVd75LicXFJMAzxzWanbyDuwi6DP0opYyLl1Y8Q8
X-Received: by 2002:a05:690c:b96:b0:786:660b:82b5 with SMTP id 00721157ae682-787d53a7a10mr61480407b3.27.1762741875035;
        Sun, 09 Nov 2025 18:31:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEMPh2N6k6ML216hxK7CX656D3mzPsUL3tDVmxptiZG0gis1LUqTj6iF3RlQO7WRybnvAbVNvj2OZk1R2nncgI=
X-Received: by 2002:a05:690c:b96:b0:786:660b:82b5 with SMTP id
 00721157ae682-787d53a7a10mr61480257b3.27.1762741874575; Sun, 09 Nov 2025
 18:31:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251103125757.1405796-1-linan666@huaweicloud.com> <20251103125757.1405796-6-linan666@huaweicloud.com>
In-Reply-To: <20251103125757.1405796-6-linan666@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 10 Nov 2025 10:30:55 +0800
X-Gm-Features: AWmQ_bny1JxQznfWpBKLAFq5VHnn-1VGKkeCkBDuzefNBgUmOFE9Kn0LbkFn9xg
Message-ID: <CALTww29YpgLSzPPkvo79bf5M-pNjGroJrmGBwx2XGQhMOQEe4A@mail.gmail.com>
Subject: Re: [PATCH v9 5/5] md: allow configuring logical block size
To: linan666@huaweicloud.com
Cc: corbet@lwn.net, song@kernel.org, yukuai@fnnas.com, linan122@huawei.com, 
	hare@suse.de, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 3, 2025 at 9:06=E2=80=AFPM <linan666@huaweicloud.com> wrote:
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
>  Documentation/admin-guide/md.rst | 10 +++++
>  drivers/md/md.h                  |  1 +
>  include/uapi/linux/raid/md_p.h   |  3 +-
>  drivers/md/md-linear.c           |  1 +
>  drivers/md/md.c                  | 77 ++++++++++++++++++++++++++++++++
>  drivers/md/raid0.c               |  1 +
>  drivers/md/raid1.c               |  1 +
>  drivers/md/raid10.c              |  1 +
>  drivers/md/raid5.c               |  1 +
>  9 files changed, 95 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide=
/md.rst
> index 1c2eacc94758..b7e7081889fe 100644
> --- a/Documentation/admin-guide/md.rst
> +++ b/Documentation/admin-guide/md.rst
> @@ -238,6 +238,16 @@ All md devices contain:
>       the number of devices in a raid4/5/6, or to support external
>       metadata formats which mandate such clipping.
>
> +  logical_block_size
> +     Configure the array's logical block size in bytes. This attribute
> +     is only supported for 1.x meta. Write the value before starting
> +     array. The final array LBS uses the maximum between this
> +     configuration and LBS of all combined devices. Note that
> +     LBS cannot exceed PAGE_SIZE before RAID supports folio.
> +     WARNING: Arrays created on new kernel cannot be assembled at old
> +     kernel due to padding check, Set module parameter 'check_new_featur=
e'
> +     to false to bypass, but data loss may occur.
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
> index 5921fb245bfa..e5f994c33dfe 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1998,6 +1998,7 @@ static int super_1_validate(struct mddev *mddev, st=
ruct md_rdev *freshest, struc
>                 mddev->layout =3D le32_to_cpu(sb->layout);
>                 mddev->raid_disks =3D le32_to_cpu(sb->raid_disks);
>                 mddev->dev_sectors =3D le64_to_cpu(sb->size);
> +               mddev->logical_block_size =3D le32_to_cpu(sb->logical_blo=
ck_size);
>                 mddev->events =3D ev1;
>                 mddev->bitmap_info.offset =3D 0;
>                 mddev->bitmap_info.space =3D 0;
> @@ -2207,6 +2208,7 @@ static void super_1_sync(struct mddev *mddev, struc=
t md_rdev *rdev)
>         sb->chunksize =3D cpu_to_le32(mddev->chunk_sectors);
>         sb->level =3D cpu_to_le32(mddev->level);
>         sb->layout =3D cpu_to_le32(mddev->layout);
> +       sb->logical_block_size =3D cpu_to_le32(mddev->logical_block_size)=
;
>         if (test_bit(FailFast, &rdev->flags))
>                 sb->devflags |=3D FailFast1;
>         else
> @@ -5935,6 +5937,68 @@ static struct md_sysfs_entry md_serialize_policy =
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
> @@ -5957,6 +6021,7 @@ static struct attribute *md_default_attrs[] =3D {
>         &md_consistency_policy.attr,
>         &md_fail_last_dev.attr,
>         &md_serialize_policy.attr,
> +       &md_logical_block_size.attr,
>         NULL,
>  };
>
> @@ -6087,6 +6152,17 @@ int mddev_stack_rdev_limits(struct mddev *mddev, s=
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
> @@ -6698,6 +6774,7 @@ static void md_clean(struct mddev *mddev)
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

Looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

