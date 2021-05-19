Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518CEC433ED
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 18:02:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AFC8611BD
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 18:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhESSDg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 14:03:36 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:61898 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230371AbhESSDf (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 May 2021 14:03:35 -0400
Received: from host109-154-217-227.range109-154.btcentralplus.com ([109.154.217.227] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1ljQWM-0003Xz-B7; Wed, 19 May 2021 19:02:14 +0100
Subject: Re: My superblocks have gone missing, can't reassemble raid5
To:     Leslie Rhorer <lesrhorer@att.net>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
 <c99e3bac-469a-0b48-31df-481754c477c7@att.net>
 <cceec847-e2e2-3d7f-008e-e3f1fac9ca20@youngman.org.uk>
 <3f77fc62-2698-a8cb-f366-75e8a63b9a8b@att.net>
From:   Wols Lists <antlists@youngman.org.uk>
Message-ID: <60A55239.9070009@youngman.org.uk>
Date:   Wed, 19 May 2021 19:00:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <3f77fc62-2698-a8cb-f366-75e8a63b9a8b@att.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 19/05/21 18:08, Leslie Rhorer wrote:
> 
> 
> On 5/19/2021 11:41 AM, antlists wrote:
>> On 19/05/2021 15:48, Leslie Rhorer wrote:
>>
>> Because defaults change?
> 
>     Oh, I also don't necessarily know which build of mdadm he is using.
> They might be default on my build but not his.
> 
>>>      Now try running a check on the assembled array:
>>> fsck /dev/md99
>>>
>>>      If that fails, shutdown the array with
>>>
>>> mdadm -S /dev/md99
>>>
>>>      and then try creating the array with a different drive order.
>>> There are only two other possible permutations of three disks.  If
>>> none of those work, you have some more serious problems.
>>
>> And here you are oversimplifying the problem immensely. If those three
>> drives aren't the originals
> 
>     Hang on.  Which drives do you mean?

The drives he originally ran --create on to create the array in the
first place.

The ONLY time you can be reasonably confident that running --create WILL
recover a damaged array is if it is still in its original state - no
drives swapped, no admin changes to the array, AND you're using the same
version of mdadm.

Cheers,
Wol
