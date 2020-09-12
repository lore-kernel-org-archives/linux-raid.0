Return-Path: <SRS0=Qcx5=CV=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4086C433E2
	for <linux-raid@archiver.kernel.org>; Sat, 12 Sep 2020 16:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C4BE20838
	for <linux-raid@archiver.kernel.org>; Sat, 12 Sep 2020 16:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgILQTV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 12 Sep 2020 12:19:21 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:29172 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbgILQTT (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 12 Sep 2020 12:19:19 -0400
Received: from host86-136-163-47.range86-136.btcentralplus.com ([86.136.163.47] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kH8FA-0007dM-AV; Sat, 12 Sep 2020 17:19:16 +0100
Subject: Re: Linux raid-like idea
To:     Brian Allen Vanderburg II <brianvanderburg2@aim.com>,
        linux-raid@vger.kernel.org
References: <1cf0d18c-2f63-6bca-9884-9544b0e7c54e.ref@aim.com>
 <1cf0d18c-2f63-6bca-9884-9544b0e7c54e@aim.com>
 <e3cb1bbe-65eb-5b75-8e99-afba72156b6e@youngman.org.uk>
 <ef3719a9-ae53-516e-29ee-36d1cdf91ef1@aim.com>
 <5F54146F.40808@youngman.org.uk>
 <274cb804-9cf1-f56c-9ee4-56463f052c09@aim.com>
 <ddd9b5b9-88e6-e730-29f4-30dfafd3a736@youngman.org.uk>
 <38f9595b-963e-b1f5-3c29-ad8981e677a7@aim.com>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <9220ea81-3a81-bb98-22e3-be1a123113a1@youngman.org.uk>
Date:   Sat, 12 Sep 2020 17:19:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <38f9595b-963e-b1f5-3c29-ad8981e677a7@aim.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/09/2020 21:14, Brian Allen Vanderburg II wrote:
> That's right, I get the various combinations confused.  So does raid61
> allow for losing 4 disks in any order and still recovering? or would
> some order of disks make it where just 3 disks lost and be bad?
> Iinteresting non-the-less and I'll have to look into it.  Obviously it's
> not intended to as a replacement for backing up important data, but, for
> me any way, just away to minimize loss of any trivial bulk data/files.

Yup. Raid 6 has two parity disks, and that's mirrored to give four 
parity disks. So as an *absolute* *minimum*, raid-61 could lose four 
disks with no data loss.

Throw in the guarantee that, with a mirror, you can lose an entire 
mirror with no data-loss, that means - with luck and a following wind - 
you could lose half your disks, PLUS the two parities in the remaining 
disks, and still recover your data. So with a raid-6+1, if I had twelve 
disks, I could lose EIGHT disks and still have a *chance* of recovering 
my array. I'm not quite sure what difference raid-61 would make.

(That says to me, if I have a raid-61, I need as a minimum a complete 
set of data disks. That also says to me, if I've splatted an 8+2 raid-61 
across 11 disks, I only need 7 for a full recovery despite needing a 
minimum of 8, so something isn't quite right here... I suspect the 7 
would be enough but I did say my mind goes Whooaaa!!!!)
> 
> It would be nice if the raid modules had support for methods that could
> support a total of more disks in any order lost without loosing data.
> Snapraid source states that it uses some Cauchy Matrix algorithm which
> in theory could loose up to 6 disks if using 6 parity disks, in any
> order, and still be able to restore the data.  I'm not familiar with the
> math behind it so can't speak to the accuracy of that claim.

That's easy, it's just whether it's worth it. Look at the maths behind 
raid-6. The "one parity disk" methods, 4 or 5, just use XOR. But that 
only works once, a second XOR parity disk adds no new redundancy and is 
worthless. I'm guessing raid-6 uses that Cauchy method you talk about - 
certainly it can generate as many parity disks as you like ... so that 
claim is good, even if raid-6 doesn't use that particular technique.

If someone wants to, mod'ing raid-6 to use 3 parity disks shouldn't be 
that hard ...


But going back to your original idea, I've been thinking about it. And 
it struck me - you NEED to regenerate parity EVERY TIME you write data 
to disk! Otherwise, writing one file on one disk instantly trashes your 
ability to recover all the other files in the same position on the other 
disks. WHOOPS! But if you think it's a good idea, by all means try and 
do it.

The other thing I'd suggest here, is try and make it more like raid-5 
than raid-4. You have X disks, let's say 5. So one disk each is numbered 
0, 1, 2, 3, 4. As part of formatting the disk ready for raid, you create 
a file containing every block where LBA mod 5 equals disk number. So as 
you recalculate your parities, that's where they go.

Cheers,
Wol
