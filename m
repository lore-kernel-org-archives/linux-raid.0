Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6878FC433B4
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 20:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41696611C2
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 20:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhESUC0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 16:02:26 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:15341 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230431AbhESUC0 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 May 2021 16:02:26 -0400
Received: from host109-154-217-227.range109-154.btcentralplus.com ([109.154.217.227] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1ljSNM-0000FH-EX; Wed, 19 May 2021 21:01:04 +0100
Subject: Re: My superblocks have gone missing, can't reassemble raid5
To:     Leslie Rhorer <lesrhorer@att.net>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
 <c99e3bac-469a-0b48-31df-481754c477c7@att.net>
 <cceec847-e2e2-3d7f-008e-e3f1fac9ca20@youngman.org.uk>
 <3f77fc62-2698-a8cb-f366-75e8a63b9a8b@att.net>
 <60A55239.9070009@youngman.org.uk>
 <8ab0ec19-4d9b-3de6-59cf-9e6a8a18bd37@att.net>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <d3a8bd2d-378e-fe84-ab81-4ac58f314b50@youngman.org.uk>
Date:   Wed, 19 May 2021 21:01:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <8ab0ec19-4d9b-3de6-59cf-9e6a8a18bd37@att.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 19/05/2021 20:01, Leslie Rhorer wrote:
>> The ONLY time you can be reasonably confident that running --create WILL
>> recover a damaged array is if it is still in its original state - no
>> drives swapped, no admin changes to the array, AND you're using the same
>> version of mdadm.
> 
>      That's a little bit of an overstatement, depending on what you mean 
> by "reasonably confident".  Swapped drives should not ordinarily cause 
> an issue, especially with RAID 4 or 5.  The parity is, after all, 
> numerically unique.  Admin changes to the array should be similarly 
> fully established provided the rebuild completed properly.  I don't 
> think the parity algorythms have changed over time in mdadm, either. Had 
> they done so, mdadm would not be able to assemble arrays from previous 
> versions regardless of whether the superblock was intact.


You said there's only three possible combinations of three drives. Every 
change I've mentioned adds another variable - more options ...

The data offset is not fixed, for one. Swapping a drive could mean 
drives have different offsets which means NO combination of drives, with 
default options, will work. Rebuilding an array moves everything around.

Yes you can explicitly specify everything, and get mdadm to recover the 
array if the superblocks have been lost, but it's nowhere as simple as 
"there are only three possible combinations".

Cheers,
Wol
