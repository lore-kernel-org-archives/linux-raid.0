Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A3BDC6FA8D
	for <linux-raid@archiver.kernel.org>; Tue, 13 Sep 2022 14:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbiIMOUP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Sep 2022 10:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbiIMOT3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Sep 2022 10:19:29 -0400
Received: from mallaury.nerim.net (smtp-102-tuesday.noc.nerim.net [178.132.17.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A82165569
        for <linux-raid@vger.kernel.org>; Tue, 13 Sep 2022 07:14:13 -0700 (PDT)
Received: from [192.168.0.247] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id B16CBDB17C;
        Tue, 13 Sep 2022 16:12:50 +0200 (CEST)
Message-ID: <f26afeb3-e7ab-2e57-9d14-5ce0d0ec740b@plouf.fr.eu.org>
Date:   Tue, 13 Sep 2022 16:12:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: change UUID of RAID devcies
Content-Language: en-US
To:     Reindl Harald <h.reindl@thelounge.net>,
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
 <071b8b8a-7a50-3eec-22d4-5880ff3f80e9@thelounge.net>
 <8babedc5-a2e7-326f-3340-10e354aecb45@plouf.fr.eu.org>
 <15f573c4-0c96-885f-659f-bfa2cbd698a7@thelounge.net>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <15f573c4-0c96-885f-659f-bfa2cbd698a7@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 13/09/2022 at 15:02, Reindl Harald wrote:
> Am 13.09.22 um 14:47 schrieb Pascal Hambourg:
> 
>> However you are right that you can get rid of the current /boot array; 
>> I don't see the need for a separate /boot, its contents could be 
>> included in the root filesystem.
> 
> and the initrd lives where?
> chicken / egg

In the /boot directory, beside the kernel image. What's different with 
the initrd ? I don't see any chicken & egg problem. If GRUB can boot the 
kernel image and initrd from a separate /boot RAID array, it can do the 
same from a root RAID array.

>>> since finally the new machines in the next step only support UEFI and 
>>> the uefi-system partition can't live on a RAID it would end there 
>>> over time anyways
>>
>> Software is not natively supported by EFI boot but there are a few 
          ^^^
Oops ! I meant "software RAID".

>> tricks to set up a redundant EFI boot: create independent EFI 
>> partitions on each disk, or create a RAID 1 array with metadata 1.0 
>> (at the end of the partition) so that the UEFI firmware can see each 
>> RAID partition as a normal EFI partition with a FAT filesystem.
> 
> sounds all not appealing

Yes, but I know no cleaner way to achieve UEFI boot redundancy, which is 
desirable.
