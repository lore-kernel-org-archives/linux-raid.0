Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9808C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  1 Apr 2022 18:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350052AbiDASX4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Apr 2022 14:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbiDASXz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Apr 2022 14:23:55 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382D8541A5
        for <linux-raid@vger.kernel.org>; Fri,  1 Apr 2022 11:22:05 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id z33so1994164ybh.5
        for <linux-raid@vger.kernel.org>; Fri, 01 Apr 2022 11:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=yBiS+ckR++dJqLLoATltXlNn3yCQMBf9cM0C1OZNuoc=;
        b=d/bdlN2aWJfwlQUaV3Nd5dixRiIyGUdkBf91ZKImSQNKwZ6svGngOUnwthmW/lVQTX
         Lcy2c/ynQj3Wmkj2ffqbNdKRsVy7IcWNlGzKg1Qj11es8XD3w2yBQxfVwu6yWf+4c2LK
         wdcbx1LCkxjJRVa9Lk7ZdN0rhPxpUb/EkYxXXQX6OzUYeoLt6aEJmsQrLh1wX/yvW/yR
         B2UENfeQ1KXh0ClAiQZbC6DGIs9oH1ElT6gcg++bQsrjMONl++a8obf+FSIEGPVqaMtb
         JEGKmkLFALAfAjxnGxDA9/jpTEAHc+CNBZ5slSKymASSms+dqlgfpK7sS0Cfo4LkyEXf
         T2Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=yBiS+ckR++dJqLLoATltXlNn3yCQMBf9cM0C1OZNuoc=;
        b=UBUY0EhUYz3HXVpGfhfwZrQA+/hD6nWL5+2UVwGCSd98dTanL9QpWS991BGYnQ1Eny
         fQ/nhaGpAqzxTmH2geRUWUThjE/yHDqDzehA3N1CkXjDvfhEBEV97Ykx/My2+fCwcDuc
         rhOm6uRhWBC5ute+yZIg9gCeVB0qKSVZfSeBTBBXInlAeTFFqhna4q0g3Q+oOIBacl2X
         oEgTH4Tfvv7jSrFAKGVpomH6Al8zEkbfrcg3toUIc3saSVrfjM+GzX+WEJYj/MXONi9D
         YUV6k9TqcDDwXHd2kxjU6l1jRTasC6towWB/Dz1/Og5aa6dihSHCQA0M8Iv3lzN3H/vW
         tCgg==
X-Gm-Message-State: AOAM530favg+bJgww+eSEYGR3lfPLoemqoYx9duJB3ZGaNpDFhyWjUl/
        VK+9Sp0Oa7wdLyoCab/kSKi+S8/LgvO69tHKWH+elilVTMI=
X-Google-Smtp-Source: ABdhPJzgejp1pRzGIsTiGrne66KHRWNyeQccebbBdE6g1LB3OmPhR37RvrL+Z6F4wke54Qw2Mabxhi9NimP5XLXwuKc=
X-Received: by 2002:a05:6902:1c9:b0:611:4169:48b3 with SMTP id
 u9-20020a05690201c900b00611416948b3mr10228713ybh.18.1648837324274; Fri, 01
 Apr 2022 11:22:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAKRnqN+_=U58dT5bvgWJ1DgyEuhjsbmCuDL+xOLxmcuG1ML4qg@mail.gmail.com>
 <e3573002-05f3-3110-62a6-e704385f877f@youngman.org.uk> <CAKRnqNLjsX9nVLrLedo4tfxtg0ZBz=6XJu=-z_Ebw6Auh+oz-Q@mail.gmail.com>
 <8c2148d0-fa97-d0ef-10cc-11f79d7da5e5@youngman.org.uk> <CAKRnqN+21BZT1eufn962xiEDvnrBtk68dTBSLT1mx7+Ac2kJ+w@mail.gmail.com>
In-Reply-To: <CAKRnqN+21BZT1eufn962xiEDvnrBtk68dTBSLT1mx7+Ac2kJ+w@mail.gmail.com>
Reply-To: bruce.korb+reply@gmail.com
From:   Bruce Korb <bruce.korb@gmail.com>
Date:   Fri, 1 Apr 2022 11:21:28 -0700
Message-ID: <CAKRnqN+6wAFPf5AGNEf948NunA97MJ9Gy5eFzLCfX+WfHY72Pg@mail.gmail.com>
Subject: Re: Trying to rescue a RAID-1 array
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     brucekorbreply <bruce.korb+reply@gmail.com>,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Um, I forgot that with a fresh install, I have to remember what all
tools I had installed and re-install 'em.

bach:/home/bkorb # /home/bkorb/bin/lsdrv/lsdrv-master/lsdrv

PCI [ahci] 00:11.4 SATA controller: Intel Corporation C610/X99 series
chipset sSATA Controller [AHCI mode] (rev 05)
=E2=94=9Cscsi 0:0:0:0 ATA      TOSHIBA HDWE160  {487OK01XFB8G}
=E2=94=82=E2=94=94sda 5.46t [8:0] Partitioned (gpt)
=E2=94=82 =E2=94=9Csda1 128.00g [8:1] btrfs 'OPT-USR' {649826e5-7406-49fb-a=
d4a-a35a0077a325}
=E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/sda1 @ /opt
=E2=94=82 =E2=94=9Csda3 64.00g [8:3] Empty/Unknown
=E2=94=82 =E2=94=9Csda4 16.00g [8:4] Empty/Unknown
=E2=94=82 =E2=94=94sda5 5.25t [8:5] MD raid1 (0/2) (w/ sdb5) in_sync 'bach:=
0'
{0e2cb19c-b567-5fcc-2982-c38e81e42a71}
=E2=94=82  =E2=94=94md0 5.25t [9:0] MD v1.2 raid1 (2) clean
{0e2cb19c:-b567-5f:cc-2982-:c38e81e42a71}
=E2=94=82   =E2=94=82               ext4 'HOME' {a6551143-65ab-40ff-82b6-8c=
c809a1a856}
=E2=94=82   =E2=94=94Mounted as /dev/md0 @ /home
=E2=94=9Cscsi 1:0:0:0 ATA      TOSHIBA HDWE160  {487OK01SFB8G}
=E2=94=82=E2=94=94sdb 5.46t [8:16] Partitioned (gpt)
=E2=94=82 =E2=94=9Csdb1 192.00g [8:17] btrfs 'VAR-TMP' {c1304823-0b3b-4655-=
bfbb-a7f064ec59f5}
=E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/sdb1 @ /var
=E2=94=82 =E2=94=9Csdb2 16.00g [8:18] Empty/Unknown
=E2=94=82 =E2=94=94sdb5 5.25t [8:21] MD raid1 (1/2) (w/ sda5) in_sync 'bach=
:0'
{0e2cb19c-b567-5fcc-2982-c38e81e42a71}
=E2=94=82  =E2=94=94md0 5.25t [9:0] MD v1.2 raid1 (2) clean
{0e2cb19c:-b567-5f:cc-2982-:c38e81e42a71}
=E2=94=82                   ext4 'HOME' {a6551143-65ab-40ff-82b6-8cc809a1a8=
56}
=E2=94=9Cscsi 2:0:0:0 ATA      HGST HMS5C4040AL {PL1331LAHEZZ5H}
=E2=94=82=E2=94=94sdc 3.64t [8:32] Partitioned (gpt)
=E2=94=82 =E2=94=9Csdc1 3.20t [8:33] MD raid0 (0/2) (w/ sde1) in_sync 'any:=
1'
{f624aab2-afc1-8758-5c20-d34955b9b36f}
=E2=94=82 =E2=94=82=E2=94=94md1 6.40t [9:1] MD v1.0 raid0 (2) clean, 64k Ch=
unk, None (None)
None {f624aab2:-afc1-87:58-5c20-:d34955b9b36f}
=E2=94=82 =E2=94=82                 xfs 'User' {fe716da2-b515-4fd6-8ea6-f44=
f48038b78}
=E2=94=82 =E2=94=9Csdc2 320.00g [8:34] ext4 'PHOTOS-B' {4ab1a2c2-dbee-4f4d-=
b491-8652ea7a24d7}
=E2=94=82 =E2=94=94sdc3 65.22g [8:35] ext4 'TEMP' {c18c28d3-dafd-4f1b-aa9f-=
b7a462139073}
=E2=94=94scsi 3:0:0:0 ATA      WDC WDS250G2B0A- {181202806197}
=E2=94=94sdd 232.89g [8:48] Partitioned (gpt)
 =E2=94=9Csdd1 901.00m [8:49] vfat 'BOOT-EFI' {AF1B-15D7}
 =E2=94=82=E2=94=94Mounted as /dev/sdd1 @ /boot/efi
 =E2=94=9Csdd2 116.00g [8:50] Partitioned (dos) 'ROOT1'
{63e24f52-2f8f-4ad1-a1e6-cb5537efcf6f}
 =E2=94=82=E2=94=9CMounted as /dev/sdd2 @ /
 =E2=94=82=E2=94=9CMounted as /dev/sdd2 @ /.snapshots
 =E2=94=82=E2=94=9CMounted as /dev/sdd2 @ /boot/grub2/i386-pc
 =E2=94=82=E2=94=9CMounted as /dev/sdd2 @ /boot/grub2/x86_64-efi
 =E2=94=82=E2=94=9CMounted as /dev/sdd2 @ /srv
 =E2=94=82=E2=94=9CMounted as /dev/sdd2 @ /usr/local
 =E2=94=82=E2=94=9CMounted as /dev/sdd2 @ /tmp
 =E2=94=82=E2=94=94Mounted as /dev/sdd2 @ /root
 =E2=94=94sdd3 116.01g [8:51] xfs 'ROOT2' {69178c35-15ea-4f04-8f29-bf4f1f6f=
890a}
  =E2=94=94Mounted as /dev/sdd3 @ /root2
PCI [ahci] 00:1f.2 SATA controller: Intel Corporation C610/X99 series
chipset 6-Port SATA Controller [AHCI mode] (rev 05)
=E2=94=9Cscsi 4:0:0:0 ATA      HGST HMS5C4040AL {PL1331LAHGEP7H}
=E2=94=82=E2=94=94sde 3.64t [8:64] Partitioned (gpt)
=E2=94=82 =E2=94=9Csde1 3.20t [8:65] MD raid0 (1/2) (w/ sdc1) in_sync 'any:=
1'
{f624aab2-afc1-8758-5c20-d34955b9b36f}
=E2=94=82 =E2=94=82=E2=94=94md1 6.40t [9:1] MD v1.0 raid0 (2) clean, 64k Ch=
unk, None (None)
None {f624aab2:-afc1-87:58-5c20-:d34955b9b36f}
=E2=94=82 =E2=94=82                 xfs 'User' {fe716da2-b515-4fd6-8ea6-f44=
f48038b78}
=E2=94=82 =E2=94=9Csde2 64.00g [8:66] swap {dbd52b6f-fc65-42e9-948b-33d9c38=
34c3c}
=E2=94=82 =E2=94=94sde3 385.22g [8:67] ext4 'PHOTO-A' {c84250ab-6563-4832-a=
919-632a34486bf1}
=E2=94=94scsi 5:0:0:0 HL-DT-ST BD-RE  WH14NS40  {SIK9TH8SE163}
=E2=94=94sr0 1.00g [11:0] Empty/Unknown
USB [usb-storage] Bus 002 Device 007: ID 05e3:0745 Genesys Logic, Inc.
Logilink CR0012 {000000000903}
=E2=94=94scsi 10:0:0:0 Generic  STORAGE DEVICE   {000000000503}
=E2=94=94sdf 0.00k [8:80] Empty/Unknown
USB [usb-storage] Bus 002 Device 008: ID 058f:6387 Alcor Micro Corp.
Flash Drive {A3A1458D}
=E2=94=94scsi 11:0:0:0 Generic  Flash Disk       {A}
=E2=94=94sdg 28.91g [8:96] Partitioned (dos)
 =E2=94=94sdg1 28.91g [8:97] vfat '32GB' {1D6B-D5DB}
  =E2=94=94Mounted as /dev/sdg1 @ /run/media/bkorb/32GB

Hmm. Interesting. Dunno what that /dev/sdf thingy is. I only have one
thumb drive plugged in and mounted as /dev/sdg1.

 - Bruce

On Fri, Apr 1, 2022 at 10:59 AM Bruce Korb <bruce.korb@gmail.com> wrote:
>
> Hi,
> Thank you again. I've attached a typescript of the commands. Here are
> the line numbers where the commands get issued. The relevant
> partitions are on /dev/sdc1 and /dev/sde1:
>
> 1:>3> uname -a
> 3:>4> mdadm --version
> 5:>5> for d in /dev/sd[ce]
> 6:>7> smartctl --xall /dev/sdc
> 252:>8> mdadm --examine /dev/sdc
> 256:>9> mdadm --examine /dev/sdc1
> 281:>5> for d in /dev/sd[ce]
> 282:>7> smartctl --xall /dev/sde
> 556:>8> mdadm --examine /dev/sde
> 560:>9> mdadm --examine /dev/sde1
> 585:>11> mdadm --detail /dev/md1
> 614:>12> /home/bkorb/bin/lsdrv/lsdrv-master/lsdrv
>
> Right after line 256, you'll see the fateful info:
> 263   Creation Time : Tue Mar 29 11:02:09 2022
> 264      Raid Level : raid0
>
> The first block of /dev/sdc1 contains:
> bkorb@bach:~> sudo od -Ax -N 4096 -tx1 /dev/sdc1
> 000000 58 46 53 42 00 00 10 00 00 00 00 00 33 33 32 d0
> 000010 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 000020 fe 71 6d a2 b5 15 4f d6 8e a6 f4 4f 48 03 8b 78
> 000030 00 00 00 00 20 00 00 07 00 00 00 00 00 00 00 60
> 000040 00 00 00 00 00 00 00 61 00 00 00 00 00 00 00 62
> 000050 00 00 00 01 0c cc cc b4 00 00 00 04 00 00 00 00
> 000060 00 06 66 66 bc b5 10 00 02 00 00 08 55 73 65 72
> 000070 00 00 00 00 00 00 00 00 0c 0c 09 03 1c 00 00 05
> 000080 00 00 00 00 00 15 9c 80 00 00 00 00 00 00 2b 48
> 000090 00 00 00 00 27 92 36 06 00 00 00 00 00 00 00 00
> 0000a0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 0000b0 00 00 00 00 00 00 00 04 00 00 00 00 00 00 00 00
> 0000c0 00 0c 10 00 00 00 10 00 00 00 01 8a 00 00 01 8a
> 0000d0 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 00
> 0000e0 6f 7c f9 cc 00 00 00 00 ff ff ff ff ff ff ff ff
> 0000f0 00 00 00 7a 00 31 11 20 00 00 00 00 00 00 00 00
> 000100 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> I wouldn't know how to find the file system start. :)
>
>  - Bruce
>
> On Thu, Mar 31, 2022 at 2:34 PM Wols Lists <antlists@youngman.org.uk> wro=
te:
> >
> > On 31/03/2022 19:14, Bruce Korb wrote:
> > > On Thu, Mar 31, 2022 at 10:06 AM Wols Lists <antlists@youngman.org.uk=
> wrote:
> > >>
> > >> On 31/03/2022 17:44, Bruce Korb wrote:
> > >>> I moved the two disks from a cleanly shut down system that could no=
t
> > >>> reboot and could not
> > >>> be upgraded to a new OS release. So, I put them in.a new box and di=
d an install.
> > >>> The installation recognized them as a RAID and decided that the
> > >>> partitions needed a
> > >>> new superblock of type RAID-0.
> > >>
> > >> That's worrying, did it really write a superblock?
> > >
> > > Yep. That worried me, too. I did the command to show the RAID status =
of the two
> > > partitions and, sure enough, both partitions were now listed as RAID0=
.
> > >
> > >>> Since these data have never been
> > >>> remounted since the
> > >>> shutdown on the original machine, I am hoping I can change the RAID
> > >>> type and mount it
> > >>> so as to recover my. .ssh and .thunderbird (email) directories. The
> > >>> bulk of the data are
> > >>> backed up (assuming no issues with the full backup of my critical
> > >>> data), but rebuilding
> > >>> and redistributing the .ssh directory would be a particular nuisanc=
e.
> > >>>
> > >>> SO: what are my options? I can't find any advice on how to tell mda=
dm
> > >>> that the RAID-0 partitions
> > >>> really are RAID-1 partitions. Last gasp might be to "mdadm --create=
"
> > >>> the RAID-1 again, but there's
> > >>> a lot of advice out there saying that it really is the last gasp
> > >>> before giving up. :)
> > >>>
> > >>
> > >> https://raid.wiki.kernel.org/index.php/Asking_for_help
> > >
> > > Sorry about that. I have two systems: the one I'm typing on and the o=
ne
> > > I am trying to bring up. At the moment, I'm in single user mode build=
ing
> > > out a new /home file system. mdadm --create is 15% done after an hour=
 :(.
> > > It'll be mid/late afternoon before /home is rebuilt, mounted and I'll=
 be
> > > able to run display commands on the "old" RAID1 (or 0) partitions.
> > >
> > >> Especially lsdrv. That tells us a LOT about your system.
> > >
> > > Expect email in about 6 hours or so. :) But openSUSE doesn't know
> > > about any "lsdrv" command. "cat /proc/mdstat" shows /dev/md1 (the
> > > RAID device I'm fretting over) to be active, raid-0 using /dev/sdc1 a=
nd sde1.
> >
> > Well, the webpage does tell you where to download it from - it's not
> > part of the official tools, and it's a personal thing that's damn usefu=
l.
> > >
> > >> What was the filesystem on your raid? Hopefully it's as simple as mo=
ving
> > >> the "start of partition", breaking the raid completely, and you can =
just
> > >> mount the filesystem.
> > >
> > > I *think* it was EXT4, but. it might be the XFS one. I think I let it=
 default
> > > and openSUSE appears to prefer the XFS file system for RAID devices.
> > > Definitely one of those two. I built it close to a decade ago, so I'l=
l be moving
> > > the data to the new /home array.
> > >
> > >> What really worries me is how and why it both recognised it as a rai=
d,
> > >> then thought it needed to be converted to raid-0. That just sounds w=
rong
> > >> on so many levels. Did you let it mess with your superblocks? I hope=
 you
> > >> said "don't touch those drives"?
> > >
> > > In retrospect, I ought to have left the drives unplugged until the in=
stall was
> > > done. The installer saw that they were RAID so it RAID-ed them. Only =
it
> > > seems to have decided on type 0 over type 1. I wasn't attentive becau=
se
> > > I've upgraded Linux so many times and it was "just done correctly" wi=
thout
> > > having to give it a lot of thought. "If only" I'd thought to back up
> > > email and ssh.
> > > (1.5TB of photos are likely okay.)
> > >
> > > Thank you so much for your reply and potentially help :)
> > >
> > If it says the drive is active ...
> >
> > When you get and run lsdrv, see if it finds a filesystem on the raid-0 =
-
> > I suspect it might!
> >
> > There's a bug, which should be well fixed, but it might have bitten you=
.
> > It breaks raid arrays. But if the drive is active, it might well mount,
> > and you will be running a degraded mirror. Mount it read-only, back it
> > up, and then see whether you can force-assemble the two bits back
> > together :-)
> >
> > But don't do anything if you have any trouble whatsoever mounting and
> > backing up.
> >
> > Cheers,
> > Wol
