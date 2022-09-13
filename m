Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8893C6FA89
	for <linux-raid@archiver.kernel.org>; Tue, 13 Sep 2022 11:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbiIMLMe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Sep 2022 07:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiIMLMb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Sep 2022 07:12:31 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600FD4F1B6
        for <linux-raid@vger.kernel.org>; Tue, 13 Sep 2022 04:12:30 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4MRgmC0tS6zXLW;
        Tue, 13 Sep 2022 13:12:27 +0200 (CEST)
Message-ID: <1fb05e0f-34b7-3ec4-bc00-ec540e592f19@thelounge.net>
Date:   Tue, 13 Sep 2022 13:12:26 +0200
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
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <0023fefe-aad1-e692-48dd-e354497f6e41@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 13.09.22 um 12:39 schrieb Pascal Hambourg:
> On 13/09/2022 at 12:28, Reindl Harald wrote:
>>
>> BTW: currently the machines are BIOS-boot - am i right that the 2 TB 
>> limitation only requires that the parts which are needed for booting 
>> are on the first 2 TB and i can use 4 TB SSD's on the two bigger 
>> machines?
> 
> Which 2 TB limitation ? EDD BIOS calls use 64-bit LBA and should not 
> have any practical limitation unless the BIOS implementation is flawed.
> 
>> in that case i think i would need GPT partitioning and does GRUB2 
>> support booting from GPT-partitioned disks in BIOS-mode?
> 
> Yes, but it requires a "BIOS boot" partition for the core image (usually 
> less than 100 kB, so 1 MB is plenty enough). Also some flawed BIOS 
> require that a legacy partition entry in the protective MBR has the 
> "boot" flag set

https://www.cyberciti.biz/tips/fdisk-unable-to-create-partition-greater-2tb.html

"For example, you cannot create 3TB or 4TB partition size (RAID based) 
using the fdisk command. It will not allow you to create a partition 
that is greater than 2TB" makes me nervous

how to get a > 3 TB partition for /dev/md2

--------------------

and finally how would the command look for "Then with just two drives 
you change the raid to raid-1"?

the first two drives are ordered to start with 1 out of 4 machines ASAP 
given that the machine in front of me is running since 2011/06 365/24......
