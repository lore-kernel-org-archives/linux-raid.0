Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86ABBC433EF
	for <linux-raid@archiver.kernel.org>; Thu,  2 Dec 2021 23:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349627AbhLBXns (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Dec 2021 18:43:48 -0500
Received: from pasta.tip.net.au ([203.10.76.2]:52001 "EHLO pasta.tip.net.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232981AbhLBXns (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 2 Dec 2021 18:43:48 -0500
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Dec 2021 18:43:48 EST
Received: from pasta.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4J4sjC6Bk3z9QDp
        for <linux-raid@vger.kernel.org>; Fri,  3 Dec 2021 10:33:51 +1100 (AEDT)
Received: from [192.168.122.14] (unknown [121.45.56.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by pasta.tip.net.au (Postfix) with ESMTPSA id 4J4sjC5kbKz9QBs
        for <linux-raid@vger.kernel.org>; Fri,  3 Dec 2021 10:33:51 +1100 (AEDT)
Message-ID: <0b763738-8c4a-f960-7e3e-6c94a04ac519@eyal.emu.id.au>
Date:   Fri, 3 Dec 2021 10:33:50 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: Help ironing out persistent mismatches on raid6
Content-Language: en-US
To:     linux-raid@vger.kernel.org
References: <7be1c467-c2c2-5f90-dc1c-f1c443954f03@mattyo.net>
From:   Eyal Lebedinsky <eyal@eyal.emu.id.au>
In-Reply-To: <7be1c467-c2c2-5f90-dc1c-f1c443954f03@mattyo.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 03/12/2021 09.04, Matt Garretson wrote:
> Hi, I have this RAID6 array of 6x 8TB drives:
> 
> /dev/md1:
>             Version : 1.2
>       Creation Time : Fri Jul  6 23:20:38 2018
>          Raid Level : raid6
>          Array Size : 31255166976 (29.11 TiB 32.01 TB)
>       Used Dev Size : 7813791744 (7.28 TiB 8.00 TB)
>        Raid Devices : 6
> 
> There is an ext4 fs on the device (no lvm).
> 
> The array for over a year has had 40 contiguous mismatches in the same spot:
> 
> md1: mismatch sector in range 2742891144-2742891152
> md1: mismatch sector in range 2742891152-2742891160
> md1: mismatch sector in range 2742891160-2742891168
> md1: mismatch sector in range 2742891168-2742891176
> md1: mismatch sector in range 2742891176-2742891184
> 
> Sector size is 512, so I guess this works out to be five 4KiB blocks, or
> 20KiB of space.
> 
> The array is checked weekly, but never been "repaired".  The ext4
> filesystem has been fsck'd a lot over the years, with no problems.  But
> I worry about what file might potentially have bad data in it.  There
> are a lot of files.
> 
> I have done:
> 
> dd status=none if=/dev/md1 ibs=512 skip=2742891144 count=40  |hexdump -C
> 
> ... and I don't see anything meaningful to me.
> 
> I have done  dumpe2fs -h /dev/md1 and it tells me block size is 4096 and
> the first block is 0.  So does....
> 
> 2742891144 * 512 / 4096 = 342861393
> 
> ...mean we are dealing with blocks # 342861393 - 342861398 of the
> filesystem?  If so, is there a way for me to see what file(s) use those
> blocks?
> 
> Thanks in advance for any tips...
> -Matt

I use debugfs to do this. Knowing each fs block range (lo hi) calculated from the raid mismatch notice:

I first identify the relevant blocks in each reported range with
	debugfs -R "testb $lo $((hi-lo))" $device
then locate the associated inodes with
	debugfs -R "icheck $list" $device
and finally discover files in these locations with
	debugfs -R "ncheck $inode" $device

Some of the above debugfs requests can take a very long time to perform. I actually have a script that
does everything and can be left to run for a day (or longer) but it is very locally specific for my setup.

HTH

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
