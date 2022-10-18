Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC51C4332F
	for <linux-raid@archiver.kernel.org>; Tue, 18 Oct 2022 19:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiJRTeo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 Oct 2022 15:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiJRTej (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 Oct 2022 15:34:39 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47ECADF08
        for <linux-raid@vger.kernel.org>; Tue, 18 Oct 2022 12:34:34 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4MsPFL6p5vzXN8;
        Tue, 18 Oct 2022 21:34:30 +0200 (CEST)
Message-ID: <aeae0cb6-142a-5a50-d174-80bb3a8eb479@thelounge.net>
Date:   Tue, 18 Oct 2022 21:34:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: calculate "Array Size" for fdisk
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <e2c8b04b-1f4b-6d65-101f-6cb83dff6be8@thelounge.net>
 <0a80cb3e-9f95-3058-b362-0d4eb03e1896@plouf.fr.eu.org>
Content-Language: en-US
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <0a80cb3e-9f95-3058-b362-0d4eb03e1896@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 10.10.22 um 17:23 schrieb Pascal Hambourg:
> On 10/10/2022 at 15:49, Reindl Harald wrote :
>> i  am at creating new RAID1 stoarges on twice sized disks to replace 
>> existing 4 drive RAID10
>>
>> looking with fdisk and calculate twice din't end well and finally "dd" 
>> the FS in the array stopped with around 2 MB too small
> 
> Which is probably the size of RAID metadata added at the beginning or 
> end of the partitions.
> 
>> is the "30716928" MiB or MB and what takes fdisk with "+30716928M"?
> 
> MiB for both
>>          Array Size : 30716928 (29.29 GiB 31.45 GB)
>>       Used Dev Size : 15358464 (14.65 GiB 15.73 GB)

nonsense - the "30716928" or "Array Size" is something like K and fro 
the sake of god no matter if you take that or 29.29 G or 31.45 G you end 
up with something useful for a partition-size in fdisk so that "Array 
Size" on that new RAID1 partition is >= as on the old RAID10

no matter qhat question i asked since 2014 on that list (--writemostly, 
chagne UUID, claculate partition size) any useful response came

whatever you do ends in WAY larger or smaller "Array Size"

finally i took 30716928 / 1000 * 1024 + (10*1024) which made it sligltly 
lager buth not that too much so that the data-parition/raid after that 
has not enough space

it's ridiculous that you have to shit around 2.5 hours to get a 
partition on a new 4 TB disk nearby (gave up with exactly) the same size 
as a 4x2 TB RAID10

i can't believe that i am the only person on palent reath which ever 
wanted to switch rom 4 drive RAID10 to 2 drive RAID1 and simply dd the 
old filesystem from a live-sio from one md-device to the other


