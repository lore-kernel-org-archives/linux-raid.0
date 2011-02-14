From: Doug Dumitru <doug@easyco.com>
Subject: Re: write-behind has no measurable effect?
Date: Mon, 14 Feb 2011 14:56:37 -0800
Message-ID: <AANLkTi=fte1B=D_8=KrEf9_dVT5gAEPTy-uw1Duz_ECB@mail.gmail.com>
References: <20110214213817.GG836@hellgate.intra.guy>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110214213817.GG836@hellgate.intra.guy>
Sender: linux-raid-owner@vger.kernel.org
To: Andras Korn <korn@raidlist.elan.rulez.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Not to be too cute, but the man page for mdadm says that
--write-behind is only attempted on drives marked --write-mostly.=A0 I
did not see a --write-mostly in your array create statement.

Also, are you trying to create a three-way-mirror or mirror the one
ssd to two HDDs as stripes.=A0 If you want the latter, you need to
create a raid0 array and then the raid1 array.

=46or testing, two drives might produce fewer anomolies.

Doug Dumitru
EasyCo LLC

On Mon, Feb 14, 2011 at 1:38 PM, Andras Korn
<korn@raidlist.elan.rulez.org> wrote:
>
> Hi,
>
> I experimented a bit with write-mostly and write-behind and found tha=
t
> write-mostly provides a very significant benefit (see below) but
> write-behind seems to have no effect whatsoever.
>
> This is not what I expected and I wonder if I missed something.
>
> I built a RAID1 array from a 64GB Corsair SSD and two 7200rpm SATA ha=
rd
> disks. I created xfs on the array, then benchmarked it using bonnie++=
,
> iozone and by compiling linux 2.6.37 (with allyesconfig).
>
> Some interesting benchmark results follow. I used a 2.6.38-rc2 kernel=
 for
> these measurements.
>
> First, the stats that were identical (within a reasonable margin of e=
rror)
> across all measurements:
>
> bonnie++ blockwise sequential write: ~110MB/s
> bonnie++ blockwise sequential rewrite: ~60MB/s
> bonnie++ blockwise sequential read: ~160-175MB/s
> iozone read, 16k block size: ~135MB/s
> kernel compilation time, user: ~5450s (*)
> kernel compilation time, system: 570s (*)
>
> (*) I didn't measure kernel compilation times without write-mostly; I=
 expect
> they would've been worse.
>
> Now for some of the measurements that resulted in (to me) surprising
> differences:
>
> Using just the SSD (so no RAID), xfs mounted with
> "noatime,noikeep,attr2,logbufs=3D8,logbsize=3D256k":
>
> bonnie++ seeks/s: 7791
> iozone random read, 16k block size: ~46MB/s
> iozone random write, 16k block size: ~44MB/s
> iozone random read, 512k block size: ~130MB/s
> iozone random write, 512k block size: ~140MB/s
> wall clock kernel compile time: 887s
>
> RAID1 from two disks and one SSD, the disks set to write-behind:
>
> mdadm --create /dev/md/ssdraid --force --assume-clean --level=3D1 \
> --raid-devices=3D3 --bitmap=3Dinternal --bitmap-chunk=3D262144 \
> /dev/sdo2 --write-behind=3D16383 -W /dev/sd[nm]2
>
> xfs mount options:
> noatime,logbsize=3D256k,logbufs=3D8,noikeep,attr2,nodiratime,delaylog
>
> bonnie++ seeks/s: 2087
> iozone random read, 16k block size: ~43MB/s
> iozone random write, 16k block size: ~3.7MB/s
> iozone random read, 512k block size: ~126MB/s
> iozone random write, 512k block size: ~69MB/s
> wall clock kernel compile time: 936s
>
> (Note the drastically reduced random write performance.)
>
> Now the same setup, but with write-behind=3D0:
>
> bonnie++ seeks/s: 1843
> iozone random read, 16k block size: ~48MB/s
> iozone random write, 16k block size: ~3.7MB/s
> iozone random read, 512k block size: ~126MB/s
> iozone random write, 512k block size: ~69MB/s
> wall clock kernel compile time: 935s
>
> So, the difference between write-behind=3D0 and write-behind=3D16383 =
(which
> seems to be the maximum) is negligible (if not imaginary).
>
> For reference, some results with even write-mostly disabled:
>
> bonnie++ seeks/s: 487.4
> iozone random read, 16k block size: ~3.7MB/s
> iozone random write, 16k block size: ~3.7MB/s
> iozone random read, 512k block size: ~58MB/s
> iozone random write, 512k block size: ~69MB/s
>
> (The full result set is available from
> <http://elan.rulez.org/~korn/tmp/iobench.ods>, 27k.)
>
> It's easy to see from the results that write-mostly does as advertise=
d:
> reads are mostly served by the SSD, so that random reads are approxim=
ately
> as fast as when I only used the SSD.
>
> I'd have expected write-behind to increase the apparent random write
> performance though, and this didn't happen (there was no measurable
> difference).
>
> I thought maybe the iozone benchmark was too synthetic (too many writ=
es in
> too short a time, so that the buffer effect of write-behind is lost);=
 that's
> why I tried the kernel compilation, but I the raid array was as slow =
with
> write-behind as without it.
>
> Any idea why write-behind doesn't seem to have an effect?
>
> Thanks
>
> Andras
>
> --
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Andras Korn <korn at elan.rul=
ez.org>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Keep your ears open - but your legs c=
rossed.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--
Doug Dumitru
EasyCo LLC
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
