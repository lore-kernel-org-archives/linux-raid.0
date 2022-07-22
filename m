Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08D1DC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 22 Jul 2022 09:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbiGVJ5Z convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 22 Jul 2022 05:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiGVJ5X (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 22 Jul 2022 05:57:23 -0400
Received: from mail.esperi.org.uk (icebox.esperi.org.uk [81.187.191.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5209631202
        for <linux-raid@vger.kernel.org>; Fri, 22 Jul 2022 02:57:22 -0700 (PDT)
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 26M9vIWE010183
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 22 Jul 2022 10:57:19 +0100
From:   Nix <nix@esperi.org.uk>
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: 5.18: likely useless very preliminary bug report: mdadm raid-6
 boot-time assembly failure
References: <87o7xmsjcv.fsf@esperi.org.uk>
        <fed30ed9-68e3-ce8b-ec27-45c48cf6a7a1@linux.dev>
        <8735evpwrf.fsf@esperi.org.uk>
        <CAAMCDeenbs5R6e_kuQR_zsv50eh49O2w4h-+BAg1xU9y0_BZ1Q@mail.gmail.com>
Emacs:  if it payed rent for disk space, you'd be rich.
Date:   Fri, 22 Jul 2022 10:57:19 +0100
In-Reply-To: <CAAMCDeenbs5R6e_kuQR_zsv50eh49O2w4h-+BAg1xU9y0_BZ1Q@mail.gmail.com>
        (Roger Heflin's message of "Wed, 20 Jul 2022 14:50:36 -0500")
Message-ID: <871qudo4g0.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-DCC--Metrics: loom 1480; Body=3 Fuz1=3 Fuz2=3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 20 Jul 2022, Roger Heflin verbalised:

> try a fdisk -l /dev/sda4   (to see if there is a partition on the
> partition).   That breaking stuff comes and goes.

... partitions come and go? :)

But no this was a blank disk before it was set up: there is no wreckage
of old stuff, and I ran wipefs before doing anything else anyway.

loom:~# blkid /dev/sda4
/dev/sda4: UUID="a35c9c54-bcdb-ff37-4f18-163ea93e9aa2" UUID_SUB="c262175d-09a1-1bc9-98d1-06dc5b18178c" LABEL="loom:slow" TYPE="linux_raid_member" PARTUUID="476279d8-7ea6-46dc-a7a4-8912267cf1b1"
loom:~# sfdisk -l /dev/sda4
Disk /dev/sda4: 2.25 TiB, 2478221630976 bytes, 4840276623 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes

> It will look like this, if you are doing all of the work on your disk
> then the mistake was probably not made.

Yeah. Also this has been assembling fine since 2017 :)

> In the below you could have an LVM device on sdfe1 (2nd block, or a
> md-raid device) that the existence of the partition table hides.

Except for an SSD, the disks are laid out identically (as in, I did it
with scripting so I can be sure that nothing else happened to them, no
stray wreckage of old filesystems or anything):

Disk /dev/sda: 7.28 TiB, 8001563222016 bytes, 15628053168 sectors
Disk model: ST8000NM0055-1RM
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: 14CB9BBE-BA31-4A1B-8643-7DE7A7EC2946

Device           Start         End     Sectors  Size Type
/dev/sda1         2048     2099199     2097152    1G EFI System
/dev/sda2      2099200   526387199   524288000  250G Linux RAID
/dev/sda3    526387200 10787775999 10261388800  4.8T Linux RAID
/dev/sda4  10787776512 15628053134  4840276623  2.3T Linux RAID

The layout is as follows (adjusted lsblk output):

NAME                     MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
sd[abcdf]                  8:0    0   7.3T  0 disk  
├─sd[abcdf]1               8:1    0     1G  0 part  /boot
├─sd[abcdf]2               8:2    0   250G  0 part  
│ └─md127                  9:127  0   1.2T  0 raid0 /.transient (bind-mounted to many places)
├─sd[abcdf]3               8:3    0   4.8T  0 part  
│ └─md125                  9:125  0  14.3T  0 raid6 
│   └─bcache0             253:0   0  14.3T  0 disk  
│     ├─main-root         252:5   0     4T  0 lvm (xfs; /, etc)
│     ├─main-workcrypt    252:8   0     2T  0 lvm (work disk)
│     │ └─workcrypt-plain 252:14  0     2T  0 crypt (xfs)
│     └─main-steam       252:11   0     1T  0 lvm (ext4)   
└─sd[abcdf]4               8:4    0   2.3T  0 part  
  └─md126                  9:126  0   6.8T  0 raid6 
    ├─main-archive       252:0    0     3T  0 lvm   /usr/archive
    ├─main-swap          252:1    0    40G  0 lvm   [SWAP]
    ├─main-vms           252:2    0     1T  0 lvm   /vm
    ├─main-phones        252:3    0    50G  0 lvm
    ├─main-private       252:4    0   100G  0 lvm
    ├─main-workmail      252:6    0    10G  0 lvm   
    ├─main-music         252:7    0   2.3T  0 lvm
    ├─main-unifi         252:9    0    10G  0 lvm
    └─main-rescue        252:10   0   100G  0 lvm   

sde                        8:64   0 447.1G  0 disk  (.5TiB SSD)
├─sde1                     8:65   0    32G  0 part  (currently unused)
├─sde2                     8:66   0   340G  0 part  (bcache cache device)
├─sde3                     8:67   0     2G  0 part  (xfs journal for main-root)
└─sde4                     8:68   0     2G  0 part  (xfs journal for main-workcrypt)

There is one LVM VG, stretching across md125 and md126, with LVs
positioned on one PV or the other (for now, until I run short of space
and have to start being less selective!).

But this is all a bit academic since none of these layers can come up in
the absence of the RAID array :)

(The layer underneath RAID is just SATA and libata, nice and simple and
nothing to go wrong -- I thought.)

> And if the sdfe1p1 is found and configured then it blocks/hides
> anything on sdfe1, and that depends on kernel scanning for partitions
> and userspace tools scanning for partitions

True! And if that isn't happening all hell breaks loose. I thought the
kernel would have found partitions automatically at boot, before
userspace even starts, but I'll admit I didn't check. Something else to
look at at the next trial boot.

> My other though was that maybe some change caused the partition type
> to start get used for something and if the type was wrong then ignore
> it.

I thought all the work done to assemble raid arrays was done by mdadm?
Because that didn't change. Does the kernel md layer also get to say
"type wrong, go away"? EW. I'd hope nothing is looking at partition
types these days...

> you might try a file -s /dev/sde1 against each partition that should
> have mdadm and make sure it says mdadm and that there is not some
> other header confusing the issue.

Ooh I didn't think of that at all!

... looks good, uuids match:

loom:~# file -s /dev/sd[afdcb]3
/dev/sda3: Linux Software RAID version 1.2 (1) UUID=4eb6bf4e:7458f1f1:d05bdfe4:6d38ca23 name=loom:fast level=6 disks=5
/dev/sdb3: Linux Software RAID version 1.2 (1) UUID=4eb6bf4e:7458f1f1:d05bdfe4:6d38ca23 name=loom:fast level=6 disks=5
/dev/sdc3: Linux Software RAID version 1.2 (1) UUID=4eb6bf4e:7458f1f1:d05bdfe4:6d38ca23 name=loom:fast level=6 disks=5
/dev/sdd3: Linux Software RAID version 1.2 (1) UUID=4eb6bf4e:7458f1f1:d05bdfe4:6d38ca23 name=loom:fast level=6 disks=5
/dev/sdf3: Linux Software RAID version 1.2 (1) UUID=4eb6bf4e:7458f1f1:d05bdfe4:6d38ca23 name=loom:fast level=6 disks=5
loom:~# file -s /dev/sd[afdcb]4
/dev/sda4: Linux Software RAID version 1.2 (1) UUID=a35c9c54:bcdbff37:4f18163e:a93e9aa2 name=loom:slow level=6 disks=5
/dev/sdb4: Linux Software RAID version 1.2 (1) UUID=a35c9c54:bcdbff37:4f18163e:a93e9aa2 name=loom:slow level=6 disks=5
/dev/sdc4: Linux Software RAID version 1.2 (1) UUID=a35c9c54:bcdbff37:4f18163e:a93e9aa2 name=loom:slow level=6 disks=5
/dev/sdd4: Linux Software RAID version 1.2 (1) UUID=a35c9c54:bcdbff37:4f18163e:a93e9aa2 name=loom:slow level=6 disks=5
/dev/sdf4: Linux Software RAID version 1.2 (1) UUID=a35c9c54:bcdbff37:4f18163e:a93e9aa2 name=loom:slow level=6 disks=5
loom:~# file -s /dev/sd[afdcb]2
/dev/sda2: Linux Software RAID version 1.2 (1) UUID=28f4c81c:f44742ea:89d4df21:6aea852b name=loom:transient level=0 disks=5
/dev/sdb2: Linux Software RAID version 1.2 (1) UUID=28f4c81c:f44742ea:89d4df21:6aea852b name=loom:transient level=0 disks=5
/dev/sdc2: Linux Software RAID version 1.2 (1) UUID=28f4c81c:f44742ea:89d4df21:6aea852b name=loom:transient level=0 disks=5
/dev/sdd2: Linux Software RAID version 1.2 (1) UUID=28f4c81c:f44742ea:89d4df21:6aea852b name=loom:transient level=0 disks=5
/dev/sdf2: Linux Software RAID version 1.2 (1) UUID=28f4c81c:f44742ea:89d4df21:6aea852b name=loom:transient level=0 disks=5

More and more this is looking like a blockdev and probably partition
discovery issue. Roll on Saturday when I can look at this again.

-- 
NULL && (void)
