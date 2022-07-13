Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CDCCCA483
	for <linux-raid@archiver.kernel.org>; Wed, 13 Jul 2022 12:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236467AbiGMMZ5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Jul 2022 08:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiGMMZv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Jul 2022 08:25:51 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB646E7CFF
        for <linux-raid@vger.kernel.org>; Wed, 13 Jul 2022 05:25:42 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id eq6so13881898edb.6
        for <linux-raid@vger.kernel.org>; Wed, 13 Jul 2022 05:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linbit-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qXqGFu8U4gPDVSr/ggPX1zJdQr5HzeAZdYNrxVaBP2U=;
        b=vTibGfqb8AoB8dfwXHh8bxVf5FbFeYJTrOLebeWcAQTsARpBmyHDJEnUnBIrIfttvA
         r3uR8GsvihZGcnixyJ1ybBzhizpsWGC8XNv0eah0RCuuKzDmiAti20pRwJemgLF+BEVc
         ehKpt9RsXGhj8HC0ZOoluR+VGr8i6Ga8NNvsMXbCqi6yI57KT9Rt3agP9JXsB/Han+gK
         zlfO+6gnu5fZbFAJFUVBzLfGv6wM7uLmp/82YfF6L0pZCUM5prM7HSQT6YHfrk27znqQ
         xp645/qTAw+03mufD09Axo2GVH6ifvt1mOsvsUAtOalPKP2vZRehwNJrzk4M4k10rqJY
         g68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qXqGFu8U4gPDVSr/ggPX1zJdQr5HzeAZdYNrxVaBP2U=;
        b=IixDJH+RcEhqg4/VUcvlmT7RFy3qHYUCEiWyRSKQs+N7Npf07j2wrNYJZlijZmOTl1
         YnOGkbGxq3R7h9Po0OgoFITxD6WxoUxlApASUdrVR6RCa3f6oZOx/h7dwZYB4knDGfct
         mRDgmKZF7V0ChyNlWfe/HA3m10frLXjnSwpB6ACiBWnrz3UeNHDB6HeEsHsngS02U7uh
         /1tE30KVxAm+O9XAUx3tClSQ+PQC+Fb/bLDejCG9Dq3Vy9JwyIPsrnB7PlvuvZXWQpdS
         XTPPN2jwYVPreDTL/NUF4rVYJuppRJwRQ5DVhbLhYva/oeKlZ/iMPJGJFm/WJYkhJCYK
         jiwQ==
X-Gm-Message-State: AJIora/RlwqIhUclNlOlFSzO/8MsuDNzVyrvkaGg7mwAPzAvil+FJf1S
        sbF27WhWX9olFxgeD1x8rVmr2Q==
X-Google-Smtp-Source: AGRyM1t2anjpsABs9moN8/saQwoeQFzlk9BcJwJ81FhrhmrzcGBgnKja0O11XVp6U4a5FFOg06Pmhg==
X-Received: by 2002:a05:6402:354c:b0:43a:dc59:657 with SMTP id f12-20020a056402354c00b0043adc590657mr4381358edd.405.1657715140797;
        Wed, 13 Jul 2022 05:25:40 -0700 (PDT)
Received: from [192.168.178.55] (h082218028181.host.wavenet.at. [82.218.28.181])
        by smtp.gmail.com with ESMTPSA id k5-20020a17090632c500b0072aa014e852sm4924686ejk.87.2022.07.13.05.25.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 05:25:40 -0700 (PDT)
Message-ID: <1304fd58-1577-3f27-0ee8-64964bd54467@linbit.com>
Date:   Wed, 13 Jul 2022 14:25:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 3/9] drbd: stop using bdevname in drbd_report_io_error
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>, Song Liu <song@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
References: <20220713055317.1888500-1-hch@lst.de>
 <20220713055317.1888500-4-hch@lst.de>
From:   =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= 
        <christoph.boehmwalder@linbit.com>
In-Reply-To: <20220713055317.1888500-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Am 13.07.22 um 07:53 schrieb Christoph Hellwig:
> Just use the %pg format specifier instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/drbd/drbd_req.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
> index e64bcfba30ef3..6d8dd14458c69 100644
> --- a/drivers/block/drbd/drbd_req.c
> +++ b/drivers/block/drbd/drbd_req.c
> @@ -523,16 +523,14 @@ static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
>  
>  static void drbd_report_io_error(struct drbd_device *device, struct drbd_request *req)
>  {
> -        char b[BDEVNAME_SIZE];
> -
>  	if (!__ratelimit(&drbd_ratelimit_state))
>  		return;
>  
> -	drbd_warn(device, "local %s IO error sector %llu+%u on %s\n",
> +	drbd_warn(device, "local %s IO error sector %llu+%u on %pg\n",
>  			(req->rq_state & RQ_WRITE) ? "WRITE" : "READ",
>  			(unsigned long long)req->i.sector,
>  			req->i.size >> 9,
> -			bdevname(device->ldev->backing_bdev, b));
> +			device->ldev->backing_bdev);
>  }
>  
>  /* Helper for HANDED_OVER_TO_NETWORK.

For the drbd part:

Reviewed-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>

Thanks.

-- 
Christoph Böhmwalder
LINBIT | Keeping the Digital World Running
DRBD HA —  Disaster Recovery — Software defined Storage
