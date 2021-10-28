Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FAEFC433F5
	for <linux-raid@archiver.kernel.org>; Thu, 28 Oct 2021 14:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11BF561056
	for <linux-raid@archiver.kernel.org>; Thu, 28 Oct 2021 14:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhJ1OI1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Oct 2021 10:08:27 -0400
Received: from smarthost01c.ixn.mail.zen.net.uk ([212.23.1.22]:43106 "EHLO
        smarthost01c.ixn.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230070AbhJ1OI0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 28 Oct 2021 10:08:26 -0400
Received: from [82.71.70.4] (helo=aawcs.co.uk)
        by smarthost01c.ixn.mail.zen.net.uk with esmtp (Exim 4.90_1)
        (envelope-from <john@aawcs.co.uk>)
        id 1mg62Y-0006XY-5A; Thu, 28 Oct 2021 14:05:58 +0000
Received: from [192.168.1.200] ( [192.168.1.200])
          by aawcs.co.uk with ESMTP (Mailtraq/2.17.7.3560) id AWCS4BA74050;
          Thu, 28 Oct 2021 15:06:55 +0100
Subject: Re: growing a RAID5 array by adding disks later
To:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <20211028133626.GX6557@justpickone.org>
From:   John Atkins <John@aawcs.co.uk>
Organization: AAW Control Systems
Message-ID: <c5b7f1f6-80c9-a7d4-2327-feab6ded91f7@aawcs.co.uk>
Date:   Thu, 28 Oct 2021 15:05:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211028133626.GX6557@justpickone.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Hops: 1
X-Originating-smarthost01c-IP: [82.71.70.4]
Feedback-ID: 82.71.70.4
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

So yes changing the array from 5 to 6 is possible, time intensive (for 
the machine). Please see 
http://www.ewams.net/?date=2013/05/02&view=Converting_RAID5_to_RAID6_in_mdadm

Growing an array with additional disks is very similar and takes time 
same as the above.

Hope this answers all your questions.

On 28/10/2021 14:36, David T-G wrote:
> Hi, all --
>
> It's time to replace a few 4T disks in our little server.  I don't
> particularly want to go back with more 4T disks (although the same
> model sure are cheap these days! :-) and figure I should put in larger
> drives as I go.  I am then left with weighing simple $/G vs total price;
> bigger drives can be cheaper per volume but of course more overall.
> My first approach is to put newer, larger drives in place and expect to
> grow into the empty space when all of the old ones have been swapped out.
>
> But ...  If I were to splurge and buy 3ea big drives to replace all of
> the space that I have now, how practical is it to grow that RAID5 array
> by adding additional drives later?  My eventual goal would be to get
> to 8-10 devices in a RAID6 layout (two "extras"), but of course I can't
> afford that today.  Do I have an easy path to get there in the long run?
>
> [BTW, can I convert an array from RAID5 to RAID6, too?]
>
> On the other hand, I do have the empty slots (currently filled with
> scratch drives here and there), so I could both replace my aging drives
> and add more and just grow this array 1) if the growth idea is practical
> and 2) if I don't get to splurge.
>
>
> TIA
>
> :-D

