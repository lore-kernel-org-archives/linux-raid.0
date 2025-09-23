Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1185695
	for <linux-raid@vger.kernel.org>; Tue, 23 Sep 2025 14:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758636439; cv=none; b=s1+NZ+d2pThc3tUlEbFe6XBGdBDCpSwqlcnUG46RxD7FAsYGzkonF3JwMKqiIcKs5cFGbiy/RFcIN61CT2LB68250yKq7Ny0tNuFK3dblb75KLGimD3TvZiCVzhgzWUV+bbT28FX2ps7ZyCB/vgF9x+R9Q7BtxngSaUkz8ngJYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758636439; c=relaxed/simple;
	bh=/2mleWLHIZh05MZ05yH7xTymq55hXfOh+CwN3zLm+GU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a4ckOaWljn7DcXj1OldK+0dxHAJA1ibeRpneqc6yaB5tXMkzVeRG9QZIkye/dcEQQVP2MIzYc6IRMfi/jBj9/noBxWG/64ubeYbeg6Wv6V8mr8KWobQRKy1nVLusoaj5vP/Keg6b95blK1LUFXa6bUjav3WZoMigiWLBvPiTRSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QTUr/gWw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QTUr/gWw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758636436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kjyw9mS8YzbSQhc83g2Zp4AXhZWU1Nn9EGqrXHlT0FA=;
	b=QTUr/gWwqU0cA5EWowreMO+6LWAfg0sn5FxCchJ3Jo4xwO9mtouVofxKwNort0w1MCn1w1
	2tIS3RINr4vyowfGQCApZF2KyY7Xj+WF1hpGCsLZS5JeDy9sWy1y7ixKcZsQGBEPJUIIqD
	VP7NCafcD8MrfymWVuJeqGuAd/f9/L8=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202-xI9Bi4u0MLezN0yFn4trAQ-1; Tue, 23 Sep 2025 10:07:14 -0400
X-MC-Unique: xI9Bi4u0MLezN0yFn4trAQ-1
X-Mimecast-MFC-AGG-ID: xI9Bi4u0MLezN0yFn4trAQ_1758636431
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-36af4d383feso11347271fa.2
        for <linux-raid@vger.kernel.org>; Tue, 23 Sep 2025 07:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758636431; x=1759241231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kjyw9mS8YzbSQhc83g2Zp4AXhZWU1Nn9EGqrXHlT0FA=;
        b=CIeE8Wj6s5XuJfko8zcsZAlIOCMwGqnIDVCz3eFr+ezCnR8yVlV6AqV7qhuaZ4WyIR
         kv8R5o77iR6WlIH7xy7LUD4cfvt/I4zn8ClGp7PByQGR9EJU9HWpG2lT2v0FVkG8Zi0p
         q+KHvxaL/ddY2Z0CFx5OEqw5Mjci4XpdpPL9nXpri8pgdUBscolUBOJQmsKTkXKNFgdO
         YEbuWwomUiBkB57OwlbkTUKNjE0sNX1rtllHvywteEJhMIzgWxEZZuCKIBXTnLNC921k
         1N2RIizWNAhMjgeYsMg9di6SZjEk5Gkbyy3/bV2ypjq5PWb4j2ihYDJQDJZPTspVZSh0
         ulAQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5lDYi4TNXd08QgU/yfOiSic3lc3fG8tt0jQ8TP4ztVvQ8/FL1uRDCWY9aVQMeHqLGFChyS66K447l@vger.kernel.org
X-Gm-Message-State: AOJu0YyTobunfb1h++Igmwq0L+LTwyAVhlI/A1N+1vhkoYyGfs/TJ2Oo
	zBZH8Ne9lv5ra/DLnSqiQ/jVOKdn6J6n10cnrF+rl5kWfZ4nNAsPeGROjEg6kVT1+TwSvyNWu9b
	KrifSlURmbZGzXDqIFnaARPTgoeuw0qkypxRmzK4NQ6hTNMSZjvPjSItSX4ZVspOd4hmZxBJvAD
	aDAxl3gv/Uq2gEss2g/yDekcC4d0sME8V/Ha45zQ==
X-Gm-Gg: ASbGncudV1b11rC5iAwzvQBqBkcgAjyQcmMXDq3orKhWQo3qDiDsPyWflPFJLEMPMWl
	OTn2lsh6Rofb7aHkRI5+px9EO8+fLHRB0FAmd+xqxWiMfsSGBvLYLf5sT6ZcjkdJW1trnz5KweD
	KGigp3ApAi6m/oeNDHPsIGbw==
X-Received: by 2002:a2e:b8c2:0:b0:350:690e:219 with SMTP id 38308e7fff4ca-36d16dec9e3mr11195871fa.33.1758636431154;
        Tue, 23 Sep 2025 07:07:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnvdcfAZXkkguji5J5L9DB0ruMNmkGB0D8m4uGELGy0j9NTHF/TaRKRd8lfyRGyyozct9JnDYa8vkQaFkAT1Q=
X-Received: by 2002:a2e:b8c2:0:b0:350:690e:219 with SMTP id
 38308e7fff4ca-36d16dec9e3mr11195701fa.33.1758636430471; Tue, 23 Sep 2025
 07:07:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250918115759.334067-1-linan666@huaweicloud.com>
 <20250918115759.334067-3-linan666@huaweicloud.com> <CALTww2_4rEb9SojpVbwFy=ZEjUc0-4ECYZKYKgsay9XzDTs-cg@mail.gmail.com>
 <b7fc02d2-7643-4bf1-1b15-c1ecdf883c87@huaweicloud.com>
In-Reply-To: <b7fc02d2-7643-4bf1-1b15-c1ecdf883c87@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 23 Sep 2025 22:06:58 +0800
X-Gm-Features: AS18NWDDDJ0K9e_QG6qURe6CQv1sgIdakMjaBaPZ9EzAF-b5kDVQqe-3LBBgdg4
Message-ID: <CALTww2_knuDVWLtVzrqcuLH5dmiyMqkAaZr2DB_ZpCYPQsYH0A@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] md: allow configuring logical block size
To: Li Nan <linan666@huaweicloud.com>
Cc: corbet@lwn.net, song@kernel.org, yukuai3@huawei.com, hare@suse.de, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, martin.petersen@oracle.com, yangerkun@huawei.com, 
	yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2025 at 9:37=E2=80=AFPM Li Nan <linan666@huaweicloud.com> w=
rote:
>
>
>
> =E5=9C=A8 2025/9/23 19:36, Xiao Ni =E5=86=99=E9=81=93:
> > Hi Li Nan
> >
> > On Thu, Sep 18, 2025 at 8:08=E2=80=AFPM <linan666@huaweicloud.com> wrot=
e:
> >>
> >> From: Li Nan <linan122@huawei.com>
> >>
> >> Previously, raid array used the maximum logical block size (LBS)
> >> of all member disks. Adding a larger LBS disk at runtime could
> >> unexpectedly increase RAID's LBS, risking corruption of existing
> >> partitions. This can be reproduced by:
> >>
> >> ```
> >>    # LBS of sd[de] is 512 bytes, sdf is 4096 bytes.
> >>    mdadm -CRq /dev/md0 -l1 -n3 /dev/sd[de] missing --assume-clean
> >>
> >>    # LBS is 512
> >>    cat /sys/block/md0/queue/logical_block_size
> >>
> >>    # create partition md0p1
> >>    parted -s /dev/md0 mklabel gpt mkpart primary 1MiB 100%
> >>    lsblk | grep md0p1
> >>
> >>    # LBS becomes 4096 after adding sdf
> >>    mdadm --add -q /dev/md0 /dev/sdf
> >>    cat /sys/block/md0/queue/logical_block_size
> >>
> >>    # partition lost
> >>    partprobe /dev/md0
> >>    lsblk | grep md0p1
> >> ```
> >
> > Thanks for the reproducer. I can reproduce it myself.
> >
> >>
> >> Simply restricting larger-LBS disks is inflexible. In some scenarios,
> >> only disks with 512 bytes LBS are available currently, but later, disk=
s
> >> with 4KB LBS may be added to the array.
> >
> > If we add a disk with 4KB LBS and configure it to 4KB by the sysfs
> > interface, how can we make the partition table readable and avoid the
> > problem mentioned above?
> >
>

Hi

> Thanks for your review.
>
> The main cause of partition loss is LBS changes. Therefore, we should
> specify a 4K LBS at creation time, instead of modifying LBS after the RAI=
D
> is already in use. For example:
>
> mdadm -C --logical-block-size=3D4096 ...
>
> In this way, even if all underlying disks are 512-byte, the RAID will be
> created with a 4096 LBS. Adding 4096-byte disks later will not cause any
> issues.

It can work. But it looks strange to me to set LBS to 4096 but all
devices' LBS is 512 bytes. I don't reject it anyway :)

>
> >>
> >> Making LBS configurable is the best way to solve this scenario.
> >> After this patch, the raid will:
> >>    - store LBS in disk metadata
> >>    - add a read-write sysfs 'mdX/logical_block_size'
> >>
> >> Future mdadm should support setting LBS via metadata field during RAID
> >> creation and the new sysfs. Though the kernel allows runtime LBS chang=
es,
> >> users should avoid modifying it after creating partitions or filesyste=
ms
> >> to prevent compatibility issues.
> >>
> >> Only 1.x metadata supports configurable LBS. 0.90 metadata inits all
> >> fields to default values at auto-detect. Supporting 0.90 would require
> >> more extensive changes and no such use case has been observed.
> >>
> >> Note that many RAID paths rely on PAGE_SIZE alignment, including for
> >> metadata I/O. A larger LBS than PAGE_SIZE will result in metadata
> >> read/write failures. So this config should be prevented.
> >>
> >> Signed-off-by: Li Nan <linan122@huawei.com>
> >> ---
> >>   Documentation/admin-guide/md.rst |  7 +++
> >>   drivers/md/md.h                  |  1 +
> >>   include/uapi/linux/raid/md_p.h   |  3 +-
> >>   drivers/md/md-linear.c           |  1 +
> >>   drivers/md/md.c                  | 75 ++++++++++++++++++++++++++++++=
++
> >>   drivers/md/raid0.c               |  1 +
> >>   drivers/md/raid1.c               |  1 +
> >>   drivers/md/raid10.c              |  1 +
> >>   drivers/md/raid5.c               |  1 +
> >>   9 files changed, 90 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-gu=
ide/md.rst
> >> index 1c2eacc94758..f5c81fad034a 100644
> >> --- a/Documentation/admin-guide/md.rst
> >> +++ b/Documentation/admin-guide/md.rst
> >> @@ -238,6 +238,13 @@ All md devices contain:
> >>        the number of devices in a raid4/5/6, or to support external
> >>        metadata formats which mandate such clipping.
> >>
> >> +  logical_block_size
> >> +     Configures the array's logical block size in bytes. This attribu=
te
> >> +     is only supported for RAID1, RAID5, RAID10 with 1.x meta. The va=
lue
> >
> > s/RAID5/RAID456/g
> >
>
> I will fix it later. Thanks.
>
> >> +     should be written before starting the array. The final array LBS
> >> +     will use the max value between this configuration and all rdev's=
 LBS.
> >> +     Note that LBS cannot exceed PAGE_SIZE.
> >> +
> >>     reshape_position
> >>        This is either ``none`` or a sector number within the devices o=
f
> >>        the array where ``reshape`` is up to.  If this is set, the thre=
e
> >> diff --git a/drivers/md/md.h b/drivers/md/md.h
> >> index afb25f727409..b0147b98c8d3 100644
> >> --- a/drivers/md/md.h
> >> +++ b/drivers/md/md.h
> >> @@ -432,6 +432,7 @@ struct mddev {
> >>          sector_t                        array_sectors; /* exported ar=
ray size */
> >>          int                             external_size; /* size manage=
d
> >>                                                          * externally =
*/
> >> +       unsigned int                    logical_block_size;
> >>          __u64                           events;
> >>          /* If the last 'event' was simply a clean->dirty transition, =
and
> >>           * we didn't write it to the spares, then it is safe and simp=
le
> >> diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/=
md_p.h
> >> index ac74133a4768..310068bb2a1d 100644
> >> --- a/include/uapi/linux/raid/md_p.h
> >> +++ b/include/uapi/linux/raid/md_p.h
> >> @@ -291,7 +291,8 @@ struct mdp_superblock_1 {
> >>          __le64  resync_offset;  /* data before this offset (from data=
_offset) known to be in sync */
> >>          __le32  sb_csum;        /* checksum up to devs[max_dev] */
> >>          __le32  max_dev;        /* size of devs[] array to consider *=
/
> >> -       __u8    pad3[64-32];    /* set to 0 when writing */
> >> +       __le32  logical_block_size;     /* same as q->limits->logical_=
block_size */
> >> +       __u8    pad3[64-36];    /* set to 0 when writing */
> >>
> >>          /* device state information. Indexed by dev_number.
> >>           * 2 bytes per device
> >> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> >> index 5d9b08115375..da8babb8da59 100644
> >> --- a/drivers/md/md-linear.c
> >> +++ b/drivers/md/md-linear.c
> >> @@ -72,6 +72,7 @@ static int linear_set_limits(struct mddev *mddev)
> >>
> >>          md_init_stacking_limits(&lim);
> >>          lim.max_hw_sectors =3D mddev->chunk_sectors;
> >> +       lim.logical_block_size =3D mddev->logical_block_size;
> >>          lim.max_write_zeroes_sectors =3D mddev->chunk_sectors;
> >>          lim.io_min =3D mddev->chunk_sectors << 9;
> >>          err =3D mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTE=
GRITY);
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index 40f56183c744..e0184942c8ec 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -1963,6 +1963,7 @@ static int super_1_validate(struct mddev *mddev,=
 struct md_rdev *freshest, struc
> >>                  mddev->layout =3D le32_to_cpu(sb->layout);
> >>                  mddev->raid_disks =3D le32_to_cpu(sb->raid_disks);
> >>                  mddev->dev_sectors =3D le64_to_cpu(sb->size);
> >> +               mddev->logical_block_size =3D le32_to_cpu(sb->logical_=
block_size);
> >>                  mddev->events =3D ev1;
> >>                  mddev->bitmap_info.offset =3D 0;
> >>                  mddev->bitmap_info.space =3D 0;
> >> @@ -2172,6 +2173,7 @@ static void super_1_sync(struct mddev *mddev, st=
ruct md_rdev *rdev)
> >>          sb->chunksize =3D cpu_to_le32(mddev->chunk_sectors);
> >>          sb->level =3D cpu_to_le32(mddev->level);
> >>          sb->layout =3D cpu_to_le32(mddev->layout);
> >> +       sb->logical_block_size =3D cpu_to_le32(mddev->logical_block_si=
ze);
> >>          if (test_bit(FailFast, &rdev->flags))
> >>                  sb->devflags |=3D FailFast1;
> >>          else
> >> @@ -5900,6 +5902,66 @@ static struct md_sysfs_entry md_serialize_polic=
y =3D
> >>   __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
> >>          serialize_policy_store);
> >>
> >> +static int mddev_set_logical_block_size(struct mddev *mddev,
> >> +                               unsigned int lbs)
> >> +{
> >> +       int err =3D 0;
> >> +       struct queue_limits lim;
> >> +
> >> +       if (queue_logical_block_size(mddev->gendisk->queue) >=3D lbs) =
{
> >> +               pr_err("%s: incompatible logical_block_size %u, can no=
t set\n",
> >> +                      mdname(mddev), lbs);
> >
> > Is it better to print the mddev's LBS and give the message "it can't
> > set lbs smaller than mddev logical block size"?
> >
>
> I agree. Let me improve this.
>
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       lim =3D queue_limits_start_update(mddev->gendisk->queue);
> >> +       lim.logical_block_size =3D lbs;
> >> +       pr_info("%s: logical_block_size is changed, data may be lost\n=
",
> >> +               mdname(mddev));
> >> +       err =3D queue_limits_commit_update(mddev->gendisk->queue, &lim=
);
> >> +       if (err)
> >> +               return err;
> >> +
> >> +       mddev->logical_block_size =3D lbs;
> >> +       return 0;
> >> +}
> >> +
> >> +static ssize_t
> >> +lbs_show(struct mddev *mddev, char *page)
> >> +{
> >> +       return sprintf(page, "%u\n", mddev->logical_block_size);
> >> +}
> >> +
> >> +static ssize_t
> >> +lbs_store(struct mddev *mddev, const char *buf, size_t len)
> >> +{
> >> +       unsigned int lbs;
> >> +       int err =3D -EBUSY;
> >> +
> >> +       /* Only 1.x meta supports configurable LBS */
> >> +       if (mddev->major_version =3D=3D 0)
> >> +               return -EINVAL;
> >
> > It looks like it should check raid level here as doc mentioned above, r=
ight?
>
> Yeah, kuai suggests supporting this feature only in 1.x meta.

I mean it should check if raid is raid0 here, right? As doc mentioned,
it should return error if raid is level 0.

Regards
Xiao
>
>
> --
> Thanks,
> Nan
>
>

