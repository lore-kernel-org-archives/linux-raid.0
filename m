Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83908C43334
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 16:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbiGSQX1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 12:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiGSQX1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 12:23:27 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E310B52E56
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 09:23:25 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id s13so634593ilp.13
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 09:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=38UrdxCZJjQSbMu3peyLDMkbVChLN0zJYxhfcLScYs4=;
        b=cdx0LvEf5Ssc5m0boJ6wzfl+eKfNYQUyKUtLni71wiUdQV8NJWwCsky6wefOC2YkzE
         fMBfRfDq/jl0R9L/zCroe2eQ8ORYCiPxnGF9wcYzNVRIwQR4NhTZ2HbTmHECMMYDXEG0
         jEZXh+sHvZP7mKT0tLnhBRRtLEx8QcZE1q8N3ATdLHVKcMS28SsEHJGtgYxDi9d+QTpX
         NH08tC0toHBQmvA7vy+wzTN6DA9wl85TmLDaT7tM5jCY1Wy2KeZYFUapTsxwntio0ltj
         oywPqqK/RDHQ4oBKEnbJTmVF2yOiDzlkdouzUlL+rChSdRn5SpPmYWotWWzD5eJamF+G
         RGzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=38UrdxCZJjQSbMu3peyLDMkbVChLN0zJYxhfcLScYs4=;
        b=1R32YP5okBNAznR2wRkEoneZj/DRONi+H41p8gJ7TPgVoo9YHFzCgMxCqu6eqPaDCk
         vqwmN8DcI6oHJj7mq/nmDeLKIhOZlt7FBHurBMcFiC4GIzByF6Wb3GT+Jra5iLHOJRjY
         l7+xgy0LNLQrhmXXJwz9aTOv4/FHjmuo4d0Xx+SpNSrgVU3FccVeiwjyRX89Bk94V3vP
         sGodnzonPfWoGo+y9VNijCYJiWh5Q3UXh47UZqvXU66rOiHGBn7IYON0QQzFvYmrmBs4
         oxNCOiDxB4FyomBCaPX1/814UV62/Nm4s+x3momMS8WIArd7JM4cQZmJIzbp5I/yqxYB
         YaQA==
X-Gm-Message-State: AJIora8xanotoVwlTSxNTj4VpJrvPjQrRt1dPRUYfSdysZGjkq9ZqfhV
        SzAKCFyhh1apk0NIBzooQ4d3Eu5ok6/BFw==
X-Google-Smtp-Source: AGRyM1sN42m366loasIDrDIxQmFRdjhCjaeIJPFN5QMXvUp79USeGUP/e8HaTwI5LF5Kk7gxjySQqA==
X-Received: by 2002:a92:c884:0:b0:2dc:bd44:84bf with SMTP id w4-20020a92c884000000b002dcbd4484bfmr11042932ilo.86.1658247805263;
        Tue, 19 Jul 2022 09:23:25 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id cd8-20020a0566381a0800b0033e72ec9d93sm6840207jab.145.2022.07.19.09.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 09:23:24 -0700 (PDT)
Message-ID: <a98b85ed-bb95-b619-9799-d946e78a68eb@kernel.dk>
Date:   Tue, 19 Jul 2022 10:23:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] md-next 20220718
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        "liuyun01@kylinos.cn" <liuyun01@kylinos.cn>
References: <4122CEAB-991E-4A4D-90FD-C48325935876@fb.com>
 <799F776B-142E-453D-9F8E-595105249E83@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <799F776B-142E-453D-9F8E-595105249E83@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/18/22 7:05 PM, Song Liu wrote:
> 
> 
>> On Jul 18, 2022, at 2:49 PM, Song Liu <songliubraving@fb.com> wrote:
>>
>> Hi Jens, 
>>
>> Please consider pulling the following changes on top of your for-5.20/drivers
>> branch. The major changes are:
>>  1. Convert prepare_to_wait() to wait_woken() api, by Logan Gunthorpe;
>>  2. Fix sectors_to_do bitmap issue, by Logan Gunthorpe. 
>>
>> Thanks,
>> Song
>>
>>
>> The following changes since commit 8c740c6bf12dec03b6f35b19fe6c183929d0b88a:
>>
>>  null_blk: fix ida error handling in null_add_dev() (2022-07-15 09:04:38 -0600)
>>
>> are available in the Git repository at:
>>
>>   https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
>>
>> for you to fetch changes up to f8584a43b407dc0b7277e722a4b7fbca9f4bee44:
>>
>>  raid5: fix duplicate checks for rdev->saved_raid_disk (2022-07-18 14:33:58 -0700)
>>
>> ----------------------------------------------------------------
>> Jackie Liu (1):
>>      raid5: fix duplicate checks for rdev->saved_raid_disk
> 
> Forgot to mention: 
> 
> This patch conflicts with the following commit in upstream and linux-next:
> 
> commit 617b365872a2 ("dm raid: fix KASAN warning in raid5_add_disks")
> 
> It should be straightforward to fix. 

Since the conflicting patch in the above tree is just a cleanup, let's
please defer that. I usually don't mind dealing with conflicts if they
are inevitable, but when it's just a cleanup then I think it'd be better
to defer to after the merge window.

Can you send this pull request with just the fix instead?

-- 
Jens Axboe

