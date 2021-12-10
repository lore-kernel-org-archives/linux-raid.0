Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12D7C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 01:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhLJBqy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 20:46:54 -0500
Received: from out1.migadu.com ([91.121.223.63]:64847 "EHLO out1.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230467AbhLJBqx (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 9 Dec 2021 20:46:53 -0500
Subject: Re: [PATCH 1/2] md/raid0: Free r0conf memory when register integrity
 failed
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1639100598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fvYtpHa4Qnk8cvFUMt8j369GlSLza9xOMECx/Ek2/xA=;
        b=rRcEcN72arP3uF/MFfMLUlWH+tT/Xaco3Ae3K1o9/1aOyxQRk5zPJSkG8sgXO8Q1jOvhJ2
        Z1j13NAaXn8Aos5wkTl49Bfmg0CqxztHxgi36JAdzYo/NE22nrI0qE01AeqW0OMwkO3Zxo
        U9hfLM9IVVBpO1tmI4g4alCr21yt4+g=
To:     Xiao Ni <xni@redhat.com>
Cc:     Song Liu <song@kernel.org>, Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
References: <1639029324-4026-1-git-send-email-xni@redhat.com>
 <1639029324-4026-2-git-send-email-xni@redhat.com>
 <CAPhsuW48S-L9QTH6q_7+Nq0+MmOfswPu5epMq=bkGokxBRE2ew@mail.gmail.com>
 <978b1c0a-2ba0-d736-8e3c-99a15997b7d5@linux.dev>
 <CALTww293ewiXD8s0b-sLbdFZgnxMZh=5e4Fj=WMB+ifoJcNP7g@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <7f6e67a9-f4c8-1952-6d79-ea36c8455434@linux.dev>
Date:   Fri, 10 Dec 2021 09:43:14 +0800
MIME-Version: 1.0
In-Reply-To: <CALTww293ewiXD8s0b-sLbdFZgnxMZh=5e4Fj=WMB+ifoJcNP7g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 12/10/21 9:34 AM, Xiao Ni wrote:
> On Fri, Dec 10, 2021 at 9:22 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>>
>>
>> On 12/10/21 2:02 AM, Song Liu wrote:
>>> On Wed, Dec 8, 2021 at 9:55 PM Xiao Ni<xni@redhat.com>  wrote:
>>>> It doesn't free memory when register integrity failed. And move
>>>> free conf codes into a single function.
>>>>
>>>> Signed-off-by: Xiao Ni<xni@redhat.com>
>>>> ---
>>>>    drivers/md/raid0.c | 18 +++++++++++++++---
>>>>    1 file changed, 15 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
>>>> index 62c8b6adac70..3fa47df1c60e 100644
>>>> --- a/drivers/md/raid0.c
>>>> +++ b/drivers/md/raid0.c
>>>> @@ -356,6 +356,7 @@ static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks
>>>>           return array_sectors;
>>>>    }
>>>>
>>>> +static void free_conf(struct r0conf *conf);
>>>>    static void raid0_free(struct mddev *mddev, void *priv);
>>>>
>>>>    static int raid0_run(struct mddev *mddev)
>>>> @@ -413,19 +414,30 @@ static int raid0_run(struct mddev *mddev)
>>>>           dump_zones(mddev);
>>>>
>>>>           ret = md_integrity_register(mddev);
>>>> +       if (ret)
>>>> +               goto free;
>>>>
>>>>           return ret;
>>>> +
>>>> +free:
>>>> +       free_conf(conf);
>>> Can we just use raid0_free() here? Also, after freeing conf,
>>> we should set mddev->private to NULL.
>> Agree, like what raid1_run did. And we might need to check the
>> return value of pers->run in level_store as well.
> Yes. It needs to check the return value and try to reback to the original
> state. I planed to fix this in the following days not this patch. This patch
> only fix the NULL reference problem after reshape.
>
> In fact, no only we need to check pers->run in level_store, we also need
> to check integrity during reshape. Now integrity only supports
> raid0/raid1/raid10,
> so it needs to do some jobs related with integrity (unregister/register)
>
> I plan to fix these two problems in the next patches. Is it OK?

Yes, fine from my side and thanks for your time.

Thanks,
Guoqing
