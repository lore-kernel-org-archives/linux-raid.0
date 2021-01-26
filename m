Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E5FC433E9
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jan 2021 11:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2FA523108
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jan 2021 11:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392162AbhAZLRE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Jan 2021 06:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392194AbhAZLPo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 26 Jan 2021 06:15:44 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2998AC061573
        for <linux-raid@vger.kernel.org>; Tue, 26 Jan 2021 03:15:04 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ox12so22451704ejb.2
        for <linux-raid@vger.kernel.org>; Tue, 26 Jan 2021 03:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Fal6U4PDNcYYqkpLjGA7YKgQHbc+tdNcYU+0SG4xNWs=;
        b=I8pUBeN0C0kksUYa74WX8vZLjhLFjzyfgXlFq40db+CE4gX4Ukrja2LtCnl3wP2ACR
         CwrFHnKe/OXsGFF4L6zdRJ+mutTUYWfuQRPBP0uSa4OIPe2BmLbuhajeCnrbbrqj53DD
         9+bCz1sq2DxVS8nR+Yvujal/UW+qwHobxlmoiMFG9Kh4EakCM0wEeBFm8dDOjLroW6nq
         gtW3XDYevKAHrw2jYOMaMOnnQVXOJyJqL++qxtR8I0YwlFvn9vqqVfHve58S0q+rE7eW
         HSUG4mkoYLhI9zKRqnZrg2IAW+Up+TGH6uuR8UKq/DPnURGvKk7ECbFvRc8Vbav+xatL
         qH7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fal6U4PDNcYYqkpLjGA7YKgQHbc+tdNcYU+0SG4xNWs=;
        b=ShTkHJ1oRxLHTBydUPV2nQ2DeiCxsaOE1fCJXhaRZsRV6UpZAhI3SjI2etnFazroC3
         oBXkPICqqoE/QSqbSOMUF6h6csjSqwAHoheSHPjDV0+ZnwF5E9Ipxp9/M7E+6CeaO+fZ
         lp6/WI6agzPUPPCq57QrVUAfvNsW8iu8p23wxA/yxgqEoyh/UrOCKqh3wk9CVl2u5PEX
         rzi3d1b3U+tdCOpB7SJPv1r/pJ0PHrZqa6acjzH9ZFLq9YbIdlaAI9qbO9nx4Uu4dnBb
         2f+VE07o1xtMq4JVqvMHYtX98wEx5GhX/CbDU0PNrXi+Cw6EO6p4X2IYGqkvBNKol9WC
         oImQ==
X-Gm-Message-State: AOAM5310HZt4i6ATSYUDew9VROEyUPDvqEUh3gjigxDUEWTW+QWU5ZNS
        NKY+YaUSFxXWAWdcYF6GirIeGpqzO/v1nKwr
X-Google-Smtp-Source: ABdhPJyTqZwwWFE1qjJwQPesEkgMftkUVX3xvNbuz6Vt5rQ2ammt2BJe6x6nFborSoQgU6ZpkjsVpQ==
X-Received: by 2002:a17:906:60c3:: with SMTP id f3mr3057881ejk.65.1611659702874;
        Tue, 26 Jan 2021 03:15:02 -0800 (PST)
Received: from ?IPv6:240e:304:2c80:dde0:4886:bf9:d177:bf2c? ([240e:304:2c80:dde0:4886:bf9:d177:bf2c])
        by smtp.gmail.com with ESMTPSA id b17sm2002740edv.56.2021.01.26.03.14.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 03:15:02 -0800 (PST)
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
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <6c7008df-942e-13b1-2e70-a058e96ab0e9@cloud.ionos.com>
Date:   Tue, 26 Jan 2021 12:14:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a27c5a64-62bf-592c-e547-1e8e904e3c97@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Donald,

On 1/26/21 10:50, Donald Buczek wrote:
[...]

>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index 2d21c298ffa7..f40429843906 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -4687,11 +4687,13 @@ action_store(struct mddev *mddev, const char 
>>> *page, size_t len)
>>>               clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>>>           if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
>>>               mddev_lock(mddev) == 0) {
>>> +            set_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
>>>               flush_workqueue(md_misc_wq);
>>>               if (mddev->sync_thread) {
>>>                   set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>>                   md_reap_sync_thread(mddev);
>>>               }
>>> +            clear_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
>>>               mddev_unlock(mddev);
>>>           }
>>>       } else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>>
>> Yes, it could break the deadlock issue, but I am not sure if it is the 
>> right way given we only set ALLOW_SB_UPDATE in suspend which makes 
>> sense since the io will be quiesced, but write idle action can't 
>> guarantee the  similar thing.
> 
> Thinking (and documenting) MD_ALLOW_SB_UPDATE as "the holder of 
> reconfig_mutex promises not to make any changes which would exclude 
> superblocks from being written" might make it easier to accept the usage.

I am not sure it is safe to set the flag here since write idle can't 
prevent IO from fs while mddev_suspend can guarantee that.

> 
>> I prefer to make resync thread not wait forever here.
>>

[...]

>>
>> -        sh = raid5_get_active_stripe(conf, new_sector, previous,
>> +        sh = raid5_get_active_stripe(conf, new_sector, previous, 0,
> 
> 
> Mistake here (fourth argument added instead of third)

Thanks for checking.

[...]

> Unfortunately, this patch did not fix the issue.
> 
>      root@sloth:~/linux# cat /proc/$(pgrep md3_resync)/stack
>      [<0>] raid5_get_active_stripe+0x1e7/0x6b0
>      [<0>] raid5_sync_request+0x2a7/0x3d0
>      [<0>] md_do_sync.cold+0x3ee/0x97c
>      [<0>] md_thread+0xab/0x160
>      [<0>] kthread+0x11b/0x140
>      [<0>] ret_from_fork+0x22/0x30
> 
> which is ( according to objdump -d -Sl drivers/md/raid5.o ) at 
> https://elixir.bootlin.com/linux/v5.11-rc5/source/drivers/md/raid5.c#L735
> 
> Isn't it still the case that the superblocks are not written, therefore 
> stripes are not processed, therefore number of active stripes are not 
> decreasing? Who is expected to wake up conf->wait_for_stripe waiters?

Hmm, how about wake the waiter up in the while loop of raid5d?

@@ -6520,6 +6532,11 @@ static void raid5d(struct md_thread *thread)
                         md_check_recovery(mddev);
                         spin_lock_irq(&conf->device_lock);
                 }
+
+               if ((atomic_read(&conf->active_stripes)
+                    < (conf->max_nr_stripes * 3 / 4) ||
+                    (test_bit(MD_RECOVERY_INTR, &mddev->recovery))))
+                       wake_up(&conf->wait_for_stripe);
         }
         pr_debug("%d stripes handled\n", handled);

If the issue still appears then I will change the waiter to break just 
if MD_RECOVERY_INTR is set, something like.

wait_event_lock_irq(conf->wait_for_stripe,
	(test_bit(MD_RECOVERY_INTR, &mddev->recovery) && sync_req) ||
	 /* the previous condition */,
	*(conf->hash_locks + hash));

Thanks,
Guoqing
