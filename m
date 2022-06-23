Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95EF6C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 23 Jun 2022 19:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbiFWT35 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Jun 2022 15:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiFWT3c (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Jun 2022 15:29:32 -0400
X-Greylist: delayed 356 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Jun 2022 12:00:26 PDT
Received: from smtp-delay1.nerim.net (mailhost-z3-p4.nerim-networks.com [195.5.209.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3AC3F9214C
        for <linux-raid@vger.kernel.org>; Thu, 23 Jun 2022 12:00:26 -0700 (PDT)
Received: from mallaury.nerim.net (smtp-104-thursday.noc.nerim.net [178.132.17.104])
        by smtp-delay1.nerim.net (Postfix) with ESMTP id DF9E72319D0
        for <linux-raid@vger.kernel.org>; Thu, 23 Jun 2022 20:54:26 +0200 (CEST)
Received: from [192.168.0.250] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id 7C53ADB17C;
        Thu, 23 Jun 2022 20:54:26 +0200 (CEST)
Message-ID: <b777865e-b265-1e83-dae0-f89654e86332@plouf.fr.eu.org>
Date:   Thu, 23 Jun 2022 20:54:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: a new install - - - putting the system on raid
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>,
        o1bigtenor <o1bigtenor@gmail.com>,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
 <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Le 23/06/2022 à 14:56, Wols Lists wrote :
> On 23/06/2022 13:11, o1bigtenor wrote:
>>
>> I am wanting to have all of /efi/boot, /, swap, /tmp, /var, /usr and
>> /usr/local on one raid-1 array and a second array for /home - - -
>> on a new install.
> 
> /efi/boot (a) must be fat32, and (b) must be a "top level" partition. 

Right, the UEFI firmware would not be able to read an EFI partition 
inside a partitioned software RAID array, and even on most unpartitioned 
RAID arrays. The most you can do is create a RAID1 array with superblock 
1.0 and use it all as an EFI partition but registering EFI boot entries 
for each EFI RAID member will be tricky.

> swap - why mirror it?

For redundancy, of course.

> If you set the fstab priorities to the same value, 
> you get a striped raid-0 for free.

Without any redundancy. What is the point of setting up RAID1 for all 
the rest and see your system crash pitifully when a drive fails because 
half of the swap suddenly becomes unreachable ?

>> I have tried the following:
>>
>> 1. make large partition on each drive
>> 2. set up raid array (2 separate arrays)
>> 3. unable to place partitions on arrays
> 
> Should be able to

Yes, RAID arrays should be partitionable by default. But your installer 
may not support it. LVM over RAID may be more widely supported.

>> 1. set up the same partitions on each set of drives
>>      (did allocate unused space between each partition)
>> 2. was only allowed one partition from each drive for the array

That sounds sensible. A RAID array with several partitions on the same 
drive does not make much sense. You must create a RAID array for each 
partition set.
