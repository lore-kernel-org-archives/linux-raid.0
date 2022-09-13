Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B990C6FA82
	for <linux-raid@archiver.kernel.org>; Tue, 13 Sep 2022 11:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbiIMLjg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Sep 2022 07:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbiIMLjf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Sep 2022 07:39:35 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950DEBE2
        for <linux-raid@vger.kernel.org>; Tue, 13 Sep 2022 04:39:32 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4MRhMQ12fyzXLW;
        Tue, 13 Sep 2022 13:39:30 +0200 (CEST)
Message-ID: <65ee1134-60e4-4577-74c7-0ba15ae39225@thelounge.net>
Date:   Tue, 13 Sep 2022 13:39:29 +0200
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
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <6b4a5399-5053-4a51-26d7-2f62c47c2981@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 13.09.22 um 13:35 schrieb Pascal Hambourg:
> On 13/09/2022 at 13:30, Reindl Harald wrote:
>> Am 13.09.22 um 13:17 schrieb Pascal Hambourg:
>>> On 13/09/2022 at 13:12, Reindl Harald wrote:
>>>> Am 13.09.22 um 12:39 schrieb Pascal Hambourg:
>>>>> On 13/09/2022 at 12:28, Reindl Harald wrote:
>>>>>>
>>>>>> BTW: currently the machines are BIOS-boot - am i right that the 2 
>>>>>> TB limitation only requires that the parts which are needed for 
>>>>>> booting are on the first 2 TB and i can use 4 TB SSD's on the two 
>>>>>> bigger machines?
>>>>>
>>>>> Which 2 TB limitation ? EDD BIOS calls use 64-bit LBA and should 
>>>>> not have any practical limitation unless the BIOS implementation is 
>>>>> flawed.
>>> (...)
>>>> "For example, you cannot create 3TB or 4TB partition size (RAID 
>>>> based) using the fdisk command. It will not allow you to create a 
>>>> partition that is greater than 2TB" makes me nervous
>>>
>>> This is a DOS/MBR partition scheme limitation, not a BIOS limitation, 
>>> and irrelevant with GPT partition scheme.
>>>
>>>> how to get a > 3 TB partition for /dev/md2
>>>
>>> Use GPT
>>
>> yeah but the goal is to convert a existing RAID1/RAID10/RAID10 setup 
>> with 4x2 TB drives to RAID1/RAID1/RAID1 with 2x4 Tb drives and so my 
>> /boot won't work with GPT :-)
> 
> Why wouldn't your /boot work with GPT ? It works for me

because you said so?

[root@srv-rhsoft:~]$ fdisk -l /dev/sda
Disk /dev/sda: 1.82 TiB, 2000398934016 bytes, 3907029168 sectors
Disk model: Samsung SSD 860
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x000d9ef2

Device     Boot    Start        End    Sectors  Size Id Type
/dev/sda1  *        2048    1026047    1024000  500M fd Linux raid 
autodetect
/dev/sda2        1026048   31746047   30720000 14.6G fd Linux raid 
autodetect
/dev/sda3       31746048 3906971647 3875225600  1.8T fd Linux raid 
autodetect

-------- Weitergeleitete Nachricht --------
Betreff: Re: change UUID of RAID devcies
Datum: Tue, 13 Sep 2022 12:39:50 +0200
Von: Pascal Hambourg <pascal@plouf.fr.eu.org>
An: Reindl Harald <h.reindl@thelounge.net>, Linux RAID Mailing List 
<linux-raid@vger.kernel.org>

Yes, but it requires a "BIOS boot" partition for the core image (usually 
less than 100 kB, so 1 MB is plenty enough). Also some flawed BIOS 
require that a legacy partition entry in the protective MBR has the 
"boot" flag set.

