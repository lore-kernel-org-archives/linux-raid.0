Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B830C433F5
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 15:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 597C260EB4
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 15:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhKBPe3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Nov 2021 11:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbhKBPe3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Nov 2021 11:34:29 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256B8C061714
        for <linux-raid@vger.kernel.org>; Tue,  2 Nov 2021 08:31:54 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id 62so18587226iou.2
        for <linux-raid@vger.kernel.org>; Tue, 02 Nov 2021 08:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=yZ1Erm+ddI5FCImkZRnUGQcDdTBSUsffV/XYyOB6I6U=;
        b=fvs6xYgpbEULHgb5ayELFXFrn1NDYut/1mBTMHyevS7nfeOocEtqaqARRLbXxv0unT
         /3VumdOKoqCCfPCfVUePJ+lOehDBmliF3qsjHJvD+g7UOK8aft2rs/awXskx5ZUbZNB7
         /7QvFda7ZQiPlS+Z7t18hTEi9RTuIYfZG7kOcD2d8BE8QsXWVsvKBq3uZAyQ/ThNe0sI
         mlg0ipExdm7uPIZNpwX8qLanK1H3n5HeFXrQJ6eBcQKo/3L724b1ZTElbnmFC5XQZtGA
         8XS/4XBCUrDAGOdESIvKXKmkrYn6Wmrq3bERBP7uHTB7WQt2dbF9MLUPfvMIJjRBUDyc
         zitg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yZ1Erm+ddI5FCImkZRnUGQcDdTBSUsffV/XYyOB6I6U=;
        b=z94JjtSSDCacPwBDLBZDrEfw4Jnt5lAIPeQLGLh7bmWhBATAPdIKMZndfFmf6GHb3G
         UDlCRCBPj2rrg2pdlz0xKuFYWg3+xZoAoZWaSTwFkdgtZ2juCi2fXZsqPVocaBq4c0TA
         2SBsrMs+zCNX/5GYnvSLZW8CGO8XhtgHxUI2g2+zJ9abDHEfmv/J28FFeMvG8E29T3/U
         j48/BZCS2JsasYVaFMZzvfzIoMh9TVyv0IV48y7/ofnTRutT6BSKvTv1Vj0aBrnH+02i
         syiN03za7JLxIgrdeiMkCg7AI9gjc2zr+L7X7vlaL3Faz6sZeQ09d3cQQbz9FUadYCbm
         /X3w==
X-Gm-Message-State: AOAM531nxfLrdCozTzscqZAdNVEwRy7AaIsgXqJksFdyF3BdKjDrKpzK
        zuYxwD8/0+3LtIjxKgRrxs9PfZQ5d85U0g==
X-Google-Smtp-Source: ABdhPJwOQqeI+9NEzC0WOWXNs3b1YNHRbWU/dahqmWFwlxrNhyPBV2mvsV+BDxGH2KL/lLpcIDPAsA==
X-Received: by 2002:a5d:9ed6:: with SMTP id a22mr26938658ioe.167.1635867113277;
        Tue, 02 Nov 2021 08:31:53 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h19sm3196332ila.37.2021.11.02.08.31.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 08:31:52 -0700 (PDT)
Subject: Re: [PATCH v2] md: add support for REQ_NOWAIT
To:     Vishal Verma <vverma@digitalocean.com>, song@kernel.org,
        linux-raid@vger.kernel.org
References: <CAPhsuW5FpeS9AfPYpNgHGCp8dP151g-t8whSiGyuxEfp2O92tg@mail.gmail.com>
 <20211102144004.25344-1-vverma@digitalocean.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <03b30587-c5a3-d871-9719-112930a9019d@kernel.dk>
Date:   Tue, 2 Nov 2021 09:31:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211102144004.25344-1-vverma@digitalocean.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/2/21 8:40 AM, Vishal Verma wrote:
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
> I also successfully tested this patch on various other
> raid personalities (1, 6 and 10).

This seems incomplete. It looks like it's propagating the nowait
flag based on constituent devices, which is correct, but surely there
are cases off the the make_request path that now need to check for NOWAIT
and return -EAGAIN if they need to block.

From a quick look, raid0 looks fine as-is. raid1 would need checking
for waiting on a read barrier, for example.

If we just add nowait and don't _actually_ fix the driver, then the
nowait exercise is pointless as it would then just mean that io_uring
would block attempting to submit. That's the broken aio behavior, and
that's certainly not the desired outcome here.

-- 
Jens Axboe

