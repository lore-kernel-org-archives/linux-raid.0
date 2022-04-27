Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB75C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 27 Apr 2022 13:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235429AbiD0NY7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Apr 2022 09:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233146AbiD0NY6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 27 Apr 2022 09:24:58 -0400
Received: from mail-41104.protonmail.ch (mail-41104.protonmail.ch [185.70.41.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069B165A8
        for <linux-raid@vger.kernel.org>; Wed, 27 Apr 2022 06:21:44 -0700 (PDT)
Date:   Wed, 27 Apr 2022 13:14:07 +0000
Authentication-Results: mail-41104.protonmail.ch;
        dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="EV2OtoVR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail2; t=1651065253;
        bh=agkBWG+9woAQG+uvXuZwRG8dX8HXOL+bUjYLOJcqOHo=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:Feedback-ID:From:To:Cc:Date:Subject:Reply-To:
         Feedback-ID:Message-ID;
        b=EV2OtoVRPTw4Ceo4PyiWdFLUpI4YtTBS+7/zuwyIx5uNevq+CNsVqp006vos4NCNi
         iHzRCaX2fql5ZYn9noDmdLAWCN7+GPhTvMxOLMY0evuYm8R65KJeH+TrR2MpWwK4LI
         CD8wD0Pa2NXSoRz3rFdSYealaw3ZYCFkTLKuVAjZ9rPurSKe48Msl+g9942HJmS7Pq
         z/Bcb8lFdrmS6OqLQY8sqUrWkBdlXFobNga6lDdYxtiKtGmddy0pgkQXZgDEXdEb/y
         aPpQdLFxhu7K8hTbmat8STvfqFg0equNpagaGQA37GQMNs7leSMK19sk/LAV+nBTYG
         bjQm0zKTwbO3g==
To:     Roger Heflin <rogerheflin@gmail.com>
From:   Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>
Cc:     John Stoffel <john@stoffel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "ceo@teo-en-ming-corp.com" <ceo@teo-en-ming-corp.com>
Reply-To: Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>
Subject: Re: arcconf Linux utility for Adaptec AAC-RAID (Rocket) (rev 02) (IBM ServeRAID 8k/8k-l8) unable to query RAID controller
Message-ID: <kwG84-2O2D48V1n_HOzdrXyxeKiLqBxdBjOamLmqc6GjRuS3b5D_7mGNejjnX0LHGJ7omrH8iAtAHJQF0yId3CNIDIIWLkB1Ral12PuJwiY=@protonmail.com>
In-Reply-To: <CAAMCDec-nEU10L6qrnmjX6kaMfG2ORobOb6fkmKKNba2D9aGUw@mail.gmail.com>
References: <iddAq1G1O5s0ZaXiG770cpphw7qFQJvJxEpC9C6KNBOPlTh3tisL-yqiUeWxokp-rHBqFCovWBDJdDea1B48qzcD1YCeipV3M7sKtGiX21o=@protonmail.com> <25189.52847.196112.389335@quad.stoffel.home> <BI8tpiYl62HTeDCz8Bge5mtCTJsyLb3NVNl2W69b6WKm2OSMg6_bUnJroS3ttUFAhT4gxLP36lvRJH0180JbvfB3JVKtXf1JEkLJ5THdcHU=@protonmail.com> <CAAMCDec-nEU10L6qrnmjX6kaMfG2ORobOb6fkmKKNba2D9aGUw@mail.gmail.com>
Feedback-ID: 39510961:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> Given that, odds are very high the disks are dying and/or one of the disk=
s failed a while ago and you are now running a no-redundancy stripe and not=
 a raid5, and odds are you need to figure out how to run and debug your arr=
ay with the vendor's tool you mentioned. Any status of the underlying raid =
will need to be done with that vendors tools and any recoveries you need to=
 do will need to be done with that tool, and the support, usage, and knowle=
dge of that tool/hw raid card is not part of the linux raid list as you don=
't have linux raid.

Noted with thanks. I had asked the linux-raid mailing list because our clie=
nt is using the hardware RAID controller in a Linux operating system.

Regards,

Mr. Turritopsis Dohrnii Teo En Ming
Targeted Individual in Singapore
27 April 2022 Wednesday






Sent with ProtonMail secure email.
------- Original Message -------
On Tuesday, April 26th, 2022 at 7:21 AM, Roger Heflin <rogerheflin@gmail.co=
m> wrote:


>
>
> On Mon, Apr 25, 2022 at 5:29 AM Turritopsis Dohrnii Teo En Ming <
> #1 as John stated this is not linux raid, this is hardware raid, you need=
 to ask the vendor whose controller that is what is going on. Given the con=
trollers age and the hardware age you probably are going to need to google =
usage of that controller and figure out exactly what is going on yourself.
>
> #2: You are using 146G disks (probably 2.5") and based on the age of the =
machine several of those disks are original, and really really old as 146GB=
 disks went EOL a few years ago. Those disks are old enough that they are g=
etting into the old age mechanical failures of pretty much everything that =
makes them work as disks.
>
> Given that, odds are very high the disks are dying and/or one of the disk=
s failed a while ago and you are now running a no-redundancy stripe and not=
 a raid5, and odds are you need to figure out how to run and debug your arr=
ay with the vendor's tool you mentioned. Any status of the underlying raid =
will need to be done with that vendors tools and any recoveries you need to=
 do will need to be done with that tool, and the support, usage, and knowle=
dge of that tool/hw raid card is not part of the linux raid list as you don=
't have linux raid.
> And given you are already getting bad blocks then your only option is lik=
ely to copy the data that you can still read off and rework with new disks,=
 possibly with a new machine as the hardware is quite old also. The 146GB d=
isks are the most concerning though as motherboards and such will last 10+ =
years but disks get very much at risk at that age.
>
> On Mon, Apr 25, 2022 at 5:36 PM Turritopsis Dohrnii Teo En Ming <teo.en.m=
ing@protonmail.com> wrote:
>
> > Dear John Stoffel,
> >
> > I have executed the following command on my client's CentOS 6.10 32-bit=
 Linux server.
> >
> > # badblocks -sv /dev/sda
> >
> > And found 512 bad blocks.
> >
> > Regards,
> >
> > Mr. Turritopsis Dohrnii Teo En Ming
> > Targeted Individual in Singapore
> > 25 Apr 2022 Monday
> >
> >
> > Sent with ProtonMail secure email.
> >
> >
> > ------- Original Message -------
> > On Monday, April 25th, 2022 at 6:25 AM, John Stoffel <john@stoffel.org>=
 wrote:
> >
> >
> > > > > > > > "Turritopsis" =3D=3D Turritopsis Dohrnii Teo En Ming teo.en=
.ming@protonmail.com writes:
> > >
> > >
> > > Turritopsis> Subject: arcconf Linux utility for Adaptec AAC-RAID
> > >
> > > Turritopsis> (Rocket) (rev 02) (IBM ServeRAID 8k/8k-l8) unable to
> > >
> > > Turritopsis> query RAID controller Good day from Singapore,
> > >
> > >
> > > Turritopsis> Our client has IBM System x3650 server (machine type:
> > >
> > > Turritopsis> 7979). Operating system is CentOS Linux 6.10 (32-bit).
> > >
> > >
> > > Ancient... you're running old mdadm code and kernel... and if it's
> > > critical enough, you could/might be able to get support from Redhat i=
f
> > > you pay them enough... and since it's a hardware RAID controller card=
,
> > > mdadm and Linux Raid isn't doing anything here, so we're really the
> > > wrong group to ask for help. But see below...
> > >
> > > Turritopsis> Recently we keep getting the following error messages
> > >
> > > Turritopsis> (output generated by dmesg).
> > >
> > >
> > > These errors look to be a bad sector on one of the disks. But since
> > > you're also using a hardware RAID controller... I would copy your dat=
a
> > > off ASAP onto some new media before you lose any thing more.
> > >
> > > Just ask them how much it will cost to keep the business running if
> > > they complain about the cost of three replacement disks on the
> > > system.
> > >
> > > But basically, I would:
> > >
> > > 0. copy the data somewhere else, especially if it's critical
> > > 1. copy the data somewhere else, especially if it's critical.
> > > 2. Try running 'badblocks' on /dev/sda to see if you can force it to
> > > re-write bad sectors. See man page for flags to use.
> > > 3. You can also try to boot the system to the BIOS and see if there's
> > > a BIOS screen for the AAC-RAID controller which lets you scrub the
> > > array or look for bad blocks.
> > >
> > > Good luck,
> > > John
> > >
> > > Turritopsis> <CODE>
> > >
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 09 2a d1 50 00 0=
2 00 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01040
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 09 2a cf 50 00 0=
2 00 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00528
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 09 2a d3 50 00 0=
2 00 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01552
> > >
> > > Turritopsis> JBD2: Detected IO errors while flushing file data on dm-=
0-8
> > >
> > > Turritopsis> JBD2: Detected IO errors while flushing file data on dm-=
0-8
> > >
> > > Turritopsis> JBD2: Detected IO errors while flushing file data on dm-=
0-8
> > >
> > > Turritopsis> JBD2: Detected IO errors while flushing file data on dm-=
0-8
> > >
> > > Turritopsis> JBD2: Detected IO errors while flushing file data on dm-=
0-8
> > >
> > > Turritopsis> JBD2: Detected IO errors while flushing file data on dm-=
0-8
> > >
> > > Turritopsis> JBD2: Detected IO errors while flushing file data on dm-=
0-8
> > >
> > > Turritopsis> JBD2: Detected IO errors while flushing file data on dm-=
0-8
> > >
> > > Turritopsis> JBD2: Detected IO errors while flushing file data on dm-=
0-8
> > >
> > > Turritopsis> JBD2: Detected IO errors while flushing file data on dm-=
0-8
> > >
> > > Turritopsis> JBD2: Detected IO errors while flushing file data on dm-=
0-8
> > >
> > > Turritopsis> JBD2: Detected IO errors while flushing file data on dm-=
0-8
> > >
> > > Turritopsis> JBD2: Detected IO errors while flushing file data on dm-=
0-8
> > >
> > > Turritopsis> JBD2: Detected IO errors while flushing file data on dm-=
0-8
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a cf 38 00 01=
 00 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00504
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 38 00 01=
 00 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00760
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 00 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00704
> > >
> > >
> > > Turritopsis> </CODE>
> > >
> > >
> > > Turritopsis> /dev/sda is a RAID 5 array with 3 harddisks of 136.6 GB =
capacity each.
> > >
> > >
> > > Turritopsis> <CODE>
> > >
> > >
> > > Turritopsis> [root@teo-en-ming-server ~]# fdisk /dev/sda
> > >
> > >
> > > Turritopsis> WARNING: DOS-compatible mode is deprecated. It's strongl=
y recommended to
> > >
> > > Turritopsis> switch off the mode (command 'c') and change display uni=
ts to
> > >
> > > Turritopsis> sectors (command 'u').
> > >
> > >
> > > Turritopsis> Command (m for help): p
> > >
> > >
> > > Turritopsis> Disk /dev/sda: 293.4 GB, 293378981888 bytes
> > >
> > > Turritopsis> 255 heads, 63 sectors/track, 35667 cylinders
> > >
> > > Turritopsis> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> > >
> > > Turritopsis> Sector size (logical/physical): 512 bytes / 512 bytes
> > >
> > > Turritopsis> I/O size (minimum/optimal): 512 bytes / 512 bytes
> > >
> > > Turritopsis> Disk identifier: 0x8b047782
> > >
> > >
> > > Turritopsis> Device Boot Start End Blocks Id System
> > >
> > > Turritopsis> /dev/sda1 * 1 64 512000 83 Linux
> > >
> > > Turritopsis> Partition 1 does not end on cylinder boundary.
> > >
> > > Turritopsis> /dev/sda2 64 35668 285989888 8e Linux LVM
> > >
> > >
> > > Turritopsis> Command (m for help):
> > >
> > >
> > > Turritopsis> </CODE>
> > >
> > >
> > > Turritopsis> We rebooted the server several times. The next morning w=
e still get the same error messages.
> > >
> > >
> > > Turritopsis> <CODE>
> > >
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] 573005824 512-byte logical blocks: (29=
3 GB/273 GiB)
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Write Protect is off
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Mode Sense: 06 00 10 00
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Write cache: disabled, read cache: ena=
bled, supports DPO and FUA
> > >
> > > Turritopsis> sda: sda1 sda2
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Attached SCSI removable disk
> > >
> > > Turritopsis> dracut: Scanning devices sda2 for LVM logical volumes vg=
_teo-en-ming-server/lv_swap vg_teo-en-ming-server/lv_root
> > >
> > > Turritopsis> EXT4-fs (sda1): mounted filesystem with ordered data mod=
e. Opts:
> > >
> > > Turritopsis> SELinux: initialized (dev sda1, type ext4), uses xattr
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 00 00 00=
 80 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00704
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 00 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00704
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225088
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 00 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00704
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225088
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 00 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00704
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225088
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 00 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00704
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225088
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 08 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00712
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225089
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 08 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00712
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225089
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 08 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00712
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225089
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 08 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00712
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225089
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 10 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00720
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225090
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 10 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00976
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 10 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00976
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225122
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 10 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00976
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225122
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 18 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00984
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225123
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 18 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00984
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225123
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 18 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00984
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225123
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 18 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00984
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225123
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 20 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00992
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225124
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 20 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00992
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225124
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 20 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
00992
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225124
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225124
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 28 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01256
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 28 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01256
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225157
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 28 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01256
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225157
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 28 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01256
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225157
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 30 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01264
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225158
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 30 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01264
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225158
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 30 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01264
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225158
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 30 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01264
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225158
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 38 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01272
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225159
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 38 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01272
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225159
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225159
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 30 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01520
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 38 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01528
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 38 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01528
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225191
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 38 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01528
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225191
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 38 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01528
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225191
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 40 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01536
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225192
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 40 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01536
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225192
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 40 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01536
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225192
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 40 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01536
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225192
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=
=3DDRIVER_SENSE
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
> > >
> > > Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 48 00 00=
 08 00
> > >
> > > Turritopsis> end_request: critical target error, dev sda, sector 1538=
01544
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225193
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225193
> > >
> > > Turritopsis> Buffer I/O error on device sda, logical block 19225193
> > >
> > >
> > > Turritopsis> </CODE>
> > >
> > >
> > > Turritopsis> Based on the following discussion thread, we think that =
the RAID controller may be failing.
> > >
> > >
> > > Turritopsis> Discussion thread: Which disk is bad in raid6 array
> > >
> > > Turritopsis> Link: https://serverfault.com/questions/384935/which-dis=
k-is-bad-in-raid6-array
> > >
> > >
> > > Turritopsis> I had downloaded 32-bit arcconf Linux utility from the f=
ollowing link.
> > >
> > >
> > > Turritopsis> Link: https://hwraid.le-vert.net/wiki/Adaptec
> > >
> > >
> > > Turritopsis> <CODE>
> > >
> > >
> > > Turritopsis> [root@teo-en-ming-server log]# lspci -vvv | grep RAID
> > >
> > > Turritopsis> 04:00.0 RAID bus controller: Adaptec AAC-RAID (Rocket) (=
rev 02)
> > >
> > > Turritopsis> Subsystem: IBM ServeRAID 8k/8k-l8
> > >
> > >
> > > Turritopsis> </CODE>
> > >
> > >
> > > Turritopsis> However, we keep getting segmentation fault running arcc=
onf utility.
> > >
> > >
> > > Turritopsis> <CODE>
> > >
> > >
> > > Turritopsis> [root@teo-en-ming-server log]# /usr/local/sbin/arcconf g=
etconfig 1
> > >
> > > Turritopsis> Segmentation fault (core dumped)
> > >
> > >
> > > Turritopsis> </CODE>
> > >
> > >
> > > Turritopsis> These are the Linux Kernel messages.
> > >
> > >
> > > Turritopsis> <CODE>
> > >
> > >
> > > Turritopsis> Apr 22 11:11:33 teo-en-ming-server kernel: aacraid: Host=
 adapter abort request (0,0,0,0)
> > >
> > > Turritopsis> Apr 22 11:11:33 teo-en-ming-server kernel: aacraid: Host=
 adapter reset request. SCSI hang ?
> > >
> > > Turritopsis> Apr 22 11:11:33 teo-en-ming-server kernel: AAC: Host ada=
pter BLINK LED 0x4
> > >
> > > Turritopsis> Apr 22 11:11:33 teo-en-ming-server kernel: AAC0: adapter=
 kernel panic'd 4.
> > >
> > > Turritopsis> Apr 22 11:12:23 teo-en-ming-server kernel: IRQ 17/aacrai=
d: IRQF_DISABLED is not guaranteed on shared IRQs
> > >
> > > Turritopsis> Apr 22 11:14:37 teo-en-ming-server kernel: aacraid: Host=
 adapter abort request (0,0,0,0)
> > >
> > > Turritopsis> Apr 22 11:14:37 teo-en-ming-server kernel: aacraid: Host=
 adapter reset request. SCSI hang ?
> > >
> > > Turritopsis> Apr 22 11:14:37 teo-en-ming-server kernel: AAC: Host ada=
pter BLINK LED 0x4
> > >
> > > Turritopsis> Apr 22 11:14:37 teo-en-ming-server kernel: AAC0: adapter=
 kernel panic'd 4.
> > >
> > > Turritopsis> Apr 22 11:15:28 teo-en-ming-server kernel: IRQ 17/aacrai=
d: IRQF_DISABLED is not guaranteed on shared IRQs
> > >
> > > Turritopsis> Apr 22 11:16:34 teo-en-ming-server kernel: aacraid: Host=
 adapter abort request (0,0,0,0)
> > >
> > > Turritopsis> Apr 22 11:16:34 teo-en-ming-server kernel: aacraid: Host=
 adapter reset request. SCSI hang ?
> > >
> > > Turritopsis> Apr 22 11:16:34 teo-en-ming-server kernel: AAC: Host ada=
pter BLINK LED 0x4
> > >
> > > Turritopsis> Apr 22 11:16:34 teo-en-ming-server kernel: AAC0: adapter=
 kernel panic'd 4.
> > >
> > >
> > > Turritopsis> </CODE>
> > >
> > >
> > > Turritopsis> It seems that I could not query the RAID controller. It =
keeps saying that the RAID controller adapter has kernel panics.
> > >
> > >
> > > Turritopsis> arcconf is a Linux utility to query the RAID controller.
> > >
> > >
> > > Turritopsis> <CODE>
> > >
> > >
> > > Turritopsis> [root@teo-en-ming-server cmdline]# lspci -nn | grep RAID
> > >
> > > Turritopsis> 04:00.0 RAID bus controller [0104]: Adaptec AAC-RAID (Ro=
cket) [9005:0286] (rev 02)
> > >
> > >
> > > Turritopsis> </CODE>
> > >
> > >
> > > Turritopsis> Do you know why I keep getting segmentation fault runnin=
g arcconf Linux utility?
> > >
> > >
> > > Turritopsis> Regards,
> > >
> > >
> > > Turritopsis> Mr. Turritopsis Dohrnii Teo En Ming
> > >
> > > Turritopsis> Targeted Individual in Singapore
> > >
> > > Turritopsis> 24 April 2022 Sunday
> > >
> > >
> > >
> > >
> > >
