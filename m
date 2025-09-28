Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276D6DF71
	for <linux-raid@vger.kernel.org>; Sun, 28 Sep 2025 01:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759024008; cv=none; b=D3VL4aYaoTiesu0f9hrBuHdCn6nWZJAftaGRj9Z3cxDFvIKF+CHrFnvIubf+0ftUEXhMQmzoWPpoHly43wdOcn3wz9fHAnVt5f6mj/PBDbGkgHmRU6Ik6t666qvDW9Onxa7jkS33RIArKTy23BW6tJMQJED+Ps0Ls6BPi4SlZ7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759024008; c=relaxed/simple;
	bh=ejUqoAqHmeObEDSOkgJuywdtokkTfBt2jA6Ep78K4ic=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UIh/biFsYn+93joXqAr8ga559OhF6vVR1OyCxGJ/AQAhGX7JlpKosHM1v5XwdoQFe6zhS5bKmQwMLFwqhMYsuE+Aaim4gGiZUjkhqQkpAaMQLLeo6fVky3m+3ltLyCt9z5sm54y484v+BEKyqTQ6d1vWXHYvczfX3THJHkl1crM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FqSVucd+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FqSVucd+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759024005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bF87j694VJWDvAZhe8HeVL364jMMLyaTKh2LPfc0lYY=;
	b=FqSVucd+7H3BIKFcTRIRf9T56xi6MXdhnEoqiJ+fzdTYGooc7whDlwJFwRKMBC7dfXNkTx
	c3PP9CcNNvzIjz9O71VjYLR56KaKX90aVOWslncs+dcQipLe31fyCP0lJuArxlJr4wUpr3
	GGUmuRKB5PXNyG+tWnVo5mcs/U2z1Rk=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-4MIkHHTiNRiEtPWYxnhC7A-1; Sat, 27 Sep 2025 21:46:43 -0400
X-MC-Unique: 4MIkHHTiNRiEtPWYxnhC7A-1
X-Mimecast-MFC-AGG-ID: 4MIkHHTiNRiEtPWYxnhC7A_1759024002
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-57a31c382b8so2357610e87.0
        for <linux-raid@vger.kernel.org>; Sat, 27 Sep 2025 18:46:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759024002; x=1759628802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bF87j694VJWDvAZhe8HeVL364jMMLyaTKh2LPfc0lYY=;
        b=Y1ePAB35FWihQBUIqw9GleD7G1rgDP3P7hkq42Fat7Sjwu3OzYRMXctVCTcA+hXsEX
         8tweNKSQHNlxGl2n1hpwQZCgouwdTeexOoI2svPF/jB/1kaKRKPsfWkrwBjp2LcHZdH4
         jQEhprgXjaG8aqhZOqZAFO+RwosiYADBpSR6jT9CrW5Ovxl9VKxy7LSQrFw0zXhdhmCk
         eow2JyEjXH/kef6hj/zGXHb0DJ1KxonSFdSHHXqOkMvIjMw/x1ahGqHjDSiZFvh40dji
         /8VnSbncfxQoxWpVADWPYbV/J0pVF9ojGOoquY4sts5CAjDs2LvKrzFTDvSftNJHtvIj
         zf6g==
X-Forwarded-Encrypted: i=1; AJvYcCXIhDR2iJ6HHPAPsd97Mla53Dp730Rl0sqD0iptmm1lkV5ceeHFihcNNHVBATTMLSQPBWp8tgR1auZp@vger.kernel.org
X-Gm-Message-State: AOJu0YwnZGftL4oQaPpy8oA8c05CiNor37ap1flcFGb2Hri7qfOjqWft
	xzXvEMWF3IDcxFZpuponcGBuBl44VxhMksuijOvBkgTfsq/Dd91pxme1VitfxwMCFWc7Y0uFWxU
	MwJGhIAkVHdkrYjSn3AG2jba/unjVj16wzTNTAv2jHrsvTYEJeq2BaEUr7+rc+1ek1qi7/sTSQV
	szMo8KFWAPs9oefnI5RwPb9CYqJ1mu910a03FNEQ==
X-Gm-Gg: ASbGncsgGi9N4Qx3uKz1Gu0cL929F4UY4qS5/i1VvkZCseyI//mPlnuWV/TO6luxWNC
	qUXHLWuj7EkG3rPD89q399GO/QQBbmKF2QrB2NY1eyWTx7inuq1Yk/k2mV3vQSq8rOsLs684a7E
	LvLWyfv5RBvvxGNHTv/ZVQVA==
X-Received: by 2002:a05:6512:1389:b0:57b:8315:7e13 with SMTP id 2adb3069b0e04-582d4258319mr3689677e87.57.1759024001679;
        Sat, 27 Sep 2025 18:46:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFvg23zKjHdxcDdNKqGHx4IilpBUrmYLEkdPN4ggzXdW7MvVx8Si8rnGO0NQ5ZtJBX3mapKU5Ugpttudjjshjw=
X-Received: by 2002:a05:6512:1389:b0:57b:8315:7e13 with SMTP id
 2adb3069b0e04-582d4258319mr3689664e87.57.1759024001179; Sat, 27 Sep 2025
 18:46:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926071837.766910-1-linan666@huaweicloud.com>
In-Reply-To: <20250926071837.766910-1-linan666@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Sun, 28 Sep 2025 09:46:29 +0800
X-Gm-Features: AS18NWBfhDqZ1h_dIwZxgNn_UaBlhpF6PvZpsXWJOEiB917WzNfB_LwJ1aOk0pE
Message-ID: <CALTww284K51ppg8XO5e6QHG+bzXhHSdJbsQAgh0fes5Jp4DW7w@mail.gmail.com>
Subject: Re: [PATCH v6] md: allow configuring logical block size
To: linan666@huaweicloud.com
Cc: corbet@lwn.net, song@kernel.org, yukuai3@huawei.com, linan122@huawei.com, 
	hare@suse.de, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, martin.petersen@oracle.com, yangerkun@huawei.com, 
	yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 26, 2025 at 3:29=E2=80=AFPM <linan666@huaweicloud.com> wrote:
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
> v6:
>  - Improve print message
>  - s/RAID5/RAID456/g
>
> v5: in patch2:
>     Fix typo. Add reproducer in log.
>
> v4:
>  patch 1: add fix tag.
>  patch 2:
>  - add documentation for sysfs.
>  - only support metadata format 1.x.
>  - do not call md_update_sb when writing sysfs. mddev->pers is NULL here.
>  - return directly before hold lock in lbs_store.
>
> v3:
>  - logical_block_size must not exceed PAGE_SIZE for bio device.
>  - Assign lim to mddev rather than to gendisk in mddev_stack_rdev_limits(=
).
>  - Remove the patch that modifies the return value.
>
> v2: No new exported interfaces are introduced.
>
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
> index 1c2eacc94758..493071158d8e 100644
> --- a/Documentation/admin-guide/md.rst
> +++ b/Documentation/admin-guide/md.rst
> @@ -238,6 +238,13 @@ All md devices contain:
>       the number of devices in a raid4/5/6, or to support external
>       metadata formats which mandate such clipping.
>
> +  logical_block_size
> +     Configures the array's logical block size in bytes. This attribute
> +     is only supported for RAID1, RAID456, RAID10 with 1.x meta. The val=
ue
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
> index 40f56183c744..91fe955cbd08 100644
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

Hi

I just saw your v5 replied email and noticed this place. The logcial
block size doesn't have relationship with sync action, right?
md_redundancy_attrs is used for sync attributes. So is it better to
put this into md_default_attrs?


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

raid0 creates zone stripes first based on the member disk's LBS. So
it's not right to change the logical block size here?

Best Regards
Xiao
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

