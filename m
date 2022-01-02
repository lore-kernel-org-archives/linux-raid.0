Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48534C433EF
	for <linux-raid@archiver.kernel.org>; Sun,  2 Jan 2022 02:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiABCIz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 1 Jan 2022 21:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiABCIy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 1 Jan 2022 21:08:54 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959B9C061574
        for <linux-raid@vger.kernel.org>; Sat,  1 Jan 2022 18:08:54 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id l16-20020a17090a409000b001b2e9628c9cso1403761pjg.4
        for <linux-raid@vger.kernel.org>; Sat, 01 Jan 2022 18:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=zHObVVdRTck30Otqg0yDMZAzPDOPFNGXOupEXUe6NbE=;
        b=E/qv1Tzr6SDY59jCLcNdD/JCQpkrpO9GMIom7z5ubJ9rWGeqo57DMwyccPOvrkQzu8
         YBlGaaWudYsaHasR+DW7CBZQK9ARjmjlWzh1boVG9oGGnmN4i6DqVL2I3XfxldFI8cL5
         NEaTw5Bb7BozEPMRPhhOBfREWtcghilW8R0iQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zHObVVdRTck30Otqg0yDMZAzPDOPFNGXOupEXUe6NbE=;
        b=oTVx2E4Wrcg3KAkAXhSbm2gUP4P95XxNXQIjen1k+zs0ZtwcYziBaM/7grPT77L31A
         H9ycJvgcNkowmcmK5MMropdb6XOkSt6a1b9z8Y5KJzWIzAuuLGxczZnThj40Ucgzby5V
         WtxCY7ZOaH2v7GS2CoxDGbv5zc/7EzjAMS8Fqo5WizzQTgvqu/V1d43+Bv5JzSaCQ79Q
         Lz9M2ttmCRubtQRS4kNvo8FHSsXgpeqPoItmx0oVyhO4ONWFxmyfO28bwpnV2SQo7KIg
         664p3Cawdsvs7qVAPxsGUwPXJErx56+0SdknlHI/smSlahcQXz99N2wNJSrj/T3MUduj
         xbIQ==
X-Gm-Message-State: AOAM532V8eYBA8/8EjXwJX7dSYFaoTyslNe2a4R5dG93n60AP/eg1EpP
        qiJK6lRbtHTV/HfiP1Zimsh2q6k8CjcPOQ==
X-Google-Smtp-Source: ABdhPJz2gUYeo/tp7IJ3IxxlyvldqhZGfKjCnWcqVi/9FsWeffG5V4CXCNo54Sm7D5Tk4wtKsZ8dGw==
X-Received: by 2002:a17:902:8f91:b0:149:87ff:ac85 with SMTP id z17-20020a1709028f9100b0014987ffac85mr23362626plo.162.1641089333425;
        Sat, 01 Jan 2022 18:08:53 -0800 (PST)
Received: from [192.168.1.4] (ip68-104-251-60.ph.ph.cox.net. [68.104.251.60])
        by smtp.gmail.com with ESMTPSA id x31sm35788181pfh.116.2022.01.01.18.08.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Jan 2022 18:08:52 -0800 (PST)
Message-ID: <b5fc1c84-ddbe-78a4-2729-04e2fd6ca7fc@digitalocean.com>
Date:   Sat, 1 Jan 2022 19:08:47 -0700
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
 <CAPhsuW6CR_+4pJx=Faf5KwusAoy1vOte9qQKBWy6fwNkp1PETA@mail.gmail.com>
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <CAPhsuW6CR_+4pJx=Faf5KwusAoy1vOte9qQKBWy6fwNkp1PETA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 1/1/22 5:11 PM, Song Liu wrote:
> On Wed, Dec 22, 2021 at 6:57 PM Song Liu <song@kernel.org> wrote:
>> On Tue, Dec 21, 2021 at 12:06 PM Vishal Verma <vverma@digitalocean.com> wrote:
>>> commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") added support
>>> for checking whether a given bdev supports handling of REQ_NOWAIT or not.
>>> Since then commit 6abc49468eea ("dm: add support for REQ_NOWAIT and enable
>>> it for linear target") added support for REQ_NOWAIT for dm. This uses
>>> a similar approach to incorporate REQ_NOWAIT for md based bios.
>>>
>>> This patch was tested using t/io_uring tool within FIO. A nvme drive
>>> was partitioned into 2 partitions and a simple raid 0 configuration
>>> /dev/md0 was created.
>>>
>>> md0 : active raid0 nvme4n1p1[1] nvme4n1p2[0]
>>>        937423872 blocks super 1.2 512k chunks
>>>
>>> Before patch:
>>>
>>> $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
>>>
>>> Running top while the above runs:
>>>
>>> $ ps -eL | grep $(pidof io_uring)
>>>
>>>    38396   38396 pts/2    00:00:00 io_uring
>>>    38396   38397 pts/2    00:00:15 io_uring
>>>    38396   38398 pts/2    00:00:13 iou-wrk-38397
>>>
>>> We can see iou-wrk-38397 io worker thread created which gets created
>>> when io_uring sees that the underlying device (/dev/md0 in this case)
>>> doesn't support nowait.
>>>
>>> After patch:
>>>
>>> $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
>>>
>>> Running top while the above runs:
>>>
>>> $ ps -eL | grep $(pidof io_uring)
>>>
>>>    38341   38341 pts/2    00:10:22 io_uring
>>>    38341   38342 pts/2    00:10:37 io_uring
>>>
>>> After running this patch, we don't see any io worker thread
>>> being created which indicated that io_uring saw that the
>>> underlying device does support nowait. This is the exact behaviour
>>> noticed on a dm device which also supports nowait.
>>>
>>> For all the other raid personalities except raid0, we would need
>>> to train pieces which involves make_request fn in order for them
>>> to correctly handle REQ_NOWAIT.
>>>
>>> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
>> I have made some changes and applied the set to md-next. However,
>> I think we don't yet have enough test coverage. Please continue testing
>> the code and send fixes on top of it. Based on the test results, we will
>> see whether we can ship it in the next merge window.
>>
>> Note, md-next branch doesn't have [1], so we need to cherry-pick it
>> for testing.
> I went through all these changes again and tested many (but not all)
> cases. The latest version is available in md-next branch.
>
> Vishal, please run tests on this version and send fixes if anything
> is broken.
>
> Thanks,
> Song
Thanks Song. This latest version looks good!
And yes, will report out if I notice any issues or anything.
