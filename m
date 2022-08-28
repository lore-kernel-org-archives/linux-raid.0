Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE9B2ECAAA2
	for <linux-raid@archiver.kernel.org>; Sun, 28 Aug 2022 19:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiH1TtQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 28 Aug 2022 15:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiH1TtO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 28 Aug 2022 15:49:14 -0400
Received: from mail.stoffel.org (li1843-175.members.linode.com [172.104.24.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543BC31DF5
        for <linux-raid@vger.kernel.org>; Sun, 28 Aug 2022 12:49:13 -0700 (PDT)
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 72F3C27C9D;
        Sun, 28 Aug 2022 15:49:12 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id BCB7AA7E2F; Sun, 28 Aug 2022 15:49:11 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <25355.50871.743993.605394@quad.stoffel.home>
Date:   Sun, 28 Aug 2022 15:49:11 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     Phil Turmel <philip@turmel.org>
Cc:     John Stoffel <john@stoffel.org>,
        Peter Sanders <plsander@gmail.com>,
        Wols Lists <antlists@youngman.org.uk>,
        NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
Subject: Re: RAID 6, 6 device array - all devices lost superblock
In-Reply-To: <ee66bcbe-0a9b-57a6-439f-72cc46debe48@turmel.org>
References: <CAKAPSkJLd836Zp3xU=zSOHg3qcEmi29Y2qOwWzeAFaDp+dNTvg@mail.gmail.com>
        <70e2ae22-bbba-77a4-c9bc-4c02752f4cb7@youngman.org.uk>
        <dc24b476-2f0a-8406-f1c0-e33b5b0eb388@youngman.org.uk>
        <4a414fc6-2666-302f-8d3d-08eb7a2986fc@turmel.org>
        <CAKAPSkJAQYsec-4zzcePbkJ7Ee0=sd_QvHj4Stnyineq+T8BXw@mail.gmail.com>
        <25355.47062.897268.3355@quad.stoffel.home>
        <ee66bcbe-0a9b-57a6-439f-72cc46debe48@turmel.org>
X-Mailer: VM 8.2.0b under 27.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Phil" == Phil Turmel <philip@turmel.org> writes:

Phil> Pssst! John,
Phil> All of my comments were attributed to Peter by your mail client. ):

Yeah... sometimes my mail reader gets confused when it cites previous
emails.  I shoudl probably just drop to > only from now on.


Phil> On 8/28/22 14:45, John Stoffel wrote:
>>>>>>> "Peter" == Peter Sanders <plsander@gmail.com> writes:
>> 
Peter> It was set up on the device level, not partitions.  (I remember
Peter> getting some advice on the web that device was better than
Peter> partition... Yay for internet advice)
>> 
>> Yeah, this is NOT good advice.  Generally systems will not destroy
>> existing partition tables, but if they see an empty (to them)
>> disk... all bets are off.
>> 
Peter> I'm surveying my other disks to see what I have available to do
Peter> the overlay attempt.
>> 
>> They're small.  They are sparse files, so just follow the
>> instructions.
>> 
Peter> What are the size of the overlay files going to end up being?
>> 
>> Not too large, but it depends on how much data is written to the
>> overlayfs to get your data back.  If you follow the instructions on
>> this page:
>> 
>> https://raid.wiki.kernel.org/index.php/Recovering_a_damaged_RAID
>> 
>> It says to create a sparse file for each disk that is 1% of the size
>> of the disk.  This can add up... you might need to add a blank disk to
>> your system to hold these.
>> 
>> In this case, if you think you know which order the disks were in, you
>> could try to create the RAID6 array (but only using the overlayfs
>> devices!!!!!)  I can't stress this enough.
>> 
>> 
Peter> I did run into UEFI vs AHCI issues early in the process.. they
Peter> are all set to non-UEFI.
>> 
>> That's good.
>> 
Peter> OS update was onto a new SSD...
>> 
>> Ok.  Do you have the old OS disk around by any chance?  That might
>> give some pointers to how the disks are setup..  You could look in
>> /var/tmp/initrd/... for old mdadm.conf files, which might give more
>> details.
>> 
Peter> On Sun, Aug 28, 2022, 12:47 Phil Turmel <philip@turmel.org> wrote:
>> 
Peter> Hi Peter, et al,
>> 
Peter> On 8/28/22 05:54, Wols Lists wrote:
>>>> On 28/08/2022 10:14, Wols Lists wrote:
>>>>> Currently I have no /dev/md* devices.
>>>>> I have access to the old mdadm.conf file - have tried assembling with
>>>>> it, with the default mdadm.conf, and with no mdadm.conf file in /etc
>>>>> and /etc/mdadm.
>>>>> 
>>>>> It looks like the drives weren't partitioned :-( I think you're into
>>>>> forensics.
>> 
Peter> It is too soon to say this.  The supplied mdadm.conf file does not
Peter> contain specific partition information.  It is possible the partition
Peter> tables have just been wiped.
>> 
>>>> Whoops - my system froze while I was originally writing my reply, and I
>>>> forgot to put this into my rewrite ...
>>>> 
>>>> Look up overlays in the wiki. I've never done it myself, but a fair few
>>>> people have said the instructions worked a treat.
>>>> 
>>>> You're basically making the drives read-only (all writes get dumped into
>>>> the overlay file), and then re-creating the array over the top, so you
>>>> can test whether you got it right. If you don't, you just ditch the
>>>> overlays and start again, if you did get it right you can recreate the
>>>> array for real.
>>>> 
>>>> Cheers,
>>>> Wol
>> 
Peter> On 8/28/22 11:10, John Stoffel wrote:
>>>>>>>>> "Peter" == Peter Sanders <plsander@gmail.com> writes:
>>>> 
Peter> have a RAID 6 array, 6 devices.  Been running it for years without much issue.
Peter> Had hardware issues with my system - ended up replacing the
Peter> motherboard, video card, and power supply and re-installing the OS
Peter> (Debian 11).
>>>> 
>>>> Can you give us details on the old vs new motherboard/cpu?  It might
>>>> be that you need to tweak the BIOS of the motherboard to expose the
>>>> old SATA formats as well.
>>>> 
>>>> Did you install debian onto a fresh boot disk?  Is your BIOS setup to
>>>> only do the new form of booting from UEFI devices, so maybe check your
>>>> BIOS settings that the data drives are all in AHCI mode, or possibly
>>>> even in IDE mode.  It all depends on how old the original hardware
>>>> was.
>>>> 
>>>> I just recenly upgraded from a 2010 MB/CPU combo and I had to tweak
>>>> the BIOS defaults to see my disks.  I guess I should do a clean
>>>> install from a blank disk, but I wanted to minimize downtime.
>> 
Peter> It is important to end up in AHCI mode on all MOBO ports.  If not set
Peter> that way now, please change them.
>> 
>>>> Wols has some great advice here, and I heartily recommend that you use
>>>> overlayfs when doing your testing.  Check the RAID WIKI for
>>>> suggestions.
>> 
Peter> Concur.
>> 
>>>> And don't panic!  Your data is probably there, but just missing the
>>>> super blocks or partition tables.
>> 
Peter> Both, I suspect.
>> 
Peter> On 8/27/22 22:00, Peter Sanders wrote:
>>>> lsdrv ------------------------
>>>> PCI [nvme] 01:00.0 Non-Volatile memory controller: Phison Electronics
>>>> Corporation E12 NVMe Controller (rev 01)
>>>> └nvme nvme0 PCIe SSD                                 {21112925606047}
>>>>   └nvme0n1 238.47g [259:0] Partitioned (dos)
>>>>    ├nvme0n1p1 485.00m [259:1] ext4 {f38776ac-1ce9-4fc8-ba50-94844b9f504e}
>>>>    │└Mounted as /dev/nvme0n1p1 @ /boot
>>>>    ├nvme0n1p2 1.00k [259:2] Partitioned (dos)
>>>>    ├nvme0n1p5 60.54g [259:3] ext4 {5ee1c3c0-3a05-466c-9f98-f5807c8d813b}
>>>>    │└Mounted as /dev/nvme0n1p5 @ /
>>>>    ├nvme0n1p6 93.13g [259:4] ext4 {9064169f-4fe3-4836-a906-28c1b445cdff}
>>>>    │└Mounted as /dev/nvme0n1p6 @ /var
>>>>    ├nvme0n1p7 37.00m [259:5] ext4 {25e161ad-94a0-4298-afaf-18e2433766ee}
>>>>    ├nvme0n1p8 82.89g [259:6] ext4 {ac874071-d759-4d33-b32f-83272f3eacd9}
>>>>    │└Mounted as /dev/nvme0n1p8 @ /home
>>>>    └nvme0n1p9 1.41g [259:7] swap {02cef84b-9a9d-4a0a-973c-fda1a78c533c}
>>>> PCI [pata_jmicron] 26:00.1 IDE interface: JMicron Technology Corp.
>>>> JMB368 IDE controller (rev 10)
>>>> └scsi 0:0:0:0 MAD DOG  LS-DVDRW TSH652M {MAD_DOG_LS-DVDRW_TSH652M}
>>>>   └sr0 1.00g [11:0] Empty/Unknown
>>>> PCI [ahci] 26:00.0 SATA controller: JMicron Technology Corp. JMB363
>>>> SATA/IDE Controller (rev 10)
>>>> └scsi 2:x:x:x [Empty]
>>>> PCI [ahci] 2b:00.0 SATA controller: Advanced Micro Devices, Inc. [AMD]
>>>> FCH SATA Controller [AHCI mode] (rev 51)
>>>> ├scsi 6:0:0:0 ATA      TOSHIBA HDWD130  {477ALBNAS}
>>>> │└sda 2.73t [8:0] Partitioned (PMBR)
>>>> └scsi 7:0:0:0 ATA      TOSHIBA HDWD130  {Y7211KPAS}
>>>>   └sdc 2.73t [8:32] Partitioned (gpt)
>>>> PCI [ahci] 2c:00.0 SATA controller: Advanced Micro Devices, Inc. [AMD]
>>>> FCH SATA Controller [AHCI mode] (rev 51)
>>>> ├scsi 8:0:0:0 ATA      WDC WD30EZRX-00D {WD-WCC1T0668790}
>>>> │└sdb 2.73t [8:16] Partitioned (gpt)
>>>> ├scsi 9:0:0:0 ATA      WDC WD30EZRX-00D {WD-WCC4N0091255}
>>>> │└sdd 2.73t [8:48] Partitioned (gpt)
>>>> ├scsi 12:0:0:0 ATA      WDC WD30EZRX-00M {WD-WCAWZ2669166}
>>>> │└sde 2.73t [8:64] Partitioned (gpt)
>>>> └scsi 13:0:0:0 ATA      TOSHIBA HDWD130  {477ABEJAS}
>>>>   └sdf 2.73t [8:80] Partitioned (gpt)
>> 
Peter> Unfortunately, my lsdrv tool is not able to reconstruct missing parts.
Peter> It is most useful when used on a *good* system and *saved* for help
Peter> diagnosing *future* problems.
>> 
Peter> Please share your /etc/fstab, and if you were using LVM on top of the
Peter> raid, share your lvm.conf and anything in /etc/lvm/backup.
>> 
Peter> Please describe the layer(s) that were on top of the raid.
>> 
Peter> We need to help you look for signatures, and it helps to be selective in
Peter> what signatures to look for.
>> 
Peter> After that, we will want to figure out your raid's chunk size and data
Peter> offsets.  If you know of a particular large file (8MB or larger) that is
Peter> sure to be in the raid and you happen to have a copy tucked away, then
Peter> my findHash[1] tool might be able to definitively determine those
Peter> values.  (Time consuming, though.)
>> 
Peter> Meanwhile, don't do *anything* that would write to those drives.
>> 
Peter> Phil
>> 
Peter> [1] https://github.com/pturmel/findHash
>> 

