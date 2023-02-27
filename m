Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F2FC6FA8E
	for <linux-raid@archiver.kernel.org>; Mon, 27 Feb 2023 01:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjB0B5X (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 26 Feb 2023 20:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjB0B5W (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 26 Feb 2023 20:57:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157B4126C6
        for <linux-raid@vger.kernel.org>; Sun, 26 Feb 2023 17:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677462994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7rRCND/HOpE/QpdfHGxb6VIrbalKbeMC9mGmL8g/Yqs=;
        b=c8o1nndY0XhWFJBQQSZUIYg0oWDyLomTsZ/wIHHhf7SCvDfINdkuNescG6RQZZkNNB6/4C
        Utb7ziZF4eAYzZYAqUH8AOWUCjbEE001fPmViKgWt9yA2mdTaR8fgilOLAZT98FLq6Pkvz
        DfVPASbIgSMUwHnCt+B1eb+j7D9Ly5g=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-645-2RjT-P4UMziiOfIjLGCTCQ-1; Sun, 26 Feb 2023 20:56:32 -0500
X-MC-Unique: 2RjT-P4UMziiOfIjLGCTCQ-1
Received: by mail-pg1-f197.google.com with SMTP id e127-20020a636985000000b004bbc748ca63so1204572pgc.3
        for <linux-raid@vger.kernel.org>; Sun, 26 Feb 2023 17:56:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7rRCND/HOpE/QpdfHGxb6VIrbalKbeMC9mGmL8g/Yqs=;
        b=oDD60tyaxUJBNVVnHcDY4yuSXxyC3coOLaJxHbmmY1dMzvriZRURyj3GVBbH6vg7sT
         0gWpyuMtkyjwQLTCBX5iQh3fmR/B8PTSqHxzM/y0UmjcfR2QZpL55UA+isKrjeA/PfC4
         UHoYSb1EvNam8l67Aw1iutIR31JuFE9+Z7Zq6jmM3ngvW2BlwFxqoeDaBX+pZ1eNtO86
         RrMXpWZJv337dO37iX43H46uVjDpDNMyEopiV/Zs8OmSoyrSVCBahtk/xtVurVdN79WK
         cuc7jecnVxFFrbrz/vgrPxgy++V1EeQ0wO+cFSXKZceEP4HI5yrIhC7ETvPoNO/KZ+r2
         zebA==
X-Gm-Message-State: AO0yUKU0tUyeXDI36mxs4c+RDP6P2M9V9PXzq4HzU7HmEJqP5PPMkcRZ
        BynmjpAGXkX9tih/QfuiI+A/UBdXKDCVFSSFAarI6owfaY5yeNKrr940phKZc5LbdD3rsutFERF
        spkq3CTzLGvmDvfCT9g73Y7ykbzX2wBrC3b1NWA==
X-Received: by 2002:a17:903:4289:b0:19a:8751:4dfc with SMTP id ju9-20020a170903428900b0019a87514dfcmr5581504plb.1.1677462990642;
        Sun, 26 Feb 2023 17:56:30 -0800 (PST)
X-Google-Smtp-Source: AK7set9VE00Rn4Z8jkknmImI9Wf6/EGMkTPU7RaYEmOxs5DmlkhPoFEnZgGVz2lqxxE7iApIOJNTA1E4sYcQOXWZuVo=
X-Received: by 2002:a17:903:4289:b0:19a:8751:4dfc with SMTP id
 ju9-20020a170903428900b0019a87514dfcmr5581498plb.1.1677462990331; Sun, 26 Feb
 2023 17:56:30 -0800 (PST)
MIME-Version: 1.0
References: <20230224183323.638-1-jonathan.derrick@linux.dev> <20230224183323.638-4-jonathan.derrick@linux.dev>
In-Reply-To: <20230224183323.638-4-jonathan.derrick@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 27 Feb 2023 09:56:18 +0800
Message-ID: <CALTww2_P6TaV7C5i2k5sUeHOpnqTxjFB-ZA98Y2re+17J5d7Kw@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] md: Use optimal I/O size for last bitmap page
To:     Jonathan Derrick <jonathan.derrick@linux.dev>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Reindl Harald <h.reindl@thelounge.net>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Sushma Kalakota <sushma.kalakota@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jonathan

I did a test in my environment, but I didn't see such a big
performance difference.

The first environment:
All nvme devices have 512 logical size, 512 phy size, and 0 optimal size. T=
hen
I used your way to rebuild the kernel
/sys/block/nvme0n1/queue/physical_block_size 512
/sys/block/nvme0n1/queue/optimal_io_size 4096
cat /sys/block/nvme0n1/queue/logical_block_size 512

without the patch set
write: IOPS=3D68.0k, BW=3D266MiB/s (279MB/s)(15.6GiB/60001msec); 0 zone res=
ets
with the patch set
write: IOPS=3D69.1k, BW=3D270MiB/s (283MB/s)(15.8GiB/60001msec); 0 zone res=
ets

The second environment:
The nvme devices' opt size are 4096. So I don't need to rebuild the kernel.
/sys/block/nvme0n1/queue/logical_block_size
/sys/block/nvme0n1/queue/physical_block_size
/sys/block/nvme0n1/queue/optimal_io_size

without the patch set
write: IOPS=3D51.6k, BW=3D202MiB/s (212MB/s)(11.8GiB/60001msec); 0 zone res=
ets
with the patch set
write: IOPS=3D53.5k, BW=3D209MiB/s (219MB/s)(12.2GiB/60001msec); 0 zone res=
ets

Best Regards
Xiao

On Sat, Feb 25, 2023 at 2:34=E2=80=AFAM Jonathan Derrick
<jonathan.derrick@linux.dev> wrote:
>
> From: Jon Derrick <jonathan.derrick@linux.dev>
>
> If the bitmap space has enough room, size the I/O for the last bitmap
> page write to the optimal I/O size for the storage device. The expanded
> write is checked that it won't overrun the data or metadata.
>
> The drive this was tested against has higher latencies when there are
> sub-4k writes due to device-side read-mod-writes of its atomic 4k write
> unit. This change helps increase performance by sizing the last bitmap
> page I/O for the device's preferred write unit, if it is given.
>
> Example Intel/Solidigm P5520
> Raid10, Chunk-size 64M, bitmap-size 57228 bits
>
> $ mdadm --create /dev/md0 --level=3D10 --raid-devices=3D4 /dev/nvme{0,1,2=
,3}n1
>         --assume-clean --bitmap=3Dinternal --bitmap-chunk=3D64M
> $ fio --name=3Dtest --direct=3D1 --filename=3D/dev/md0 --rw=3Drandwrite -=
-bs=3D4k --runtime=3D60
>
> Without patch:
>   write: IOPS=3D1676, BW=3D6708KiB/s (6869kB/s)(393MiB/60001msec); 0 zone=
 resets
>
> With patch:
>   write: IOPS=3D15.7k, BW=3D61.4MiB/s (64.4MB/s)(3683MiB/60001msec); 0 zo=
ne resets
>
> Biosnoop:
> Without patch:
> Time        Process        PID     Device      LBA        Size      Lat
> 1.410377    md0_raid10     6900    nvme0n1   W 16         4096      0.02
> 1.410387    md0_raid10     6900    nvme2n1   W 16         4096      0.02
> 1.410374    md0_raid10     6900    nvme3n1   W 16         4096      0.01
> 1.410381    md0_raid10     6900    nvme1n1   W 16         4096      0.02
> 1.410411    md0_raid10     6900    nvme1n1   W 115346512  4096      0.01
> 1.410418    md0_raid10     6900    nvme0n1   W 115346512  4096      0.02
> 1.410915    md0_raid10     6900    nvme2n1   W 24         3584      0.43 =
<--
> 1.410935    md0_raid10     6900    nvme3n1   W 24         3584      0.45 =
<--
> 1.411124    md0_raid10     6900    nvme1n1   W 24         3584      0.64 =
<--
> 1.411147    md0_raid10     6900    nvme0n1   W 24         3584      0.66 =
<--
> 1.411176    md0_raid10     6900    nvme3n1   W 2019022184 4096      0.01
> 1.411189    md0_raid10     6900    nvme2n1   W 2019022184 4096      0.02
>
> With patch:
> Time        Process        PID     Device      LBA        Size      Lat
> 5.747193    md0_raid10     727     nvme0n1   W 16         4096      0.01
> 5.747192    md0_raid10     727     nvme1n1   W 16         4096      0.02
> 5.747195    md0_raid10     727     nvme3n1   W 16         4096      0.01
> 5.747202    md0_raid10     727     nvme2n1   W 16         4096      0.02
> 5.747229    md0_raid10     727     nvme3n1   W 1196223704 4096      0.02
> 5.747224    md0_raid10     727     nvme0n1   W 1196223704 4096      0.01
> 5.747279    md0_raid10     727     nvme0n1   W 24         4096      0.01 =
<--
> 5.747279    md0_raid10     727     nvme1n1   W 24         4096      0.02 =
<--
> 5.747284    md0_raid10     727     nvme3n1   W 24         4096      0.02 =
<--
> 5.747291    md0_raid10     727     nvme2n1   W 24         4096      0.02 =
<--
> 5.747314    md0_raid10     727     nvme2n1   W 2234636712 4096      0.01
> 5.747317    md0_raid10     727     nvme1n1   W 2234636712 4096      0.02
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jon Derrick <jonathan.derrick@linux.dev>
> ---
>  drivers/md/md-bitmap.c | 33 +++++++++++++++++++++++++++++----
>  1 file changed, 29 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index bf250a5e3a86..920bb68156d2 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -209,6 +209,28 @@ static struct md_rdev *next_active_rdev(struct md_rd=
ev *rdev, struct mddev *mdde
>         return NULL;
>  }
>
> +static unsigned int optimal_io_size(struct block_device *bdev,
> +                                   unsigned int last_page_size,
> +                                   unsigned int io_size)
> +{
> +       if (bdev_io_opt(bdev) > bdev_logical_block_size(bdev))
> +               return roundup(last_page_size, bdev_io_opt(bdev));
> +       return io_size;
> +}
> +
> +static unsigned int bitmap_io_size(unsigned int io_size, unsigned int op=
t_size,
> +                                  sector_t start, sector_t boundary)
> +{
> +       if (io_size !=3D opt_size &&
> +           start + opt_size / SECTOR_SIZE <=3D boundary)
> +               return opt_size;
> +       if (start + io_size / SECTOR_SIZE <=3D boundary)
> +               return io_size;
> +
> +       /* Overflows boundary */
> +       return 0;
> +}
> +
>  static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
>                            struct page *page)
>  {
> @@ -218,6 +240,7 @@ static int __write_sb_page(struct md_rdev *rdev, stru=
ct bitmap *bitmap,
>         sector_t offset =3D mddev->bitmap_info.offset;
>         sector_t ps, sboff, doff;
>         unsigned int size =3D PAGE_SIZE;
> +       unsigned int opt_size =3D PAGE_SIZE;
>
>         bdev =3D (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
>         if (page->index =3D=3D store->file_pages - 1) {
> @@ -225,8 +248,8 @@ static int __write_sb_page(struct md_rdev *rdev, stru=
ct bitmap *bitmap,
>
>                 if (last_page_size =3D=3D 0)
>                         last_page_size =3D PAGE_SIZE;
> -               size =3D roundup(last_page_size,
> -                              bdev_logical_block_size(bdev));
> +               size =3D roundup(last_page_size, bdev_logical_block_size(=
bdev));
> +               opt_size =3D optimal_io_size(bdev, last_page_size, size);
>         }
>
>         ps =3D page->index * PAGE_SIZE / SECTOR_SIZE;
> @@ -241,7 +264,8 @@ static int __write_sb_page(struct md_rdev *rdev, stru=
ct bitmap *bitmap,
>                         return -EINVAL;
>         } else if (offset < 0) {
>                 /* DATA  BITMAP METADATA  */
> -               if (offset + ps + size / SECTOR_SIZE > 0)
> +               size =3D bitmap_io_size(size, opt_size, offset + ps, 0);
> +               if (size =3D=3D 0)
>                         /* bitmap runs in to metadata */
>                         return -EINVAL;
>
> @@ -250,7 +274,8 @@ static int __write_sb_page(struct md_rdev *rdev, stru=
ct bitmap *bitmap,
>                         return -EINVAL;
>         } else if (rdev->sb_start < rdev->data_offset) {
>                 /* METADATA BITMAP DATA */
> -               if (sboff + ps + size / SECTOR_SIZE > doff)
> +               size =3D bitmap_io_size(size, opt_size, sboff + ps, doff)=
;
> +               if (size =3D=3D 0)
>                         /* bitmap runs in to data */
>                         return -EINVAL;
>         } else {
> --
> 2.27.0
>

