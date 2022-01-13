Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F08FAC433F5
	for <linux-raid@archiver.kernel.org>; Thu, 13 Jan 2022 00:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236403AbiAMADs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 Jan 2022 19:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236356AbiAMADn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 Jan 2022 19:03:43 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD67C06173F
        for <linux-raid@vger.kernel.org>; Wed, 12 Jan 2022 16:03:43 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id v7so5038224qtw.13
        for <linux-raid@vger.kernel.org>; Wed, 12 Jan 2022 16:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/622wrzJ4zCUQBxAxbDG9IscVm6KJINAIwvRSW4QEI4=;
        b=AZorhNUAkTC7KZSkOCqoM/KbdlD6xsnDDVUAcf9j8iAs8zLWApTfsr3K/eiayzZVI2
         U9pDuruLJlzlFv3kKALSjy5wK2kKaxqym8Mz6tWJkPZXBA9Hi6uwb3D49A/15a+BF3Ku
         D4fPq9vwJg+WQq53echnqsDzLNV9VnVF4JoSo1X8MUEE7yHlGqQLnTjyEooHTyRaRCY2
         cgLKQ2TAyvezTnLwk4vJfiToU7Z/n+zCegpImBJZjlqX8hTyZb6LF2/6fy8rJbHjLeuW
         6LzQJgw0GsvLtQXQV8TvCAQLseLDjHQqpdZ5mhuKL7lMC8VsPJlN96Lh0eAC/MOaoPjI
         OEzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/622wrzJ4zCUQBxAxbDG9IscVm6KJINAIwvRSW4QEI4=;
        b=wNZ78p9abOrXZKgaINE8Rii+gHcEBYvS/7+Qgd8VZgBkHXN1Ij0dUYJjfm8khkWDXJ
         p1xj55bSy8HkuvxGZKiKCclewOdLUEqV3mF2RStpxJLc4o9/3XDKAknty4T1IsxePJUl
         nKsliqKRltVIjE8IdywmaSlXI+mrwZdCItZGn3f8QneXzYM09S4fJuHC8SrErNSJIsT3
         SeWVbmJ++vCJPgFQIdJjVPUp09DQGPUN3pijkbB0Y6sUdApPoVwr+umHi8S8Zv0HPi4J
         eRIZSrlelOwNfj/s32yGtdUsYMt4OgOYTEJTRgTFrjgPDbKwi8laLkSWIYcRBDdb+wFX
         2KPQ==
X-Gm-Message-State: AOAM532KiRZ88Dd8MpemQrIJFAar7IHfLvJlZOrEowoawl6fJZWY46S2
        I+mkg8NI16A7Aw8UKcck7ZwdivAx3CuxBrhxNIA=
X-Google-Smtp-Source: ABdhPJz5zeBeAszJZPxKuB06FfIPO/CSoTVhwwxH1giT+MUQjpedfYmPMvNbpR+I4IMt0Ah1G2+Ewpk/AOivT0BgZss=
X-Received: by 2002:a05:622a:44b:: with SMTP id o11mr1791217qtx.296.1642032221796;
 Wed, 12 Jan 2022 16:03:41 -0800 (PST)
MIME-Version: 1.0
References: <CAPx-8MP0+C9M9ysigF-gfaUBE8nv7nzbm4HO06yC_z5i3U3D=Q@mail.gmail.com>
 <20220110104733.00001048@linux.intel.com> <CAPx-8MNa97Aokgz8RzfiGEPXFLpzbGduNV9hUOYdGXRmfxSg3g@mail.gmail.com>
 <CAAMCDecViLw=V_nFgJicLa=nDoADScpwg_pfWF2ubF5D=aCsaA@mail.gmail.com>
In-Reply-To: <CAAMCDecViLw=V_nFgJicLa=nDoADScpwg_pfWF2ubF5D=aCsaA@mail.gmail.com>
From:   Aidan Walton <aidan.walton@gmail.com>
Date:   Thu, 13 Jan 2022 01:03:05 +0100
Message-ID: <CAPx-8MNgtVuUgdOBsZiQyXmS=nCoj255D+oNrkGOcsNVhixC3g@mail.gmail.com>
Subject: Re: md device remains active even when all supporting disks have
 failed and been disabled by the kernel.
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Roger,
As I mentioned, it is a:
JMicron Technology Corp. JMB363

The reason for it failing is not entirely clear, but I'm fairly sure
it's not related to your suggestions. I can make it fail at will by
using:
 dd if=/dev/sdc of=/dev/null bs=64k count=10000   and  dd if=/dev/sdd
of=/dev/null bs=64k count=10000

Now as I increase the block size of dd, the rate of errors and resets
reduces, in what seems to be a rather linear manner. (Not in any way
scientifically proven) but there is a clear relationship between
commands/sec and resets.

If I use dd on only one disk, I get no errors and no resets, and this
applies to either disk.

Thanks for the interest, however I was not trying to digress off topic
too much. I don't think the linux-raid list is responsible for all
possible controllers out there. However the interactions between
mdraid and LVM is important and this is actually why I posted
initially.

Essentially I'm hoping someone comes back and says....hey did you
check that such a file under sys/.... is clear or not etc.
i.e. My instinct tells me somehow the kernel is holding a lock on LVM
and the mount/umount commands don't seem to care. They do what is
expected and /proc/mounts is updated accordingly. That is to say, file
locking is not the problem, but something is that I have missed and I
dont have the necessary knowledge to focus down onto it.

On Wed, 12 Jan 2022 at 23:54, Roger Heflin <rogerheflin@gmail.com> wrote:
>
> What kind of sata controller do you have?   I know of some 4pt marvell
> ones that if you execute smart commands or too many commands against
> it will "fault" and drop all of the disks going via that controller.
>
> On Wed, Jan 12, 2022 at 4:10 PM Aidan Walton <aidan.walton@gmail.com> wrote:
> >
> > Hi Mariusz,
> > In my case, the fact that mdraid does not show a 'total failure' is
> > not the root of the problem. However in my opinion I would say that
> > not having mdraid more accurately reflect the state of the underlying
> > hardware can be mis-leading. Initially when I looked at this issue, I
> > was convinced that only one disk had failed and I was scratching my
> > head about firstly why I still could not R/W the array while it
> > appeared to have an active member. Secondly, when I rebooted I noticed
> > that the array became instantly synchronised with both members active.
> > This was not what I expected, as normally an array that has had a
> > single failed disk would require a ra-add and resync.  Then when the
> > problem re-occured I noticed that it was not the same disk that was
> > flagged faulty, next reboot; the faulty disk flipped back the other
> > way... and so on. This was what prompted me to look closer at the
> > kernel. Here I found my answer at the SATA controller. Therefore
> > although mdraids design approach did not cause me any data loss, it
> > did have me looking in the wrong direction for the fault, assuming a
> > disk problem.
> >
> > I have still not been able to successfully --stop the array. I think
> > the issue sits in the LVM domain. Although I can not be 100% sure.
> > What I have achieved is some level of understanding that some process
> > that starts a boot time is in some unknown manner holding a lock on
> > the mdarid  - devmapper - LVM combination. I have unmounted the file
> > system, but LVM refuses to let go of the logical volume. Therefore so
> > does dev-mapper and of course mdraid. I have systematically stopped or
> > killed almost every single running process on the system, taking it
> > back to a skeleton, with not much more than init running, it still
> > refuses to let go.
> >
> > However, when I prevent auto-mounting of the raid array at boot, and
> > then manually assemble the raid array, LVM finds its meta data, builds
> > the VG and LV and mounts. If I then manually force the exact same SATA
> > controller failure, which results in the exact same mdraid behaviour,
> > I am then able to unmount the filesystem and ...... hey presto
> > deactivate the LVM LV. Which then allows me to --stop the mdraid. Just
> > as I want. Again it does not solve my SATA hardware issues, but being
> > at this point does give me options to restart the hardware etc, and
> > probably, though very messily, get the filesystem up again without a
> > reboot. The problem being I can not achieve this behaviour without
> > manually assembling the array after boot. If you have any idea what
> > could possibly be holding this lock I would be glad to hear.
> >
> > At this point I'm going to have to try and systematically step through
> > the boot process and try re-arranging, when the array gets assembled.
> > My first attempts at this have been to <ignore> the raid array in
> > mdadm.conf and comment the array out of /etc/fstab. In this way mdraid
> > inside initramfs does not auto-assemble and LVM does not auto scan for
> > the VG. Once I am in the real boot sequence, I have created a systemd
> > mount unit that I can pull in from other systemd units, to change the
> > point in the boot process when the array is assembled. In this way
> > hopefully I can influence when other services are interacting with the
> > array in some way and perhaps find the root cause ......   Work in
> > progress..but slowly as the fault occurs only very occasionally and I
> > still need a working server.
> > All the best.. Aidan
> >
> > On Mon, 10 Jan 2022 at 10:47, Mariusz Tkaczyk
> > <mariusz.tkaczyk@linux.intel.com> wrote:
> > >
> > > On Fri, 7 Jan 2022 23:30:31 +0100
> > > Aidan Walton <aidan.walton@gmail.com> wrote:
> > >
> > > > Hi,
> > > > I have a system running:
> > > > Ubuntu Server 20.04.3 LTS on a 5.4.0-92-generic kernel.
> > > >
> > > > On the motherboard is a:
> > > > SATA controller: JMicron Technology Corp. JMB363 SATA/IDE Controller
> > > > (rev 02)
> > > >
> > > > Connected to this I have:
> > > > 2x Western Digital - WDC WD5001AALS-00L3B2, BIOS :01.03B01 500Gb
> > > > drives
> > > >
> > > > Each drive has a single partition and is part of a RAID1 array:
> > > > /dev/md90:
> > > > .....
> > > >     Number   Major   Minor   RaidDevice State
> > > >        0       8       33        0      active sync   /dev/sdc1
> > > >        2       8       49        1      active sync   /dev/sdd1
> > > >
> > > > On top of this I have a single LVM VG and LV. (Probably not important)
> > > >
> > > > I have noticed some strange behaviour and upon investigation I find
> > > > the md device in the following state:
> > > > /dev/md90:
> > > > ....
> > > >
> > > >     Number   Major   Minor   RaidDevice State
> > > >        0       8       33        0      active sync   /dev/sdc1
> > > >        -       0        0        1      removed
> > > >
> > > >        2       8       49        -      faulty   /dev/sdd1
> > > >
> > > >
> > > > In fact neither /dev/sdc1 or /dev/sdd1 are available. In fact neither
> > > > are /dev/sdc or /dev/sdd, the physical drives, as they both been
> > > > disconnected by the kernel:
> > > > /dev/sdc is attached to ata7:00  and  /dev/sdd is attached to ata.8:00
> > > > This is the log of the kernel events:
> > > >
> > > >
> > > > Jan 07 22:09:03 mx kernel: ata7.00: exception Emask 0x32 SAct 0x0 SErr
> > > > 0x0 action 0xe frozen
> > > > Jan 07 22:09:03 mx kernel: ata7.00: irq_stat 0xffffffff, unknown FIS
> > > > 00000000 00000000 00000000 00000000, host bus
> > > > Jan 07 22:09:03 mx kernel: ata7.00: failed command: READ DMA
> > > > Jan 07 22:09:03 mx kernel: ata7.00: cmd
> > > > c8/00:00:00:cf:26/00:00:00:00:00/e0 tag 18 dma 131072 in
> > > > Jan 07 22:09:03 mx kernel: ata7.00: status: { DRDY }
> > > > Jan 07 22:09:03 mx kernel: ata7: hard resetting link
> > > > Jan 07 22:09:03 mx kernel: ata7: SATA link up 1.5 Gbps (SStatus 113
> > > > SControl 310)
> > > > Jan 07 22:09:09 mx kernel: ata7.00: qc timeout (cmd 0xec)
> > > > Jan 07 22:09:09 mx kernel: ata7.00: failed to IDENTIFY (I/O error,
> > > > err_mask=0x4) Jan 07 22:09:09 mx kernel: ata7.00: revalidation failed
> > > > (errno=-5) Jan 07 22:09:09 mx kernel: ata7: hard resetting link
> > > > Jan 07 22:09:19 mx kernel: ata7: softreset failed (1st FIS failed)
> > > > Jan 07 22:09:19 mx kernel: ata7: hard resetting link
> > > > Jan 07 22:09:29 mx kernel: ata7: softreset failed (1st FIS failed)
> > > > Jan 07 22:09:29 mx kernel: ata7: hard resetting link
> > > > Jan 07 22:09:35 mx kernel: ata8.00: exception Emask 0x40 SAct 0x0 SErr
> > > > 0x800 action 0x6 frozen
> > > > Jan 07 22:09:35 mx kernel: ata8: SError: { HostInt }
> > > > Jan 07 22:09:35 mx kernel: ata8.00: failed command: READ DMA
> > > > Jan 07 22:09:35 mx kernel: ata8.00: cmd
> > > > c8/00:00:00:64:4a/00:00:00:00:00/e0 tag 2 dma 131072 in
> > > > Jan 07 22:09:35 mx kernel: ata8.00: status: { DRDY }
> > > > Jan 07 22:09:35 mx kernel: ata8: hard resetting link
> > > > Jan 07 22:09:45 mx kernel: ata8: softreset failed (1st FIS failed)
> > > > Jan 07 22:09:45 mx kernel: ata8: hard resetting link
> > > > Jan 07 22:09:55 mx kernel: ata8: softreset failed (1st FIS failed)
> > > > Jan 07 22:09:55 mx kernel: ata8: hard resetting link
> > > > Jan 07 22:10:04 mx kernel: ata7: softreset failed (1st FIS failed)
> > > > Jan 07 22:10:04 mx kernel: ata7: hard resetting link
> > > > Jan 07 22:10:09 mx kernel: ata7: softreset failed (1st FIS failed)
> > > > Jan 07 22:10:09 mx kernel: ata7: reset failed, giving up
> > > > Jan 07 22:10:09 mx kernel: ata7.00: disabled
> > > > Jan 07 22:10:09 mx kernel: ata7: EH complete
> > > > Jan 07 22:10:30 mx kernel: ata8: softreset failed (1st FIS failed)
> > > > Jan 07 22:10:30 mx kernel: ata8: hard resetting link
> > > > Jan 07 22:10:35 mx kernel: ata8: softreset failed (1st FIS failed)
> > > > Jan 07 22:10:35 mx kernel: ata8: reset failed, giving up
> > > > Jan 07 22:10:35 mx kernel: ata8.00: disabled
> > > > Jan 07 22:10:35 mx kernel: ata8: EH complete
> > > >
> > > > This is happening because of some issue with the SATA controller on
> > > > the motherboard. This has not been resolved and probably never will
> > > > be, I see many others through google search complaining of similar
> > > > issues with the SATA controller.
> > > > This failure only occurs when the SATA controller is placed under very
> > > > heavy load, I have minimised the impact of the problem by not using
> > > > NCQ, this helps, but it still occurs. Ironically the biggest issue I
> > > > have is that mdadm "checkarray" is running because of a systemd
> > > > background process every week or so, and this hammers the disk into
> > > > failure. Most of the normal daily usage never generates the link
> > > > resets.
> > > > Naturally I have changed SATA cables and moved drives around onto
> > > > different controllers, but alas, it does seem to be the hardware on
> > > > the motherboard.
> > > > However as a workaround I was hoping to accept the occasional failure
> > > > and then using some scripting and 'setpci' I can get the kernel to
> > > > hard reset the chipset and attach the drives again. I have the process
> > > > working in terms of getting the kernel to re-attach the drives,
> > > > but.......
> > > >
> > > > Unfortunately mdraid will not let go of them, I can not stop the
> > > > arrays, and therefore can't rebuild them. If I simply allow the kernel
> > > > to re-attach the drives the kernel names are swapped over, as
> > > > something (mdraid) is stopping the kernel re-using the same device
> > > > names. Anyway being dependent on the same kernel device names is not a
> > > > great plan anyway, so I was simply trying to get mdadm to reassemble
> > > > the array as soon as the 'workaround' script gets the drives back in
> > > > contact with libata (kernel).
> > > >
> > > > Plan:
> > > > 1. Detecting the problem. (mdadm state)
> > > > 2. Stop the array totally (can NOT do it)
> > > > 3. reset the chipset across the PCI bus.
> > > > 4. allow kernel to re-attach drives.
> > > > 5. re-assemble the md device with mdadm
> > > > 6. restart, if necessary higher layer services...
> > > >
> > > > So why is mdraid holding on to the array:
> > > >
> > > > # mdadm --stop /dev/md90
> > > > mdadm: Cannot get exclusive access to /dev/md90:Perhaps a running
> > > > process, mounted filesystem or active volume group?
> > > >
> > > > I can not be 100% sure that something else is using the device, but I
> > > > can't think of anything that is and I stopped every process I can
> > > > think of..... Plus why is the array still shown as 'active' when none
> > > > of its member devices even exist anymore?
> > > >
> > > > What I do know is that device mapper (coming down from LVM)  still has
> > > > an entry in /dev/mapper. But then probably no surprise as /dev/md90
> > > > the failed array is still an active device node. If you attempt to
> > > > write to it, I receive I/O errors from the kernel. In fact as far as
> > > > any higher layer services are concerned md90 and the LVM LV on top of
> > > > it are still active and working when in reality, they are not. It
> > > > causes very strange NFS errors and such.
> > > >
> > > > mdraid does actually attempt to iteratively remove both partitions
> > > > when the kernel signals the disable state, but only 1 of them
> > > > succeeds.
> > > > I did an strace of the same iterative 'fail:remove' process that
> > > > mdraid attempts when the kernel issues -- kernel: ata7.00: disabled
> > > >
> > > > eg:
> > > > /sbin/mdadm -If sdc1 --path pci-0000:02:00.0-ata-1
> > > > mdadm: set device faulty failed for sdc1:  Device or resource busy
> > > >
> > > > The only clue is perhaps this line from the strace:
> > > > openat(AT_FDCWD, "/sys/block/md90/md/dev-sdc1/block/dev", O_RDWR) = -1
> > > > EACCES (Permission denied)    What is the mdadm command doing that
> > > > results in a permission problem?
> > > >
> > > > So the only way I can get rid of this md raid array is a reboot.
> > > > Damn!!!
> > > >
> > > >
> > > > Any help is much appreciated.
> > > > Aidan
> > > >
> > > >
> > > >
> > > Hi Aidan,
> > > This is how it is implemented. Drive is not removed if array failure
> > > will cause array failed. Please see:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=9a567843f7ce0037bfd4d5fdc58a09d0a527b28b
> > >
> > > For RAID1 you can use solution proposed in patch below but IMO it is
> > > not your problem. Please stop LVM and then try to stop array. To stop
> > > array it needs to be "free" (all upper handlers are down).
> > >
> > > Thanks,
> > > Mariusz
