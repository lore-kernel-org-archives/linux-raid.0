Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD79DECAAD2
	for <linux-raid@archiver.kernel.org>; Mon, 29 Aug 2022 22:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiH2Wiw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 Aug 2022 18:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiH2Wiu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 Aug 2022 18:38:50 -0400
X-Greylist: delayed 570 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 29 Aug 2022 15:38:48 PDT
Received: from pasta.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E6B9DB65
        for <linux-raid@vger.kernel.org>; Mon, 29 Aug 2022 15:38:48 -0700 (PDT)
Received: from pasta.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4MGlV3706Qz9QNs
        for <linux-raid@vger.kernel.org>; Tue, 30 Aug 2022 08:29:15 +1000 (AEST)
Received: from [192.168.122.14] (unknown [121.45.36.149])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4MGlV36WdTz9QNd
        for <linux-raid@vger.kernel.org>; Tue, 30 Aug 2022 08:29:15 +1000 (AEST)
Message-ID: <1d978f6c-e1cc-e928-efc5-11ff167938b1@eyal.emu.id.au>
Date:   Tue, 30 Aug 2022 08:29:15 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: RAID 6, 6 device array - all devices lost superblock
Content-Language: en-US
To:     linux-raid@vger.kernel.org
References: <CAKAPSkJLd836Zp3xU=zSOHg3qcEmi29Y2qOwWzeAFaDp+dNTvg@mail.gmail.com>
 <70e2ae22-bbba-77a4-c9bc-4c02752f4cb7@youngman.org.uk>
 <dc24b476-2f0a-8406-f1c0-e33b5b0eb388@youngman.org.uk>
 <4a414fc6-2666-302f-8d3d-08eb7a2986fc@turmel.org>
 <CAKAPSkJAQYsec-4zzcePbkJ7Ee0=sd_QvHj4Stnyineq+T8BXw@mail.gmail.com>
 <25355.47062.897268.3355@quad.stoffel.home>
 <ee66bcbe-0a9b-57a6-439f-72cc46debe48@turmel.org>
 <25355.50871.743993.605394@quad.stoffel.home>
 <CAKAPSkLQ4K1R_aD1=iURTFQmm_DXDMr=wx+VDET7DOUy+6Zp_Q@mail.gmail.com>
 <25357.13191.843087.630097@quad.stoffel.home>
From:   Eyal Lebedinsky <fedora@eyal.emu.id.au>
In-Reply-To: <25357.13191.843087.630097@quad.stoffel.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 30/08/2022 07.45, John Stoffel wrote:
>>>>>> "Peter" == Peter Sanders <plsander@gmail.com> writes:
> 
> Peter> Phil,
> Peter> fstab from the working config -
> 
> Peter> # <file system> <mount point>   <type>  <options>       <dump>  <pass>
> Peter> # / was on /dev/sda1 during installation
> Peter> UUID=50976432-b750-4809-80ac-3bbdd2773163 /               ext4
> Peter> errors=remount-ro 0       1
> Peter> # /home was on /dev/sda6 during installation
> Peter> UUID=eb93a2c4-0190-41fa-a41d-7a5966c6bc47 /home           ext4
> Peter> defaults        0       2
> Peter> # /var was on /dev/sda5 during installation
> Peter> UUID=d1aa6d1f-3ee9-48a8-9350-b15149f738c4 /var            ext4
> Peter> defaults        0       2
> Peter> /dev/sr0        /media/cdrom0   udf,iso9660 user,noauto     0       0
> Peter> /dev/sr1        /media/cdrom1   udf,iso9660 user,noauto     0       0
> Peter> # raid array
> Peter> /dev/md0    /mnt/raid6    ext4    defaults    0    2
> 
> Peter> No LVM, one large EXT4 partition
> 
> Peter> I have several large files ( NEF and various mpg files) I can identify
> Peter> and have backup copies available.
> 
> Peter> I have the overlays created. 300G for each of the six drives.
> 
> So that's good.  Now you have to try and figure out which order they
> were created in.  As the docs show, you setup the overlayfs on top of
> each of the six drives.
> 
> Keep track by noting the drive serial numbers, since Linux can move
> them around and change drive letters on reboots.
> 
> 
> Then using the overlays, do an:
> 
>       mdadm --create /dev/md0 --level=raid6 -n 6 /dev/sd[bcdefg]
>       fsck -n /dev/md0
> 
> and see what you get.  If it doesn't look like a real filesystem, then
> you can break it down, and then modify the order you give the drive
> letters, like:
> 
> 	 /dev/sd[cdefge]
> 
> and rinse and repeat as it goes.  Not fun... but should hopefully fix
> things for you.
> 
> John

An aside, I would think the way to specify a list in a nominated order is something like

$ echo /dev/sd{c,d,a,b}
/dev/sdc /dev/sdd /dev/sda /dev/sdb

rather than

$ echo /dev/sd[cdab]
/dev/sda /dev/sdb /dev/sdc /dev/sdd

which will be in sorting order, regardless of the order of the letter.

-- 
Eyal Lebedinsky (fedora@eyal.emu.id.au)
