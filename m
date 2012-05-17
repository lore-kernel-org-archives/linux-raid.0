From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: doubt about resync - raid1
Date: Thu, 17 May 2012 12:57:18 -0300
Message-ID: <CABYL=TrpEHiEKDrTVfMh4AMSOFBO_CeJ3rY721sa1kBoJ_pODQ@mail.gmail.com>
References: <CABYL=TpcfGubJAnCJ=Z5T3Lh4PVKQSWPwSXAx+-=ke3pp_+aOg@mail.gmail.com>
	<CABYL=ToxbORuD-rM1oh9MUWeF5v5gu8LyMVbXAFeoVbfc=_pow@mail.gmail.com>
	<CALFpzo4rsv_2+E-WXWs2Hq5_D83fT3fbQBH5Rx2nqdcZrdih3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALFpzo4rsv_2+E-WXWs2Hq5_D83fT3fbQBH5Rx2nqdcZrdih3Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marcus Sorensen <shadowsor@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i did this and don't worked
echo 1 > /sys/block/md1/md/sync_force_parallel

at /proc/mdstat
/dev/md1 appears as sync
but stay at 0%
and after /dev/md0 resync /dev/md1 start

there's another way to force sync?

2012/5/17 Marcus Sorensen <shadowsor@gmail.com>
>
> see /sys/block/md[0,1,2]/md/sync_force_parallel
>
> On Thu, May 17, 2012 at 9:50 AM, Roberto Spadim <roberto@spadim.com.b=
r> wrote:
> > hi guys, i was running a resync in a non-normal hardware instalatio=
n
> >
> > it's a server with 4 disks, they are in a raid hardware controller =
(perci
> > from dell)
> > disk 1-2 are raid1 and linux know it about /dev/sda
> > disk 3-4 are raid1 and linux know it about /dev/sdb
> >
> > well i add more 4 disks
> > disk 5-6 raid1 with /dev/sdc
> > disk 7-8 raid1 with /dev/sdd
> >
> > nice...
> > well /dev/sda and /dev/sdb have same partitions (/dev/sda1, 2 3 4) =
and have
> > some md devices in this partitions..
> > /dev/md0 =3D /dev/sda1 /dev/sdb1
> > /dev/md1 =3D /dev/sda2 /dev/sdb2
> > /dev/md2 =3D /dev/sda3 /dev/sdb3
> > all raid 1 too
> >
> > i create same partitions on /dev/sdc, /dev/sdd
> > and add they to md raid1
> > /dev/md0 =3D /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
> > /dev/md1 =3D /dev/sda2 /dev/sdb2 /dev/sdc2 /dev/sdd2
> > /dev/md2 =3D /dev/sda3 /dev/sdb3 /dev/sdc3 /dev/sdd3
> >
> >
> > nice..
> > mdadm start resync...
> > the point is...
> > /dev/sda1 start copies to /dev/sdc1 and /dev/sdd1, i checked this w=
ith
> > iostat -d 1 -k, and server is idle, only mdadm and raid is running,
> > /dev/sda1 have reads and /dev/sdc1 and /dev/sdd1 have writes
> > nice..
> >
> > the problem is...
> > /dev/sdc2 and /dev/sdd2 didn't start sync while /dev/md0 is running=
, since
> > they share the same devices (/dev/md0 =3D> /dev/sda1, /dev/md1 =3D>=
 /dev/sda2)
> >
> > could i force a sync in /dev/md1??
> > since /dev/sda is a raid1 hardware, it can handle two disks without
> > performace problems...
> > it have 2 heads, in others words the mdadm disk balance isn't perfe=
ct here
> > to this solution, but works... the problem is sync not running, if =
i could
> > force it every things could be allright
> >
> > i must check kernel version, it's about 2.6.3x, 1 year old +-
> >
> > well that's it, any ideas?
> >
> >
> > ***
> > sorry if i send two emails, the email was configured to HTML/RICH T=
EXT text
> >
> >
> > --
> > Roberto Spadim
> > Spadim Technology / SPAEmpresarial
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html




--
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
