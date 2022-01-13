Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00999C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 13 Jan 2022 16:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236908AbiAMQt0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Jan 2022 11:49:26 -0500
Received: from outbound5b.eu.mailhop.org ([3.125.66.160]:52372 "EHLO
        outbound5b.eu.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236822AbiAMQt0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 Jan 2022 11:49:26 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1642092503; cv=none;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        b=TYClsMtfZm6V0mZTkHT3Ybpy/FWGrUba2d4B2R5SjJXsnJA6TBxGSNS2EtvaiI5LdrkrSWdUnCXuj
         5ylHcnGUNrwyUvE+cQqOlV+9o6fj15bLanne8nsy5NmyUAGZLUGkbGcpe7d+5rdewvjB22AjEjqhSf
         1/VgSsU8UWFu+Y3thGQBAGw03eBMV1wLM/17nJYfviV0Zwy6tZPyDfs1rvPb59gr346u4or8VdWjSZ
         CvYrEyLv4nZa9uAnCAcqr3EQigIZRjYw5PIsdcglOXp6nBNoWM3anT4xsIVGzHPiK6JIcNfIExJvJB
         aCNJvXwZ1Qfi/AcpMTSXANZvcGqw2bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
         subject:mime-version:date:message-id:dkim-signature:from;
        bh=+YJIa0xXgdWh8P+mkhK3Q5eDud/95/zBS0O4quI62aA=;
        b=Fh85sk+lOsMH2Wg0euIwzNdof6wPOw5kAndYzeHbNT10KEwq+wt9fH7iPOLwJ28AT3fxVRGWem/nk
         DkZyyaamC+HNemGpwOPnl7O6WOGgOfLNVuZ04sbf076mi3ZZY2XtTqqunQgv7CTgXCpksD/VTgdk/N
         dUMNfeCOCc/5vdADyppK/a0D/IM7+nfJ01t+pZUtTBqq0M9cu7WimFdEzwQy7XsjOmOnRteCbla7IM
         +LULozy7Hf3ttwGqubGdIg6/BNFvPvzKV7xhc3Y7fYhPjBvo8cXm4ek0bV9UzhKMd3Owqb5eKVjviw
         26EVtkKTu/zvsVZawhdj/9cQ3blT4FA==
ARC-Authentication-Results: i=1; outbound3.eu.mailhop.org;
        spf=softfail smtp.mailfrom=demonlair.co.uk smtp.remote-ip=86.166.202.46;
        dmarc=none header.from=demonlair.co.uk;
        arc=none header.oldest-pass=0;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=dkim-high;
        h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
         subject:mime-version:date:message-id:from;
        bh=+YJIa0xXgdWh8P+mkhK3Q5eDud/95/zBS0O4quI62aA=;
        b=TGfnU95HCH9r7utXBzyA9lq9lSxFRv9n7bjhG8Y9nJKa0x0FhWepjSk7OU+wCQzVJcvKCWY642MSQ
         9wNKIt5toY2TAElcGaCRexyUZ1L+tL1Ku1zPcY1VLWTAPcyKaPvRSzDJbgcL/3HtY4DPobDOm4eZqi
         t8EhRAR6fpvTrYo/eLhWEjEVO8vhplP+P9lTc/wTB9hyx3VAU6YUjdYBR0C4zGxdniAPHpmXca7cdk
         ACYsQF5BTMtLv4EIkM8Ew87DjAq68ZFOV436axvcHNNMLxzEaritbH3FLx4Hy2UDznLQ3se15m8j3i
         YThKJmfkxRfk2Uxu+GKTjs/sAYXmKRg==
X-Originating-IP: 86.166.202.46
X-MHO-RoutePath: ZGVtb25sYWly
X-MHO-User: 9c906d4e-7490-11ec-ba47-95b64d6800c5
X-Report-Abuse-To: https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information
X-Mail-Handler: DuoCircle Outbound SMTP
Received: from phoenix.demonlair.co.uk (host86-166-202-46.range86-166.btcentralplus.com [86.166.202.46])
        by outbound3.eu.mailhop.org (Halon) with ESMTPA
        id 9c906d4e-7490-11ec-ba47-95b64d6800c5;
        Thu, 13 Jan 2022 16:48:19 +0000 (UTC)
Received: from [10.57.1.71] (mercury.demonlair.co.uk [10.57.1.71])
        by phoenix.demonlair.co.uk (Postfix) with ESMTP id 1A1E01EA058;
        Thu, 13 Jan 2022 16:48:19 +0000 (GMT)
Message-ID: <f89de7bd-61c4-85e0-d50c-a1296640a1e2@demonlair.co.uk>
Date:   Thu, 13 Jan 2022 16:48:17 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: md device remains active even when all supporting disks have
 failed and been disabled by the kernel.
Content-Language: en-GB
To:     Aidan Walton <aidan.walton@gmail.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Linux RAID <linux-raid@vger.kernel.org>
References: <CAPx-8MP0+C9M9ysigF-gfaUBE8nv7nzbm4HO06yC_z5i3U3D=Q@mail.gmail.com>
 <20220110104733.00001048@linux.intel.com>
 <CAPx-8MNa97Aokgz8RzfiGEPXFLpzbGduNV9hUOYdGXRmfxSg3g@mail.gmail.com>
 <20220113154627.00006dee@linux.intel.com>
 <CAPx-8MPSOLZXT8FHo9eorFY1sxOQyWJJ-8QwfneRZ8HEO-U5nA@mail.gmail.com>
From:   Geoff Back <geoff@demonlair.co.uk>
In-Reply-To: <CAPx-8MPSOLZXT8FHo9eorFY1sxOQyWJJ-8QwfneRZ8HEO-U5nA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

I believe md90 will remain locked all the time that any LVM-created
device mapping exists that references the md90 PV, regardless of whether
that mapping is in use.

You could try using "lvchange -an <vgname>/<volume>" to deactivate the
LV.  That should remove the DM mapping, which should in turn unlock md90.

Cheers,

Geoff.


On 13/01/2022 16:35, Aidan Walton wrote:
> Progress of sorts:
> I have tried to get the results as requested. However I was
> experimenting with the patch that you referenced initially and before
> I did this test, I forgot that I had actually run:
> echo 1 > /sys/block/md90/md/fail_last_dev
>
> So the outcome was interesting as the result proves this feature does
> work as expected and the md90 array showed both devices flagged as
> down. Better!
> /dev/md90:
>            Version : 1.2
>      Creation Time : Sat Nov  3 03:09:16 2018
>         Raid Level : raid1
>         Array Size : 488253440 (465.63 GiB 499.97 GB)
>      Used Dev Size : 488253440 (465.63 GiB 499.97 GB)
>       Raid Devices : 2
>      Total Devices : 2
>        Persistence : Superblock is persistent
>
>      Intent Bitmap : Internal
>
>        Update Time : Thu Jan 13 17:08:38 2022
>              State : clean, FAILED
>     Active Devices : 0
>     Failed Devices : 2
>      Spare Devices : 0
>
> Consistency Policy : bitmap
>
>     Number   Major   Minor   RaidDevice State
>        -       0        0        0      removed
>        -       0        0        1      removed
>
>        0       8       33        -      faulty   /dev/sdc1
>        2       8       49        -      faulty   /dev/sdd1
>
> The process that led to this is below:
> from journalctl:
> Jan 13 17:07:05 mx kernel: ata7.00: exception Emask 0x32 SAct 0x0 SErr
> 0x0 action 0xe frozen
> Jan 13 17:07:05 mx kernel: ata7.00: irq_stat 0xffffffff, unknown FIS
> 00000000 00000000 00000000 00000000, host bus
> Jan 13 17:07:05 mx kernel: ata7.00: failed command: READ DMA
> Jan 13 17:07:05 mx kernel: ata7.00: cmd
> c8/00:00:18:2d:ec/00:00:00:00:00/e0 tag 22 dma 131072 in
> Jan 13 17:07:05 mx kernel: ata7.00: status: { DRDY }
> Jan 13 17:07:05 mx kernel: ata7: hard resetting link
> Jan 13 17:07:15 mx kernel: ata7: softreset failed (1st FIS failed)
> Jan 13 17:07:15 mx kernel: ata7: hard resetting link
> Jan 13 17:07:25 mx kernel: ata7: softreset failed (1st FIS failed)
> Jan 13 17:07:25 mx kernel: ata7: hard resetting link
> Jan 13 17:07:36 mx kernel: ata8.00: exception Emask 0x40 SAct 0x0 SErr
> 0x800 action 0x6 frozen
> Jan 13 17:07:36 mx kernel: ata8: SError: { HostInt }
> Jan 13 17:07:36 mx kernel: ata8.00: failed command: READ DMA
> Jan 13 17:07:36 mx kernel: ata8.00: cmd
> c8/00:00:78:53:d9/00:00:00:00:00/e0 tag 10 dma 131072 in
> Jan 13 17:07:36 mx kernel: ata8.00: status: { DRDY }
> Jan 13 17:07:36 mx kernel: ata8: hard resetting link
> Jan 13 17:07:46 mx kernel: ata8: softreset failed (1st FIS failed)
> Jan 13 17:07:46 mx kernel: ata8: hard resetting link
> Jan 13 17:07:56 mx kernel: ata8: softreset failed (1st FIS failed)
> Jan 13 17:07:56 mx kernel: ata8: hard resetting link
> Jan 13 17:08:00 mx kernel: ata7: softreset failed (1st FIS failed)
> Jan 13 17:08:00 mx kernel: ata7: hard resetting link
> Jan 13 17:08:05 mx kernel: ata7: softreset failed (1st FIS failed)
> Jan 13 17:08:05 mx kernel: ata7: reset failed, giving up
> Jan 13 17:08:05 mx kernel: ata7.00: disabled
> Jan 13 17:08:05 mx kernel: ata7: EH complete
> Jan 13 17:08:31 mx kernel: ata8: softreset failed (1st FIS failed)
> Jan 13 17:08:31 mx kernel: ata8: hard resetting link
> Jan 13 17:08:36 mx kernel: ata8: softreset failed (1st FIS failed)
> Jan 13 17:08:36 mx kernel: ata8: reset failed, giving up
> Jan 13 17:08:36 mx kernel: ata8.00: disabled
> Jan 13 17:08:36 mx kernel: ata8: EH complete
>
>
> from udevadm monitor, NOTE, I noticed that udev monitor did not seem
> to spit anything out at the point in time when the first SATA device
> ata7.00: was disabled. The messages below only appeared 30secs later
> when ata8.00: went down: Sorry no timestamping on udevadm monitor, but
> read below from exactly when this occurred: Jan 13 17:08:36 mx kernel:
> ata8.00: disabled
>
> KERNEL[226088.463136] add
> /kernel/slab/kmalloc-192/cgroup/kmalloc-192(549:mdmonitor.service)
> (cgroup)
> KERNEL[226088.463335] add
> /kernel/slab/kmalloc-1k/cgroup/kmalloc-1k(549:mdmonitor.service)
> (cgroup)
> KERNEL[226088.464229] add
> /kernel/slab/task_struct/cgroup/task_struct(549:mdmonitor.service)
> (cgroup)
> KERNEL[226088.464374] add
> /kernel/slab/:A-0000080/cgroup/task_delay_info(549:mdmonitor.service)
> (cgroup)
> KERNEL[226088.464467] add
> /kernel/slab/:A-0000704/cgroup/files_cache(549:mdmonitor.service)
> (cgroup)
> KERNEL[226088.464718] add
> /kernel/slab/sighand_cache/cgroup/sighand_cache(549:mdmonitor.service)
> (cgroup)
> KERNEL[226088.465312] add
> /kernel/slab/:A-0001152/cgroup/signal_cache(549:mdmonitor.service)
> (cgroup)
> UDEV  [226088.472483] add
> /kernel/slab/kmalloc-192/cgroup/kmalloc-192(549:mdmonitor.service)
> (cgroup)
> UDEV  [226088.473360] add
> /kernel/slab/kmalloc-1k/cgroup/kmalloc-1k(549:mdmonitor.service)
> (cgroup)
> UDEV  [226088.480328] add
> /kernel/slab/task_struct/cgroup/task_struct(549:mdmonitor.service)
> (cgroup)
> UDEV  [226088.486830] add
> /kernel/slab/:A-0000080/cgroup/task_delay_info(549:mdmonitor.service)
> (cgroup)
> UDEV  [226088.487077] add
> /kernel/slab/sighand_cache/cgroup/sighand_cache(549:mdmonitor.service)
> (cgroup)
> UDEV  [226088.488851] add
> /kernel/slab/:A-0000704/cgroup/files_cache(549:mdmonitor.service)
> (cgroup)
> UDEV  [226088.493066] add
> /kernel/slab/:A-0001152/cgroup/signal_cache(549:mdmonitor.service)
> (cgroup)
> KERNEL[226089.014423] add
> /kernel/slab/:a-0000104/cgroup/buffer_head(549:mdmonitor.service)
> (cgroup)
> UDEV  [226089.017837] add
> /kernel/slab/:a-0000104/cgroup/buffer_head(549:mdmonitor.service)
> (cgroup)
> KERNEL[226089.188538] add
> /kernel/slab/radix_tree_node/cgroup/radix_tree_node(549:mdmonitor.service)
> (cgroup)
> KERNEL[226089.189366] add
> /kernel/slab/ext4_inode_cache/cgroup/ext4_inode_cache(549:mdmonitor.service)
> (cgroup)
> UDEV  [226089.193043] add
> /kernel/slab/radix_tree_node/cgroup/radix_tree_node(549:mdmonitor.service)
> (cgroup)
> UDEV  [226089.194414] add
> /kernel/slab/ext4_inode_cache/cgroup/ext4_inode_cache(549:mdmonitor.service)
> (cgroup)
> KERNEL[226090.421762] add
> /kernel/slab/kmalloc-8/cgroup/kmalloc-8(549:mdmonitor.service)
> (cgroup)
> UDEV  [226090.425465] add
> /kernel/slab/kmalloc-8/cgroup/kmalloc-8(549:mdmonitor.service)
> (cgroup)
> KERNEL[226090.442542] add
> /kernel/slab/proc_inode_cache/cgroup/proc_inode_cache(549:mdmonitor.service)
> (cgroup)
> UDEV  [226090.445999] add
> /kernel/slab/proc_inode_cache/cgroup/proc_inode_cache(549:mdmonitor.service)
> (cgroup)
> KERNEL[226090.458800] add
> /kernel/slab/:A-0000072/cgroup/eventpoll_pwq(549:mdmonitor.service)
> (cgroup)
> KERNEL[226090.460227] add
> /kernel/slab/kmalloc-16/cgroup/kmalloc-16(549:mdmonitor.service)
> (cgroup)
> UDEV  [226090.463193] add
> /kernel/slab/:A-0000072/cgroup/eventpoll_pwq(549:mdmonitor.service)
> (cgroup)
> UDEV  [226090.467271] add
> /kernel/slab/kmalloc-16/cgroup/kmalloc-16(549:mdmonitor.service)
> (cgroup)
> KERNEL[226090.880178] add
> /kernel/slab/kmalloc-rcl-64/cgroup/kmalloc-rcl-64(549:mdmonitor.service)
> (cgroup)
> UDEV  [226090.883794] add
> /kernel/slab/kmalloc-rcl-64/cgroup/kmalloc-rcl-64(549:mdmonitor.service)
> (cgroup)
>
>
>
> dmsetup info -c
> Name                                Maj Min Stat Open Targ Event  UUID
> storage.mx.vg2-shared_sun_NAS.lv1   253   0 L--w    1    1      0
> LVM-Ud9pj6QE4hK1K3xiAFMVCnno3SrXaRyTXJLtTGDOPjBUppJgzr4t0jJowixEOtx7
> storage.mx.vg1-shared_sun_users.lv1 253   2 L--w    1    1      0
> LVM-ypcHlbNXu36FLRgU0EcUiXBSIvcOlHEP3MHkBKsBeHf6Q68TIuGA9hd5UfCpvOeo
> ubuntu_server--vg-ubuntu_server--lv 253   1 L--w    1    1      0
> LVM-eGBUJxP1vlW3MfNNeC2r5JfQUiKKWZ73t3U3Jji3lggXe8LPrUf0xRE0YyPzSorO
>
> NOTE the 'open' status on the NAS.lv1 device. In fact the device is not mounted:
>
> cat /proc/mounts | grep mapper
> /dev/mapper/ubuntu_server--vg-ubuntu_server--lv / ext4
> rw,relatime,errors=remount-ro 0 0
> /dev/mapper/storage.mx.vg1-shared_sun_users.lv1 /mnt/home ext4 rw,relatime 0 0
>
> pvdisplay
>   --- Physical volume ---
>   PV Name               /dev/md1
>   VG Name               storage.mx.vg1
>   PV Size               111.73 GiB / not usable 3.00 MiB
>   Allocatable           yes (but full)
>   PE Size               4.00 MiB
>   Total PE              28603
>   Free PE               0
>   Allocated PE          28603
>   PV UUID               4yDnuz-PEHg-uZqd-djWS-DNnp-Qzuf-fYvGZJ
>
>   --- Physical volume ---
>   PV Name               /dev/md0
>   VG Name               ubuntu_server-vg
>   PV Size               <37.22 GiB / not usable 0
>   Allocatable           yes (but full)
>   PE Size               4.00 MiB
>   Total PE              9528
>   Free PE               0
>   Allocated PE          9528
>   PV UUID               G0bNbO-DOz4-I2nN-rEQq-X00m-PG3a-fPAP3I
>
> So in this case LVM seems to recognise that the md90 device is gone.
>
> Before I changed the 'fail_last_dev' option, When I ran these LVM
> commands, I was experiencing a short delay and then a report in place
> of the failed device saying that LVM had given up waiting for a udev
> entry to become available after 10000mS. Sorry I didn't catch this,
> for the log, but it is from memory.
>
> But now this delay is not happening and LVM seems to have a correct
> and consistent view of the failed mount point. Clearly mdraid has sent
> the failure up the stack.
>
>
> However mdraid will still NOT stop the md90 device:
>
> mdadm --stop /dev/md90
> mdadm: Cannot get exclusive access to /dev/md90:Perhaps a running
> process, mounted filesystem or active volume group?
>
> ATB
> Aidan
>
> On Thu, 13 Jan 2022 at 15:46, Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
>> Hi Aidan,
>>
>> On Wed, 12 Jan 2022 02:29:47 +0100
>> Aidan Walton <aidan.walton@gmail.com> wrote:
>>
>>> Hi Mariusz,
>>> In my case, the fact that mdraid does not show a 'total failure' is
>>> not the root of the problem. However in my opinion I would say that
>>> not having mdraid more accurately reflect the state of the underlying
>>> hardware can be mis-leading. Initially when I looked at this issue, I
>>> was convinced that only one disk had failed and I was scratching my
>>> head about firstly why I still could not R/W the array while it
>>> appeared to have an active member. Secondly, when I rebooted I noticed
>>> that the array became instantly synchronised with both members active.
>> We have raid1 so first fail should be recorded in metadata. From your
>> description, I understand that nothing like this happened. For me, it
>> seems that the controller lost both drives in the same moment and as a
>> result nothing was saved. After reboot raid is assembled without
>> rebuild because metadata on both members is valid.
>>
>>> This was not what I expected, as normally an array that has had a
>>> single failed disk would require a ra-add and resync.  Then when the
>>> problem re-occured I noticed that it was not the same disk that was
>>> flagged faulty, next reboot; the faulty disk flipped back the other
>>> way... and so on. This was what prompted me to look closer at the
>>> kernel. Here I found my answer at the SATA controller. Therefore
>>> although mdraids design approach did not cause me any data loss, it
>>> did have me looking in the wrong direction for the fault, assuming a
>>> disk problem.
>>>
>>> I have still not been able to successfully --stop the array. I think
>>> the issue sits in the LVM domain. Although I can not be 100% sure.
>>> What I have achieved is some level of understanding that some process
>>> that starts a boot time is in some unknown manner holding a lock on
>>> the mdarid  - devmapper - LVM combination. I have unmounted the file
>>> system, but LVM refuses to let go of the logical volume. Therefore so
>>> does dev-mapper and of course mdraid. I have systematically stopped or
>>> killed almost every single running process on the system, taking it
>>> back to a skeleton, with not much more than init running, it still
>>> refuses to let go
>>>
>>> However, when I prevent auto-mounting of the raid array at boot, and
>>> then manually assemble the raid array, LVM finds its meta data, builds
>>> the VG and LV and mounts. If I then manually force the exact same SATA
>>> controller failure, which results in the exact same mdraid behaviour,
>>> I am then able to unmount the filesystem and ...... hey presto
>>> deactivate the LVM LV. Which then allows me to --stop the mdraid. Just
>>> as I want. Again it does not solve my SATA hardware issues, but being
>>> at this point does give me options to restart the hardware etc, and
>>> probably, though very messily, get the filesystem up again without a
>>> reboot. The problem being I can not achieve this behaviour without
>>> manually assembling the array after boot. If you have any idea what
>>> could possibly be holding this lock I would be glad to hear.
>>>
>> Could you connect to the udev monitor and analyze events triggered in
>> both cases? This is the one idea I have.
>>
>> Thanks,
>> Mariusz
>>
>>> At this point I'm going to have to try and systematically step through
>>> the boot process and try re-arranging, when the array gets assembled.
>>> My first attempts at this have been to <ignore> the raid array in
>>> mdadm.conf and comment the array out of /etc/fstab. In this way mdraid
>>> inside initramfs does not auto-assemble and LVM does not auto scan for
>>> the VG. Once I am in the real boot sequence, I have created a systemd
>>> mount unit that I can pull in from other systemd units, to change the
>>> point in the boot process when the array is assembled. In this way
>>> hopefully I can influence when other services are interacting with the
>>> array in some way and perhaps find the root cause ......   Work in
>>> progress..but slowly as the fault occurs only very occasionally and I
>>> still need a working server.
>>> All the best.. Aidan
>>>
>>> On Mon, 10 Jan 2022 at 10:47, Mariusz Tkaczyk
>>> <mariusz.tkaczyk@linux.intel.com> wrote:
>>>> On Fri, 7 Jan 2022 23:30:31 +0100
>>>> Aidan Walton <aidan.walton@gmail.com> wrote:
>>>>
>>>>> Hi,
>>>>> I have a system running:
>>>>> Ubuntu Server 20.04.3 LTS on a 5.4.0-92-generic kernel.
>>>>>
>>>>> On the motherboard is a:
>>>>> SATA controller: JMicron Technology Corp. JMB363 SATA/IDE
>>>>> Controller (rev 02)
>>>>>
>>>>> Connected to this I have:
>>>>> 2x Western Digital - WDC WD5001AALS-00L3B2, BIOS :01.03B01 500Gb
>>>>> drives
>>>>>
>>>>> Each drive has a single partition and is part of a RAID1 array:
>>>>> /dev/md90:
>>>>> .....
>>>>>     Number   Major   Minor   RaidDevice State
>>>>>        0       8       33        0      active sync   /dev/sdc1
>>>>>        2       8       49        1      active sync   /dev/sdd1
>>>>>
>>>>> On top of this I have a single LVM VG and LV. (Probably not
>>>>> important)
>>>>>
>>>>> I have noticed some strange behaviour and upon investigation I
>>>>> find the md device in the following state:
>>>>> /dev/md90:
>>>>> ....
>>>>>
>>>>>     Number   Major   Minor   RaidDevice State
>>>>>        0       8       33        0      active sync   /dev/sdc1
>>>>>        -       0        0        1      removed
>>>>>
>>>>>        2       8       49        -      faulty   /dev/sdd1
>>>>>
>>>>>
>>>>> In fact neither /dev/sdc1 or /dev/sdd1 are available. In fact
>>>>> neither are /dev/sdc or /dev/sdd, the physical drives, as they
>>>>> both been disconnected by the kernel:
>>>>> /dev/sdc is attached to ata7:00  and  /dev/sdd is attached to
>>>>> ata.8:00 This is the log of the kernel events:
>>>>>
>>>>>
>>>>> Jan 07 22:09:03 mx kernel: ata7.00: exception Emask 0x32 SAct 0x0
>>>>> SErr 0x0 action 0xe frozen
>>>>> Jan 07 22:09:03 mx kernel: ata7.00: irq_stat 0xffffffff, unknown
>>>>> FIS 00000000 00000000 00000000 00000000, host bus
>>>>> Jan 07 22:09:03 mx kernel: ata7.00: failed command: READ DMA
>>>>> Jan 07 22:09:03 mx kernel: ata7.00: cmd
>>>>> c8/00:00:00:cf:26/00:00:00:00:00/e0 tag 18 dma 131072 in
>>>>> Jan 07 22:09:03 mx kernel: ata7.00: status: { DRDY }
>>>>> Jan 07 22:09:03 mx kernel: ata7: hard resetting link
>>>>> Jan 07 22:09:03 mx kernel: ata7: SATA link up 1.5 Gbps (SStatus
>>>>> 113 SControl 310)
>>>>> Jan 07 22:09:09 mx kernel: ata7.00: qc timeout (cmd 0xec)
>>>>> Jan 07 22:09:09 mx kernel: ata7.00: failed to IDENTIFY (I/O error,
>>>>> err_mask=0x4) Jan 07 22:09:09 mx kernel: ata7.00: revalidation
>>>>> failed (errno=-5) Jan 07 22:09:09 mx kernel: ata7: hard resetting
>>>>> link Jan 07 22:09:19 mx kernel: ata7: softreset failed (1st FIS
>>>>> failed) Jan 07 22:09:19 mx kernel: ata7: hard resetting link
>>>>> Jan 07 22:09:29 mx kernel: ata7: softreset failed (1st FIS failed)
>>>>> Jan 07 22:09:29 mx kernel: ata7: hard resetting link
>>>>> Jan 07 22:09:35 mx kernel: ata8.00: exception Emask 0x40 SAct 0x0
>>>>> SErr 0x800 action 0x6 frozen
>>>>> Jan 07 22:09:35 mx kernel: ata8: SError: { HostInt }
>>>>> Jan 07 22:09:35 mx kernel: ata8.00: failed command: READ DMA
>>>>> Jan 07 22:09:35 mx kernel: ata8.00: cmd
>>>>> c8/00:00:00:64:4a/00:00:00:00:00/e0 tag 2 dma 131072 in
>>>>> Jan 07 22:09:35 mx kernel: ata8.00: status: { DRDY }
>>>>> Jan 07 22:09:35 mx kernel: ata8: hard resetting link
>>>>> Jan 07 22:09:45 mx kernel: ata8: softreset failed (1st FIS failed)
>>>>> Jan 07 22:09:45 mx kernel: ata8: hard resetting link
>>>>> Jan 07 22:09:55 mx kernel: ata8: softreset failed (1st FIS failed)
>>>>> Jan 07 22:09:55 mx kernel: ata8: hard resetting link
>>>>> Jan 07 22:10:04 mx kernel: ata7: softreset failed (1st FIS failed)
>>>>> Jan 07 22:10:04 mx kernel: ata7: hard resetting link
>>>>> Jan 07 22:10:09 mx kernel: ata7: softreset failed (1st FIS failed)
>>>>> Jan 07 22:10:09 mx kernel: ata7: reset failed, giving up
>>>>> Jan 07 22:10:09 mx kernel: ata7.00: disabled
>>>>> Jan 07 22:10:09 mx kernel: ata7: EH complete
>>>>> Jan 07 22:10:30 mx kernel: ata8: softreset failed (1st FIS failed)
>>>>> Jan 07 22:10:30 mx kernel: ata8: hard resetting link
>>>>> Jan 07 22:10:35 mx kernel: ata8: softreset failed (1st FIS failed)
>>>>> Jan 07 22:10:35 mx kernel: ata8: reset failed, giving up
>>>>> Jan 07 22:10:35 mx kernel: ata8.00: disabled
>>>>> Jan 07 22:10:35 mx kernel: ata8: EH complete
>>>>>
>>>>> This is happening because of some issue with the SATA controller
>>>>> on the motherboard. This has not been resolved and probably never
>>>>> will be, I see many others through google search complaining of
>>>>> similar issues with the SATA controller.
>>>>> This failure only occurs when the SATA controller is placed under
>>>>> very heavy load, I have minimised the impact of the problem by
>>>>> not using NCQ, this helps, but it still occurs. Ironically the
>>>>> biggest issue I have is that mdadm "checkarray" is running
>>>>> because of a systemd background process every week or so, and
>>>>> this hammers the disk into failure. Most of the normal daily
>>>>> usage never generates the link resets.
>>>>> Naturally I have changed SATA cables and moved drives around onto
>>>>> different controllers, but alas, it does seem to be the hardware
>>>>> on the motherboard.
>>>>> However as a workaround I was hoping to accept the occasional
>>>>> failure and then using some scripting and 'setpci' I can get the
>>>>> kernel to hard reset the chipset and attach the drives again. I
>>>>> have the process working in terms of getting the kernel to
>>>>> re-attach the drives, but.......
>>>>>
>>>>> Unfortunately mdraid will not let go of them, I can not stop the
>>>>> arrays, and therefore can't rebuild them. If I simply allow the
>>>>> kernel to re-attach the drives the kernel names are swapped over,
>>>>> as something (mdraid) is stopping the kernel re-using the same
>>>>> device names. Anyway being dependent on the same kernel device
>>>>> names is not a great plan anyway, so I was simply trying to get
>>>>> mdadm to reassemble the array as soon as the 'workaround' script
>>>>> gets the drives back in contact with libata (kernel).
>>>>>
>>>>> Plan:
>>>>> 1. Detecting the problem. (mdadm state)
>>>>> 2. Stop the array totally (can NOT do it)
>>>>> 3. reset the chipset across the PCI bus.
>>>>> 4. allow kernel to re-attach drives.
>>>>> 5. re-assemble the md device with mdadm
>>>>> 6. restart, if necessary higher layer services...
>>>>>
>>>>> So why is mdraid holding on to the array:
>>>>>
>>>>> # mdadm --stop /dev/md90
>>>>> mdadm: Cannot get exclusive access to /dev/md90:Perhaps a running
>>>>> process, mounted filesystem or active volume group?
>>>>>
>>>>> I can not be 100% sure that something else is using the device,
>>>>> but I can't think of anything that is and I stopped every process
>>>>> I can think of..... Plus why is the array still shown as 'active'
>>>>> when none of its member devices even exist anymore?
>>>>>
>>>>> What I do know is that device mapper (coming down from LVM)
>>>>> still has an entry in /dev/mapper. But then probably no surprise
>>>>> as /dev/md90 the failed array is still an active device node. If
>>>>> you attempt to write to it, I receive I/O errors from the kernel.
>>>>> In fact as far as any higher layer services are concerned md90
>>>>> and the LVM LV on top of it are still active and working when in
>>>>> reality, they are not. It causes very strange NFS errors and such.
>>>>>
>>>>> mdraid does actually attempt to iteratively remove both partitions
>>>>> when the kernel signals the disable state, but only 1 of them
>>>>> succeeds.
>>>>> I did an strace of the same iterative 'fail:remove' process that
>>>>> mdraid attempts when the kernel issues -- kernel: ata7.00:
>>>>> disabled
>>>>>
>>>>> eg:
>>>>> /sbin/mdadm -If sdc1 --path pci-0000:02:00.0-ata-1
>>>>> mdadm: set device faulty failed for sdc1:  Device or resource busy
>>>>>
>>>>> The only clue is perhaps this line from the strace:
>>>>> openat(AT_FDCWD, "/sys/block/md90/md/dev-sdc1/block/dev", O_RDWR)
>>>>> = -1 EACCES (Permission denied)    What is the mdadm command
>>>>> doing that results in a permission problem?
>>>>>
>>>>> So the only way I can get rid of this md raid array is a reboot.
>>>>> Damn!!!
>>>>>
>>>>>
>>>>> Any help is much appreciated.
>>>>> Aidan
>>>>>
>>>>>
>>>>>
>>>> Hi Aidan,
>>>> This is how it is implemented. Drive is not removed if array failure
>>>> will cause array failed. Please see:
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=9a567843f7ce0037bfd4d5fdc58a09d0a527b28b
>>>>
>>>> For RAID1 you can use solution proposed in patch below but IMO it is
>>>> not your problem. Please stop LVM and then try to stop array. To
>>>> stop array it needs to be "free" (all upper handlers are down).
>>>>
>>>> Thanks,
>>>> Mariusz

-- 
Geoff Back
What if we're all just characters in someone's nightmares?

