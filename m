Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B204BC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 22 Dec 2021 16:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbhLVQGw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Dec 2021 11:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbhLVQGv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Dec 2021 11:06:51 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C57C061574
        for <linux-raid@vger.kernel.org>; Wed, 22 Dec 2021 08:06:51 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id y16so3479449ioc.8
        for <linux-raid@vger.kernel.org>; Wed, 22 Dec 2021 08:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3jgRacYUS8Qgs1rOthnUYPJ+DJhj2dYVhswQkydjxRM=;
        b=aurg6tDuwSN48Vxy5eIL3sHjzwenWpccg+2H9gU08hz9CwOMCSuimQiuvBFr1CBADx
         OBwFR2r0bhJUAbeFsPOgV0aI6PAC6FjAv7ocv+QNgX9+qI0ZKwnAcux3/Oy3yvElYHIT
         fOIGI2QNp35ZlBIhF0mv1VQ74Zb7f4F4SFE4VG4oJU6F6OMiYOwO5Cm3K+dLPZj0nqx7
         BrjIG97eyoswhNpM3tRPR447PEOu6gh2yyThcq15elu+8BNvZsfF0Uqay8XUjpfowyQs
         Z7FCVD9Lj8cNjQ6HE4ZXZ8zgnmAedctOTS4/yREGmwKFspQZaI7co2sp1O5i+0pqrKSR
         U/HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3jgRacYUS8Qgs1rOthnUYPJ+DJhj2dYVhswQkydjxRM=;
        b=UjV9oZ4K+C2DzVUY7+sFd0v2Tt7ojA9MT5siLzIP0z+bN7cywJrRUAc/m1QmaU2znR
         x/WPDSySch7/ELp2nQa7VHFsRueJZIRt+rx7PvgQnVB9w0dtHdZD/TNFKNR1p2XH1y9v
         KR+n8hxKyamMzoRQB+dQaQKvDZyyZ6efKfXHgu3byiQwbKayTa1QWcJE2G+p1xsGwAAD
         L3Bwc3bhq0smF5HaRYg2g0Cg3igwViI0+DhAsfdoDvIGKsptTI9u3hKl5ixD3ZHkUCU7
         fQVrduq1cWAIRtobRvS4nUul6IY7M7tlFoTWN8Eq/blMG8U+TyjW+bv2MnlaTcl+1Rbv
         P6MQ==
X-Gm-Message-State: AOAM533tjYyK7l+pMZE5CDcZPiXb2mYbYfd68ZpNF5gkqY82+l1kOsUs
        qc/qFHtWOFQn08yX413X0BDVzA==
X-Google-Smtp-Source: ABdhPJyCUqMZ27jOgmmpGkbvNR3+UUuvjvX/ToiR0kELGz2l5PxkwhqejQedr8mJimDUuIJK8CYxIA==
X-Received: by 2002:a05:6638:150e:: with SMTP id b14mr2041352jat.246.1640189211046;
        Wed, 22 Dec 2021 08:06:51 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i8sm310027ilm.63.2021.12.22.08.06.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Dec 2021 08:06:50 -0800 (PST)
Subject: Re: [PATCH v6 1/4] md: add support for REQ_NOWAIT
To:     Vishal Verma <vverma@digitalocean.com>, song@kernel.org,
        linux-raid@vger.kernel.org
Cc:     rgoldwyn@suse.de
References: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com>
 <20211221200622.29795-1-vverma@digitalocean.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3659a288-022e-d613-7d07-47ab0c2997a5@kernel.dk>
Date:   Wed, 22 Dec 2021 09:06:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211221200622.29795-1-vverma@digitalocean.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/21/21 1:06 PM, Vishal Verma wrote:
> commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") added support
> for checking whether a given bdev supports handling of REQ_NOWAIT or not.
> Since then commit 6abc49468eea ("dm: add support for REQ_NOWAIT and enable
> it for linear target") added support for REQ_NOWAIT for dm. This uses
> a similar approach to incorporate REQ_NOWAIT for md based bios.
> 
> This patch was tested using t/io_uring tool within FIO. A nvme drive
> was partitioned into 2 partitions and a simple raid 0 configuration
> /dev/md0 was created.
> 
> md0 : active raid0 nvme4n1p1[1] nvme4n1p2[0]
>       937423872 blocks super 1.2 512k chunks
> 
> Before patch:
> 
> $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
> 
> Running top while the above runs:
> 
> $ ps -eL | grep $(pidof io_uring)
> 
>   38396   38396 pts/2    00:00:00 io_uring
>   38396   38397 pts/2    00:00:15 io_uring
>   38396   38398 pts/2    00:00:13 iou-wrk-38397
> 
> We can see iou-wrk-38397 io worker thread created which gets created
> when io_uring sees that the underlying device (/dev/md0 in this case)
> doesn't support nowait.
> 
> After patch:
> 
> $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
> 
> Running top while the above runs:
> 
> $ ps -eL | grep $(pidof io_uring)
> 
>   38341   38341 pts/2    00:10:22 io_uring
>   38341   38342 pts/2    00:10:37 io_uring
> 
> After running this patch, we don't see any io worker thread
> being created which indicated that io_uring saw that the
> underlying device does support nowait. This is the exact behaviour
> noticed on a dm device which also supports nowait.
> 
> For all the other raid personalities except raid0, we would need
> to train pieces which involves make_request fn in order for them
> to correctly handle REQ_NOWAIT.

1-4 look fine to me now:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

