Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD475C433DB
	for <linux-raid@archiver.kernel.org>; Mon,  8 Feb 2021 14:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C4F864E84
	for <linux-raid@archiver.kernel.org>; Mon,  8 Feb 2021 14:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbhBHO4l (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Feb 2021 09:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbhBHOzV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 Feb 2021 09:55:21 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13358C06178C
        for <linux-raid@vger.kernel.org>; Mon,  8 Feb 2021 06:54:41 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id b21so10356517pgk.7
        for <linux-raid@vger.kernel.org>; Mon, 08 Feb 2021 06:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=AYRGoYePQAzJ7LEhFJURePb+3/N+X+kqoSUl81c+Xxg=;
        b=GHHxqHgedWlJYgkjkbcDnLpb3OWbBGZgJYIvQehnw8oIk70LBueh4uMiVEo1sLLtEU
         fegcPAvpvCFDiDd/0BLKsUE3o2GknmUFAduY92QftR4YSsvF7OEsS6do7RnGV4VecXJf
         hw9LxEBr/FyL+gUiaIJQB/UX2Qv8rfyiOIeSAFksmiaHqJ3+H6Gk3MWt7thkNhrGRr9K
         OYJS2RbGi+C16zSG9BVQfaXxhmRwytMichhbsXhdA58cu6335aD+Btfu9XsMsoIoPa7d
         1FIDBGMbRTkxEfYuzlUkdwdDwmS3AvBb8+Q7Ss3Hy2h8JAYsou0Opdyjj215AKCij9qR
         xEsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AYRGoYePQAzJ7LEhFJURePb+3/N+X+kqoSUl81c+Xxg=;
        b=kFoGI9BtIOoAJFUpUNLV+X5HvB90X8YT83RDMtDTGtCNUZyxl9aui6wQeRsgeYoFXT
         iRG3fpuzxuUb6QSY89vjpgZJQD9f87eR4/sV3z3l7Z6/DHizdGrtjfc/twDrjDA1HqTL
         mGy2T/df+Wn6Npy3bR66U9Q7dSPb0w8DXXlDClrAwhhdYZnrjcniA2DUyu77j8KfHUf5
         N2I8RtGNEm7odTqhRYZwqDTfQeHQOR/FflTpUCoPHSfc5ZD4l7JsZ0p3hr68HZlfu5ZB
         LghSERsQQKx0NjkIl4lISwQEHjx2K83jWo4IZRyr2xMoaGqwv52kPPZAtBUuCvV1OXiF
         jXFA==
X-Gm-Message-State: AOAM530sufsUX2KHdEczXgjKmvHGxiIp1ilAYuLW2+j7PmH07hwglnQK
        nFJmsGkIDfOSfvFqZjd55D0LZQ==
X-Google-Smtp-Source: ABdhPJxfc/2QCJTpVg4dyshnVgR559LUcvi/kuA9m/Mz0GV0CAHUPwYobHgPYSKyW/Zg6VRaLeprtA==
X-Received: by 2002:a65:5883:: with SMTP id d3mr18264467pgu.301.1612796078639;
        Mon, 08 Feb 2021 06:54:38 -0800 (PST)
Received: from [0.0.0.0] ([62.217.45.26])
        by smtp.gmail.com with ESMTPSA id m5sm19218026pgj.11.2021.02.08.06.54.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 06:54:37 -0800 (PST)
Subject: Re: md_raid: mdX_raid6 looping after sync_action "check" to "idle"
 transition
To:     Donald Buczek <buczek@molgen.mpg.de>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+raid@molgen.mpg.de
References: <aa9567fd-38e1-7b9c-b3e1-dc2fdc055da5@molgen.mpg.de>
 <7c5438c7-2324-cc50-db4d-512587cb0ec9@molgen.mpg.de>
 <b289ae15-ff82-b36e-4be4-a1c8bbdbacd7@cloud.ionos.com>
 <37c158cb-f527-34f5-2482-cae138bc8b07@molgen.mpg.de>
 <efb8d47b-ab9b-bdb9-ee2f-fb1be66343b1@molgen.mpg.de>
 <55e30408-ac63-965f-769f-18be5fd5885c@molgen.mpg.de>
 <d95aa962-9750-c27c-639a-2362bdb32f41@cloud.ionos.com>
 <30576384-682c-c021-ff16-bebed8251365@molgen.mpg.de>
 <cdc0b03c-db53-35bc-2f75-93bbca0363b5@molgen.mpg.de>
 <bc342de0-98d2-1733-39cd-cc1999777ff3@molgen.mpg.de>
 <c3390ab0-d038-f1c3-5544-67ae9c8408b1@cloud.ionos.com>
 <a27c5a64-62bf-592c-e547-1e8e904e3c97@molgen.mpg.de>
 <6c7008df-942e-13b1-2e70-a058e96ab0e9@cloud.ionos.com>
 <12f09162-c92f-8fbb-8382-cba6188bfb29@molgen.mpg.de>
 <6757d55d-ada8-9b7e-b7fd-2071fe905466@cloud.ionos.com>
 <93d8d623-8aec-ad91-490c-a414c4926fb2@molgen.mpg.de>
 <0bb7c8d8-6b96-ce70-c5ee-ba414de10561@cloud.ionos.com>
 <e271e183-20e9-8ca2-83eb-225d4d7ab5db@molgen.mpg.de>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <1cdfceb6-f39b-70e1-3018-ea14dbe257d9@cloud.ionos.com>
Date:   Mon, 8 Feb 2021 15:53:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e271e183-20e9-8ca2-83eb-225d4d7ab5db@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2/8/21 12:38, Donald Buczek wrote:
>> 5. maybe don't hold reconfig_mutex when try to unregister sync_thread, 
>> like this.
>>
>>          /* resync has finished, collect result */
>>          mddev_unlock(mddev);
>>          md_unregister_thread(&mddev->sync_thread);
>>          mddev_lock(mddev);
> 
> As above: While we wait for the sync thread to terminate, wouldn't it be 
> a problem, if another user space operation takes the mutex?

I don't think other places can be blocked while hold mutex, otherwise 
these places can cause potential deadlock. Please try above two lines 
change. And perhaps others have better idea.

Thanks,
Guoqing
