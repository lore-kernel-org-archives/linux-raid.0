Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 056E8C25B0E
	for <linux-raid@archiver.kernel.org>; Tue, 16 Aug 2022 13:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbiHPNyd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Aug 2022 09:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234505AbiHPNy3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 16 Aug 2022 09:54:29 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D8440567
        for <linux-raid@vger.kernel.org>; Tue, 16 Aug 2022 06:54:23 -0700 (PDT)
Subject: Re: [PATCH RFC] md: call md_cluster_stop() in __md_stop()
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660658061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VhBwF2/an4ccjAAgxP4ikTnppPJY7Wpbm3FN1LqhV38=;
        b=vSo3gvNL5KaxjXx8KQ++berXGByMbr055QE7Ov48iXDRA+BBJI0lAQLjEmIU1e8G/213Wd
        ZemXSf2WnVqT+uEd17Xl+jg145xH611QHT7FoBsDpWK1owXoHEgUlvKHIc/1y031pPYOM3
        qps6zPViBVPv7R8jeYh/4NmLbBQmmj8=
To:     NeilBrown <neilb@suse.de>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
References: <166027061107.20931.13490156249149223084@noble.neil.brown.name>
 <d45190a8-fffe-3a96-19ff-bdeccbc31945@linux.dev>
 <166061152702.5425.9507699881285566239@noble.neil.brown.name>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <a6657e08-b6a7-358b-2d2a-0ac37d49d23a@linux.dev>
Date:   Tue, 16 Aug 2022 21:53:53 +0800
MIME-Version: 1.0
In-Reply-To: <166061152702.5425.9507699881285566239@noble.neil.brown.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 8/16/22 8:58 AM, NeilBrown wrote:
> On Mon, 15 Aug 2022, Guoqing Jiang wrote:
>> Hi Neil,
>>
>> Sorry for later reply since I was on vacation last week.
>>
>> On 8/12/22 10:16 AM, NeilBrown wrote:
>>> [[ I noticed the e151 patch recently which seems to admit that it broke
>>>      something.  So I looked into it and came up with this.
>> I just noticed it ...
>>
>>>      It seems to make sense, but I'm not in a position to test it.
>>>      Guoqing: does it look OK to you?
>>>      - NeilBrown
>>> ]]
>>>
>>> As described in Commit: 48df498daf62 ("md: move bitmap_destroy to the
>>> beginning of __md_stop") md_cluster_stop() needs to run before the
>>> mdddev->thread is stopped.
>>> The change to make this happen was reverted in Commit: e151db8ecfb0
>>> ("md-raid: destroy the bitmap after destroying the thread") due to
>>> problems it caused.
>>>
>>> To restore correct behaviour, make md_cluster_stop() reentrant and
>>> explicitly call it at the start of __md_stop(), after first calling
>>> md_bitmap_wait_behind_writes().
>>>
>>> Fixes: e151db8ecfb0 ("md-raid: destroy the bitmap after destroying the thread")
>>> Signed-off-by: NeilBrown <neilb@suse.de>
>>> ---
>>>    drivers/md/md-cluster.c | 1 +
>>>    drivers/md/md.c         | 3 +++
>>>    2 files changed, 4 insertions(+)
>>>
>>> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
>>> index 742b2349fea3..37bf0aa4ed71 100644
>>> --- a/drivers/md/md-cluster.c
>>> +++ b/drivers/md/md-cluster.c
>>> @@ -1009,6 +1009,7 @@ static int leave(struct mddev *mddev)
>>>    	     test_bit(MD_CLOSING, &mddev->flags)))
>>>    		resync_bitmap(mddev);
>>>    
>>> +	mddev->cluster_info = NULL;
>> The above makes sense.
> Thanks.
>
>>>    	set_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
>>>    	md_unregister_thread(&cinfo->recovery_thread);
>>>    	md_unregister_thread(&cinfo->recv_thread);
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index afaf36b2f6ab..a57b2dff64dd 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -6238,6 +6238,9 @@ static void mddev_detach(struct mddev *mddev)
>>>    static void __md_stop(struct mddev *mddev)
>>>    {
>>>    	struct md_personality *pers = mddev->pers;
>>> +
>>> +	md_bitmap_wait_behind_writes(mddev);
>>> +	md_cluster_stop(mddev);
>>>    	mddev_detach(mddev);
>>>    	/* Ensure ->event_work is done */
>>>    	if (mddev->event_work.func)
>> The md_bitmap_destroy is called in __md_stop with or without e151db8ecfb0,
>> and it already invokes md_bitmap_wait_behind_writes and md_cluster_stop by
>> md_bitmap_free. So the above is sort of redundant to me.
> The point is that md_cluster_stop() needs to run before mddev_detach()
> shuts down the thread.  If we don't call all of md_bitmap_destroy()
> before mddev_detach() we need to at least run md_cluster_stop(), and I
> think we need to run md_bitmap_wait_behind_writes() before that.
>
>
>> For the issue described in e151db8ecfb, looks like raid1d was running after
>> __md_stop, I am wondering if dm-raid should stop write first just like
>> normal md-raid.
> That looks like a really good idea, that should make it safe to move
> md_bitmap_destroy() back before mddev_detach().
> Would you like to post a patch to make those two changes, and include
> Mikulas Patocka, or should I?

NP, will send it later, thanks for your review.

BRs,
Guoqing
