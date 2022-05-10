Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05820C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 10 May 2022 12:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241025AbiEJMF3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 May 2022 08:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240849AbiEJMF1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 10 May 2022 08:05:27 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DBE3A712
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 05:01:28 -0700 (PDT)
Received: from theinternet.molgen.mpg.de (theinternet.molgen.mpg.de [141.14.31.7])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 4951061E6478B;
        Tue, 10 May 2022 14:01:27 +0200 (CEST)
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
To:     Song Liu <song@kernel.org>, Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
 <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <fdabab9e-e0ce-330d-b4db-0a11fde82615@molgen.mpg.de>
Date:   Tue, 10 May 2022 14:01:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/10/22 8:44 AM, Song Liu wrote:
> On Mon, May 9, 2022 at 1:09 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>>
>>
>>
>> On 5/9/22 2:37 PM, Song Liu wrote:
>>> On Fri, May 6, 2022 at 4:37 AM Guoqing Jiang<guoqing.jiang@linux.dev>  wrote:
>>>> From: Guoqing Jiang<guoqing.jiang@cloud.ionos.com>
>>>>
>>>> Unregister sync_thread doesn't need to hold reconfig_mutex since it
>>>> doesn't reconfigure array.
>>>>
>>>> And it could cause deadlock problem for raid5 as follows:
>>>>
>>>> 1. process A tried to reap sync thread with reconfig_mutex held after echo
>>>>      idle to sync_action.
>>>> 2. raid5 sync thread was blocked if there were too many active stripes.
>>>> 3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
>>>>      which causes the number of active stripes can't be decreased.
>>>> 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
>>>>      to hold reconfig_mutex.
>>>>
>>>> More details in the link:
>>>> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
>>>>
>>>> Let's call unregister thread between mddev_unlock and mddev_lock_nointr
>>>> (thanks for the report from kernel test robot<lkp@intel.com>) if the
>>>> reconfig_mutex is held, and mddev_is_locked is introduced accordingly.
>>> mddev_is_locked() feels really hacky to me. It cannot tell whether
>>> mddev is locked
>>> by current thread. So technically, we can unlock reconfigure_mutex for
>>> other thread
>>> by accident, no?
>>
>> I can switch back to V2 if you think that is the correct way to do though no
>> one comment about the change in dm-raid.
> 
> I guess v2 is the best at the moment. I pushed a slightly modified v2 to
> md-next.

I think, this can be used to get a double-free from md_unregister_thread.

Please review

https://lore.kernel.org/linux-raid/8312a154-14fb-6f07-0cf1-8c970187cc49@molgen.mpg.de/

Best
   Donald

> 
> Thanks for working on this.
> Song
> 


-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
