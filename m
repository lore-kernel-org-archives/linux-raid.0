Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24387ECAAD2
	for <linux-raid@archiver.kernel.org>; Sun, 28 Aug 2022 09:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiH1JPE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 28 Aug 2022 05:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiH1JPD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 28 Aug 2022 05:15:03 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13C924944
        for <linux-raid@vger.kernel.org>; Sun, 28 Aug 2022 02:14:59 -0700 (PDT)
Received: from host86-128-157-135.range86-128.btcentralplus.com ([86.128.157.135] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1oSENd-0001Gj-Bt;
        Sun, 28 Aug 2022 10:14:58 +0100
Message-ID: <70e2ae22-bbba-77a4-c9bc-4c02752f4cb7@youngman.org.uk>
Date:   Sun, 28 Aug 2022 10:14:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: RAID 6, 6 device array - all devices lost superblock
Content-Language: en-GB
To:     Peter Sanders <plsander@gmail.com>, linux-raid@vger.kernel.org
References: <CAKAPSkJLd836Zp3xU=zSOHg3qcEmi29Y2qOwWzeAFaDp+dNTvg@mail.gmail.com>
Cc:     Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <CAKAPSkJLd836Zp3xU=zSOHg3qcEmi29Y2qOwWzeAFaDp+dNTvg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 28/08/2022 03:00, Peter Sanders wrote:
> have a RAID 6 array, 6 devices.  Been running it for years without much issue.
> 
> Had hardware issues with my system - ended up replacing the
> motherboard, video card, and power supply and re-installing the OS
> (Debian 11).
> 
> As the hardware issues evolved, I'd crash, reboot, un-mount the array,
> run fsck, mount and continue on my way - no problems.
> 
> After the hardware was replaced, my array will not assemble - mdadm
> assemble reports no RAID superblock on the devices.
> root@superior:/etc/mdadm# mdadm --assemble --scan --verbose
> mdadm: looking for devices for /dev/md/0
> mdadm: cannot open device /dev/sr0: No medium found
> mdadm: No super block found on /dev/sda (Expected magic a92b4efc, got 00000000)
> mdadm: no RAID superblock on /dev/sda
> mdadm: No super block found on /dev/sdb (Expected magic a92b4efc, got 00000000)
> mdadm: no RAID superblock on /dev/sdb
> 
> Examine reports
> /dev/sda:
>     MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> 
> Searching for these results indicate I can rebuild the superblock, but
> details on how to do that are lacking, at least on the pages I found.

Ouch. That's not nice, but we should be able to get things back, I hope.

I notice it's looking for your superblock on the drive itself. Were your 
drives partitioned? Because unfortunately, it's well known for drives 
moving between hardware to have their MBR/GPT wiped :-( Hopefully that's 
the case, and examining the drives with gdisk/fdisk will come up with 
"your GPT is damaged. Recover?". If so, you're probably good. If not, do 
you have a record of your partitions? Can you just recreate them? If you 
don't know what you're doing here, I'd wait for a bit more advice unless 
you can back the drives up first.

Whatever happens, do you have a backup? Can you make one?

If your drives were NOT partitioned, then I'm afraid we're into 
forensics here. Read up on overlays, so you can make the drives 
read-only, re-create the superblock, and check if you got it right. I've 
not done this myself, so I would hesitate to advise you, but loads of 
people have said the instructions do work, and they've recovered their 
arrays.
> 
> Currently I have no /dev/md* devices.
> I have access to the old mdadm.conf file - have tried assembling with
> it, with the default mdadm.conf, and with no mdadm.conf file in /etc
> and /etc/mdadm.

It looks like the drives weren't partitioned :-( I think you're into 
forensics.
> 
> Suggestions for how to get the array back would be most appreciated.

Not what you're asking for, but another suggestion - DITCH THOSE DRIVES. 
WD Greens are just plain unsuitable for raid, and if your P300s are new, 
they are too :-( (Greens will be damaged as their optimisation is 
completely wrong for raid, the new P300s are SMR) I notice that ERC is 
disabled ...

I'd get 4x6TB N300s or Seagate Ironwolves (if cost is an issue, you can 
get away with two). If you do get four, swap out two greens, and rebuild 
onto the 6TBs. If you can only afford two, swap out two P300s, raid-0 
them and rebuild as raid-5 onto the 6TB/P300 drives, then you CAN go 
raid-6 raid-0ing a green and your last P300 together. Just get rid of 
the greens asap, and the P300s after.
> 
> Thanks
> - Peter
> 
Cheers,
Wol
