Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D21EC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 20 May 2022 18:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352606AbiETS1o (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 May 2022 14:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbiETS1n (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 May 2022 14:27:43 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B833170F10
        for <linux-raid@vger.kernel.org>; Fri, 20 May 2022 11:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=Ky/sjyVI4TSiHGi2p8nt8nMyitdeYK+EKfqldLdASMA=; b=Eob8LOP8o+xLEuzVWmy/Dp9v/k
        4YItx+qK6tJ0oLkJSQkc7ut8V2sF7h6N29NM6O0RYst6Ar0s293Rr929WJcBHT88q9Yja4IeWIFEX
        pyDHer0upKMgDowUyOISeJkBLD2VDGLYQag3JgzDwCobZJwYhfT1mkkhkcvEX3rSb+dyjqua44rCk
        DlZ5Su/A9BdwwnQj+UfBa0FE83UTC9RAeVX5RlEAvsE9AYHAmxUvDqUpoZvgUS9tMfN5pcsGwNqEN
        Rr/AANZq+/Itkmh0Ax/pZcCGjdRtITlSII6CfI1QkydalBy9cQiigiM3PbjW2odbWK6XvEi+gMAWB
        Ito7OXsQ==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1ns7La-003FWo-2A; Fri, 20 May 2022 12:27:35 -0600
Message-ID: <b4244eab-d9e2-20a0-ebce-1a96e8fadb91@deltatee.com>
Date:   Fri, 20 May 2022 12:27:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-CA
To:     Song Liu <song@kernel.org>, Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Donald Buczek <buczek@molgen.mpg.de>,
        linux-raid <linux-raid@vger.kernel.org>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
 <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: song@kernel.org, guoqing.jiang@linux.dev, buczek@molgen.mpg.de, linux-raid@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Hi,

On 2022-05-10 00:44, Song Liu wrote:
> On Mon, May 9, 2022 at 1:09 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
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
>>>>     idle to sync_action.
>>>> 2. raid5 sync thread was blocked if there were too many active stripes.
>>>> 3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
>>>>     which causes the number of active stripes can't be decreased.
>>>> 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
>>>>     to hold reconfig_mutex.
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
> 

I noticed a clear regression with mdadm tests with this patch in md-next
(7e6ba434cc6080).

Before the patch, tests 07reshape5intr and 07revert-grow would fail
fairly infrequently (about 1 in 4 runs for the former and 1 in 30 runs
for the latter).

After this patch, both tests always fail.

I don't have time to dig into why this is, but it would be nice if
someone can at least fix the regression. It is hard to make any progress
on these tests if we are continuing to further break them.

Logan
