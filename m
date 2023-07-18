Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BD7EB64DC
	for <linux-raid@archiver.kernel.org>; Tue, 18 Jul 2023 17:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbjGRRCb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 Jul 2023 13:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbjGRRCQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 Jul 2023 13:02:16 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080A62D52
        for <linux-raid@vger.kernel.org>; Tue, 18 Jul 2023 10:01:17 -0700 (PDT)
Received: from host86-180-115-107.range86-180.btcentralplus.com ([86.180.115.107] helo=[192.168.1.99])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1qLo3J-0008kU-6t;
        Tue, 18 Jul 2023 17:59:57 +0100
Message-ID: <92c5962f-86d1-3cf7-e157-96c953b6b164@youngman.org.uk>
Date:   Tue, 18 Jul 2023 17:59:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: Corrupted RAID 1
To:     Yu Kuai <yukuai1@huaweicloud.com>,
        Leslie Rhorer <lesrhorer@att.net>,
        Linux RAID <linux-raid@vger.kernel.org>
Cc:     "yukuai (C)" <yukuai3@huawei.com>
References: <d44dd435-46e8-f40c-e8cf-24e6c6e93687.ref@att.net>
 <d44dd435-46e8-f40c-e8cf-24e6c6e93687@att.net>
 <b4bd295a-25a2-c66d-0bdc-29cdf402bbbb@huaweicloud.com>
Content-Language: en-GB
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <b4bd295a-25a2-c66d-0bdc-29cdf402bbbb@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 18/07/2023 10:25, Yu Kuai wrote:
> Hi,
> 
> 在 2023/07/14 4:58, Leslie Rhorer 写道:
>>      I have a corrupted bootable RAID 1 array on a pair of SDD drives, 
>> and I fear I need some assistance.  Actually, there are four 
>> partitions on each drive, and two RAID 1 arrays were assembled from 
>> each drive. When working properly, the second pair of partitions were 
>> mounted as / and the first pair were mounted as /boot.  The OS is 
>> Debian Buster. When I attempt to boot the system, it goes directly to 
>> the GRUB prompt.
>>
>>      I pulled the drives and attached them to an active system.  Mdadm 
>> reports both partition tables to be intact with partition labels of 
>> fd, 83, ef, and 82, respectively and MBR magic of aa55.  When I try to 
>> assemble any array says the partitions exist but are not md arrays.
>>
>>      Fdisk reports the partition types as Linux raid autodetect, 
>> Linux, EFI, and Linux swap / Solaris.  The EFI partitions are marked 
>> bootable and contain the following:
>>
>> total 3472
>> -rwxr-xr-x 1 root root     108 May 28  2022 BOOTX64.CSV
>> -rwxr-xr-x 1 root root   84648 May 28  2022 fbx64.efi
>> -rwxr-xr-x 1 root root     152 May 28  2022 grub.cfg
>> -rwxr-xr-x 1 root root 1672576 May 28  2022 grubx64.efi
>> -rwxr-xr-x 1 root root  845480 May 28  2022 mmx64.efi
>> -rwxr-xr-x 1 root root  934240 May 28  2022 shimx64.efi
>>
>>      Any suggestions?  I should say that the running system
>> (Bullseye) is not the same version as the failed one (Buster).  Of 
>> course the failed system does need to be upgraded, but there are 
>> specific reasons why this is quite undesirable at this point.
>> .
> 
> There really is not enough information, what is the kernel version?
> And in the active system, what mdadm cmds you're using and what's the
> result? (And please show us the result of mdadm -E /dev/[partition]).
> 
@kuai

Point them at the wiki ...

https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn

Cheers,
Wol

