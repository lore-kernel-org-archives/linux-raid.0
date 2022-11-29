Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CDD4C433FE
	for <linux-raid@archiver.kernel.org>; Tue, 29 Nov 2022 21:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237066AbiK2V1a (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237015AbiK2V13 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 29 Nov 2022 16:27:29 -0500
X-Greylist: delayed 597 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Nov 2022 13:27:26 PST
Received: from box.sotapeli.fi (sotapeli.fi [37.59.98.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32376037D
        for <linux-raid@vger.kernel.org>; Tue, 29 Nov 2022 13:27:26 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8C0298722C;
        Tue, 29 Nov 2022 22:17:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sotapeli.fi; s=dkim;
        t=1669756645; h=from:subject:date:message-id:to:mime-version:content-type:
         content-transfer-encoding:in-reply-to:references;
        bh=IcX0yExVxegqEOdtQYaTmDI7SQprMVeXIzvWMcElL7w=;
        b=FoMWBYnaP4oWDVfCV/YOK/ofV+TULhaTX98Uo2WdX4Q+tR8SCeUgPWhGdLsWiDvD2ueKTo
        R35rr6Xr8lrGwL0NItEN7+XiuZLERS0tNNA+5d+0KXysjgFhyxDVEUNLi2xSoSEFeiQJ56
        G3ckY34d/Bmr5KkVaAGf7CBuPAM1Irfiut4hZGLs6crtX4srXAIuDU8UyK03BAEz3Pu65F
        Ot77JdeQZ+kooj+uAWp0Jj2Iq9G1U72XgI8a4Qnii1n4aqX09nTV6h6YJcWh8j4OKF7n7h
        k+W+Rf+AkVdzJLON7xv9gOfGuz+sBlSnaycVUc3yyfwD1HtJZ+8jVEnyWN+zfA==
Message-ID: <ab803396-fb7f-50b6-9aa8-2803aa526fe4@sotapeli.fi>
Date:   Tue, 29 Nov 2022 23:17:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: md RAID0 can be grown (was "Re: how do i fix these RAID5
 arrays?")
To:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <CAAMCDecPXmZsxaAPcSOOY4S7_ieRZC8O_u7LjLLH-t8L-6+21Q@mail.gmail.com>
 <20221125132259.GG19721@jpo>
 <CAAMCDed1-4zFgHMS760dO1pThtkrn8K+FMuG-QQ+9W-FE0iq9Q@mail.gmail.com>
 <20221125194932.GK19721@jpo> <20221128142422.GM19721@jpo>
From:   Jani Partanen <jiipee@sotapeli.fi>
In-Reply-To: <20221128142422.GM19721@jpo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi David,

Nice to see that there is others who like to take things extreme and 
live on razor edge. ;)

I had different side disks, so I made raid5 so that I first joined 
example 1TB and 2TB together with md linear so I could add that as 
member to other 3TB raid5 pool.

But stuff started to become complex and then I had few disk failures 
with 3TB drives. (didn't lose any data) So I bought some 4TB drives 
more, enough that I was able to start all over. Made new pool from 4TB 
drives, added it to LVM and then moved all data from old pool to this 
shiny new. When data was transferred, I left all remaining 3TB drives 
and made raid5 pool out of them and added it to LVM.
Anyway, go LVM if you are planning to slice and dice disks like before. 
With LVM later on if you add space, it will be much more simple task and 
LVM automaticly works like linear but offers much other benefits.
LVM is very much worth to learn. Start up virtual machine and assign 
multiple small vdisks to it and you have enviroment where it's safe to 
play around with md and lvm.

Here is some snips how my setup looks now. I have different logical 
volumes for big data pool and virtual machines. Reason is that I don't 
want VM's to go through encryption, VM can do it on it's own and also I 
can now just create logican volume and install VM directly to it if I 
want. For "big" datapool is btrfs because I like cow, quite much of my 
use benefit alot from it.


-----------------------------

vgdisplay
   --- Volume group ---
   VG Name               volgroup0_datapool
   System ID
   Format                lvm2
   Metadata Areas        2
   Metadata Sequence No  62
   VG Access             read/write
   VG Status             resizable
   MAX LV                0
   Cur LV                5
   Open LV               1
   Max PV                0
   Cur PV                2
   Act PV                2
   VG Size               28.19 TiB
   PE Size               4.00 MiB
   Total PE              7390684
   Alloc PE / Size       6843196 / 26.10 TiB
   Free  PE / Size       547488 / <2.09 TiB
   VG UUID               OmE21G-oG3a-Oxqb-Nc0V-uAes-PFfh-nvvP07

  pvdisplay
   --- Physical volume ---
   PV Name               /dev/md124
   VG Name               volgroup0_datapool
   PV Size               13.64 TiB / not usable 6.00 MiB
   Allocatable           yes (but full)
   PE Size               4.00 MiB
   Total PE              3576116
   Free PE               0
   Allocated PE          3576116
   PV UUID               jtE1e0-JK7h-Z6Xy-X1ms-vhnT-NkMh-6aFLRK

   --- Physical volume ---
   PV Name               /dev/md123
   VG Name               volgroup0_datapool
   PV Size               14.55 TiB / not usable 4.00 MiB
   Allocatable           yes
   PE Size               4.00 MiB
   Total PE              3814568
   Free PE               547488
   Allocated PE          3267080
   PV UUID               kYMebn-1JK8-aApe-eTSN-QY7v-c59d-FGStdu

cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md123 : active raid5 sdf1[3] sde1[2] sdd1[1] sdg1[5] sdc1[0]
       15624474624 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[5/5] [UUUUU]
       bitmap: 0/30 pages [0KB], 65536KB chunk

md124 : active raid5 sdn1[6] sdj1[1] sdl1[3] sdk1[2] sdi1[0] sdm1[4]
       14647777280 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[6/6] [UUUUUU]
       bitmap: 0/22 pages [0KB], 65536KB chunk

-----------------------------

It is shame that linux doesn't have native support for one system rule 
them all. There is zfs but because of licence, it most likely never be a 
part of kernel so at least I am not gonna use it until it's in kernel.
Even windows is far ahead of linux on that front. Storage spaces is 
quite powerfull and you can do all kind of nice stuff with it. I have on 
my windows machine tiered store done with storage space. Meaning that I 
have HDD and SSD paired as one big pool and hot data stay on ssd.

You can archive about everything what zfs offers with linux tools, but 
it means you will need to make very complex pool. Layer after layer and 
at least I feel that more layers you add, more breaking points you add.

I really like btrfs, but because raid5 scrub is broken, it cannot be 
really used. Broken raid5 scrub is only deal breaker for me not using 
it. write hole bug is not an issue if you dont raid5 your meta. But 
still btrfs is missing few key features what zfs offer. Encryption and 
cache.


On 28/11/2022 16.24, David T-G wrote:
> Hi, all --
>
> ...and then David T-G home said...
> %
> % ...and then Roger Heflin said...
> % % You may not be able to grow with either linear and/or raid0 under mdadm.
> %
> ...
> % What do you think of
> %
> %   mdadm -A --update=devicesize /dev/md50
> %
> % as discussed in
> %
> %   https://serverfault.com/questions/1068788/how-to-change-size-of-raid0-software-array-by-resizing-partition
> %
> % recently?
>
> It looks like this works.  Read on for more future plans, but here's how
> growing worked out.
>
> First, you'll recall, I added the new slices to each RAID5 array and then
> fixed them so that they're all working again.  Thank you, everyone :-)
>
> Second, all I had to do was stop the array and reassemble, and md noticed
> like a champ.  Awesome!
>
>    diskfarm:~ # mdadm -D /dev/md50
>    /dev/md50:
>    ...
>            Raid Level : raid0
>            Array Size : 19526301696 (18.19 TiB 19.99 TB)
>    ...
>    diskfarm:~ # mdadm -S /dev/md50
>    mdadm: stopped /dev/md50
>    diskfarm:~ # mdadm -A --update=devicesize /dev/md50
>    mdadm: /dev/md50 has been started with 6 drives.
>    diskfarm:~ # mdadm -D /dev/md50
>    /dev/md50:
>    ...
>            Raid Level : raid0
>            Array Size : 29289848832 (27.28 TiB 29.99 TB)
>    ...
>
> Next I had to resize the partition to use the more space now
> available.
>
>    diskfarm:~ # parted /dev/md50
>    ...
>    (parted) u s p free
>    Model: Linux Software RAID Array (md)
>    Disk /dev/md50: 58579697664s
>    Sector size (logical/physical): 512B/4096B
>    Partition Table: gpt
>    Disk Flags:
>    
>    Number  Start         End           Size          File system  Name         Flags
>            34s           6143s         6110s         Free Space
>     1      6144s         39052597247s  39052591104s  xfs          10Traid50md
>            39052597248s  58579697630s  19527100383s  Free Space
>    
>    (parted) rm 1
>    (parted) mkpart pri xfs 6144s 100%
>    (parted) name 1 10Traid50md
>    (parted) p free
>    Model: Linux Software RAID Array (md)
>    Disk /dev/md50: 58579697664s
>    Sector size (logical/physical): 512B/4096B
>    Partition Table: gpt
>    Disk Flags:
>    
>    Number  Start         End           Size          File system  Name         Flags
>            34s           6143s         6110s         Free Space
>     1      6144s         58579691519s  58579685376s  xfs          10Traid50md
>            58579691520s  58579697630s  6111s         Free Space
>    
>    (parted) q
>    
>    diskfarm:~ # parted /dev/md50 p free
>    Model: Linux Software RAID Array (md)
>    Disk /dev/md50: 30.0TB
>    Sector size (logical/physical): 512B/4096B
>    Partition Table: gpt
>    Disk Flags:
>    
>    Number  Start   End     Size    File system  Name         Flags
>            17.4kB  3146kB  3128kB  Free Space
>     1      3146kB  30.0TB  30.0TB  xfs          10Traid50md
>            30.0TB  30.0TB  3129kB  Free Space
>
> Finally, I had to grow the XFS filesystem.  That was simple enough,
> although it's supposed to be done with the volume mounted, which just
> felt ... wrong :-)
>
>    diskfarm:~ # df -kh /mnt/10Traid50md/
>    Filesystem      Size  Used Avail Use% Mounted on
>    /dev/md50p1      19T   19T   95G 100% /mnt/10Traid50md
>    diskfarm:~ # xfs_growfs -n /mnt/10Traid50md
>    meta-data=/dev/md50p1            isize=512    agcount=32, agsize=152549248 blks
>             =                       sectsz=4096  attr=2, projid32bit=1
>             =                       crc=1        finobt=1, sparse=0, rmapbt=0
>             =                       reflink=0
>    data     =                       bsize=4096   blocks=4881573888, imaxpct=5
>             =                       sunit=128    swidth=768 blks
>    naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>    log      =internal log           bsize=4096   blocks=521728, version=2
>             =                       sectsz=4096  sunit=1 blks, lazy-count=1
>    realtime =none                   extsz=4096   blocks=0, rtextents=0
>    diskfarm:~ # xfs_growfs /mnt/10Traid50md
>    meta-data=/dev/md50p1            isize=512    agcount=32, agsize=152549248 blks
>             =                       sectsz=4096  attr=2, projid32bit=1
>             =                       crc=1        finobt=1, sparse=0, rmapbt=0
>             =                       reflink=0
>    data     =                       bsize=4096   blocks=4881573888, imaxpct=5
>             =                       sunit=128    swidth=768 blks
>    naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>    log      =internal log           bsize=4096   blocks=521728, version=2
>             =                       sectsz=4096  sunit=1 blks, lazy-count=1
>    realtime =none                   extsz=4096   blocks=0, rtextents=0
>    data blocks changed from 4881573888 to 7322460672
>    diskfarm:~ # df -kh /mnt/10Traid50md
>    Filesystem      Size  Used Avail Use% Mounted on
>    /dev/md50p1      28T   19T  9.2T  67% /mnt/10Traid50md
>
> Et voila, we have more free space.  Yay.
>
> So this works in theory, but ... there's that linear question :-/
>
>
> %
> ...
> % % so here is roughly how to do it (commands may not be exact)> and assuming
> % % your devices are /dev/md5[0123]
> % %
> % % PV == physical volume (a disk or md raid device generally).
> % % VG == volume group (a group of PV).
> % % LV == logical volume (a block device inside a vg made up of part of a PV or
> % % several PVs).
> % %
> % % pvcreate /dev/md5[0123]
> % % vgcreate bigvg /dev/md5[0123]
> % % lvcreate -L <size> -n mylv bigvg
> [snip]
>
> Thanks again, and I do plan to read up on LVM.  For now, though, I'm
> thinkin' I'll rebuild under md in linear mode.  Stealing from my RAID10
> subthread (where I owe similar tests), I tried pulling 128MiB to 8GiB of
> data from a single RAID5 slice versus the big RAID0 stripe
>
>    diskfarm:~ # for D in 52 50 ; do for C in 128 256 512 ; do for S in 1M 4M 16M ; do CMD="dd if=/dev/md$D of=/dev/null bs=$S count=$C iflag=direct" ; echo "## $CMD" ; $CMD 2>&1 | egrep -v records ; done ; done ; done
>    ## dd if=/dev/md52 of=/dev/null bs=1M count=128 iflag=direct
>    134217728 bytes (134 MB, 128 MiB) copied, 1.20121 s, 112 MB/s
>    ## dd if=/dev/md52 of=/dev/null bs=4M count=128 iflag=direct
>    536870912 bytes (537 MB, 512 MiB) copied, 1.82563 s, 294 MB/s
>    ## dd if=/dev/md52 of=/dev/null bs=16M count=128 iflag=direct
>    2147483648 bytes (2.1 GB, 2.0 GiB) copied, 9.03782 s, 238 MB/s
>    ## dd if=/dev/md52 of=/dev/null bs=1M count=256 iflag=direct
>    268435456 bytes (268 MB, 256 MiB) copied, 2.6694 s, 101 MB/s
>    ## dd if=/dev/md52 of=/dev/null bs=4M count=256 iflag=direct
>    1073741824 bytes (1.1 GB, 1.0 GiB) copied, 3.72331 s, 288 MB/s
>    ## dd if=/dev/md52 of=/dev/null bs=16M count=256 iflag=direct
>    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 13.6094 s, 316 MB/s
>    ## dd if=/dev/md52 of=/dev/null bs=1M count=512 iflag=direct
>    536870912 bytes (537 MB, 512 MiB) copied, 6.39903 s, 83.9 MB/s
>    ## dd if=/dev/md52 of=/dev/null bs=4M count=512 iflag=direct
>    2147483648 bytes (2.1 GB, 2.0 GiB) copied, 7.45123 s, 288 MB/s
>    ## dd if=/dev/md52 of=/dev/null bs=16M count=512 iflag=direct
>    8589934592 bytes (8.6 GB, 8.0 GiB) copied, 28.1189 s, 305 MB/s
>    ## dd if=/dev/md50 of=/dev/null bs=1M count=128 iflag=direct
>    134217728 bytes (134 MB, 128 MiB) copied, 3.74023 s, 35.9 MB/s
>    ## dd if=/dev/md50 of=/dev/null bs=4M count=128 iflag=direct
>    536870912 bytes (537 MB, 512 MiB) copied, 9.96306 s, 53.9 MB/s
>    ## dd if=/dev/md50 of=/dev/null bs=16M count=128 iflag=direct
>    2147483648 bytes (2.1 GB, 2.0 GiB) copied, 19.994 s, 107 MB/s
>    ## dd if=/dev/md50 of=/dev/null bs=1M count=256 iflag=direct
>    268435456 bytes (268 MB, 256 MiB) copied, 7.25855 s, 37.0 MB/s
>    ## dd if=/dev/md50 of=/dev/null bs=4M count=256 iflag=direct
>    1073741824 bytes (1.1 GB, 1.0 GiB) copied, 18.9692 s, 56.6 MB/s
>    ## dd if=/dev/md50 of=/dev/null bs=16M count=256 iflag=direct
>    4294967296 bytes (4.3 GB, 4.0 GiB) copied, 40.2443 s, 107 MB/s
>    ## dd if=/dev/md50 of=/dev/null bs=1M count=512 iflag=direct
>    536870912 bytes (537 MB, 512 MiB) copied, 14.1076 s, 38.1 MB/s
>    ## dd if=/dev/md50 of=/dev/null bs=4M count=512 iflag=direct
>    2147483648 bytes (2.1 GB, 2.0 GiB) copied, 38.6795 s, 55.5 MB/s
>    ## dd if=/dev/md50 of=/dev/null bs=16M count=512 iflag=direct
>    8589934592 bytes (8.6 GB, 8.0 GiB) copied, 81.4364 s, 105 MB/s
>
> and as expected the difference
>
>    RAID5 / RAID0 performance
>    (speedup)
>    
>            1M        4M       16M
>        +---------+---------+---------+
>    128 | 112/036 | 294/054 | 238/107 |
>        | (3.1)   | (5.4)   | (2.2)   |
>        +---------+---------+---------+
>    256 | 101/037 | 288/057 | 316/107 |
>        | (2.7)   | (5.0)   | (3.0)   |
>        +---------+---------+---------+
>    512 | 084/038 | 288/056 | 305/105 |
>        | (2.2)   | (5.1)   | (2.9)   |
>        +---------+---------+---------+
>
> is significant.  So, yeah, I'll be wiping and rebuilding md50 as a
> straight linear.  Watch for more test results when that's done :-)
> Fingers crossed that I get much better results; if not, maybe it'll
> be time to switch to LVM after all.
>
>
> Thanks again to all & HAND
>
> :-D

