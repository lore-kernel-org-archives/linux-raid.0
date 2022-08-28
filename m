Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57227ECAAA2
	for <linux-raid@archiver.kernel.org>; Sun, 28 Aug 2022 17:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiH1RN1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 28 Aug 2022 13:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiH1RN0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 28 Aug 2022 13:13:26 -0400
X-Greylist: delayed 1573 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 28 Aug 2022 10:13:24 PDT
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880B429822
        for <linux-raid@vger.kernel.org>; Sun, 28 Aug 2022 10:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc
        :To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yEPEimsABiXdt+xOM7n7xdWJouKgrhWQVp1LFPygdQU=; b=VwpsqlujM4dk4zKPD6Ym0O0/iB
        +zTqY+jIFqg8Ct/2Ya57gz2DWiMOgxQWEvoaML78pZxeSi5Esw9MQ6OzLUZkBM932jmpEswdSCAsr
        Zn6AkXQgK+kZvU+0p4EcXj/e1ae7nnGMmnx1cmEXwx7iwrSyNp5nNJpkKi4ZvLhpPcQF0WzOAiXIu
        Lplx1ga7Secmrw5bVUBiSMUsBXd40nffkJLfjDqS+Gd1a3iB9Ylwzcm2teM/EhLCgXDjR2fK45RMQ
        4Zh4T+hAO8hTilm85hJTr+Zk32iVbRkzhiARMKxKOEFknOE+wP9K4q77v+wE9BSDetLLd8ymwPIRs
        v/fQEsjw==;
Received: from 108-70-166-50.lightspeed.tukrga.sbcglobal.net ([108.70.166.50] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1oSLRA-0000Si-8h; Sun, 28 Aug 2022 16:47:04 +0000
Message-ID: <4a414fc6-2666-302f-8d3d-08eb7a2986fc@turmel.org>
Date:   Sun, 28 Aug 2022 12:47:03 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: RAID 6, 6 device array - all devices lost superblock
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>,
        Peter Sanders <plsander@gmail.com>,
        John Stoffel <john@stoffel.org>
Cc:     NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
References: <CAKAPSkJLd836Zp3xU=zSOHg3qcEmi29Y2qOwWzeAFaDp+dNTvg@mail.gmail.com>
 <70e2ae22-bbba-77a4-c9bc-4c02752f4cb7@youngman.org.uk>
 <dc24b476-2f0a-8406-f1c0-e33b5b0eb388@youngman.org.uk>
From:   Phil Turmel <philip@turmel.org>
In-Reply-To: <dc24b476-2f0a-8406-f1c0-e33b5b0eb388@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Peter, et al,

On 8/28/22 05:54, Wols Lists wrote:
> On 28/08/2022 10:14, Wols Lists wrote:
>>> Currently I have no /dev/md* devices.
>>> I have access to the old mdadm.conf file - have tried assembling with
>>> it, with the default mdadm.conf, and with no mdadm.conf file in /etc
>>> and /etc/mdadm.
>>
>> It looks like the drives weren't partitioned :-( I think you're into 
>> forensics.

It is too soon to say this.  The supplied mdadm.conf file does not
contain specific partition information.  It is possible the partition
tables have just been wiped.


> Whoops - my system froze while I was originally writing my reply, and I 
> forgot to put this into my rewrite ...
> 
> Look up overlays in the wiki. I've never done it myself, but a fair few 
> people have said the instructions worked a treat.
> 
> You're basically making the drives read-only (all writes get dumped into 
> the overlay file), and then re-creating the array over the top, so you 
> can test whether you got it right. If you don't, you just ditch the 
> overlays and start again, if you did get it right you can recreate the 
> array for real.
> 
> Cheers,
> Wol

On 8/28/22 11:10, John Stoffel wrote:
>>>>>> "Peter" == Peter Sanders <plsander@gmail.com> writes:
> 
> Peter> have a RAID 6 array, 6 devices.  Been running it for years without much issue.
> Peter> Had hardware issues with my system - ended up replacing the
> Peter> motherboard, video card, and power supply and re-installing the OS
> Peter> (Debian 11).
> 
> Can you give us details on the old vs new motherboard/cpu?  It might
> be that you need to tweak the BIOS of the motherboard to expose the
> old SATA formats as well.  
> 
> Did you install debian onto a fresh boot disk?  Is your BIOS setup to
> only do the new form of booting from UEFI devices, so maybe check your
> BIOS settings that the data drives are all in AHCI mode, or possibly
> even in IDE mode.  It all depends on how old the original hardware
> was.  
> 
> I just recenly upgraded from a 2010 MB/CPU combo and I had to tweak
> the BIOS defaults to see my disks.  I guess I should do a clean
> install from a blank disk, but I wanted to minimize downtime.  

It is important to end up in AHCI mode on all MOBO ports.  If not set 
that way now, please change them.

> Wols has some great advice here, and I heartily recommend that you use
> overlayfs when doing your testing.  Check the RAID WIKI for
> suggestions.

Concur.

> And don't panic!  Your data is probably there, but just missing the
> super blocks or partition tables. 

Both, I suspect.

On 8/27/22 22:00, Peter Sanders wrote:
> lsdrv ------------------------
> PCI [nvme] 01:00.0 Non-Volatile memory controller: Phison Electronics
> Corporation E12 NVMe Controller (rev 01)
> └nvme nvme0 PCIe SSD                                 {21112925606047}
>  └nvme0n1 238.47g [259:0] Partitioned (dos)
>   ├nvme0n1p1 485.00m [259:1] ext4 {f38776ac-1ce9-4fc8-ba50-94844b9f504e}
>   │└Mounted as /dev/nvme0n1p1 @ /boot
>   ├nvme0n1p2 1.00k [259:2] Partitioned (dos)
>   ├nvme0n1p5 60.54g [259:3] ext4 {5ee1c3c0-3a05-466c-9f98-f5807c8d813b}
>   │└Mounted as /dev/nvme0n1p5 @ /
>   ├nvme0n1p6 93.13g [259:4] ext4 {9064169f-4fe3-4836-a906-28c1b445cdff}
>   │└Mounted as /dev/nvme0n1p6 @ /var
>   ├nvme0n1p7 37.00m [259:5] ext4 {25e161ad-94a0-4298-afaf-18e2433766ee}
>   ├nvme0n1p8 82.89g [259:6] ext4 {ac874071-d759-4d33-b32f-83272f3eacd9}
>   │└Mounted as /dev/nvme0n1p8 @ /home
>   └nvme0n1p9 1.41g [259:7] swap {02cef84b-9a9d-4a0a-973c-fda1a78c533c}
> PCI [pata_jmicron] 26:00.1 IDE interface: JMicron Technology Corp.
> JMB368 IDE controller (rev 10)
> └scsi 0:0:0:0 MAD DOG  LS-DVDRW TSH652M {MAD_DOG_LS-DVDRW_TSH652M}
>  └sr0 1.00g [11:0] Empty/Unknown
> PCI [ahci] 26:00.0 SATA controller: JMicron Technology Corp. JMB363
> SATA/IDE Controller (rev 10)
> └scsi 2:x:x:x [Empty]
> PCI [ahci] 2b:00.0 SATA controller: Advanced Micro Devices, Inc. [AMD]
> FCH SATA Controller [AHCI mode] (rev 51)
> ├scsi 6:0:0:0 ATA      TOSHIBA HDWD130  {477ALBNAS}
> │└sda 2.73t [8:0] Partitioned (PMBR)
> └scsi 7:0:0:0 ATA      TOSHIBA HDWD130  {Y7211KPAS}
>  └sdc 2.73t [8:32] Partitioned (gpt)
> PCI [ahci] 2c:00.0 SATA controller: Advanced Micro Devices, Inc. [AMD]
> FCH SATA Controller [AHCI mode] (rev 51)
> ├scsi 8:0:0:0 ATA      WDC WD30EZRX-00D {WD-WCC1T0668790}
> │└sdb 2.73t [8:16] Partitioned (gpt)
> ├scsi 9:0:0:0 ATA      WDC WD30EZRX-00D {WD-WCC4N0091255}
> │└sdd 2.73t [8:48] Partitioned (gpt)
> ├scsi 12:0:0:0 ATA      WDC WD30EZRX-00M {WD-WCAWZ2669166}
> │└sde 2.73t [8:64] Partitioned (gpt)
> └scsi 13:0:0:0 ATA      TOSHIBA HDWD130  {477ABEJAS}
>  └sdf 2.73t [8:80] Partitioned (gpt)

Unfortunately, my lsdrv tool is not able to reconstruct missing parts. 
It is most useful when used on a *good* system and *saved* for help 
diagnosing *future* problems.

Please share your /etc/fstab, and if you were using LVM on top of the 
raid, share your lvm.conf and anything in /etc/lvm/backup.

Please describe the layer(s) that were on top of the raid.

We need to help you look for signatures, and it helps to be selective in 
what signatures to look for.

After that, we will want to figure out your raid's chunk size and data 
offsets.  If you know of a particular large file (8MB or larger) that is 
sure to be in the raid and you happen to have a copy tucked away, then 
my findHash[1] tool might be able to definitively determine those 
values.  (Time consuming, though.)

Meanwhile, don't do *anything* that would write to those drives.

Phil

[1] https://github.com/pturmel/findHash
