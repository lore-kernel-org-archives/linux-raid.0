Return-Path: <SRS0=Hvl7=EP=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AEE2C2D0A3
	for <linux-raid@archiver.kernel.org>; Mon,  9 Nov 2020 11:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F21A206ED
	for <linux-raid@archiver.kernel.org>; Mon,  9 Nov 2020 11:30:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V995cmrS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbgKILaX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 Nov 2020 06:30:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29062 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727311AbgKILaX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 Nov 2020 06:30:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604921421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qJPHU79Z9aFII+RXhVTkpUcHO9yLNqjEBCGqyvXY310=;
        b=V995cmrSEl54zDxw55HTc5LkSVBjkP2bV0TQekN9COsw8YV5x1PRZoXTiOQWYGIU7qeB/F
        S4Jatc89SsaTrYA2XyRpHprinR8Gwv4zs3Vt/5nvJ4nLkVnzBzM/M3xEYu8X8hmCleZFtk
        XB3dlRLouPrOoTfOtSq1W/8EfJ7ljA0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-XhJpEooSMPeUcPSFpz9dTA-1; Mon, 09 Nov 2020 06:30:20 -0500
X-MC-Unique: XhJpEooSMPeUcPSFpz9dTA-1
Received: by mail-wm1-f72.google.com with SMTP id s3so8524wmj.6
        for <linux-raid@vger.kernel.org>; Mon, 09 Nov 2020 03:30:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qJPHU79Z9aFII+RXhVTkpUcHO9yLNqjEBCGqyvXY310=;
        b=C3gzqgJoKv24Qtni7MwumylHT+8G1C4Btal9+fCdT4v33i36uCBRp+xlC5VUxUjAZo
         msdKNE4tPbpimi9ed7iblWFmuJ3zvIUvEdF/0Vl0I1fV6NV9lKQexcn92/bbpC07G9Mq
         iFwsPh6iSp8ayC0nP9qLU42zhrJsKSNPWEAVRMV6untV+/c67pxceReMu/GkQnAOUQw2
         Eb+5NrnSuGG7fzGGeo0VVVb9poAuq4rNxL3hkgGmCovfOu7KBzr97Ds1oZPXYfkC+bmf
         GuWJnRYmgq120T9AWSHUZtwsZvYaWy71JJvWA3F8EIt3KuXYilTlZ9B1fAry3r/Hmlyc
         N+mw==
X-Gm-Message-State: AOAM531OD3hbYJBxYMh4yaQTTHp+AiNGHo2mzafb+oKX7QNin6pJvJm7
        Xl0xeMIHPo6wMY8IliHnj9NvUi+V2sPGmEHjiXlEccEDW1SyRZtk5eYVSz1Ihgi0SeTO8/ECfYw
        UKHmPCHg6pU2beMlCXtHf2w==
X-Received: by 2002:a05:6000:1005:: with SMTP id a5mr10320366wrx.425.1604921419108;
        Mon, 09 Nov 2020 03:30:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxfMfmWa9Cv9HNLSs0dLMrckBnIhQ+LX5gsNBfqeNBoHRKN7zV/cjWgtINNh6h724r5DlDOEA==
X-Received: by 2002:a05:6000:1005:: with SMTP id a5mr10320328wrx.425.1604921418961;
        Mon, 09 Nov 2020 03:30:18 -0800 (PST)
Received: from redhat.com (bzq-79-181-34-244.red.bezeqint.net. [79.181.34.244])
        by smtp.gmail.com with ESMTPSA id 35sm10972366wro.71.2020.11.09.03.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 03:30:17 -0800 (PST)
Date:   Mon, 9 Nov 2020 06:30:10 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Justin Sanders <justin@coraid.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, nbd@other.debian.org,
        ceph-devel@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 23/24] virtio-blk: remove a spurious call to
 revalidate_disk_size
Message-ID: <20201109063004-mutt-send-email-mst@kernel.org>
References: <20201106190337.1973127-1-hch@lst.de>
 <20201106190337.1973127-24-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106190337.1973127-24-hch@lst.de>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Nov 06, 2020 at 08:03:35PM +0100, Christoph Hellwig wrote:
> revalidate_disk_size just updates the block device size from the disk
> size.  Thus calling it from revalidate_disk_size doesn't actually do
> anything.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/block/virtio_blk.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 3e812b4c32e669..145606dc52db1e 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -598,7 +598,6 @@ static void virtblk_update_cache_mode(struct virtio_device *vdev)
>  	struct virtio_blk *vblk = vdev->priv;
>  
>  	blk_queue_write_cache(vblk->disk->queue, writeback, false);
> -	revalidate_disk_size(vblk->disk, true);
>  }
>  
>  static const char *const virtblk_cache_types[] = {
> -- 
> 2.28.0

