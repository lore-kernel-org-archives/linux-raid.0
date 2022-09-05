Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BF5ECAAD3
	for <linux-raid@archiver.kernel.org>; Mon,  5 Sep 2022 19:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiIETg4 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Sep 2022 15:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiIETgy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 5 Sep 2022 15:36:54 -0400
Received: from mail.stoffel.org (li1843-175.members.linode.com [172.104.24.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180044F6B3
        for <linux-raid@vger.kernel.org>; Mon,  5 Sep 2022 12:36:52 -0700 (PDT)
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 3D3242440C;
        Mon,  5 Sep 2022 15:36:51 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id D32D4A7E63; Mon,  5 Sep 2022 15:36:50 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <25366.20434.805504.507324@quad.stoffel.home>
Date:   Mon, 5 Sep 2022 15:36:50 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     Peter Sanders <plsander@gmail.com>
Cc:     John Stoffel <john@stoffel.org>,
        Wols Lists <antlists@youngman.org.uk>,
        Eyal Lebedinsky <fedora@eyal.emu.id.au>,
        linux-raid@vger.kernel.org
Subject: Re: RAID 6, 6 device array - all devices lost superblock
In-Reply-To: <CAKAPSkKX8cBBVHtuiw9N04oU37TMcDfYQb2i4evqaLRxuc74og@mail.gmail.com>
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
        <1d978f6c-e1cc-e928-efc5-11ff167938b1@eyal.emu.id.au>
        <CAKAPSkJhf8hWGTQiCne6BnMPYoum4hJT3diz9U1FGAfq=_N-nA@mail.gmail.com>
        <CAKAPSkK1bTf+7GOxmB-odjr2zej6XBCT_VGhfNC1KnSXZHjeRw@mail.gmail.com>
        <8e994200-146e-61ce-bb4a-f7f111f47b10@youngman.org.uk>
        <CAKAPSkKQA3cV1rcj9cNrdKorOOqyjHf_4BCLxbEx8ibusJP5nA@mail.gmail.com>
        <25359.50842.604856.467479@quad.stoffel.home>
        <CAKAPSkL45hc2kTkZyZwhuMz+Pr+rqP70tARvMz4CzEdTtB1sHw@mail.gmail.com>
        <CAKAPSkKpykx7wCy9Qqc4QjyXAT4MbiRuTEZf2nE0F9eWyW5F4A@mail.gmail.com>
        <25362.21920.20956.599850@quad.stoffel.home>
        <CAKAPSk+jhN-T9ubdFBs6N2k10veT2u5noyQ8NBnRE9igeZgn7g@mail.gmail.com>
        <CAKAPSkKX8cBBVHtuiw9N04oU37TMcDfYQb2i4evqaLRxuc74og@mail.gmail.com>
X-Mailer: VM 8.2.0b under 27.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Peter" == Peter Sanders <plsander@gmail.com> writes:

> tried removing the setup:
> root@superior:/mnt/backup# mdadm --stop /dev/md1
> mdadm: stopped /dev/md1
> root@superior:/mnt/backup#  parallel 'dmsetup remove {/}; rm
> overlay-{/}' ::: $DEVICES
> ^C

> (ran for an hour before cancel... )

> root@superior:/mnt/backup# dmsetup status
> No devices found
> root@superior:/mnt/backupls
> lost+found  overlay-sdb  overlay-sdc  overlay-sdd  overlay-sde
> overlay-sdf  overlay-sdg
> root@superior:/mnt/backup# rm overlay-sd*
> root@superior:/mnt/backup# ls /dev/loop
> ls: cannot access '/dev/loop': No such file or directory
> root@superior:/mnt/backup# ls /dev/loop*
> /dev/loop0  /dev/loop2    /dev/loop4  /dev/loop6    /dev/loop-control
> /dev/loop1  /dev/loop3    /dev/loop5  /dev/loop7
> root@superior:/mnt/backup# parallel losetup -d ::: /dev/loop[0-9]*
> losetup: /dev/loop6: detach failed: No such device or address
> losetup: /dev/loop7: detach failed: No such device or address
> root@superior:/mnt/backup# ls /dev/loop*
> /dev/loop0  /dev/loop2    /dev/loop4  /dev/loop6    /dev/loop-control
> /dev/loop1  /dev/loop3    /dev/loop5  /dev/loop7
> root@superior:/mnt/backup# ls -la /dev/lo*
> lrwxrwxrwx 1 root root      28 Sep  2 20:22 /dev/log ->
> /run/systemd/journal/dev-log
> brw-rw---- 1 root disk  7,   0 Sep  2 20:32 /dev/loop0
> brw-rw---- 1 root disk  7,   1 Sep  2 20:32 /dev/loop1
> brw-rw---- 1 root disk  7,   2 Sep  2 20:32 /dev/loop2
> brw-rw---- 1 root disk  7,   3 Sep  2 20:32 /dev/loop3
> brw-rw---- 1 root disk  7,   4 Sep  2 20:32 /dev/loop4
> brw-rw---- 1 root disk  7,   5 Sep  2 20:32 /dev/loop5
> brw-rw---- 1 root disk  7,   6 Sep  2 20:32 /dev/loop6
> brw-rw---- 1 root disk  7,   7 Sep  2 20:32 /dev/loop7
> crw-rw---- 1 root disk 10, 237 Sep  2 20:32 /dev/loop-control
> root@superior:/mnt/backup# losetup -d ::: /dev/loop70
> losetup: :::: failed to use device: No such device
> root@superior:/mnt/backup# losetup -d ::: /dev/loop7
> losetup: :::: failed to use device: No such device
> root@superior:/mnt/backup# losetup -d  /dev/loop7
> losetup: /dev/loop7: detach failed: No such device or address
> root@superior:/mnt/backup# ls -la /dev/loop*
> brw-rw---- 1 root disk  7,   0 Sep  2 20:32 /dev/loop0
> brw-rw---- 1 root disk  7,   1 Sep  2 20:32 /dev/loop1
> brw-rw---- 1 root disk  7,   2 Sep  2 20:32 /dev/loop2
> brw-rw---- 1 root disk  7,   3 Sep  2 20:32 /dev/loop3
> brw-rw---- 1 root disk  7,   4 Sep  2 20:32 /dev/loop4
> brw-rw---- 1 root disk  7,   5 Sep  2 20:32 /dev/loop5
> brw-rw---- 1 root disk  7,   6 Sep  2 20:32 /dev/loop6
> brw-rw---- 1 root disk  7,   7 Sep  2 20:32 /dev/loop7
> crw-rw---- 1 root disk 10, 237 Sep  2 20:32 /dev/loop-control
> root@superior:/mnt/backup# losetup /dev/loop7
> losetup: /dev/loop7: No such file or directory
> root@superior:/mnt/backup# losetup /dev/loop5
> losetup: /dev/loop5: No such file or directory
> root@superior:/mnt/backup#


> not sure why losetup cannot see the existing /dev/loopx devices.

I was reading the dmsetup man page and it said that if the devices are
open, when you do a remove, it sorta fails them and then blocks them
as unable to have more IO sent to them.  But honestly I'm not an
expert on dmsetup.  

But sure, try to reboot each time, but you also need to make sure the
disks are in the same positions each time after reboot, so look at the
serial numbers.

       lsscsi -g -l 

might be enough to give you unique or instead use:

      hdparm -i /dev/sda | grep SerialNo

to get the info and keep track of which disk is in which order.

John



> On Fri, Sep 2, 2022 at 8:39 PM Peter Sanders <plsander@gmail.com> wrote:
>> 
>> Repeat of run 1
>> 
>> plsander@superior:~$ su -
>> Password:
>> root@superior:~# cat /proc/partitions
>> major minor  #blocks  name
>> 
>> 259        0  250059096 nvme0n1
>> 259        1     496640 nvme0n1p1
>> 259        2          1 nvme0n1p2
>> 259        3   63475712 nvme0n1p5
>> 259        4   97654784 nvme0n1p6
>> 259        5      37888 nvme0n1p7
>> 259        6   86913024 nvme0n1p8
>> 259        7    1474560 nvme0n1p9
>> 8       16 2930266584 sdb
>> 8       80 2930266584 sdf
>> 8        0 1953514584 sda
>> 8        1 1953513472 sda1
>> 8       32 2930266584 sdc
>> 8       96 2930266584 sdg
>> 8       64 2930266584 sde
>> 8       48 2930266584 sdd
>> 11        0    1048575 sr0
>> root@superior:~# cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> unused devices: <none>
>> root@superior:~# DEVICES="/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg"
>> root@superior:~# echo $DEVICES
>> /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg
>> root@superior:~# parallel 'test -e /dev/loop{#} || mknod -m 660
>> /dev/loop{#} b 7 {#}' ::: $DEVICES
>> root@superior:~# ls /dev/lo
>> log           loop2         loop4         loop6
>> loop1         loop3         loop5         loop-control
>> root@superior:~# ls /dev/lo*
>> /dev/log  /dev/loop1  /dev/loop2  /dev/loop3  /dev/loop4  /dev/loop5
>> /dev/loop6  /dev/loop-control
>> root@superior:~# ls -l /dev/loop*
>> brw-rw---- 1 root root  7,   1 Sep  2 20:30 /dev/loop1
>> brw-rw---- 1 root root  7,   2 Sep  2 20:30 /dev/loop2
>> brw-rw---- 1 root root  7,   3 Sep  2 20:30 /dev/loop3
>> brw-rw---- 1 root root  7,   4 Sep  2 20:30 /dev/loop4
>> brw-rw---- 1 root root  7,   5 Sep  2 20:30 /dev/loop5
>> brw-rw---- 1 root root  7,   6 Sep  2 20:30 /dev/loop6
>> crw-rw---- 1 root disk 10, 237 Sep  2 20:22 /dev/loop-control
>> root@superior:~# cd /mnt/backup/
>> root@superior:/mnt/backup# parallel truncate -s4000G overlay-{/} ::: $DEVICES
>> root@superior:/mnt/backup# ls -l
>> total 16
>> drwx------ 2 root root         16384 Aug 28 18:50 lost+found
>> -rw-r--r-- 1 root root 4294967296000 Sep  2 20:31 overlay-sdb
>> -rw-r--r-- 1 root root 4294967296000 Sep  2 20:31 overlay-sdc
>> -rw-r--r-- 1 root root 4294967296000 Sep  2 20:31 overlay-sdd
>> -rw-r--r-- 1 root root 4294967296000 Sep  2 20:31 overlay-sde
>> -rw-r--r-- 1 root root 4294967296000 Sep  2 20:31 overlay-sdf
>> -rw-r--r-- 1 root root 4294967296000 Sep  2 20:31 overlay-sdg
>> root@superior:/mnt/backup# rm over*
>> root@superior:/mnt/backup# parallel truncate -s300G overlay-{/} ::: $DEVICES
>> root@superior:/mnt/backup# ls -la
>> total 24
>> drwxr-xr-x 3 root root         4096 Sep  2 20:31 .
>> drwxr-xr-x 7 root root         4096 Aug 29 09:17 ..
>> drwx------ 2 root root        16384 Aug 28 18:50 lost+found
>> -rw-r--r-- 1 root root 322122547200 Sep  2 20:31 overlay-sdb
>> -rw-r--r-- 1 root root 322122547200 Sep  2 20:31 overlay-sdc
>> -rw-r--r-- 1 root root 322122547200 Sep  2 20:31 overlay-sdd
>> -rw-r--r-- 1 root root 322122547200 Sep  2 20:31 overlay-sde
>> -rw-r--r-- 1 root root 322122547200 Sep  2 20:31 overlay-sdf
>> -rw-r--r-- 1 root root 322122547200 Sep  2 20:31 overlay-sdg
>> root@superior:/mnt/backup# dmsetup status
>> No devices found
>> root@superior:/mnt/backup# date
>> Fri 02 Sep 2022 08:32:11 PM EDT
>> root@superior:/mnt/backup#  parallel 'size=$(blockdev --getsize {});
>> loop=$(losetup -f --show -- overlay-{/}); echo 0 $size snapshot {}
>> $loop P 8 | dmsetup create {/}' ::: $DEVICES
>> root@superior:/mnt/backup# date
>> Fri 02 Sep 2022 08:32:20 PM EDT
>> root@superior:/mnt/backup# dmsetup status
>> sdg: 0 5860533168 snapshot 16/629145600 16
>> sdf: 0 5860533168 snapshot 16/629145600 16
>> sde: 0 5860533168 snapshot 16/629145600 16
>> sdd: 0 5860533168 snapshot 16/629145600 16
>> sdc: 0 5860533168 snapshot 16/629145600 16
>> sdb: 0 5860533168 snapshot 16/629145600 16
>> root@superior:/mnt/backup# OVERLAYS=$(parallel echo /dev/mapper/{/}
>> ::: $DEVICES)
>> root@superior:/mnt/backup# echo $OVERLAYS
>> /dev/mapper/sdb /dev/mapper/sdc /dev/mapper/sdd /dev/mapper/sde
>> /dev/mapper/sdf /dev/mapper/sdg
>> root@superior:/mnt/backup# mdadm --create /dev/md1 --level=raid6 -n 6
>> --assume-clean $OVERLAYS
>> mdadm: partition table exists on /dev/mapper/sdb
>> mdadm: partition table exists on /dev/mapper/sdc
>> mdadm: partition table exists on /dev/mapper/sdc but will be lost or
>> meaningless after creating array
>> mdadm: partition table exists on /dev/mapper/sdd
>> mdadm: partition table exists on /dev/mapper/sdd but will be lost or
>> meaningless after creating array
>> mdadm: partition table exists on /dev/mapper/sde
>> mdadm: partition table exists on /dev/mapper/sde but will be lost or
>> meaningless after creating array
>> mdadm: partition table exists on /dev/mapper/sdf
>> mdadm: partition table exists on /dev/mapper/sdf but will be lost or
>> meaningless after creating array
>> mdadm: partition table exists on /dev/mapper/sdg
>> mdadm: partition table exists on /dev/mapper/sdg but will be lost or
>> meaningless after creating array
>> Continue creating array? y
>> mdadm: Defaulting to version 1.2 metadata
>> mdadm: array /dev/md1 started.
>> root@superior:/mnt/backup# ls -l /dev/md*
>> brw-rw---- 1 root disk 9, 1 Sep  2 20:34 /dev/md1
>> root@superior:/mnt/backup# fsck /dev/md1
>> fsck from util-linux 2.36.1
>> e2fsck 1.46.2 (28-Feb-2021)
>> ext2fs_open2: Bad magic number in super-block
>> fsck.ext2: Superblock invalid, trying backup blocks...
>> fsck.ext2: Bad magic number in super-block while trying to open /dev/md1
>> 
>> The superblock could not be read or does not describe a valid ext2/ext3/ext4
>> filesystem.  If the device is valid and it really contains an ext2/ext3/ext4
>> filesystem (and not swap or ufs or something else), then the superblock
>> is corrupt, and you might try running e2fsck with an alternate superblock:
>> e2fsck -b 8193 <device>
>> or
>> e2fsck -b 32768 <device>
>> 
>> root@superior:/mnt/backup# blkid /dev/md1
>> root@superior:/mnt/backup#
>> root@superior:/mnt/backup# cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md1 : active raid6 dm-3[5] dm-2[4] dm-1[3] dm-5[2] dm-0[1] dm-4[0]
>> 11720536064 blocks super 1.2 level 6, 512k chunk, algorithm 2
>> [6/6] [UUUUUU]
>> bitmap: 0/22 pages [0KB], 65536KB chunk
>> 
>> unused devices: <none>
>> root@superior:/mnt/backup#
>> 
>> Some questions -
>> - is the easiest 'reset for next run' to reboot and rebuild?
>> 
>> 
>> On Fri, Sep 2, 2022 at 3:12 PM John Stoffel <john@stoffel.org> wrote:
>> >
>> > >>>>> "Peter" == Peter Sanders <plsander@gmail.com> writes:
>> >
>> > Peter, please include the output of all the commands, not just the
>> > commands themselves.  See my comments below.
>> >
>> >
>> > > Question on restarting from scratch...
>> > > How to reset to the starting point?
>> >
>> > I think you need to blow away the loop devices and re-create them.
>> >
>> > Or at least blow away the dmsetup devices you just created.
>> >
>> > It might be quickest to just reboot.  What OS are you using for the
>> > recovery?  Is it a recent live image?  Sorry for asking so many
>> > questions... some of this is new to me too.
>> >
>> >
>> > > dmsetup, both for remove and create of the overlay seems to be hanging.
>> >
>> > > On Fri, Sep 2, 2022 at 10:56 AM Peter Sanders <plsander@gmail.com> wrote:
>> > >>
>> > >> contents of /proc/mdstat
>> > >>
>> > >> root@superior:/mnt/backup# cat /proc/mdstat
>> > >> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> > >> [raid4] [raid10]
>> > >> unused devices: <none>
>> > >> root@superior:/mnt/backup#
>> > >>
>> > >>
>> > >>
>> > >> Here are the steps I ran (minus some mounting other devices and
>> > >> looking around for mdadm tracks on the old os disk)
>> > >>
>> > >> 410  DEVICES=$(cat /proc/partitions | parallel --tagstring {5}
>> > >> --colsep ' +' mdadm -E /dev/{5} |grep $UUID | parallel --colsep '\t'
>> > >> echo /dev/{1})
>> > >> 411  apt install parallel
>> > >> 412  DEVICES=$(cat /proc/partitions | parallel --tagstring {5}
>> > >> --colsep ' +' mdadm -E /dev/{5} |grep $UUID | parallel --colsep '\t'
>> > >> echo /dev/{1})
>> > >> 413  echo $DEVICES
>> >
>> > So you found no MD RAID super blocks on any of the base devices.  You
>> > can skip this step moving forward.
>> >
>> > >> 414  cat /proc/partitions
>> > >> 415  DEVICES=/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg
>> > >> 416  DEVICES="/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg"
>> > >> 417  echo $DEVICES
>> > >> 418  parallel 'test -e /dev/loop{#} || mknod -m 660 /dev/loop{#} b 7
>> > >> {#}' ::: $DEVICES
>> > >> 419  ls /dev/loop*
>> >
>> > Can you show the output of all these commands, not just the commands please?
>> >
>> > >> 423  parallel truncate -s300G overlay-{/} ::: $DEVICES
>> >
>> > >> 427  parallel 'size=$(blockdev --getsize {}); loop=$(losetup -f
>> > >> --show -- overlay-{/}); echo 0 $size snapshot {} $loop P 8 | dmsetup
>> > >> create {/}' ::: $DEVICES
>> > >> 428  ls /dev/mapper/
>> >
>> > This is some key output to view.
>> >
>> > >> 429  OVERLAYS=$(parallel echo /dev/mapper/{/} ::: $DEVICES)
>> > >> 430  echo $OVERLAYS
>> >
>> > What are the overlays?
>> >
>> > >> 431  dmsetup status
>> >
>> > What did this command show?
>> >
>> > >> 432  mdadm --assemble --force /dev/md1 $OVERLAYS
>> >
>> > And here is where I think you need to put --assume-clean when using
>> > 'create' command instead.  It's not going to assemble anything because
>> > the info was wiped.  I *think* you really want:
>> >
>> >    mdadm --create /dev/md1 --level=raid6 -n 6 --assume-clean $OVERLAYS
>> >
>> > And once you do this above command and it comes back, do:
>> >
>> >     cat /proc/mdstat
>> >
>> > and show all the output please!
>> >
>> > >> 433  history
>> > >> 434  dmsetup status
>> > >> 435  echo $OVERLAYS
>> > >> 436  mdadm --assemble --force /dev/md0 $OVERLAYS
>> > >> 437  cat /proc/partitions
>> > >> 438  mkdir /mnt/oldroot
>> > >> << look for inird mdadm files >>
>> > >> 484  echo $OVERLAYS
>> > >> 485  mdadm --create /dev/md0 --level=raid6 -n 6 /dev/mapper/sdb
>> > >> /dev/mapper/sdc /dev/mapper/sdd /dev/mapper/sde /dev/mapper/sdf
>> > >> /dev/mapper/sdg
>> >
>> > I'm confused here, what  is the difference between the md1 you
>> > assembled above, and the md0 you're doing here?
>> >
>> > >> << cancelled out of 485, review instructions... >>
>> > >> 486  mdadm --create /dev/md0 --level=raid6 -n 6 /dev/mapper/sdb
>> > >> /dev/mapper/sdc /dev/mapper/sdd /dev/mapper/sde /dev/mapper/sdf
>> > >> /dev/mapper/sdg
>> > >> 487  fsck -n /dev/md0
>> >
>> > And what output did you get here?  Did it find a filesystem?  You might want
>> > to try:
>> >
>> >    blkid /dev/md0
>> >
>> >
>> > >> 488  mdadm --stop /dev/md0
>> > >> 489  echo $DEVICES
>> > >> 490   parallel 'dmsetup remove {/}; rm overlay-{/}' ::: $DEVICES
>> > >> 491  dmsetup status
>> >
>> > This all worked properly?  No errors?
>> >
>> > I gave up after this because it's not clear what the results really
>> > are.  If you don't find a filesystem that fsck's cleanly, then you
>> > should just need to stop the array, then re-create it but shuffle the
>> > order of the devices.
>> >
>> > Instead of disk in order of "sdb sdc sdd... sdN", you would try the
>> > order "sdc sdd ... sdN sdb".   See how I moved sdb to the end of the
>> > list of devices?  With six disks, you have I think 6 factorial options
>> > to try.   Which is alot of options to go though, and why you need to
>> > automate this more.  But also keep a log and show the output!
>> >
>> > John
>> >
>> >
>> > >> 492  ls
>> > >> 493  rm overlay-*
>> > >> 494  ls
>> > >> 495  parallel losetup -d ::: /dev/loop[0-9]*
>> > >> 496  parallel 'test -e /dev/loop{#} || mknod -m 660 /dev/loop{#} b 7
>> > >> {#}' ::: $DEVICES
>> > >> 497  parallel truncate -s300G overlay-{/} ::: $DEVICES
>> > >> 498  parallel 'size=$(blockdev --getsize {}); loop=$(losetup -f
>> > >> --show -- overlay-{/}); echo 0 $size snapshot {} $loop P 8 | dmsetup
>> > >> create {/}' ::: $DEVICES
>> > >> 499  dmsetup status
>> > >> 500  /sbin/reboot
>> > >> 501  history
>> > >> 502  dmsetup status
>> > >> 503  mount
>> > >> 504  cat /proc/partitions
>> > >> 505  nano /etc/fstab
>> > >> 506  mount /mnt/backup/
>> > >> 507  ls /mnt/backup/
>> > >> 508  rm /mnt/backup/
>> > >> 509  rm /mnt/backup/overlay-sd*
>> > >> 510  emacs setupOverlay &
>> > >> 511  ps auxww | grep emacs
>> > >> 512  kill 65017
>> > >> 513  ls /dev/loo*
>> > >> 514  DEVICES='/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg'
>> > >> 515  echo $DEVICES
>> > >> 516   parallel 'test -e /dev/loop{#} || mknod -m 660 /dev/loop{#} b
>> > >> 7 {#}' ::: $DEVICES
>> > >> 517  ls /dev/loo*
>> > >> 518  parallel truncate -s4000G overlay-{/} ::: $DEVICES
>> > >> 519  ls
>> > >> 520  rm overlay-sd*
>> > >> 521  cd /mnt/bak
>> > >> 522  cd /mnt/backup/
>> > >> 523  ls
>> > >> 524  parallel truncate -s4000G overlay-{/} ::: $DEVICES
>> > >> 525  ls -la
>> > >> 526  blockdev --getsize /dev/sdb
>> > >> 527  man losetup
>> > >> 528  man losetup
>> > >> 529  parallel 'size=$(blockdev --getsize {}); loop=$(losetup -f
>> > >> --show -- overlay-{/}); echo 0 $size snapshot {} $loop P 8 | dmsetup
>> > >> create {/}' ::: $DEVICES
>> > >> 530  dmsetup status
>> > >> 531  history | grep mdadm
>> > >> 532  history
>> > >> 533  dmsetup status
>> > >> 534  history | grep dmsetup
>> > >> 535  dmsetup status
>> > >> 536  dmsetup remove sdg
>> > >> 537  dmsetup ls --tree
>> > >> 538  lsof
>> > >> 539  dmsetup ls --tre
>> > >> 540  dmsetup ls --tree
>> > >> 541  lsof | grep -i sdg
>> > >> 542  lsof | grep -i sdf
>> > >> 543  history |grep dmsetup | less
>> > >> 544  dmsetup status
>> > >> 545  history > ~plsander/Documents/raidIssues/joblog
>> > >>
>> > >> On Wed, Aug 31, 2022 at 4:37 PM John Stoffel <john@stoffel.org> wrote:
>> > >> >
>> > >> > >>>>> "Peter" == Peter Sanders <plsander@gmail.com> writes:
>> > >> >
>> > >> > > encountering a puzzling situation.
>> > >> > > dmsetup is failing to return.
>> > >> >
>> > >> > I don't think you need to use dmsetup in your case, but can you post
>> > >> > *all* the commands you ran before you got to this point, and the
>> > >> > output of
>> > >> >
>> > >> >        cat /proc/mdstat
>> > >> >
>> > >> > as well?  Thinking on this some more, you might need to actually also
>> > >> > add:
>> > >> >
>> > >> >         --assume-clean
>> > >> >
>> > >> > to the 'mdadm create ....' string, since you don't want it to zero the
>> > >> > array or anything.
>> > >> >
>> > >> > Sorry for not remembering this at the time!
>> > >> >
>> > >> > So if you can, please just start over from scratch, showing the setup
>> > >> > of the loop devices, the overlayfs setup, and the building the RAID6
>> > >> > array, along with the cat /proc/mdstat after you do the initial build.
>> > >> >
>> > >> > John
>> > >> >
>> > >> > P.S.  For those who hated my email citing tool, I pulled it out for
>> > >> > now.  Only citing with > now.  :-)
>> > >> >
>> > >> > > root@superior:/mnt/backup# dmsetup status
>> > >> > > sdg: 0 5860533168 snapshot 16/8388608000 16
>> > >> > > sdf: 0 5860533168 snapshot 16/8388608000 16
>> > >> > > sde: 0 5860533168 snapshot 16/8388608000 16
>> > >> > > sdd: 0 5860533168 snapshot 16/8388608000 16
>> > >> > > sdc: 0 5860533168 snapshot 16/8388608000 16
>> > >> > > sdb: 0 5860533168 snapshot 16/8388608000 16
>> > >> >
>> > >> > > dmsetup remove sdg  runs for hours.
>> > >> > > Canceled it, ran dmsetup ls --tree and find that sdg is not present in the list.
>> > >> >
>> > >> > > dmsetup status shows:
>> > >> > > sdf: 0 5860533168 snapshot 16/8388608000 16
>> > >> > > sde: 0 5860533168 snapshot 16/8388608000 16
>> > >> > > sdd: 0 5860533168 snapshot 16/8388608000 16
>> > >> > > sdc: 0 5860533168 snapshot 16/8388608000 16
>> > >> > > sdb: 0 5860533168 snapshot 16/8388608000 16
>> > >> >
>> > >> > > dmsetup ls --tree
>> > >> > > root@superior:/mnt/backup# dmsetup ls --tree
>> > >> > > sdf (253:3)
>> > >> > >  ├─ (7:3)
>> > >> > >  └─ (8:80)
>> > >> > > sde (253:1)
>> > >> > >  ├─ (7:1)
>> > >> > >  └─ (8:64)
>> > >> > > sdd (253:2)
>> > >> > >  ├─ (7:2)
>> > >> > >  └─ (8:48)
>> > >> > > sdc (253:0)
>> > >> > >  ├─ (7:0)
>> > >> > >  └─ (8:32)
>> > >> > > sdb (253:5)
>> > >> > >  ├─ (7:5)
>> > >> > >  └─ (8:16)
>> > >> >
>> > >> > > any suggestions?
>> > >> >
>> > >> >
>> > >> >
>> > >> > > On Tue, Aug 30, 2022 at 2:03 PM Wols Lists <antlists@youngman.org.uk> wrote:
>> > >> > >>
>> > >> > >> On 30/08/2022 14:27, Peter Sanders wrote:
>> > >> > >> >
>> > >> > >> > And the victory conditions would be a mountable file system that passes a fsck?
>> > >> > >>
>> > >> > >> Yes. Just make sure you delve through the file system a bit and satisfy
>> > >> > >> yourself it looks good, too ...
>> > >> > >>
>> > >> > >> Cheers,
>> > >> > >> Wol
