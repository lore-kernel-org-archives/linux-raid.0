Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D637CC433DB
	for <linux-raid@archiver.kernel.org>; Wed, 24 Feb 2021 09:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C81C64E6C
	for <linux-raid@archiver.kernel.org>; Wed, 24 Feb 2021 09:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbhBXJ0r (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Feb 2021 04:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234454AbhBXJ0o (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Feb 2021 04:26:44 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4D7C061574
        for <linux-raid@vger.kernel.org>; Wed, 24 Feb 2021 01:26:03 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id n10so1057011pgl.10
        for <linux-raid@vger.kernel.org>; Wed, 24 Feb 2021 01:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=skeImN742nfG4E0VR51CuEJEgnI11NI7CM+fbkLvJHE=;
        b=KdMp2Xxu1lxwo85MH7HqrKTDape4aeTBAX36uuyqZzrxkZqZi85qJBFJXRdPt7gix/
         B4WQj+FsH6WZO6XIY+/Ac/7rvTS+2Bj6Q/8ATWZ64vD4qQeTW3dh+0GB7kQoqidfwzke
         Md0sm80WkdPubKyk7Fs6TNKah3MBUNCf8ryTgvAMtKCqoLNxsgAOGdM02j7GzHLptvMT
         j9JNVqma5Cy9+tZT9vZaWGTGQN4FUEFcmnl2jaORbx/n0zqwhgGPQaOc7w9XVVnln7FN
         o7Dne3xBxyf3I20Qb8FsnXpnZl1czCBV9M8qE1EOBPSJDnuDuxpQarzoEhVLpBbwqx3B
         gAfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=skeImN742nfG4E0VR51CuEJEgnI11NI7CM+fbkLvJHE=;
        b=MUNr9PoPGzp81uUGxL39LXh8WXt/zjs2wxgizvrmfy6HcToDADVQxLLaK+iKUaG4a3
         ely/V0ETjYGXXiOrq0q3FSRoR9/hK4a72cpo/12siYVYdeVJ9gOuij25XfcGm143GDUZ
         zz1L86ICEZunflOK4GIHrKtCmGciSlMFa6HgWY3uAIG6VRQRWnHvHC6ic2edkHzVWm81
         LDBxiLDWYrvtX42BbM8su7VumDyEQR4hFdZ8UGGaDC5auuXxvjDBagr8PC6/rym25OHJ
         pqDIMV5HbTbXapvLvUKYQ7KJ+ILaUI++w6TXN4Pqo16OMmRN6l+UAJLXHKbelSGWxKlU
         uxuA==
X-Gm-Message-State: AOAM53245oiQyirBamscU+FY6Dzk2nGuFF/FEwM2BHVV2s5nztBoVEbW
        rTDce9OBgFlfPyUzss6sG4Z2Dg==
X-Google-Smtp-Source: ABdhPJwNecl6jFwBFdxrR9hTadcRdwBZB3K+w0crjykXhBn8Jc1gVvlfJaQSqb4iF2lgIXJ/PgvMjw==
X-Received: by 2002:a65:5ac9:: with SMTP id d9mr27664900pgt.74.1614158761974;
        Wed, 24 Feb 2021 01:26:01 -0800 (PST)
Received: from [0.0.0.0] ([62.217.45.26])
        by smtp.gmail.com with ESMTPSA id g9sm1946042pfo.115.2021.02.24.01.25.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 01:26:01 -0800 (PST)
Subject: Re: [PATCH V2] md: don't unregister sync_thread with reconfig_mutex
 held
To:     Song Liu <song@kernel.org>, Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        Donald Buczek <buczek@molgen.mpg.de>, it+raid@molgen.mpg.de
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
 <36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
 <CAPhsuW5s6fk3kua=9Z9o3VPCcN1wdUqXybXm9cp4arJW5+oBvQ@mail.gmail.com>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <9f28f6e2-e46a-bfed-09d8-2fec941ea881@cloud.ionos.com>
Date:   Wed, 24 Feb 2021 10:25:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW5s6fk3kua=9Z9o3VPCcN1wdUqXybXm9cp4arJW5+oBvQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2/24/21 10:09, Song Liu wrote:
> On Mon, Feb 15, 2021 at 3:08 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>>
>> [+cc Donald]
>>
>> Am 13.02.21 um 01:49 schrieb Guoqing Jiang:
>>> Unregister sync_thread doesn't need to hold reconfig_mutex since it
>>> doesn't reconfigure array.
>>>
>>> And it could cause deadlock problem for raid5 as follows:
>>>
>>> 1. process A tried to reap sync thread with reconfig_mutex held after echo
>>>      idle to sync_action.
>>> 2. raid5 sync thread was blocked if there were too many active stripes.
>>> 3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
>>>      which causes the number of active stripes can't be decreased.
>>> 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
>>>      to hold reconfig_mutex.
>>>
>>> More details in the link:
>>> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
>>>
>>> And add one parameter to md_reap_sync_thread since it could be called by
>>> dm-raid which doesn't hold reconfig_mutex.
>>>
>>> Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
>>> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> 
> I don't really like this fix. But I haven't got a better (and not too
> complicated)
> alternative.
> 
>>> ---
>>> V2:
>>> 1. add one parameter to md_reap_sync_thread per Jack's suggestion.
>>>
>>>    drivers/md/dm-raid.c |  2 +-
>>>    drivers/md/md.c      | 14 +++++++++-----
>>>    drivers/md/md.h      |  2 +-
>>>    3 files changed, 11 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>>> index cab12b2..0c4cbba 100644
>>> --- a/drivers/md/dm-raid.c
>>> +++ b/drivers/md/dm-raid.c
>>> @@ -3668,7 +3668,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
>>>        if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
>>>                if (mddev->sync_thread) {
>>>                        set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>> -                     md_reap_sync_thread(mddev);
>>> +                     md_reap_sync_thread(mddev, false);
> 
> I think we can add mddev_lock() and mddev_unlock() here and then we don't
> need the extra parameter?
> 

I thought it too, but I would prefer get the input from DM people first.

@ Mike or Alasdair


Thanks,
Guoqing
