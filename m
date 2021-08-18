Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38188C4338F
	for <linux-raid@archiver.kernel.org>; Wed, 18 Aug 2021 00:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14B3760524
	for <linux-raid@archiver.kernel.org>; Wed, 18 Aug 2021 00:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbhHRApp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Aug 2021 20:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbhHRApo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 Aug 2021 20:45:44 -0400
Received: from poetics.madmonks.org (unknown [IPv6:2404:9400:3:0:216:3eff:fee0:d9b5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63E03C061764
        for <linux-raid@vger.kernel.org>; Tue, 17 Aug 2021 17:45:10 -0700 (PDT)
Received: from poetics.madmonks.org (localhost [127.0.0.1])
        by poetics.madmonks.org (Postfix) with ESMTP id F3F508006E2;
        Wed, 18 Aug 2021 10:45:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=madmonks.org;
        s=default; t=1629247503;
        bh=weOvT2qib5i2w0ioBhSQlYM6rPBtZJF2zXR32k96m/c=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
        b=KV7M7oSqeraciidfUZZx+hR7qWn6AiWG4RCAXtax+tSa7rNbOZuRNKylJ7i+voLtt
         rjQvb+fsX9IOU+oYJhPqwRKLXCMWazKV6ybdCCzp7qH2+TdllNB8o+Rx6I6voA7aqT
         FTngKrttnEGLiFF1tcP4ksc8ODF/dpQdJgGtLSGAw1ma3wTc2muM4kt0KrvrDHy/8I
         gri5jJ7nPORLJ1rKeOZMY9iNnDdorB7L3rn7NZLQgvu2JKKdPYBZf5ReCBImB5AQQ+
         4tQ94qftYD3XJ1LcKl+nLM22vJMuw8AV82m0NRGvCCADMxTD3uon3z3dVA8FG5rND9
         oO+3KBJkvs31Q==
Received: from smtpclient.apple (121-200-4-56.79c804.syd.nbn.aussiebb.net [121.200.4.56])
        by poetics.madmonks.org (Postfix) with ESMTPSA id DE4CD8006E1;
        Wed, 18 Aug 2021 10:45:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=madmonks.org;
        s=default; t=1629247502;
        bh=weOvT2qib5i2w0ioBhSQlYM6rPBtZJF2zXR32k96m/c=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
        b=WXT58oQwa01cxK/70oh3c8Fc4CxLtKsbfUpc+yYNaVpia7tLG6GapsA/38K/sSBeG
         LuAYCvJ4DKPMX6qcJ4GpHoqc/miyHMbzoxQyu3E7sinsXa0VdF48hgN0mQp/IXCcO1
         Fvq6DZNkFs5C+RsiMUNbLtf78xwqLWus6PNz4U/smkYWarrNtDo7YT4ghle76mr3dK
         qD+rC9Wlp7jilgoTR9j34nlyC56543IMJxaInUEXuHhSjzGZ94my/ILKyDVKdLMtf1
         HXcvX4BE11VClYkRKfNdoatqKsuBmkxHEloWx1sju8WsWED4P+1HnRb6cbG0uJytsf
         q4CAYr9+cGjWQ==
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3691.0.3\))
Subject: Re: [Non-DoD Source] Can't get RAID5/RAID6 NVMe randomread IOPS - AMD
 ROME what am I missing?????
From:   Matt Wallis <mattw@madmonks.org>
In-Reply-To: <5EAED86C53DED2479E3E145969315A238585E0EF@UMECHPA7B.easf.csd.disa.mil>
Date:   Wed, 18 Aug 2021 10:45:04 +1000
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <300042B9-F46F-42CF-8FD7-F1C2FE0965E5@madmonks.org>
References: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
 <AS8PR04MB799205817C4647DAC740DE9A91EA9@AS8PR04MB7992.eurprd04.prod.outlook.com>
 <5EAED86C53DED2479E3E145969315A2385856AD0@UMECHPA7B.easf.csd.disa.mil>
 <5EAED86C53DED2479E3E145969315A2385856AF7@UMECHPA7B.easf.csd.disa.mil>
 <5EAED86C53DED2479E3E145969315A2385856B25@UMECHPA7B.easf.csd.disa.mil>
 <5EAED86C53DED2479E3E145969315A2385856B62@UMECHPA7B.easf.csd.disa.mil>
 <5EAED86C53DED2479E3E145969315A2385856B85@UMECHPA7B.easf.csd.disa.mil>
 <20210808174331.1e444db9@gofri-dell>
 <5EAED86C53DED2479E3E145969315A2385857258@UMECHPA7B.easf.csd.disa.mil>
 <5EAED86C53DED2479E3E145969315A238585E0EF@UMECHPA7B.easf.csd.disa.mil>
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
X-Mailer: Apple Mail (2.3691.0.3)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jim,

Awesome stuff. I=E2=80=99m looking to get access back to a server I was =
using before for my tests so I can play some more myself.
I did wonder about your use case, and if you were planning to present =
the storage over a network to another server, or intended to use it as =
local storage for an application.

The problem is basically that we=E2=80=99re limited no matter what we =
do. There=E2=80=99s no way with current PCIe+networking to get that =
bandwidth outside the box, and you don=E2=80=99t have much compute left =
inside the box.

You could simplify the configuration a little bit by using a parallel =
file system like BeeGFS. Parallel file systems like to stripe data over =
multiple targets anyway, so you could remove the LVM layer, and simply =
present 64 RAID volumes for BeeGFS to write to. =20

Normal parallel file system operation is to export the volumes over a =
network, but BeeGFS does have an alternate mode called BeeOND, or BeeGFS =
on Demand, which builds up dynamic file systems using the local disks in =
multiple servers, you could potentially look at a single server BeeOND =
configuration and see if that worked, but I suspect you=E2=80=99d be =
exchanging bottlenecks.

There=E2=80=99s a new parallel FS on the market that might also be of =
interest, called MadFS. It=E2=80=99s based on another parallel file =
system but with certain parts re-written using the Rust language which =
significantly improved it=E2=80=99s ability to handle higher IOPs.=20

Hmm, just realised the box I had access to before won=E2=80=99t help, it =
was built on an older Intel platform so bottlenecked by PCIe lanes. =
I=E2=80=99ll have to see if I can get something newer.

Matt.

> On 18 Aug 2021, at 07:21, Finlayson, James M CIV (USA) =
<james.m.finlayson4.civ@mail.mil> wrote:
>=20
> All,
> A quick random performance update (this is the best I can do in "going =
for it" with all of the guidance from this list) - I'm thrilled.....
>=20
> 5.14rc4 kernel Gen 4 drives, all AMD Rome BIOS tuning to keep I/O from =
power throttling,  SMT turned on (off yielded higher performance but =
left no room for anything else),  15.36TB drives cut into 32 equal =
partitions,  32 NUMA aligned raid5 9+1s from the same partition on NUMA0 =
combined with an LVM concatenating all 32 RAID5's into one volume.    I =
then do the exact same thing on NUMA1.
>=20
> 4K random reads, SMT off, sustained bandwidth of > 90GB/s, sustained =
IOPS across both LVMs, ~23M - bad part, only 7% of the system left to do =
anything useful
> 4K random reads, SMT on, sustained bandwidth of > 84GB/s, sustained =
IOPS across both LVMs, ~21M - 46.7% idle (.73% users, 52.6% system time)
> Takeaway - IMHO, no reason to turn off SMT, it helps way more than it =
hurts...
>=20
> Without the partitioning and lvm shenanigans, with SMT on, 5.14rc4 =
kernel, most AMD BIOS tuning (not all), I'm at 46GB/s, 11.7M IOPS , =
42.2% idle (3% user, 54.7% system time)
>=20
> With stock RHEL 8.4, 4.18 kernel, SMT on, both partitioning and LVM =
shenanigans, most AMD BIOS tuning (not all), I'm at 81.5GB/s, 20.4M =
IOPS, 49% idle (5.5% user, 46.75% system time)
>=20
> The question I have for the list, given my large drive sizes, it takes =
me a day to set up and build an mdraid/lvm configuration.    Has anybody =
found the "sweet spot" for how many partitions per drive?    I now have =
a script to generate the drive partitions, a script for building the =
mdraid volumes, and a procedure for unwinding from all of this and =
starting again.   =20
>=20
> If anybody knows the point of diminishing return for the number of =
partitions per drive to max out at, it would save me a few days of =
letting 32 run for a day, reconfiguring for 16, 8, 4, 2, 1....I could =
just tear apart my LVMs and remake them with half as many RAID =
partitions, but depending upon how the nvme drive is "RAINed" across =
NAND chips, I might leave performance on the table.   The researcher in =
me says, start over, don't make ANY assumptions.
>=20
> As an aside, on the server, I'm maintaining around 1.1M  NUMA aware =
IOPS per drive, when hitting all 24 drives individually without RAID, so =
I'm thrilled with the performance ceiling with the RAID, I just have to =
find a way to make it something somebody would be willing to maintain.   =
Somewhere is a sweet spot between sustainability and performance.   Once =
I find that I have to figure out if there is something useful to do with =
this new toy.....
>=20
>=20
> Regards,
> Jim
>=20
>=20
>=20
>=20
> -----Original Message-----
> From: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>=20=

> Sent: Monday, August 9, 2021 3:02 PM
> To: 'Gal Ofri' <gal.ofri@volumez.com>; 'linux-raid@vger.kernel.org' =
<linux-raid@vger.kernel.org>
> Cc: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>
> Subject: RE: [Non-DoD Source] Re: Can't get RAID5/RAID6 NVMe =
randomread IOPS - AMD ROME what am I missing?????
>=20
> Sequential Performance:
> BLUF, 1M sequential, direct I/O  reads, QD 128  - 85GiB/s across both =
10+1+1 NUMA aware 128K striped LUNS.   Had the imbalance between NUMA 0 =
44.5GiB/s and NUMA 1 39.4GiB/s but still could be drifting power =
management on the AMD Rome cores.    I tried a 1280K blocksize to try to =
get a full stripe read, but Linux seems so unfriendly to non-power of 2 =
blocksizes.... performance decreased considerably (20GiB/s ?) with the =
10x128KB blocksize....   I think I ran for about 40 minutes with the 1M =
reads...
>=20
>=20
> socket0-md: (g=3D0): rw=3Dread, bs=3D(R) 1024KiB-1024KiB, (W) =
1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=3Dlibaio, iodepth=3D128 =
...
> socket1-md: (g=3D1): rw=3Dread, bs=3D(R) 1024KiB-1024KiB, (W) =
1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=3Dlibaio, iodepth=3D128 =
...
> fio-3.26
> Starting 128 processes
>=20
> fio: terminating on signal 2
>=20
> socket0-md: (groupid=3D0, jobs=3D64): err=3D 0: pid=3D1645360: Mon Aug =
 9 18:53:36 2021
>  read: IOPS=3D45.6k, BW=3D44.5GiB/s (47.8GB/s)(114TiB/2626961msec)
>    slat (usec): min=3D12, max=3D4463, avg=3D24.86, stdev=3D15.58
>    clat (usec): min=3D249, max=3D1904.8k, avg=3D179674.12, =
stdev=3D138190.51
>     lat (usec): min=3D295, max=3D1904.8k, avg=3D179699.07, =
stdev=3D138191.00
>    clat percentiles (msec):
>     |  1.00th=3D[    3],  5.00th=3D[    5], 10.00th=3D[    7], =
20.00th=3D[   17],
>     | 30.00th=3D[  106], 40.00th=3D[  116], 50.00th=3D[  209], =
60.00th=3D[  226],
>     | 70.00th=3D[  236], 80.00th=3D[  321], 90.00th=3D[  351], =
95.00th=3D[  372],
>     | 99.00th=3D[  472], 99.50th=3D[  481], 99.90th=3D[ 1267], =
99.95th=3D[ 1401],
>     | 99.99th=3D[ 1586]
>   bw (  MiB/s): min=3D  967, max=3D114322, per=3D8.68%, avg=3D45897.69, =
stdev=3D330.42, samples=3D333433
>   iops        : min=3D  929, max=3D114304, avg=3D45879.39, =
stdev=3D330.41, samples=3D333433
>  lat (usec)   : 250=3D0.01%, 500=3D0.01%, 750=3D0.05%, 1000=3D0.06%
>  lat (msec)   : 2=3D0.49%, 4=3D4.36%, 10=3D9.43%, 20=3D7.52%, 50=3D3.48%=

>  lat (msec)   : 100=3D2.70%, 250=3D47.39%, 500=3D24.25%, 750=3D0.09%, =
1000=3D0.01%
>  lat (msec)   : 2000=3D0.15%
>  cpu          : usr=3D0.07%, sys=3D1.83%, ctx=3D77483816, majf=3D0, =
minf=3D37747
>  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, =
32=3D0.1%, >=3D64=3D100.0%
>     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
>     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.1%
>     issued rwts: total=3D119750623,0,0,0 short=3D0,0,0,0 =
dropped=3D0,0,0,0
>     latency   : target=3D0, window=3D0, percentile=3D100.00%, =
depth=3D128
> socket1-md: (groupid=3D1, jobs=3D64): err=3D 0: pid=3D1645424: Mon Aug =
 9 18:53:36 2021
>  read: IOPS=3D40.3k, BW=3D39.4GiB/s (42.3GB/s)(101TiB/2627054msec)
>    slat (usec): min=3D12, max=3D57137, avg=3D23.77, stdev=3D27.80
>    clat (usec): min=3D130, max=3D1746.1k, avg=3D203005.37, =
stdev=3D158045.10
>     lat (usec): min=3D269, max=3D1746.1k, avg=3D203029.23, =
stdev=3D158045.27
>    clat percentiles (usec):
>     |  1.00th=3D[    570],  5.00th=3D[    693], 10.00th=3D[   2573],
>     | 20.00th=3D[  21103], 30.00th=3D[ 102237], 40.00th=3D[ 143655],
>     | 50.00th=3D[ 204473], 60.00th=3D[ 231736], 70.00th=3D[ 283116],
>     | 80.00th=3D[ 320865], 90.00th=3D[ 421528], 95.00th=3D[ 455082],
>     | 99.00th=3D[ 583009], 99.50th=3D[ 608175], 99.90th=3D[1061159],
>     | 99.95th=3D[1166017], 99.99th=3D[1367344]
>   bw (  MiB/s): min=3D  599, max=3D124821, per=3D-3.40%, avg=3D40571.79,=
 stdev=3D319.36, samples=3D333904
>   iops        : min=3D  568, max=3D124809, avg=3D40554.92, =
stdev=3D319.34, samples=3D333904
>  lat (usec)   : 250=3D0.01%, 500=3D0.14%, 750=3D6.31%, 1000=3D2.60%
>  lat (msec)   : 2=3D0.58%, 4=3D2.04%, 10=3D4.17%, 20=3D3.82%, 50=3D3.71%=

>  lat (msec)   : 100=3D5.91%, 250=3D32.86%, 500=3D33.81%, 750=3D3.81%, =
1000=3D0.10%
>  lat (msec)   : 2000=3D0.14%
>  cpu          : usr=3D0.05%, sys=3D1.56%, ctx=3D71342745, majf=3D0, =
minf=3D37766
>  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, =
32=3D0.1%, >=3D64=3D100.0%
>     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
>     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.1%
>     issued rwts: total=3D105992570,0,0,0 short=3D0,0,0,0 =
dropped=3D0,0,0,0
>     latency   : target=3D0, window=3D0, percentile=3D100.00%, =
depth=3D128
>=20
> Run status group 0 (all jobs):
>   READ: bw=3D44.5GiB/s (47.8GB/s), 44.5GiB/s-44.5GiB/s =
(47.8GB/s-47.8GB/s), io=3D114TiB (126TB), run=3D2626961-2626961msec
>=20
> Run status group 1 (all jobs):
>   READ: bw=3D39.4GiB/s (42.3GB/s), 39.4GiB/s-39.4GiB/s =
(42.3GB/s-42.3GB/s), io=3D101TiB (111TB), run=3D2627054-2627054msec
>=20
> Disk stats (read/write):
>    md0: ios=3D960804546/0, merge=3D0/0, ticks=3D18446744072288672424/0, =
in_queue=3D18446744072288672424, util=3D100.00%, aggrios=3D0/0, =
aggrmerge=3D0/0, aggrticks=3D0/0, aggrin_queue=3D0, aggrutil=3D0.00%
>  nvme0n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme3n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme6n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme11n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme9n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme2n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme5n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme10n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme8n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme1n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme4n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme7n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>    md1: ios=3D850399203/0, merge=3D0/0, ticks=3D2118156441/0, =
in_queue=3D2118156441, util=3D100.00%, aggrios=3D0/0, aggrmerge=3D0/0, =
aggrticks=3D0/0, aggrin_queue=3D0, aggrutil=3D0.00%
>  nvme15n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme18n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme20n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme23n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme14n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme17n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme22n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme13n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme19n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme21n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme12n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>  nvme24n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, =
util=3D0.00%
>=20
> -----Original Message-----
> From: Gal Ofri <gal.ofri@volumez.com>
> Sent: Sunday, August 8, 2021 10:44 AM
> To: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>
> Cc: 'linux-raid@vger.kernel.org' <linux-raid@vger.kernel.org>
> Subject: Re: [Non-DoD Source] Re: Can't get RAID5/RAID6 NVMe =
randomread IOPS - AMD ROME what am I missing?????
>=20
> On Thu, 5 Aug 2021 21:10:40 +0000
> "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil> =
wrote:
>=20
>> BLUF upfront with 5.14rc3 kernel that our SA built - md0 a 10+1+1
>> RAID5 - 5.332 M IOPS 20.3GiB/s, md1 a 10+1+1 RAID5, 5.892M IOPS =
22.5GiB/s  - best hero numbers I've ever seen on mdraid  RAID5 IOPS.   I =
think the kernel patch is good.  Prior was  socket0 1.263M IOPS =
4934MiB/s, socket1 1.071M IOSP, 4183MiB/s....   I'm willing to help push =
this as hard as we can until we hit a bottleneck outside of our control.
> That's great !
> Thanks for sharing your results.
> I'd appreciate if you could run a sequential-reads workload =
(128k/256k) so that we get a better sense of the throughput potential =
here.
>=20
>> In my strict numa adherence with mdraid, I see lots of variability =
between reboots/assembles.    Sometimes md0 wins, sometimes md1 wins, =
and in my earlier runs md0 and md1 are notionally balanced.   I change =
nothing but see this variance.   I just cranked up a week long extended =
run of these 10+1+1s under the 5.14rc3 kernel and right now   md0 is =
doing 5M IOPS and md1 6.3M=20
> Given my humble experience with the code in question, I suspect that =
it is not really optimized for numa awareness, so I find your findings =
quite reasonable. I don't really have a good tip for that.
>=20
> I'm focusing now on thin-provisioned logical volumes (lvm - it has a =
much worse reads bottleneck actually), but we have plans for researching
> md/raid5 again soon to improve write workloads.
> I'll ping you when I have a patch that might be relevant.
>=20
> Cheers,
> Gal
