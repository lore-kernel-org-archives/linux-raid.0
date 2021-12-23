Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB95C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 23 Dec 2021 03:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346132AbhLWDIN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Dec 2021 22:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbhLWDIN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Dec 2021 22:08:13 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45936C061574
        for <linux-raid@vger.kernel.org>; Wed, 22 Dec 2021 19:08:13 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id i5-20020a05683033e500b0057a369ac614so5229961otu.10
        for <linux-raid@vger.kernel.org>; Wed, 22 Dec 2021 19:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=SX+zSiOlrsxXeqxdgWSk0b/L0zYCQKB268BCHT8p3qA=;
        b=dd+DTIMIWagwaEoxCmb2ITv40XQzTxY9OlgSPvSth8hKfwVCtxZbmhKNu708a6Zc9A
         I1ELolRClJen950VbYMlNmPc+KM+xJEvCl8NoMmJ23w8kfHqcBDXTDdaoiYRlv12TUTv
         vwNeYiB3gBI4eLdMP2ELynhCEErY7gDq4sUK8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SX+zSiOlrsxXeqxdgWSk0b/L0zYCQKB268BCHT8p3qA=;
        b=i4IHs7NlIIHuupHU2S22Y/mjzwsBu0TWOlMQCF5M7oLXGPKX9w9XSDHR5P1ohKzWtC
         TMU0NGKqrD+0FNJAdZ17Rn2s0VjmV5I1mpkHZFZa66aDkWwpXDuQAsSa+xgnjWZyB3zl
         +WjGQPMc969VSsq15k5ZOJdRWB+vRYAK7GGoKxNb/3bvs2xwAHOh105vuhtz9USLVBiH
         BtRwOaUXXFmuDPQ5UCoQvEnMIeM7naOomV+i3sId12sUPuQpLL2ll7nPtUSk81oo7pfD
         oAiK3N98yYHDiQlTDqXQy6NB7ZtRLSCCssM/Ug6gA47Bn2MvcMxtv3pKQlahnYjGEMIX
         +n+A==
X-Gm-Message-State: AOAM5303e3oDb7pAGQw1q68lWbd8CVuNFYvcnnqc2JUiJ3cbN6SnENJy
        wHR/euAbBSINMjNh0zRyae3+hg==
X-Google-Smtp-Source: ABdhPJx4h/Iuzc7dODnOQZaBq8xGKCkoewF9ZVKdCSD/No4EInroICXAqOqN5KIZH5a0Tli0pADe3g==
X-Received: by 2002:a05:6830:12c3:: with SMTP id a3mr282421otq.24.1640228892388;
        Wed, 22 Dec 2021 19:08:12 -0800 (PST)
Received: from [192.168.1.4] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id v41sm679097ooi.0.2021.12.22.19.08.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Dec 2021 19:08:11 -0800 (PST)
Message-ID: <3a0264f9-fa6b-8cc0-2b66-2e663650c053@digitalocean.com>
Date:   Wed, 22 Dec 2021 20:08:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v6 1/4] md: add support for REQ_NOWAIT
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, rgoldwyn@suse.de
References: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com>
 <20211221200622.29795-1-vverma@digitalocean.com>
 <CAPhsuW7-4UW3kMo6vcW1Mo=sZZK_AciFHSDaxsprVgjaP5GNzw@mail.gmail.com>
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <CAPhsuW7-4UW3kMo6vcW1Mo=sZZK_AciFHSDaxsprVgjaP5GNzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 12/22/21 7:57 PM, Song Liu wrote:
> On Tue, Dec 21, 2021 at 12:06 PM Vishal Verma <vverma@digitalocean.com> wrote:
>> commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") added support
>> for checking whether a given bdev supports handling of REQ_NOWAIT or not.
>> Since then commit 6abc49468eea ("dm: add support for REQ_NOWAIT and enable
>> it for linear target") added support for REQ_NOWAIT for dm. This uses
>> a similar approach to incorporate REQ_NOWAIT for md based bios.
>>
>> This patch was tested using t/io_uring tool within FIO. A nvme drive
>> was partitioned into 2 partitions and a simple raid 0 configuration
>> /dev/md0 was created.
>>
>> md0 : active raid0 nvme4n1p1[1] nvme4n1p2[0]
>>        937423872 blocks super 1.2 512k chunks
>>
>> Before patch:
>>
>> $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
>>
>> Running top while the above runs:
>>
>> $ ps -eL | grep $(pidof io_uring)
>>
>>    38396   38396 pts/2    00:00:00 io_uring
>>    38396   38397 pts/2    00:00:15 io_uring
>>    38396   38398 pts/2    00:00:13 iou-wrk-38397
>>
>> We can see iou-wrk-38397 io worker thread created which gets created
>> when io_uring sees that the underlying device (/dev/md0 in this case)
>> doesn't support nowait.
>>
>> After patch:
>>
>> $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
>>
>> Running top while the above runs:
>>
>> $ ps -eL | grep $(pidof io_uring)
>>
>>    38341   38341 pts/2    00:10:22 io_uring
>>    38341   38342 pts/2    00:10:37 io_uring
>>
>> After running this patch, we don't see any io worker thread
>> being created which indicated that io_uring saw that the
>> underlying device does support nowait. This is the exact behaviour
>> noticed on a dm device which also supports nowait.
>>
>> For all the other raid personalities except raid0, we would need
>> to train pieces which involves make_request fn in order for them
>> to correctly handle REQ_NOWAIT.
>>
>> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
> I have made some changes and applied the set to md-next. However,
> I think we don't yet have enough test coverage. Please continue testing
> the code and send fixes on top of it. Based on the test results, we will
> see whether we can ship it in the next merge window.
>
> Note, md-next branch doesn't have [1], so we need to cherry-pick it
> for testing.
>
> Thanks,
> Song
>
> [1] a08ed9aae8a3 ("block: fix double bio queue when merging in cached
> request path")
Great, and I agree will continue testing this.

Just saw you already addressing some silly things
I missed in v6. Sorry about that.

Thank you!
