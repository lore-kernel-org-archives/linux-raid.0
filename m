Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED37AC433B4
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 13:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD6FC610A8
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 13:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353717AbhESNm3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 09:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346655AbhESNm3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 May 2021 09:42:29 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7594AC06175F
        for <linux-raid@vger.kernel.org>; Wed, 19 May 2021 06:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IsfGJWFMOt4DL96aY9Ph7vIdE86NkvDWCU9ABR4USao=; b=GR0aO2trhUJOgJ/lstSHXpec1p
        j44En+g4jBSweSsyaqUVuOBDUKnr05UY5/RBISid62TGMliZDejy3CvcB1uaRLfyCfeyWhwZ50qYx
        S7t79aB61Dujz8NZX8j3DxrcQwFAjJtKBteybYeif0GX3asL3R0bAGYTKkhfBxEZ8pLH5pIzKfbJa
        QtYwKr4XbvxMBhRAoNNekkK7eRgmo9wPkK3J+4kxNzRyAJ8YfrJ1y3ljHwjQq/w98DLgO10nj3gBo
        6Iev2DdM7KZpp41eVlpQpWpJEEE3xQaPJDhs/NBnSffs2RT308++EtI9dkqN+LHk7xJk/9vuFYiOT
        5ebNYKyA==;
Received: from c-73-43-58-214.hsd1.ga.comcast.net ([73.43.58.214] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1ljMRd-0001a5-8N; Wed, 19 May 2021 13:41:05 +0000
Subject: Re: My superblocks have gone missing, can't reassemble raid5
To:     Leslie Rhorer <lesrhorer@att.net>,
        Reindl Harald <h.reindl@thelounge.net>,
        Roman Mamedov <rm@romanrm.net>,
        Roger Heflin <rogerheflin@gmail.com>
Cc:     Christopher Thomas <youkai@earthlink.net>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
 <20210517112844.388d2270@natsu>
 <CAAMCDec=H=6ceP9bKjSnsQyvmZ0LqTAYzJTDmDQoBOHSJV+hDw@mail.gmail.com>
 <20210517181905.6f976f1a@natsu>
 <2e37cf64-1696-a5ca-f7db-83a1d098133d@turmel.org>
 <d21d0214-32e6-1213-b5a5-5b630223e346@thelounge.net>
 <09d03968-28e3-8c67-38c1-e3a8c577bd93@att.net>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <e4258686-7673-9f5f-d333-fbbb95c066b1@turmel.org>
Date:   Wed, 19 May 2021 09:41:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <09d03968-28e3-8c67-38c1-e3a8c577bd93@att.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/19/21 9:20 AM, Leslie Rhorer wrote:
> 
> 
> On 5/18/2021 1:31 PM, Reindl Harald wrote:

[trim/]

>> leave some margin and padding around the used space solves that 
>> problem entirely and i still need to hear a single valid reason for 
>> using unpartitioned drives in a RAID
> 
>      I can give you about a dozen.  We will start with this:
> 
> 1. Partitioning is not necessary.  Doing something that is not necessary 
> is not usually worthwhile.

1a: sure.  1b:  I can think of many things that aren't *necessary* but 
are certainly worthwhile.  I can even throw a few out there, like 
personal hygiene, healthy diets, exercise.  In this context, I would 
list drive smart monitoring, weekly scrubs, and sysadmins with a clue.

> 2. Partitioning offers no advantages.  Doing something unnecessary is 
> questionable.  Doing something that has no purpose at all is downright 
> foolish.

Who says it has no purpose.  Its purpose is to segment a device into 
regions with associated metadata.

> 3. Partitioning introduces an additional layer of activity.  This makes 
> it both more complex and more wasteful of resources.  And yes, before 
> you bring it up, the additional complexity and resource infringement are 
> quite small.  They are not zero, however, and they are in essence 
> continuous.  Every little bit counts.

Hmm.  A sector offset and limit check, buried deep in the kernel's 
common code.  I dare you to measure the incremental impact.

> 4. There is no guarantee the partitioning that works today will work 
> tomorrow.  It should, of course, and it probably will, but why take a 
> risk when there is absolutely no gain whatsoever?

You assert "no gain", but you provide no support for your assertion.

> 5. It is additional work that ultimately yields no positive result 
> whatsoever.  Admittedly, partitioning one disk is not a lot of work. 
> Partitioning 50 disks is another matter.  Partitioning 500 disks...

You assert "no positive result whatsoever".  Sounds like #4.  With 
similar lack of support.  Fluffing up your list, much?

> 6. Partitioning has an intent.  That intent is of no relevance 
> whatsoever on a device whose content is singular in scope.  Are you 
> suggesting we should also partition tapes?  Ralph Waldo Emerson had 
> something important to say about repeatedly doing things simply because 
> they have been done before and elsewhere.

No relevance?  Metadata can be rather useful when operating systems 
encounter what looks like an empty disk.  Metadata that says "not 
empty!"  Especially valuable when metadata is *recognized* by all 
operating systems.  You know, like, a *standard*.  While MDraid places 
metadata on the devices it uses, only Linux *recognizes* it.

> 7. There is no downside to forfeiting the partition table.  Not needing 
> to do something is an extremely good reason for not doing it.  This is 
> of course a corollary to point #1.

Just more fluff.

Microsoft and a number of NAS products are known to corrupt drives with 
no partition table.  I vaguely recall hardware raid doing it, too. 
That's a damn good reason to add a tiny (measurable?) amount of overhead.

And dude, making a single partition on a disk can be /scripted/.  Might 
want to learn about that, if the pain of the driving fdisk/gdisk 
occasionally is too much for your delicate fingers.

Phil
