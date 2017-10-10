From: Curt <lightspd@gmail.com>
Subject: Re: hung grow
Date: Tue, 10 Oct 2017 15:25:39 -0400
Message-ID: <CADg2FGYQti9hFAqtRMEH8B-i4kwJJ3fYRdrRauD5F3OSZ_Q0vw@mail.gmail.com>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
 <89992d1f-172f-9fc6-3a1e-50df34e11d3b@turmel.org> <CADg2FGaPFTNLuQPussL=YFDCRndRDFX99D-KjnWfD93MqGJXmg@mail.gmail.com>
 <CADg2FGZNs9KmkKGvbCf-dwsqxYN5ftJd5v7RTJ1M=rLP=v6wJg@mail.gmail.com>
 <CADg2FGa5iUGVqVvy5MrJf00fCqH4NEVXrODPHS6Dc=jsrBx2PQ@mail.gmail.com>
 <87po9xyv0r.fsf@notabene.neil.brown.name> <CADg2FGaeuptaWRnM5+Z_aAR08vG-311s8p6OrBwZUNeCrNGu1g@mail.gmail.com>
 <87d15xymgc.fsf@notabene.neil.brown.name> <CADg2FGbzr_JcrGfvU6kpGc_5vJ=+L2gXx3PcfpOTsst8BeNA-Q@mail.gmail.com>
 <CADg2FGaFt4_4UHPUSnY8tr=LeJMKKojR_QrPE-YoXvWmgXXZxQ@mail.gmail.com>
 <0d4987d9-e8ff-0cdb-6e45-7f962b75c189@turmel.org> <3e5766b0-1437-2857-4806-264386d1633f@youngman.org.uk>
 <6d4b7055-c26c-951e-b63c-273a7fe447b8@turmel.org> <CADg2FGad+Tpu-4Z4rx1Kx_U1Tw64nQ_FqGuPRn5ODV=_pYFuDw@mail.gmail.com>
 <e8dce17e-d231-0004-e9a1-511abacfcfda@turmel.org> <CADg2FGZ-=VP2Q++qkKqfQ06zeBho1TR3=biqbdxT7-4pMCcLLQ@mail.gmail.com>
 <5a3fb3ec-299a-67c9-9d1c-ef28ca2164dd@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5a3fb3ec-299a-67c9-9d1c-ef28ca2164dd@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Anthony Youngman <antlists@youngman.org.uk>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> Just --freeze-reshape, not --update.
>
Ok, here's the output
mdadm --detail /dev/md127
/dev/md127:
           Version : 0.91
     Creation Time : Fri Jun 15 15:52:05 2012
        Raid Level : raid6
        Array Size : 9767519360 (9315.03 GiB 10001.94 GB)
     Used Dev Size : 1953503872 (1863.01 GiB 2000.39 GB)
      Raid Devices : 8
     Total Devices : 6
   Preferred Minor : 127
       Persistence : Superblock is persistent

       Update Time : Tue Oct 10 15:11:26 2017
             State : clean, FAILED, reshaping
    Active Devices : 5
   Working Devices : 6
    Failed Devices : 0
     Spare Devices : 1

            Layout : left-symmetric
        Chunk Size : 64K

Consistency Policy : unknown

    Reshape Status : 0% complete
     Delta Devices : 1, (7->8)

              UUID : 714a612d:9bd35197:36c91ae3:c168144d
            Events : 0.11559682

    Number   Major   Minor   RaidDevice State
       0       8       97        0      active sync   /dev/sdg1
       1       8       49        1      active sync   /dev/sdd1
       2       8       33        2      active sync   /dev/sdc1
       3       8        1        3      active sync   /dev/sda1
       4      65      145        4      active sync   /dev/sdz1
       -       0        0        5      removed
       6       8       16        6      spare rebuilding   /dev/sdb
       -       0        0        7      removed

But in my dmesg, I'm seeing task md127_reshape blocked for 120
seconds, and when I cat sync_action, it shows reshape.  Which
shouldn't it be frozen or something like that?  Also md127_raid6 task
is using 100% cpu.  I was going to paste the assemble output, but hit
clear instead of copy.  It didn't show any errors I saw, just starting
with 6 drives. reshape isn't using any cpu

If I do a cat of /proc/pid/stack, all I get is
[<ffffffffffffffff>] 0xffffffffffffffff

Should I just let it run?


Here's dmesg output for the raid stuff
521267.896376]  sdb: unknown partition table
[521267.896766] md: bind<sdd1>
[521267.896900] md: bind<sdc1>
[521267.897089] md: bind<sda1>
[521267.897336] md: bind<sdz1>
[521267.902584] md: bind<sdb>
[521267.918722] md: bind<sdg1>
[521268.013150] md/raid:md127: reshape will continue
[521268.013168] md/raid:md127: device sdg1 operational as raid disk 0
[521268.013170] md/raid:md127: device sdz1 operational as raid disk 4
[521268.013172] md/raid:md127: device sda1 operational as raid disk 3
[521268.013173] md/raid:md127: device sdc1 operational as raid disk 2
[521268.013175] md/raid:md127: device sdd1 operational as raid disk 1
[521268.014065] md/raid:md127: allocated 0kB
[521268.014096] md/raid:md127: raid level 6 active with 6 out of 8
devices, algorithm 2
[521268.019158] RAID conf printout:
[521268.019160]  --- level:6 rd:8 wd:6
[521268.019162]  disk 0, o:1, dev:sdg1
[521268.019164]  disk 1, o:1, dev:sdd1
[521268.019166]  disk 2, o:1, dev:sdc1
[521268.019167]  disk 3, o:1, dev:sda1
[521268.019169]  disk 4, o:1, dev:sdz1
[521268.019171]  disk 6, o:1, dev:sdb
[521268.019208] md127: Warning: Device sdz1 is misaligned
[521268.019210] md127: Warning: Device sda1 is misaligned
[521268.019211] md127: Warning: Device sda1 is misaligned
[521268.019236] md127: detected capacity change from 0 to 10001939824640
[521268.019242] md: reshape of RAID array md127
[521268.019248] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[521268.019249] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for reshape.
[521268.019255] md: using 128k window, over a total of 1953503872k.
