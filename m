Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90516C43219
	for <linux-raid@archiver.kernel.org>; Mon,  9 May 2022 08:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237015AbiEIIq0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 May 2022 04:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236053AbiEIIPn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 May 2022 04:15:43 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630FD12EA17
        for <linux-raid@vger.kernel.org>; Mon,  9 May 2022 01:11:46 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1652083769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VaPesRw1wCdHVXoelvRzZkv+LjOF7fMmR4ujza4rtec=;
        b=dxNM4p7gAdmk2dwIhJeSMpJsgbH8ad7QDtQfYI8pmmDD0EqWngxqCUsI0yLxh34MyM+Af0
        BIPivL4xcj4kwVHlxIkxF8lYKPuBp/ez015qOmw6rf0llVQSD01NQOKD0Lqdok2hFxiznm
        6RdhoQKYpd8ZWCI6TrTC0M8hPQ6rRGI=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
To:     Song Liu <song@kernel.org>
Cc:     Donald Buczek <buczek@molgen.mpg.de>,
        linux-raid <linux-raid@vger.kernel.org>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
Message-ID: <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
Date:   Mon, 9 May 2022 16:09:24 +0800
MIME-Version: 1.0
In-Reply-To: <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/9/22 2:37 PM, Song Liu wrote:
> On Fri, May 6, 2022 at 4:37 AM Guoqing Jiang<guoqing.jiang@linux.dev>  wrote:
>> From: Guoqing Jiang<guoqing.jiang@cloud.ionos.com>
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
>> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
>>
>> Let's call unregister thread between mddev_unlock and mddev_lock_nointr
>> (thanks for the report from kernel test robot<lkp@intel.com>) if the
>> reconfig_mutex is held, and mddev_is_locked is introduced accordingly.
> mddev_is_locked() feels really hacky to me. It cannot tell whether
> mddev is locked
> by current thread. So technically, we can unlock reconfigure_mutex for
> other thread
> by accident, no?

I can switch back to V2 if you think that is the correct way to do though no
one comment about the change in dm-raid.

Thanks,
Guoqing
