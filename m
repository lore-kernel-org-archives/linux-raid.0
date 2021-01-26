Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54EE4C433E0
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jan 2021 14:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30C2622228
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jan 2021 14:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404933AbhAZOJx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Jan 2021 09:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392711AbhAZOHN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 26 Jan 2021 09:07:13 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97423C0611C2
        for <linux-raid@vger.kernel.org>; Tue, 26 Jan 2021 06:06:21 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id o16so1880088pgg.5
        for <linux-raid@vger.kernel.org>; Tue, 26 Jan 2021 06:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+czMnlTMDcv/kNs5J/9z223E++sGCsTNb3CDdoR0L8I=;
        b=fi71ayd9wyt+fvpLXgDBpwyqm3kdyFaM2YKXHHucSl+lMGRtQbNPJFZ92zBToRIfq0
         EiCz5GHY6NRg+pxgnq5HuzWYJdVaxiEDkpOHdyrw6DATIDG9jBeb8PRjkX3q17rwSBdC
         6Q/8Y0RQIfMWi14C3+fg8wQVNUxrdZyrxDuLEDjJzjG3W6edT8ejg5nlhy5KYwAaTWY3
         ZKeV65HjG7Fe34RLaTNO4vuWT9a6g31sQk0Wp4k9bUSRwKSFDR7s2AiMcV9/HL952Vse
         U9AWWdZYZAmYG2oHUtRcC3TA+FZf+emsCI5Hnz17kVXxY7Jyul3fGRf7fmc7uyHhunu2
         EdSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+czMnlTMDcv/kNs5J/9z223E++sGCsTNb3CDdoR0L8I=;
        b=YbfsCSVhiiWi2h7ylwEU6ec3kl8i6WvD6KbP+YQcn9SP89+X9W00cJVwqgH0HGqa6/
         k6QEWT+40U27kPY3U90SIuD1vfpxerm9dTSHEfEKqDXjfmS3qDwA3un/xujscQ3z1YDl
         DXmRVHbr1arqqjKujpCl5lqGYUUbp8QeIcPwI2e9xyoDfbn5EZEZpQcuJgoFifw0llNY
         QLiOJJ/RU47ZDjNNSgnrBgJqjqNKKmv4XeU97rUhcsony9xpFdiK3CMi8ttgAYuKCghB
         mVjgM2OQvSDaRQ3OH0JDilhCyDkVoU1HUdYfPoQ2gWs6wZ7rmuR8PI9EbWMbt/0mM2Xa
         NU3g==
X-Gm-Message-State: AOAM5329Mptl8LPmw1uXot3kztDxI86erosjYZvWaAxieFbcb/tWKxqM
        4UDEMYkTx8MI6oFC7azIzYPImQ==
X-Google-Smtp-Source: ABdhPJxxgfR/FwfOdv6eZaWjcfWUhE7OX0mzpeacr4hdmuX8RH+Qggs/D2OIYcHBl56BQsULJfOPfQ==
X-Received: by 2002:a62:7dc4:0:b029:1ba:765:3af with SMTP id y187-20020a627dc40000b02901ba076503afmr5331083pfc.78.1611669979990;
        Tue, 26 Jan 2021 06:06:19 -0800 (PST)
Received: from [10.8.0.111] ([89.187.162.118])
        by smtp.gmail.com with ESMTPSA id b67sm19214493pfa.140.2021.01.26.06.06.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 06:06:18 -0800 (PST)
Subject: Re: md_raid: mdX_raid6 looping after sync_action "check" to "idle"
 transition
To:     Donald Buczek <buczek@molgen.mpg.de>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+raid@molgen.mpg.de
References: <aa9567fd-38e1-7b9c-b3e1-dc2fdc055da5@molgen.mpg.de>
 <95fbd558-5e46-7a6a-43ac-bcc5ae8581db@cloud.ionos.com>
 <77244d60-1c2d-330e-71e6-4907d4dd65fc@molgen.mpg.de>
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
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <6757d55d-ada8-9b7e-b7fd-2071fe905466@cloud.ionos.com>
Date:   Tue, 26 Jan 2021 15:06:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <12f09162-c92f-8fbb-8382-cba6188bfb29@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 1/26/21 13:58, Donald Buczek wrote:
> 
> 
>> Hmm, how about wake the waiter up in the while loop of raid5d?
>>
>> @@ -6520,6 +6532,11 @@ static void raid5d(struct md_thread *thread)
>>                          md_check_recovery(mddev);
>>                          spin_lock_irq(&conf->device_lock);
>>                  }
>> +
>> +               if ((atomic_read(&conf->active_stripes)
>> +                    < (conf->max_nr_stripes * 3 / 4) ||
>> +                    (test_bit(MD_RECOVERY_INTR, &mddev->recovery))))
>> +                       wake_up(&conf->wait_for_stripe);
>>          }
>>          pr_debug("%d stripes handled\n", handled);
> 
> Hmm... With this patch on top of your other one, we still have the basic 
> symptoms (md3_raid6 busy looping), but the sync thread is now hanging at
> 
>      root@sloth:~# cat /proc/$(pgrep md3_resync)/stack
>      [<0>] md_do_sync.cold+0x8ec/0x97c
>      [<0>] md_thread+0xab/0x160
>      [<0>] kthread+0x11b/0x140
>      [<0>] ret_from_fork+0x22/0x30
> 
> instead, which is 
> https://elixir.bootlin.com/linux/latest/source/drivers/md/md.c#L8963

Not sure why recovery_active is not zero, because it is set 0 before 
blk_start_plug, and raid5_sync_request returns 0 and skipped is also set 
to 1. Perhaps handle_stripe calls md_done_sync.

Could you double check the value of recovery_active? Or just don't wait 
if resync thread is interrupted.

wait_event(mddev->recovery_wait,
	   test_bit(MD_RECOVERY_INTR,&mddev->recovery) ||
	   !atomic_read(&mddev->recovery_active));

> And, unlike before, "md: md3: data-check interrupted." from the pr_info 
> two lines above appears in dmesg.

Yes, that is intentional since MD_RECOVERY_INTR is set by write idle.

Anyway, will try the script and investigate more about the issue.

Thanks,
Guoqing
