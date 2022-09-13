Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 529EEC6FA82
	for <linux-raid@archiver.kernel.org>; Tue, 13 Sep 2022 12:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbiIMMWJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Sep 2022 08:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbiIMMWC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Sep 2022 08:22:02 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAAA3ECCB
        for <linux-raid@vger.kernel.org>; Tue, 13 Sep 2022 05:22:01 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4MRjJR1m61zXLW;
        Tue, 13 Sep 2022 14:21:59 +0200 (CEST)
Message-ID: <071b8b8a-7a50-3eec-22d4-5880ff3f80e9@thelounge.net>
Date:   Tue, 13 Sep 2022 14:21:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: change UUID of RAID devcies
Content-Language: en-US
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <2341a2a9-b86e-f0e5-784a-05dbd474dec5@thelounge.net>
 <729bdc01-b0ae-887a-6d2a-5135d287636c@youngman.org.uk>
 <05a1161b-d798-c68f-d37c-a9fc373c6e73@thelounge.net>
 <0023fefe-aad1-e692-48dd-e354497f6e41@plouf.fr.eu.org>
 <1fb05e0f-34b7-3ec4-bc00-ec540e592f19@thelounge.net>
 <3fc0b889-3ef9-652e-6452-2eeede918683@plouf.fr.eu.org>
 <9e537739-2fbd-2c99-8191-54faf0a69a8b@thelounge.net>
 <6b4a5399-5053-4a51-26d7-2f62c47c2981@plouf.fr.eu.org>
 <65ee1134-60e4-4577-74c7-0ba15ae39225@thelounge.net>
 <97b66977-97c7-21aa-f1d9-f0d34a0fcf9b@plouf.fr.eu.org>
 <b428f8c6-cf8b-218c-3cae-8f36327901f7@thelounge.net>
 <ec3b9673-688b-18c8-188b-246e9c63a2d0@plouf.fr.eu.org>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <ec3b9673-688b-18c8-188b-246e9c63a2d0@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 13.09.22 um 14:03 schrieb Pascal Hambourg:
> On 13/09/2022 at 13:50, Reindl Harald wrote:
>>
>> Am 13.09.22 um 13:48 schrieb Pascal Hambourg:
>>>
>>> Legacy boot on GPT has some requirements, but it works
>>
>> but we are talking about a LIVE-migration/reshape of existing disks 
>> with no place left for another partition
> 
> So what ? Aren't you going to create a GPT partition table on your 4-TB 
> drives ? Else you won't be able to use the space beyond 2 TiB. (*)
> A GPT partition table supports up to 128 partitions by default.

i won't have a choice as it looks like and so the easiest choice would 
be migrate /boot completly to a USB-stick and simply ignore the current 
/boot RAID1 which is just 482M small

since finally the new machines in the next step only support UEFI and 
the uefi-system partition can't live on a RAID it would end there over 
time anyways

the 4 machines are two pairs (homeoffice and office for two people) 
cloned by remove two drives and rebuild the array on both so the 
bbot-part is always identical and the stick on one can boot the other

so for now my last remaining question is "how would the command look for 
"Then with just two drives you change the raid to raid-1"

> (*) In the DOS/MBR partition scheme, Linux supports that a partition 
> ends beyond 2 TiB up to 4 TiB but this is a non standard trick and 
> probably not supported by usual partitioning tools
meh
