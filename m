Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39F0C19F2D
	for <linux-raid@archiver.kernel.org>; Sat, 13 Aug 2022 23:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiHMXCv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 13 Aug 2022 19:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiHMXCr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 13 Aug 2022 19:02:47 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF317FE4A
        for <linux-raid@vger.kernel.org>; Sat, 13 Aug 2022 16:02:44 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id x7-20020a4aaf47000000b0044884ebb925so749842oon.2
        for <linux-raid@vger.kernel.org>; Sat, 13 Aug 2022 16:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc;
        bh=z0b93M/udZ+6Xo7daYm8PwKqXMeV+96qTzVJOQ4GjGw=;
        b=qK1m58z3TjOsypybxLxbNbqFowzQep0NI/6FO/QAzvofpEExdGW+NoRzw3HIw8URrn
         xbsyY9utQwjBnvx2iJdSHuT3AsazaLwktDx1prSnh+jEmvVFOwaduMA9taMEDxNRafY4
         //Uye/tX1625GKNngxueqmivuCaGkU6I6TYw2GDBAe39wbARl8Jygb/gRYc264b7HSuQ
         1NltwZLqhQhZQQ7ZZbDjgXzs4soO1C2yjZuC8JjhsXJvDAlOwDT392i11XLsD77nLL33
         fCImUCwrfwLPSy0bchccjc38WzOAkuqr9/veV4sZ5B+p7UjWWPusChiHJLj3wj00GCE+
         J3iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc;
        bh=z0b93M/udZ+6Xo7daYm8PwKqXMeV+96qTzVJOQ4GjGw=;
        b=al9lke3uKSk2pgWHYbplcWqk3UUrkAUZANUl3EqgAEwPH7gx9JnNjdXpS6sUJEJvaT
         t+0bf1Af2dZYYe9IP8Vz1E68v+5oaDe09KBMLhcFVuJafE6hlsdToAxZdaBzorWfDGT5
         GcGR3mJdMPVD0pMdsCcCvlUFMbWOjSHijsgNuJgPWYvdLYgYnC03qnkXVo7w+9O80sAN
         kM/O22N0Cd8ZoNCTmO8AnjwNYz8hk2CBs7HNp/BRPaJS5O7KxIRHK1aDSPpRONQvgySC
         Lrmx83M1LGAwjCZVq1X2Zgqss+M0rM2Y8GKi6ypRWtZvWD/RmNL+pz8AfBAIu+yo5xYx
         IGWQ==
X-Gm-Message-State: ACgBeo3oD5/73soHQh9OCcs9aSNiycqAYaAwVqwmJJ4MZFaIucxunv9t
        X9548kZCU3sNz11OcMuPSByFFJkHn1txLW9OtYi8PD2v
X-Google-Smtp-Source: AA6agR5dlBp1W1h/1WZmTGrLv88cyzN7KklX7NovqgJ9C4Dz00P7a39q1GCtmEaRG4IgZAnxV5+7lwsPFqBHusMQE0s=
X-Received: by 2002:a4a:e1db:0:b0:448:e5c2:592 with SMTP id
 n27-20020a4ae1db000000b00448e5c20592mr3117290oot.45.1660431763458; Sat, 13
 Aug 2022 16:02:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAGRSmLt0gMZ6_XUE_24tEZaKHB1tviANpZKVs+Jsr5OiE22y8Q@mail.gmail.com>
In-Reply-To: <CAGRSmLt0gMZ6_XUE_24tEZaKHB1tviANpZKVs+Jsr5OiE22y8Q@mail.gmail.com>
From:   "David F." <df7729@gmail.com>
Date:   Sat, 13 Aug 2022 16:02:32 -0700
Message-ID: <CAGRSmLvJTtW=fbYN+F523V9Sngim2wZK+6VaxaNdraRdX+6saA@mail.gmail.com>
Subject: Re: mdadm not assembling RAID?
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

So it does have something to with the mapper devices.   If I add
"nodmraid" kernel parameter then mdadm raid works like it did before.
 I want searching config parameters for the kernel to see if I enabled
DMRAID somehow but didn't find any.   Why is the new disk/updated
programs automatically starting dmraid?   could it be udev rules .. I
don't really understand them .. but dmraid is an option for non intel
type raid, so what happens is dmraid is tried first for all but the
intel items, then mdadm is used.  But this is not coming from my call
of dmraid, it's coming from someplace automatic ??

On Sat, Aug 13, 2022 at 12:58 PM David F. <df7729@gmail.com> wrote:
>
> I have an older system with Intel RAID (striped) I use to test updates
> to my linux boot disk to ensure the RAID is still working.  I just
> went through a big update of all the utilities and shared libraries
> along with moving from 5.10 to 5.15 kernel.  There was a stage where
> the kernel was updated to 5.15 but all the utilities and shared
> libraries were not (and md raid was working).  The problem is now
> there are no md devices created, but there are a bunch of dm devices
> created that never were before.
>
> This group has been very helpful in the past.  I hope you can help
> with what is going on here?  Does it have something to do with the
> updated devmapper ?  Should I revert?
>
> I put both the old working information and the new information below -
> separated by the 3 lines of equals.
>
>
> ============================================================
> ============================================================
> ============================================================
>
> Here's the old boot information where it works (5.10.x kernel):
>
> Contents of /sys/block:
> fd0    loop1  loop3  loop5  loop7  md127  sdb    sr0
> loop0  loop2  loop4  loop6  md126  sda    sdc
>
> Contents of /dev:
> block            md126p4          tty19            tty57
> bsg              md126p5          tty2             tty58
> btrfs-control    md127            tty20            tty59
> bus              mem              tty21            tty6
> cdrom            null             tty22            tty60
> cdrw             port             tty23            tty61
> char             psaux            tty24            tty62
> console          ptmx             tty25            tty63
> core             pts              tty26            tty7
> cpu_dma_latency  random           tty27            tty8
> disk             rfkill           tty28            tty9
> dvd              rtc              tty29            ttyS0
> fb0              rtc0             tty3             ttyS1
> fd               sda              tty30            ttyS2
> fd0              sda1             tty31            ttyS3
> full             sda2             tty32            urandom
> fuse             sda3             tty33            vcs
> fw0              sda5             tty34            vcs1
> hidraw0          sdb              tty35            vcs2
> hidraw1          sdc              tty36            vcs3
> hidraw2          sdc1             tty37            vcs4
> hidraw3          sg0              tty38            vcs5
> hpet             sg1              tty39            vcs6
> input            sg2              tty4             vcsa
> kmsg             sg3              tty40            vcsa1
> lightnvm         sr0              tty41            vcsa2
> log              stderr           tty42            vcsa3
> loop-control     stdin            tty43            vcsa4
> loop0            stdout           tty44            vcsa5
> loop1            synth            tty45            vcsa6
> loop2            tty              tty46            vcsu
> loop3            tty0             tty47            vcsu1
> loop4            tty1             tty48            vcsu2
> loop5            tty10            tty49            vcsu3
> loop6            tty11            tty5             vcsu4
> loop7            tty12            tty50            vcsu5
> mapper           tty13            tty51            vcsu6
> md               tty14            tty52            vga_arbiter
> md126            tty15            tty53            zero
> md126p1          tty16            tty54
> md126p2          tty17            tty55
> md126p3          tty18            tty56
>
> Contents of /proc/partitions:
> major minor  #blocks  name
>
>    2        0          4 fd0
>   11        0    1048575 sr0
>    8        0  244198584 sda
>    8        1   32684242 sda1
>    8        2          1 sda2
>    8        3     514048 sda3
>    8        5    2088418 sda5
>    8       16  732574584 sdb
>    8       32    7897088 sdc
>    8       33    7895916 sdc1
>    9      126  488391680 md126
>  259        0   32684242 md126p1
>  259        1          1 md126p2
>  259        2     514048 md126p3
>  259        3       8032 md126p4
>  259        4   10040593 md126p5
>
> Contents of /proc/mdstat (Linux software RAID status):
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
> [raid4] [multipath]
> md126 : active raid0 sda[1] sdb[0]
>       488391680 blocks super external:/md127/0 128k chunks
>
> md127 : inactive sda[1](S) sdb[0](S)
>       7945 blocks super external:imsm
>
> unused devices: <none>
>
> Contents of /run/mdadm/map (Linux software RAID arrays):
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> md126 /md127/0 835de710:3d35bfb1:d159af46:6570f120 /dev/md/TestRAID
> md127 imsm 788c3635:2e37de4b:87d08323:987f57e5 /dev/md/imsm0
>
> Contents of /etc/mdadm/mdadm.conf (Linux software RAID config file):
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> # mdadm.conf
> #
> # Please refer to mdadm.conf(5) for information about this file.
> #
>
> # by default (built-in), scan all partitions (/proc/partitions) and all
> # containers for MD superblocks. alternatively, specify devices to scan, using
> # wildcards if desired.
> DEVICE partitions containers
>
> # automatically tag new arrays as belonging to the local system
> HOMEHOST <system>
>
> ARRAY metadata=imsm UUID=788c3635:2e37de4b:87d08323:987f57e5
> ARRAY /dev/md/TestRAID container=788c3635:2e37de4b:87d08323:987f57e5
> member=0 UUID=835de710:3d35bfb1:d159af46:6570f120
>
> Long listing of /dev/md directory and /dev/md* device files (Linux
> software RAID devices):
> brw-rw----    1 root     disk        9, 126 Aug 13 04:17 /dev/md126
> brw-rw----    1 root     disk      259,   0 Aug 13 04:17 /dev/md126p1
> brw-rw----    1 root     disk      259,   1 Aug 13 04:17 /dev/md126p2
> brw-rw----    1 root     disk      259,   2 Aug 13 04:17 /dev/md126p3
> brw-rw----    1 root     disk      259,   3 Aug 13 04:17 /dev/md126p4
> brw-rw----    1 root     disk      259,   4 Aug 13 04:17 /dev/md126p5
> brw-rw----    1 root     disk        9, 127 Aug 13 04:17 /dev/md127
>
> /dev/md:
> lrwxrwxrwx    1 root     root             8 Aug 13 04:17 TestRAID -> ../md126
> lrwxrwxrwx    1 root     root            10 Aug 13 04:17 TestRAID1 -> ../md126p1
> lrwxrwxrwx    1 root     root            10 Aug 13 04:17 TestRAID2 -> ../md126p2
> lrwxrwxrwx    1 root     root            10 Aug 13 04:17 TestRAID3 -> ../md126p3
> lrwxrwxrwx    1 root     root            10 Aug 13 04:17 TestRAID4 -> ../md126p4
> lrwxrwxrwx    1 root     root            10 Aug 13 04:17 TestRAID5 -> ../md126p5
> lrwxrwxrwx    1 root     root             8 Aug 13 04:17 imsm0 -> ../md127
>
> Contents of /tbu/utility/mdadm.txt (mdadm troubleshooting data
> captured when 'start-md' is executed):
> mdadm - v4.1 - 2018-10-01
> Output of 'mdadm --examine --scan'
> ARRAY metadata=imsm UUID=788c3635:2e37de4b:87d08323:987f57e5
> ARRAY /dev/md/TestRAID container=788c3635:2e37de4b:87d08323:987f57e5
> member=0 UUID=835de710:3d35bfb1:d159af46:6570f120
> Output of 'mdadm --assemble --scan --no-degraded -v'
> mdadm: looking for devices for further assembly
> mdadm: no RAID superblock on /dev/sdc1
> mdadm: /dev/sdc is not attached to Intel(R) RAID controller.
> mdadm: No OROM/EFI properties for /dev/sdc
> mdadm: no RAID superblock on /dev/sdc
> mdadm: no RAID superblock on /dev/sda5
> mdadm: no RAID superblock on /dev/sda3
> mdadm: no RAID superblock on /dev/sda2
> mdadm: no RAID superblock on /dev/sda1
> mdadm: /dev/sdb is identified as a member of /dev/md/imsm0, slot 1.
> mdadm: /dev/sda is identified as a member of /dev/md/imsm0, slot 0.
> mdadm: added /dev/sdb to /dev/md/imsm0 as 1
> mdadm: added /dev/sda to /dev/md/imsm0 as 0
> mdadm: Container /dev/md/imsm0 has been assembled with 2 drives
> mdadm: looking for devices for /dev/md/TestRAID
> mdadm: looking in container /dev/md/imsm0
> mdadm: found match on member /md127/0 in /dev/md/imsm0
> mdadm: Started /dev/md/TestRAID with 2 devices
> Output of 'dmesg | grep md:'
> md: md127 stopped.
> md: md126 stopped.
>
>
> Output of 'mdadm --examine /dev/sda'
> /dev/sda:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.0.00
>     Orig Family : a209f7f5
>          Family : a209f7f5
>      Generation : 0000016d
>      Attributes : All supported
>            UUID : 788c3635:2e37de4b:87d08323:987f57e5
>        Checksum : 7cb36503 correct
>     MPB Sectors : 1
>           Disks : 2
>    RAID Devices : 1
>
>   Disk00 Serial : WD-WCANK2656465
>           State : active
>              Id : 00000000
>     Usable Size : 488391680 (232.88 GiB 250.06 GB)
>
> [TestRAID]:
>            UUID : 835de710:3d35bfb1:d159af46:6570f120
>      RAID Level : 0
>         Members : 2
>           Slots : [UU]
>     Failed disk : none
>       This Slot : 0
>     Sector Size : 512
>      Array Size : 976783360 (465.77 GiB 500.11 GB)
>    Per Dev Size : 488391944 (232.88 GiB 250.06 GB)
>   Sector Offset : 0
>     Num Stripes : 1907780
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : normal
>     Dirty State : clean
>      RWH Policy : off
>
>   Disk01 Serial : 3QK01SE5
>           State : active
>              Id : 00010000
>     Usable Size : 1465143680 (698.63 GiB 750.15 GB)
>
>
> Output of 'mdadm --examine /dev/sdb'
> /dev/sdb:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.0.00
>     Orig Family : a209f7f5
>          Family : a209f7f5
>      Generation : 0000016d
>      Attributes : All supported
>            UUID : 788c3635:2e37de4b:87d08323:987f57e5
>        Checksum : 7cb36503 correct
>     MPB Sectors : 1
>           Disks : 2
>    RAID Devices : 1
>
>   Disk01 Serial : 3QK01SE5
>           State : active
>              Id : 00010000
>     Usable Size : 1465138766 (698.63 GiB 750.15 GB)
>
> [TestRAID]:
>            UUID : 835de710:3d35bfb1:d159af46:6570f120
>      RAID Level : 0
>         Members : 2
>           Slots : [UU]
>     Failed disk : none
>       This Slot : 1
>     Sector Size : 512
>      Array Size : 976783360 (465.77 GiB 500.11 GB)
>    Per Dev Size : 488391944 (232.88 GiB 250.06 GB)
>   Sector Offset : 0
>     Num Stripes : 1907780
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : normal
>     Dirty State : clean
>      RWH Policy : off
>
>   Disk00 Serial : WD-WCANK2656465
>           State : active
>              Id : 00000000
>     Usable Size : 488386766 (232.88 GiB 250.05 GB)
>
>
> Output of 'mdadm --examine /dev/sdc'
> /dev/sdc:
>    MBR Magic : aa55
> Partition[0] :     15791832 sectors at           63 (type 0b)
>
>
> Output of 'mdadm --detail /dev/md*', if any:
> mdadm: /dev/md does not appear to be an md device
> /dev/md126:
>          Container : /dev/md/imsm0, member 0
>         Raid Level : raid0
>         Array Size : 488391680 (465.77 GiB 500.11 GB)
>       Raid Devices : 2
>      Total Devices : 2
>
>              State : clean
>     Active Devices : 2
>    Working Devices : 2
>     Failed Devices : 0
>      Spare Devices : 0
>
>         Chunk Size : 128K
>
> Consistency Policy : none
>
>
>               UUID : 835de710:3d35bfb1:d159af46:6570f120
>     Number   Major   Minor   RaidDevice State
>        1       8        0        0      active sync   /dev/sda
>        0       8       16        1      active sync   /dev/sdb
> /dev/md126p1:
>          Container : /dev/md/imsm0, member 0
>         Raid Level : raid0
>         Array Size : 32684242 (31.17 GiB 33.47 GB)
>       Raid Devices : 2
>      Total Devices : 2
>
>              State : clean
>     Active Devices : 2
>    Working Devices : 2
>     Failed Devices : 0
>      Spare Devices : 0
>
>         Chunk Size : 128K
>
> Consistency Policy : none
>
>
>               UUID : 835de710:3d35bfb1:d159af46:6570f120
>     Number   Major   Minor   RaidDevice State
>        1       8        0        0      active sync   /dev/sda
>        0       8       16        1      active sync   /dev/sdb
> /dev/md126p2:
>          Container : /dev/md/imsm0, member 0
>         Raid Level : raid0
>         Array Size : 1
>       Raid Devices : 2
>      Total Devices : 2
>
>              State : clean
>     Active Devices : 2
>    Working Devices : 2
>     Failed Devices : 0
>      Spare Devices : 0
>
>         Chunk Size : 128K
>
> Consistency Policy : none
>
>
>               UUID : 835de710:3d35bfb1:d159af46:6570f120
>     Number   Major   Minor   RaidDevice State
>        1       8        0        0      active sync   /dev/sda
>        0       8       16        1      active sync   /dev/sdb
> /dev/md126p3:
>          Container : /dev/md/imsm0, member 0
>         Raid Level : raid0
>         Array Size : 514048 (502.00 MiB 526.39 MB)
>       Raid Devices : 2
>      Total Devices : 2
>
>              State : clean
>     Active Devices : 2
>    Working Devices : 2
>     Failed Devices : 0
>      Spare Devices : 0
>
>         Chunk Size : 128K
>
> Consistency Policy : none
>
>
>               UUID : 835de710:3d35bfb1:d159af46:6570f120
>     Number   Major   Minor   RaidDevice State
>        1       8        0        0      active sync   /dev/sda
>        0       8       16        1      active sync   /dev/sdb
> /dev/md126p4:
>          Container : /dev/md/imsm0, member 0
>         Raid Level : raid0
>         Array Size : 8032 (7.84 MiB 8.23 MB)
>       Raid Devices : 2
>      Total Devices : 2
>
>              State : clean
>     Active Devices : 2
>    Working Devices : 2
>     Failed Devices : 0
>      Spare Devices : 0
>
>         Chunk Size : 128K
>
> Consistency Policy : none
>
>
>               UUID : 835de710:3d35bfb1:d159af46:6570f120
>     Number   Major   Minor   RaidDevice State
>        1       8        0        0      active sync   /dev/sda
>        0       8       16        1      active sync   /dev/sdb
> /dev/md126p5:
>          Container : /dev/md/imsm0, member 0
>         Raid Level : raid0
>         Array Size : 10040593 (9.58 GiB 10.28 GB)
>       Raid Devices : 2
>      Total Devices : 2
>
>              State : clean
>     Active Devices : 2
>    Working Devices : 2
>     Failed Devices : 0
>      Spare Devices : 0
>
>         Chunk Size : 128K
>
> Consistency Policy : none
>
>
>               UUID : 835de710:3d35bfb1:d159af46:6570f120
>     Number   Major   Minor   RaidDevice State
>        1       8        0        0      active sync   /dev/sda
>        0       8       16        1      active sync   /dev/sdb
> /dev/md127:
>            Version : imsm
>         Raid Level : container
>      Total Devices : 2
>
>    Working Devices : 2
>
>
>               UUID : 788c3635:2e37de4b:87d08323:987f57e5
>      Member Arrays : /dev/md/TestRAID
>
>     Number   Major   Minor   RaidDevice
>
>        -       8        0        -        /dev/sda
>        -       8       16        -        /dev/sdb
>
> Contents of /dev/mapper directory:
> crw-------    1 root     root       10, 236 Aug 13 04:17 control
>
> ============================================================
> ============================================================
> ============================================================
> ============================================================
>
> Here is the new version that doesn't work (5.15.x kernel):
>
> Contents of /sys/block:
> dm-0   dm-2   dm-5   loop0  loop2  loop4  loop6  sda    sdc
> dm-1   dm-4   fd0    loop1  loop3  loop5  loop7  sdb    sr0
>
> Contents of /dev:
> block            mem              tty20            tty58
> bsg              null             tty21            tty59
> btrfs-control    port             tty22            tty6
> bus              psaux            tty23            tty60
> cdrom            ptmx             tty24            tty61
> cdrw             pts              tty25            tty62
> char             random           tty26            tty63
> console          rfkill           tty27            tty7
> core             rtc              tty28            tty8
> cpu_dma_latency  rtc0             tty29            tty9
> disk             sda              tty3             ttyS0
> dm-0             sda1             tty30            ttyS1
> dm-1             sda2             tty31            ttyS2
> dm-2             sda3             tty32            ttyS3
> dm-4             sda5             tty33            urandom
> dm-5             sdb              tty34            vcs
> dvd              sdc              tty35            vcs1
> fb0              sdc1             tty36            vcs2
> fd               sg0              tty37            vcs3
> fd0              sg1              tty38            vcs4
> full             sg2              tty39            vcs5
> fuse             sg3              tty4             vcs6
> fw0              sr0              tty40            vcsa
> hidraw0          stderr           tty41            vcsa1
> hidraw1          stdin            tty42            vcsa2
> hidraw2          stdout           tty43            vcsa3
> hidraw3          synth            tty44            vcsa4
> hpet             tty              tty45            vcsa5
> input            tty0             tty46            vcsa6
> kmsg             tty1             tty47            vcsu
> log              tty10            tty48            vcsu1
> loop-control     tty11            tty49            vcsu2
> loop0            tty12            tty5             vcsu3
> loop1            tty13            tty50            vcsu4
> loop2            tty14            tty51            vcsu5
> loop3            tty15            tty52            vcsu6
> loop4            tty16            tty53            vga_arbiter
> loop5            tty17            tty54            zero
> loop6            tty18            tty55
> loop7            tty19            tty56
> mapper           tty2             tty57
>
> Contents of /proc/partitions:
> major minor  #blocks  name
>
>    2        0          4 fd0
>   11        0    1048575 sr0
>    8       16  732574584 sdb
>    8        0  244198584 sda
>    8        1   32684242 sda1
>    8        2          1 sda2
>    8        3     514048 sda3
>    8        5    2088418 sda5
>  252        0  488391936 dm-0
>  252        1   32684242 dm-1
>  252        2     514048 dm-2
>  252        4       8032 dm-4
>  252        5   10040593 dm-5
>    8       32   15687680 sdc
>    8       33   15687441 sdc1
>
> Listing of /dev/dm-x devices (LVM, dmraid, etc.):
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> brw-rw----    1 root     disk      252,   0 Aug 13 04:27 /dev/dm-0
> brw-rw----    1 root     disk      252,   1 Aug 13 04:27 /dev/dm-1
> brw-rw----    1 root     disk      252,   2 Aug 13 04:27 /dev/dm-2
> brw-rw----    1 root     disk      252,   4 Aug 13 04:27 /dev/dm-4
> brw-rw----    1 root     disk      252,   5 Aug 13 04:27 /dev/dm-5
>
> Listing of /sys/block/dm-x/slaves:
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> /sys/block/dm-0/slaves:
> lrwxrwxrwx    1 root     root             0 Aug 13 11:28 sda ->
> ../../../../pci0000:00/0000:00:1f.2/ata3/host2/target2:0:0/2:0:0:0/block/sda
> lrwxrwxrwx    1 root     root             0 Aug 13 04:28 sdb ->
> ../../../../pci0000:00/0000:00:1f.2/ata4/host3/target3:0:0/3:0:0:0/block/sdb
>
> /sys/block/dm-1/slaves:
> lrwxrwxrwx    1 root     root             0 Aug 13 04:28 dm-0 -> ../../dm-0
>
> /sys/block/dm-2/slaves:
> lrwxrwxrwx    1 root     root             0 Aug 13 04:28 dm-0 -> ../../dm-0
>
> /sys/block/dm-4/slaves:
> lrwxrwxrwx    1 root     root             0 Aug 13 04:28 dm-0 -> ../../dm-0
>
> /sys/block/dm-5/slaves:
> lrwxrwxrwx    1 root     root             0 Aug 13 04:28 dm-0 -> ../../dm-0
>
> Contents of /proc/mdstat (Linux software RAID status):
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
> [raid4] [multipath]
> unused devices: <none>
>
> Contents of /run/mdadm/map (Linux software RAID arrays):
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Contents of /etc/mdadm/mdadm.conf (Linux software RAID config file):
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> # mdadm.conf
> #
> # Please refer to mdadm.conf(5) for information about this file.
> #
>
> # by default (built-in), scan all partitions (/proc/partitions) and all
> # containers for MD superblocks. alternatively, specify devices to scan, using
> # wildcards if desired.
> DEVICE partitions containers
>
> # automatically tag new arrays as belonging to the local system
> HOMEHOST <system>
>
> ARRAY metadata=imsm UUID=788c3635:2e37de4b:87d08323:987f57e5
> ARRAY /dev/md/TestRAID container=788c3635:2e37de4b:87d08323:987f57e5
> member=0 UUID=835de710:3d35bfb1:d159af46:6570f120
>
> Contents of /tbu/utility/mdadm.txt (mdadm troubleshooting data
> captured when 'start-md' is executed):
> mdadm - v4.1 - 2018-10-01
> Output of 'mdadm --examine --scan'
> ARRAY metadata=imsm UUID=788c3635:2e37de4b:87d08323:987f57e5
> ARRAY /dev/md/TestRAID container=788c3635:2e37de4b:87d08323:987f57e5
> member=0 UUID=835de710:3d35bfb1:d159af46:6570f120
> Output of 'mdadm --assemble --scan --no-degraded -v'
> mdadm: looking for devices for further assembly
> mdadm: no RAID superblock on /dev/sdc1
> mdadm: /dev/sdc is not attached to Intel(R) RAID controller.
> mdadm: No OROM/EFI properties for /dev/sdc
> mdadm: no RAID superblock on /dev/sdc
> mdadm: /dev/dm-5 is not attached to Intel(R) RAID controller.
> mdadm: No OROM/EFI properties for /dev/dm-5
> mdadm: no RAID superblock on /dev/dm-5
> mdadm: /dev/dm-4 is not attached to Intel(R) RAID controller.
> mdadm: No OROM/EFI properties for /dev/dm-4
> mdadm: no RAID superblock on /dev/dm-4
> mdadm: /dev/dm-2 is not attached to Intel(R) RAID controller.
> mdadm: No OROM/EFI properties for /dev/dm-2
> mdadm: no RAID superblock on /dev/dm-2
> mdadm: /dev/dm-1 is not attached to Intel(R) RAID controller.
> mdadm: No OROM/EFI properties for /dev/dm-1
> mdadm: no RAID superblock on /dev/dm-1
> mdadm: /dev/dm-0 is not attached to Intel(R) RAID controller.
> mdadm: No OROM/EFI properties for /dev/dm-0
> mdadm: no RAID superblock on /dev/dm-0
> mdadm: no RAID superblock on /dev/sda5
> mdadm: no RAID superblock on /dev/sda3
> mdadm: no RAID superblock on /dev/sda2
> mdadm: no RAID superblock on /dev/sda1
> mdadm: /dev/sda is busy - skipping
> mdadm: /dev/sdb is busy - skipping
> mdadm: looking for devices for /dev/md/TestRAID
> mdadm: Cannot assemble mbr metadata on /dev/sdc1
> mdadm: Cannot assemble mbr metadata on /dev/sdc
> mdadm: Cannot assemble mbr metadata on /dev/dm-5
> mdadm: Cannot assemble mbr metadata on /dev/dm-4
> mdadm: Cannot assemble mbr metadata on /dev/dm-2
> mdadm: Cannot assemble mbr metadata on /dev/dm-1
> mdadm: Cannot assemble mbr metadata on /dev/dm-0
> mdadm: Cannot assemble mbr metadata on /dev/sda5
> mdadm: Cannot assemble mbr metadata on /dev/sda3
> mdadm: Cannot assemble mbr metadata on /dev/sda2
> mdadm: no recogniseable superblock on /dev/sda1
> mdadm: /dev/sda has wrong uuid.
> mdadm: /dev/sdb has wrong uuid.
> Output of 'dmesg | grep md:'
>
>
> Output of 'mdadm --examine /dev/sda'
> /dev/sda:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.0.00
>     Orig Family : a209f7f5
>          Family : a209f7f5
>      Generation : 0000016e
>      Attributes : All supported
>            UUID : 788c3635:2e37de4b:87d08323:987f57e5
>        Checksum : 7cb36504 correct
>     MPB Sectors : 1
>           Disks : 2
>    RAID Devices : 1
>
>   Disk00 Serial : WD-WCANK2656465
>           State : active
>              Id : 00000000
>     Usable Size : 488391680 (232.88 GiB 250.06 GB)
>
> [TestRAID]:
>            UUID : 835de710:3d35bfb1:d159af46:6570f120
>      RAID Level : 0
>         Members : 2
>           Slots : [UU]
>     Failed disk : none
>       This Slot : 0
>     Sector Size : 512
>      Array Size : 976783360 (465.77 GiB 500.11 GB)
>    Per Dev Size : 488391944 (232.88 GiB 250.06 GB)
>   Sector Offset : 0
>     Num Stripes : 1907780
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : normal
>     Dirty State : clean
>      RWH Policy : off
>
>   Disk01 Serial : 3QK01SE5
>           State : active
>              Id : 00010000
>     Usable Size : 1465143680 (698.63 GiB 750.15 GB)
>
>
> Output of 'mdadm --examine /dev/sdb'
> /dev/sdb:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.0.00
>     Orig Family : a209f7f5
>          Family : a209f7f5
>      Generation : 0000016e
>      Attributes : All supported
>            UUID : 788c3635:2e37de4b:87d08323:987f57e5
>        Checksum : 7cb36504 correct
>     MPB Sectors : 1
>           Disks : 2
>    RAID Devices : 1
>
>   Disk01 Serial : 3QK01SE5
>           State : active
>              Id : 00010000
>     Usable Size : 1465138766 (698.63 GiB 750.15 GB)
>
> [TestRAID]:
>            UUID : 835de710:3d35bfb1:d159af46:6570f120
>      RAID Level : 0
>         Members : 2
>           Slots : [UU]
>     Failed disk : none
>       This Slot : 1
>     Sector Size : 512
>      Array Size : 976783360 (465.77 GiB 500.11 GB)
>    Per Dev Size : 488391944 (232.88 GiB 250.06 GB)
>   Sector Offset : 0
>     Num Stripes : 1907780
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : normal
>     Dirty State : clean
>      RWH Policy : off
>
>   Disk00 Serial : WD-WCANK2656465
>           State : active
>              Id : 00000000
>     Usable Size : 488386766 (232.88 GiB 250.05 GB)
>
>
> Output of 'mdadm --examine /dev/sdc'
> /dev/sdc:
>    MBR Magic : aa55
> Partition[0] :     31374882 sectors at           63 (type 0b)
>
>
> Output of 'mdadm --detail /dev/md*', if any:
> mdadm: cannot open /dev/md*: No such file or directory
>
> Contents of /dev/mapper directory:
> crw-------    1 root     root       10, 236 Aug 13 04:27 control
> brw-rw----    1 root     disk      252,   0 Aug 13 04:27 isw_chbifgccjd_TestRAID
> brw-rw----    1 root     disk      252,   1 Aug 13 04:27
> isw_chbifgccjd_TestRAID1
> brw-rw----    1 root     disk      252,   2 Aug 13 04:27
> isw_chbifgccjd_TestRAID3
> brw-rw----    1 root     disk      252,   4 Aug 13 04:27
> isw_chbifgccjd_TestRAID4
> brw-rw----    1 root     disk      252,   5 Aug 13 04:27
> isw_chbifgccjd_TestRAID5
