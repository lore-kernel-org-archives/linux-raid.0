Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70548C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 01:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbhLJBKo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 20:10:44 -0500
Received: from out2.migadu.com ([188.165.223.204]:16206 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230526AbhLJBKo (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 9 Dec 2021 20:10:44 -0500
Subject: Re: [PATCH V2] md: don't unregister sync_thread with reconfig_mutex
 held
To:     Donald Buczek <buczek@molgen.mpg.de>,
        Paul Menzel <pmenzel@molgen.mpg.de>, song@kernel.org
Cc:     agk@redhat.com, snitzer@redhat.com, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, it+raid@molgen.mpg.de
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
 <36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
 <2cefad59-c0fc-d48f-f7a5-5d593931feb7@molgen.mpg.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <43ae2d60-4f28-07ea-95dc-ae722ca13b23@linux.dev>
Date:   Fri, 10 Dec 2021 09:06:57 +0800
MIME-Version: 1.0
In-Reply-To: <2cefad59-c0fc-d48f-f7a5-5d593931feb7@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 12/9/21 8:57 PM, Donald Buczek wrote:
> [Update Guoqing’s email address]
>
> On 15.02.21 12:07, Paul Menzel wrote:
>> [+cc Donald]
>>
>> Am 13.02.21 um 01:49 schrieb Guoqing Jiang:
>>> Unregister sync_thread doesn't need to hold reconfig_mutex since it
>>> doesn't reconfigure array.
>>>
>>> And it could cause deadlock problem for raid5 as follows:
>>>
>>> 1. process A tried to reap sync thread with reconfig_mutex held 
>>> after echo
>>>     idle to sync_action.
>>> 2. raid5 sync thread was blocked if there were too many active stripes.
>>> 3. SB_CHANGE_PENDING was set (because of write IO comes from upper 
>>> layer)
>>>     which causes the number of active stripes can't be decreased.
>>> 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was 
>>> not able
>>>     to hold reconfig_mutex.
>>>
>>> More details in the link:
>>> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t 
>>>
>>>
>>> And add one parameter to md_reap_sync_thread since it could be 
>>> called by
>>> dm-raid which doesn't hold reconfig_mutex.
>>>
>>> Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
>
> Thanks, Paul, for putting me into the cc.
>
> Guoqing, I don't think, I've tested this patch. Please remove the 
> tested-by.

This version is basically the similar as the change in the thread.

https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#m546d8c55a42f308985b9d31d4be85832edcd15ab

Anyway, I will remove your tested-by per the request if I will update 
the patch.

Thanks,
Guoqing
