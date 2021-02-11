Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180E4C433E6
	for <linux-raid@archiver.kernel.org>; Thu, 11 Feb 2021 09:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE41064E6F
	for <linux-raid@archiver.kernel.org>; Thu, 11 Feb 2021 09:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhBKJT2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 11 Feb 2021 04:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhBKJL6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 11 Feb 2021 04:11:58 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D9BC061574
        for <linux-raid@vger.kernel.org>; Thu, 11 Feb 2021 01:11:17 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id a9so8926945ejr.2
        for <linux-raid@vger.kernel.org>; Thu, 11 Feb 2021 01:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GJWWyynVsENDfnB6i5IT3DI6vZjeH5WBlOF9/Uk36nU=;
        b=SmGA4nyMbcb8sqSjdEiLTR+K4WVbXacWR1cGz80LyWgrvyg0fd13WohL43yw8zdh8r
         BRH0nWGuDXPzetZ4CCTwNgTsnioe0YvIyAFDawBCjGYYumnKMUfvBGYwaCEddBShH0oR
         drytDjkU6WcFvnYb/3gpFJiDiuqos8bHc+lgZelbcRaU1j1+DZnJnu3DijgaSlu0U6Fd
         pSgmDlHELZUEfLrq5hNgmfU9AQn6My4xcqfh6t1+Vk9RmPB5+Kjm6jf8MNSav6uk9ZO9
         KFlzdOS2BCvMvts4afTjTQTfHW30g7A2t25oR2Nzj1n0e3CHQ5SjOsUMkZNBeoFUU2w7
         aoHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GJWWyynVsENDfnB6i5IT3DI6vZjeH5WBlOF9/Uk36nU=;
        b=tEldg9mD7bT2FQgAmMi56tl2v66me+6Zbvv3mkIRrGTUcA2ZHOpjWTzg+anVhfkshE
         7KOQGp/DUzqLUxacPQE7lD7e25TccSh6KLWb4yVIYEYDAKIySe5iJF98Pr4kOH433nAx
         KJGQqzR2V2BP/5AcLc7KS7/llGbH4k0QmTVj78vB3xlkog5J9ML5kIfKkeGGmrESPuRw
         hIX4ToWPbEuWlC7HrPTgT83vIRSQUPEYTh748SV66Vqcfm2H1j6zNnAxueuMf/DkNySE
         OPSmwMk6FCcnPsoMAeXLmw5St21NNV4kUAE14NNZCKCo3FF1XcIrlOnGrVLIdCT20ht3
         ihGg==
X-Gm-Message-State: AOAM532tfQHIdWB3aKyJkYAxMc02vzHs/EgTd8RF0hvz45pC24D34VOq
        eYh/So/zQBan9xgNvM6rvOUTFnXSdp8+sg==
X-Google-Smtp-Source: ABdhPJxwe1KxH64hRaOWfr5mN+BxJOomnfPhR4E5uTk9UDpYOUYocnPUvL/3XempbjNk03jyZKhGUw==
X-Received: by 2002:a17:906:1c17:: with SMTP id k23mr7384992ejg.121.1613034676294;
        Thu, 11 Feb 2021 01:11:16 -0800 (PST)
Received: from [0.0.0.0] ([2001:1438:4010:2540:ad3b:cb1a:9d6a:6077])
        by smtp.gmail.com with ESMTPSA id mh4sm3668021ejb.122.2021.02.11.01.11.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 01:11:15 -0800 (PST)
Subject: Re: [PATCH] md: don't unregister sync_thread with reconfig_mutex held
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <1612923676-18294-1-git-send-email-guoqing.jiang@cloud.ionos.com>
 <CAPhsuW5ZU2fpP1smSodKWFCqLu4J91sWqY6DC7ppQ=3VvJM+eQ@mail.gmail.com>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <7fdb9726-4b1f-e04c-2451-f47139ddc05b@cloud.ionos.com>
Date:   Thu, 11 Feb 2021 10:11:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW5ZU2fpP1smSodKWFCqLu4J91sWqY6DC7ppQ=3VvJM+eQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2/11/21 08:28, Song Liu wrote:
> On Tue, Feb 9, 2021 at 6:22 PM Guoqing Jiang
> <guoqing.jiang@cloud.ionos.com> wrote:
>>
>> Unregister sync_thread doesn't need to hold reconfig_mutex since it
>> doesn't reconfigure array.
>>
>> And it could cause deadlock problem for raid5 as follows:
>>
>> 1. process A tried to reap sync thread with reconfig_mutex held after echo
>>     idle to sync_action.
>> 2. raid5 sync thread was blocked if there were too many active stripes.
>> 3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
>>     which causes the number of active stripes can't be decreased.
>> 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
>>     to hold reconfig_mutex.
>>
>> More details in the link:
>> issu://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
>>
>> Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
>> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> 
> Thanks for debugging the issue. However, I am not sure whether this is
> the proper
> fix. For example, would this break dm-raid.c:raid_message()? IIUC,
> raid_message()
> calls md_reap_sync_thread() without holding reconfigure_mutex, no?

Oops, I didn't notice dm-raid calls it though md did call it with 
reconfig_mutex held. But on the other side, it proves we don't need to 
call md_reap_sync_thread with the mutex held.

Thanks,
Guoqing
