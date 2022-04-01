Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE4A8C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  1 Apr 2022 22:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241797AbiDAWgO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Apr 2022 18:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236916AbiDAWgN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Apr 2022 18:36:13 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2145720D816
        for <linux-raid@vger.kernel.org>; Fri,  1 Apr 2022 15:34:22 -0700 (PDT)
Received: from host86-155-180-61.range86-155.btcentralplus.com ([86.155.180.61] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1naNCm-0007MF-Dd;
        Fri, 01 Apr 2022 20:45:08 +0100
Message-ID: <776f85f6-33a2-f226-f6ff-09e736ccefd1@youngman.org.uk>
Date:   Fri, 1 Apr 2022 20:45:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Trying to rescue a RAID-1 array
Content-Language: en-GB
To:     bruce.korb+reply@gmail.com
Cc:     linux-raid@vger.kernel.org
References: <CAKRnqN+_=U58dT5bvgWJ1DgyEuhjsbmCuDL+xOLxmcuG1ML4qg@mail.gmail.com>
 <e3573002-05f3-3110-62a6-e704385f877f@youngman.org.uk>
 <CAKRnqNLjsX9nVLrLedo4tfxtg0ZBz=6XJu=-z_Ebw6Auh+oz-Q@mail.gmail.com>
 <8c2148d0-fa97-d0ef-10cc-11f79d7da5e5@youngman.org.uk>
 <CAKRnqN+21BZT1eufn962xiEDvnrBtk68dTBSLT1mx7+Ac2kJ+w@mail.gmail.com>
 <CAKRnqN+6wAFPf5AGNEf948NunA97MJ9Gy5eFzLCfX+WfHY72Pg@mail.gmail.com>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <CAKRnqN+6wAFPf5AGNEf948NunA97MJ9Gy5eFzLCfX+WfHY72Pg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hmmm... what drives are the damaged array on? There's an intact raid1 
there ...

On 01/04/2022 19:21, Bruce Korb wrote:
> Um, I forgot that with a fresh install, I have to remember what all
> tools I had installed and re-install 'em.
> 
> bach:/home/bkorb # /home/bkorb/bin/lsdrv/lsdrv-master/lsdrv
> 
> PCI [ahci] 00:11.4 SATA controller: Intel Corporation C610/X99 series
> chipset sSATA Controller [AHCI mode] (rev 05)
> ├scsi 0:0:0:0 ATA      TOSHIBA HDWE160  {487OK01XFB8G}
> │└sda 5.46t [8:0] Partitioned (gpt)
> │ ├sda1 128.00g [8:1] btrfs 'OPT-USR' {649826e5-7406-49fb-ad4a-a35a0077a325}
> │ │└Mounted as /dev/sda1 @ /opt
> │ ├sda3 64.00g [8:3] Empty/Unknown
> │ ├sda4 16.00g [8:4] Empty/Unknown
> │ └sda5 5.25t [8:5] MD raid1 (0/2) (w/ sdb5) in_sync 'bach:0'

So sda5 has a raid1 on it  ...

> {0e2cb19c-b567-5fcc-2982-c38e81e42a71}
> │  └md0 5.25t [9:0] MD v1.2 raid1 (2) clean

called md0

> {0e2cb19c:-b567-5f:cc-2982-:c38e81e42a71}
> │   │               ext4 'HOME' {a6551143-65ab-40ff-82b6-8cc809a1a856}
> │   └Mounted as /dev/md0 @ /home

and mounted as /home.

> ├scsi 1:0:0:0 ATA      TOSHIBA HDWE160  {487OK01SFB8G}
> │└sdb 5.46t [8:16] Partitioned (gpt)
> │ ├sdb1 192.00g [8:17] btrfs 'VAR-TMP' {c1304823-0b3b-4655-bfbb-a7f064ec59f5}
> │ │└Mounted as /dev/sdb1 @ /var
> │ ├sdb2 16.00g [8:18] Empty/Unknown
> │ └sdb5 5.25t [8:21] MD raid1 (1/2) (w/ sda5) in_sync 'bach:0'
> {0e2cb19c-b567-5fcc-2982-c38e81e42a71}
> │  └md0 5.25t [9:0] MD v1.2 raid1 (2) clean

and sdb5 is the other half.

> {0e2cb19c:-b567-5f:cc-2982-:c38e81e42a71}
> │                   ext4 'HOME' {a6551143-65ab-40ff-82b6-8cc809a1a856}
> ├scsi 2:0:0:0 ATA      HGST HMS5C4040AL {PL1331LAHEZZ5H}
> │└sdc 3.64t [8:32] Partitioned (gpt)
> │ ├sdc1 3.20t [8:33] MD raid0 (0/2) (w/ sde1) in_sync 'any:1'
> {f624aab2-afc1-8758-5c20-d34955b9b36f}
> │ │└md1 6.40t [9:1] MD v1.0 raid0 (2) clean, 64k Chunk, None (None)
> None {f624aab2:-afc1-87:58-5c20-:d34955b9b36f}
> │ │                 xfs 'User' {fe716da2-b515-4fd6-8ea6-f44f48038b78}

This looks promising ... dunno what on earth it thought it was doing, 
but it's telling me that on sdc1 we have a raid 0, version 1.0, with an 
xfs on it. Is there any chance your install formatted the new raid? 
Because if it did your data is probably toast, but if it didn't we might 
be home and dry.

> │ ├sdc2 320.00g [8:34] ext4 'PHOTOS-B' {4ab1a2c2-dbee-4f4d-b491-8652ea7a24d7}
> │ └sdc3 65.22g [8:35] ext4 'TEMP' {c18c28d3-dafd-4f1b-aa9f-b7a462139073}
> └scsi 3:0:0:0 ATA      WDC WDS250G2B0A- {181202806197}
> └sdd 232.89g [8:48] Partitioned (gpt)
>   ├sdd1 901.00m [8:49] vfat 'BOOT-EFI' {AF1B-15D7}
>   │└Mounted as /dev/sdd1 @ /boot/efi
>   ├sdd2 116.00g [8:50] Partitioned (dos) 'ROOT1'
> {63e24f52-2f8f-4ad1-a1e6-cb5537efcf6f}
>   │├Mounted as /dev/sdd2 @ /
>   │├Mounted as /dev/sdd2 @ /.snapshots
>   │├Mounted as /dev/sdd2 @ /boot/grub2/i386-pc
>   │├Mounted as /dev/sdd2 @ /boot/grub2/x86_64-efi
>   │├Mounted as /dev/sdd2 @ /srv
>   │├Mounted as /dev/sdd2 @ /usr/local
>   │├Mounted as /dev/sdd2 @ /tmp
>   │└Mounted as /dev/sdd2 @ /root
>   └sdd3 116.01g [8:51] xfs 'ROOT2' {69178c35-15ea-4f04-8f29-bf4f1f6f890a}
>    └Mounted as /dev/sdd3 @ /root2
> PCI [ahci] 00:1f.2 SATA controller: Intel Corporation C610/X99 series
> chipset 6-Port SATA Controller [AHCI mode] (rev 05)
> ├scsi 4:0:0:0 ATA      HGST HMS5C4040AL {PL1331LAHGEP7H}
> │└sde 3.64t [8:64] Partitioned (gpt)
> │ ├sde1 3.20t [8:65] MD raid0 (1/2) (w/ sdc1) in_sync 'any:1'
> {f624aab2-afc1-8758-5c20-d34955b9b36f}
> │ │└md1 6.40t [9:1] MD v1.0 raid0 (2) clean, 64k Chunk, None (None)
> None {f624aab2:-afc1-87:58-5c20-:d34955b9b36f}
> │ │                 xfs 'User' {fe716da2-b515-4fd6-8ea6-f44f48038b78}

And the other half of the raid.

> │ ├sde2 64.00g [8:66] swap {dbd52b6f-fc65-42e9-948b-33d9c3834c3c}
> │ └sde3 385.22g [8:67] ext4 'PHOTO-A' {c84250ab-6563-4832-a919-632a34486bf1}
> └scsi 5:0:0:0 HL-DT-ST BD-RE  WH14NS40  {SIK9TH8SE163}
> └sr0 1.00g [11:0] Empty/Unknown
> USB [usb-storage] Bus 002 Device 007: ID 05e3:0745 Genesys Logic, Inc.
> Logilink CR0012 {000000000903}
> └scsi 10:0:0:0 Generic  STORAGE DEVICE   {000000000503}
> └sdf 0.00k [8:80] Empty/Unknown
> USB [usb-storage] Bus 002 Device 008: ID 058f:6387 Alcor Micro Corp.
> Flash Drive {A3A1458D}
> └scsi 11:0:0:0 Generic  Flash Disk       {A}
> └sdg 28.91g [8:96] Partitioned (dos)
>   └sdg1 28.91g [8:97] vfat '32GB' {1D6B-D5DB}
>    └Mounted as /dev/sdg1 @ /run/media/bkorb/32GB
> 
> Hmm. Interesting. Dunno what that /dev/sdf thingy is. I only have one
> thumb drive plugged in and mounted as /dev/sdg1.
> 
Can you mount the raid? This just looks funny to me though, so make sure 
it's read only.

Seeing as it made it v1.0, that means the raid superblock is at the end 
of the device and will not have done much if any damage ...

It's probably a good idea to create a loopback device and mount it via 
that because it will protect the filesystem.

Does any of this feel like it's right?

Cheers,
Wol
