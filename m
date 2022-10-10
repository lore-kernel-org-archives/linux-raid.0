Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC661C433FE
	for <linux-raid@archiver.kernel.org>; Mon, 10 Oct 2022 15:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiJJPjH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 Oct 2022 11:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJJPjF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 10 Oct 2022 11:39:05 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A7B72FD4
        for <linux-raid@vger.kernel.org>; Mon, 10 Oct 2022 08:39:04 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4MmNPK6VGKzXMx;
        Mon, 10 Oct 2022 17:39:01 +0200 (CEST)
Message-ID: <df073c32-d755-b42e-53c4-af8ec8a0b4f3@thelounge.net>
Date:   Mon, 10 Oct 2022 17:39:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: calculate "Array Size" for fdisk
Content-Language: en-US
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <e2c8b04b-1f4b-6d65-101f-6cb83dff6be8@thelounge.net>
 <0a80cb3e-9f95-3058-b362-0d4eb03e1896@plouf.fr.eu.org>
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

which should have been on the old RAID10 too :-)

anways, two pairs of identical machines and after one is done partition 
table can be cloned

>> is the "30716928" MiB or MB and what takes fdisk with "+30716928M"?
> 
> MiB for both.
> 
>>          Array Size : 30716928 (29.29 GiB 31.45 GB)
>>       Used Dev Size : 15358464 (14.65 GiB 15.73 GB)

so i should be good with +30716930M

2 MB extra size - i have 3 MB unpartitioned space on the end of the 2TB 
disks and will make boot 400MB instead 500MB to get some headroom :-)

>> did i say that i hate it that M isn't strictly 1024 when it comes to IT?
> 
> "M" is never 1024

in software outputs it often still is

> "M" (mega) was defined and should always be used as 1000000. If you mean 
> 1048576, use "Mi" (mebi)

well, on the other hand one could expect to store 1TB data on a 1TB 
drive.... with 100 GB drives the doifferences wasn't that large but 
these days....

one of my storage servers has a 6.8T ext4 FS on a 4x4TB RAID10 and 8 
versus 6.8..... :-)

