Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F5CEB64D0
	for <linux-raid@archiver.kernel.org>; Tue, 13 Jun 2023 14:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242264AbjFMOPd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Jun 2023 10:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240380AbjFMOPb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Jun 2023 10:15:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D4719A
        for <linux-raid@vger.kernel.org>; Tue, 13 Jun 2023 07:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686665691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DpkNnyJl/r+l38jd7G4jK6EOYDsTz3j87kgRPwWTAIk=;
        b=PiFdWzNifpm1yGDrfrWK22ZwRmetMRqxY9A/pSMv7znK3bv946cb2UQtPaA7qfkfwrpC1x
        wCeva8eBqksc54i/CpRAKNBtGaMfYztS+0iUlybIfL1kJKZO/OrCU9uGTYRad0IFB1nwrp
        jJUA+JSdb/PqMiljb+98dZg2td04W4w=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-CUQHc6NuOy2PKoRH8J-FWQ-1; Tue, 13 Jun 2023 10:14:40 -0400
X-MC-Unique: CUQHc6NuOy2PKoRH8J-FWQ-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1b3b39e1468so16281795ad.0
        for <linux-raid@vger.kernel.org>; Tue, 13 Jun 2023 07:14:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686665674; x=1689257674;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DpkNnyJl/r+l38jd7G4jK6EOYDsTz3j87kgRPwWTAIk=;
        b=LmhVMdjt2F6Gz20DWQ5hc5rzPIuX0Z0O8xavBnj0R+aHxPykGTYGBz2moQz++ymNhB
         j47hg4kNPYM51aDdUxEyLDoskk0i5xjjselvG00KZwiMADC3h3MwXt7LzzAnqCtF+9/N
         XjrEvX/fbP/0tTY8bcferXwIWu/UrPNY4Oz7WRAO+raHR4TNlFqH4lCLYfl4cYDWaFTy
         WDE+aY5PCXY6cYAxV/C95aOto02Gr3xR/ZM3V3RNfTxWKtbdaRYYj/EX6qy2FujRgwKW
         GsZZgN/PQxAW/MdDPP6ZNbjL7QQYmgb+pfQWNTtXt4qwsAkuevdy4SoTG/BWCtMEN8Fr
         /FXA==
X-Gm-Message-State: AC+VfDwHSmQ/nr3QEKeQVT+dzeasuPEBvdzpPPzJQP3RjaYuClGzZL/i
        F0KUbHDw+R4oG+tOunI9iywu6UcqzwYLXKIc6DhXvRhg7ATL2yT48rLeJ4kOknYe+YrgA981tU7
        pX9XMR/feGM5UJ9oroui6qw==
X-Received: by 2002:a17:902:db05:b0:1ac:750e:33ef with SMTP id m5-20020a170902db0500b001ac750e33efmr10683889plx.3.1686665673980;
        Tue, 13 Jun 2023 07:14:33 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7hphU5oNXY+vLyEtzb2/VXAwyFdv/W1ERGfScbT2ryMWNZzP9j95BDoUSr4GRG7HdpNpBDJA==
X-Received: by 2002:a17:902:db05:b0:1ac:750e:33ef with SMTP id m5-20020a170902db0500b001ac750e33efmr10683869plx.3.1686665673684;
        Tue, 13 Jun 2023 07:14:33 -0700 (PDT)
Received: from [10.72.13.126] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q23-20020a170902b11700b001b008b3dee2sm4805118plr.287.2023.06.13.07.14.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 07:14:33 -0700 (PDT)
Message-ID: <3917c8cf-dff7-e922-1d64-7ca1d7f03030@redhat.com>
Date:   Tue, 13 Jun 2023 22:14:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [dm-devel] [PATCH -next v2 2/6] md: refactor action_store() for
 'idle' and 'frozen'
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     guoqing.jiang@linux.dev, agk@redhat.com, snitzer@kernel.org,
        dm-devel@redhat.com, song@kernel.org, yi.zhang@huawei.com,
        yangerkun@huawei.com, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-3-yukuai1@huaweicloud.com>
 <b780ccfd-66b1-fdd1-b33e-aa680fbd86f1@redhat.com>
 <1aaf9150-bbd3-87a8-8d54-8b5d63ab5ed3@huaweicloud.com>
 <CALTww2-ta1NUJxcT3Dq5KP7iunnVx24X7RKj1OKYTYwEPeDNrg@mail.gmail.com>
 <68b215a4-b4bb-7c94-6ad4-84ea859af742@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
In-Reply-To: <68b215a4-b4bb-7c94-6ad4-84ea859af742@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


在 2023/6/13 下午8:44, Yu Kuai 写道:
> Hi,
>
> 在 2023/06/13 20:25, Xiao Ni 写道:
>> On Tue, Jun 13, 2023 at 8:00 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>
>>> Hi,
>>>
>>> 在 2023/06/13 16:02, Xiao Ni 写道:
>>>>
>>>> 在 2023/5/29 下午9:20, Yu Kuai 写道:
>>>>> From: Yu Kuai <yukuai3@huawei.com>
>>>>>
>>>>> Prepare to handle 'idle' and 'frozen' differently to fix a deadlock,
>>>>> there
>>>>> are no functional changes except that MD_RECOVERY_RUNNING is checked
>>>>> again after 'reconfig_mutex' is held.
>>>>
>>>>
>>>> Can you explain more about why it needs to check MD_RECOVERY_RUNNING
>>>> again here?
>>>
>>> As I explain in the following comment:
>>
>> Hi
>>
>> Who can clear the flag before the lock is held?
>
> Basically every where that can clear the flag...
>
> // This context     // Other context
>             mutex_lock
>             ...
> test_bit -> pass
>             clear_bit
>             mutex_unlock
> mutex_lock
> test_bit -> check again
>
> Thanks,
> Kuai

At first, I wanted to figure out a specific case. Now I have the answer. 
Maybe there are two people that want to stop

the sync action at the same time. So this is the case that can be 
checked by the codes.

Regards

Xiao

>>
>> Regards
>> Xiao
>>>>> +    /*
>>>>> +     * Check again in case MD_RECOVERY_RUNNING is cleared before 
>>>>> lock is
>>>>> +     * held.
>>>>> +     */
>>>>> +    if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
>>>>> +        mddev_unlock(mddev);
>>>>> +        return;
>>>>> +    }
>>>
>>> Thanks,
>>> Kuai
>>>
>>
>> .
>>
>

