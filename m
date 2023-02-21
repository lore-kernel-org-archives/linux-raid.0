Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8AB5C61DA3
	for <linux-raid@archiver.kernel.org>; Tue, 21 Feb 2023 02:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbjBUCkD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Feb 2023 21:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbjBUCjy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Feb 2023 21:39:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76317222E1
        for <linux-raid@vger.kernel.org>; Mon, 20 Feb 2023 18:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676947121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DNuqk7Mv4MKapCmknJ4VeuwWLslECUxcYeUThQnBozQ=;
        b=bwDttNSZ/vee7L0PP2qs16DaxufuzKkHJCA5/XywqI3VsfexyfeAxnUU7xjSboJOf1zzlw
        Wr/tBrigcOTkqVSqmxI34uBoquME6RU8+TPFsr2QoOAqm+pQYFPvz3xTYqIvneqaMCWds3
        28kwfxASMxNP439ocT34HEcIgwpLdTU=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-124-16r1as5sNzWMJDjOAc3SVw-1; Mon, 20 Feb 2023 21:38:40 -0500
X-MC-Unique: 16r1as5sNzWMJDjOAc3SVw-1
Received: by mail-pj1-f71.google.com with SMTP id qb12-20020a17090b280c00b002310ecae757so1407696pjb.1
        for <linux-raid@vger.kernel.org>; Mon, 20 Feb 2023 18:38:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DNuqk7Mv4MKapCmknJ4VeuwWLslECUxcYeUThQnBozQ=;
        b=N2V5OB8uxyeiSmm6v/sF//Eh7ost5wQ8qFqhxFKl0i+Mxsv+JXGUofa7/quUwC7qs0
         +PpOIKOVb3NGRmHgI83USiMuDHFsOUPYtB+Qeptko2go/thfok8uWs6usMoiM4u5j0FN
         PAfQuzCnTwdq44dz8cz0e1+mQKCV6oVw6TrIpTAtkmOhZ8D/uYlrQoBwWBdexA7uNa1k
         rTIqHOOTmnN9yRrWxHDfBVYgz9TAVH9ejddWhJ38aleIGbHvgzRm7ph7GpSnNWHyIQgi
         xa0Vn2LwRW8VoSOdK2pc/YyO52pip8dOEw3ZENX+n67wEAHonxlhqxnSTblqggWXLaaq
         bUTg==
X-Gm-Message-State: AO0yUKU/LCusMyaxhd4LSQeR66GauDDxo+DA3HlhFD8G0tzjg0eYxpQA
        yiFnzdYZCF72wYx+diSpoF3dtjIt8IoBJFIMkBtfb22YCxx8uB6AayGl6UTQmXlU5xrrRd7nCNl
        imnBsBEdkDf+x+mCH0eubTpFhgk+mddo9zJbsfcYdoJOhjA==
X-Received: by 2002:a17:903:8c4:b0:19a:6b55:a44d with SMTP id lk4-20020a17090308c400b0019a6b55a44dmr405727plb.1.1676947118167;
        Mon, 20 Feb 2023 18:38:38 -0800 (PST)
X-Google-Smtp-Source: AK7set/oGW6wb+76NTd9hGByCO/15W9autd7GdqdoWYKOiRwHdPVqayi1rvTd2pNSEXYsRZ7eQ/CZdGZEJY6/6fLfNA=
X-Received: by 2002:a17:903:8c4:b0:19a:6b55:a44d with SMTP id
 lk4-20020a17090308c400b0019a6b55a44dmr405721plb.1.1676947117800; Mon, 20 Feb
 2023 18:38:37 -0800 (PST)
MIME-Version: 1.0
References: <20230217183139.106-1-jonathan.derrick@linux.dev>
In-Reply-To: <20230217183139.106-1-jonathan.derrick@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 21 Feb 2023 10:38:26 +0800
Message-ID: <CALTww2-3t-Tyjh1yAZhM+6Rwgh7t2=EFk1hOpvnTuiN91yyfDg@mail.gmail.com>
Subject: Re: [PATCH v2] md: Use optimal I/O size for last bitmap page
To:     Jonathan Derrick <jonathan.derrick@linux.dev>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Sushma Kalakota <sushma.kalakota@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Feb 18, 2023 at 2:36 AM Jonathan Derrick
<jonathan.derrick@linux.dev> wrote:
>
> From: Jon Derrick <jonathan.derrick@linux.dev>
>
> If the bitmap space has enough room, size the I/O for the last bitmap
> page write to the optimal I/O size for the storage device. The expanded
> write is checked that it won't overrun the data or metadata.
>
> This change helps increase performance by preventing unnecessary
> device-side read-mod-writes due to non-atomic write unit sizes.

Hi Jonathan

Thanks for your patch.

Could you explain more about the how the optimal io size can affect
the device-side read-mod-writes?

Regards
Xiao
>
> Example Intel/Solidigm P5520
> Raid10, Chunk-size 64M, bitmap-size 57228 bits
>
> $ mdadm --create /dev/md0 --level=10 --raid-devices=4 /dev/nvme{0,1,2,3}n1 --assume-clean --bitmap=internal --bitmap-chunk=64M
> $ fio --name=test --direct=1 --filename=/dev/md0 --rw=randwrite --bs=4k --runtime=60
>
> Without patch:
>   write: IOPS=1676, BW=6708KiB/s (6869kB/s)(393MiB/60001msec); 0 zone resets
>
> With patch:
>   write: IOPS=15.7k, BW=61.4MiB/s (64.4MB/s)(3683MiB/60001msec); 0 zone resets
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
> 1.410915    md0_raid10     6900    nvme2n1   W 24         3584      0.43
> 1.410935    md0_raid10     6900    nvme3n1   W 24         3584      0.45
> 1.411124    md0_raid10     6900    nvme1n1   W 24         3584      0.64
> 1.411147    md0_raid10     6900    nvme0n1   W 24         3584      0.66
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
> 5.747279    md0_raid10     727     nvme0n1   W 24         4096      0.01
> 5.747279    md0_raid10     727     nvme1n1   W 24         4096      0.02
> 5.747284    md0_raid10     727     nvme3n1   W 24         4096      0.02
> 5.747291    md0_raid10     727     nvme2n1   W 24         4096      0.02
> 5.747314    md0_raid10     727     nvme2n1   W 2234636712 4096      0.01
> 5.747317    md0_raid10     727     nvme1n1   W 2234636712 4096      0.02
>
> Signed-off-by: Jon Derrick <jonathan.derrick@linux.dev>
> ---
> v1->v2: Add more information to commit message
>
>  drivers/md/md-bitmap.c | 27 ++++++++++++++++++---------
>  1 file changed, 18 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index e7cc6ba1b657..569297ea9b99 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -220,6 +220,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>         rdev = NULL;
>         while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
>                 int size = PAGE_SIZE;
> +               int optimal_size = PAGE_SIZE;
>                 loff_t offset = mddev->bitmap_info.offset;
>
>                 bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
> @@ -228,9 +229,14 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>                         int last_page_size = store->bytes & (PAGE_SIZE-1);
>                         if (last_page_size == 0)
>                                 last_page_size = PAGE_SIZE;
> -                       size = roundup(last_page_size,
> -                                      bdev_logical_block_size(bdev));
> +                       size = roundup(last_page_size, bdev_logical_block_size(bdev));
> +                       if (bdev_io_opt(bdev) > bdev_logical_block_size(bdev))
> +                               optimal_size = roundup(last_page_size, bdev_io_opt(bdev));
> +                       else
> +                               optimal_size = size;
>                 }
> +
> +
>                 /* Just make sure we aren't corrupting data or
>                  * metadata
>                  */
> @@ -246,9 +252,11 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>                                 goto bad_alignment;
>                 } else if (offset < 0) {
>                         /* DATA  BITMAP METADATA  */
> -                       if (offset
> -                           + (long)(page->index * (PAGE_SIZE/512))
> -                           + size/512 > 0)
> +                       loff_t off = offset + (long)(page->index * (PAGE_SIZE/512));
> +                       if (size != optimal_size &&
> +                           off + optimal_size/512 <= 0)
> +                               size = optimal_size;
> +                       else if (off + size/512 > 0)
>                                 /* bitmap runs in to metadata */
>                                 goto bad_alignment;
>                         if (rdev->data_offset + mddev->dev_sectors
> @@ -257,10 +265,11 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>                                 goto bad_alignment;
>                 } else if (rdev->sb_start < rdev->data_offset) {
>                         /* METADATA BITMAP DATA */
> -                       if (rdev->sb_start
> -                           + offset
> -                           + page->index*(PAGE_SIZE/512) + size/512
> -                           > rdev->data_offset)
> +                       loff_t off = rdev->sb_start + offset + page->index*(PAGE_SIZE/512);
> +                       if (size != optimal_size &&
> +                           off + optimal_size/512 <= rdev->data_offset)
> +                               size = optimal_size;
> +                       else if (off + size/512 > rdev->data_offset)
>                                 /* bitmap runs in to data */
>                                 goto bad_alignment;
>                 } else {
> --
> 2.27.0
>

