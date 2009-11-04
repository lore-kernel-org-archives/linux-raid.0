From: CoolCold <coolthecold@gmail.com>
Subject: Re: Slow raid5 grow performance, with iostat showing unexpected
	behavior
Date: Thu, 5 Nov 2009 01:45:08 +0300
Message-ID: <f19d625d0911041445g69f1790u8aa8ed2e2b70cd51@mail.gmail.com>
References: <ef2613f30911041244h258de090sdc79612a08b38339@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ef2613f30911041244h258de090sdc79612a08b38339@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: James Lee <james.lee@cantab.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You can try blktrace , should be in Ubuntu repos.

On Wed, Nov 4, 2009 at 11:44 PM, James Lee <james.lee@cantab.net> wrote=
:
> Hi all,
>
> I'm currently running a grow operation to add a third drive to a
> 2-drive RAID5 array. =A0After increasing speed_limit_min and
> speed_limit_max, to large values, the reshape is progressing at a
> fairly constant 8 - 8.5 MB/s. =A0This isn't crazily slow, but I'd exp=
ect
> faster - I've had a bit of a dig and am seeing some unexpected
> behavior.
>
>
> Here's what /proc/mdstat shows (md1 is the array being reshaped, sde2
> is the new device):
>
> james@james-server:~$ cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md1 : active raid5 sde2[2] sdd2[0] sdf2[1]
> =A0 =A0 =A0419922944 blocks super 0.91 level 5, 64k chunk, algorithm =
2 [3/3] [UUU]
> =A0 =A0 =A0[=3D=3D=3D>.................] =A0reshape =3D 18.5% (780527=
36/419922944)
> finish=3D688.5min speed=3D8272K/sec
>
> md0 : active raid5 sde1[3] sda1[0] sdg1[5] sdf1[4] sdd1[2] sdb1[1]
> =A0 =A0 =A01562481280 blocks level 5, 64k chunk, algorithm 2 [6/6] [U=
UUUUU]
>
>
> I'd expect iostat to show reads and writes for sdd2 and sdf2, and
> writes for sde2, and not a lot else (the system is idle other than
> this reshape). =A0What it actually shows is:
>
> james@james-server:~$ iostat
> Linux 2.6.24-25-server (james-server) =A0 =A0 11/04/2009
>
> avg-cpu: =A0%user =A0 %nice %system %iowait =A0%steal =A0 %idle
> =A0 =A0 =A0 =A0 =A0 0.15 =A0 =A00.02 =A0 =A03.27 =A0 =A00.30 =A0 =A00=
=2E00 =A0 96.26
>
> Device: =A0 =A0 =A0 =A0 =A0 =A0tps =A0 Blk_read/s =A0 Blk_wrtn/s =A0 =
Blk_read =A0 Blk_wrtn
> sda =A0 =A0 =A0 =A0 =A0 =A0 =A012.91 =A0 =A0 =A07705.76 =A0 =A0 =A0 =A0=
 0.04 =A0625173188 =A0 =A0 =A0 3224
> sdb =A0 =A0 =A0 =A0 =A0 =A0 =A012.60 =A0 =A0 =A07705.81 =A0 =A0 =A0 =A0=
 0.03 =A0625177270 =A0 =A0 =A0 2744
> md0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.84 =A0 =A0 =A0 =A0 6.68 =A0 =A0 =A0=
 =A0 0.02 =A0 =A0 542154 =A0 =A0 =A0 1440
> sdc =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.56 =A0 =A0 =A0 =A011.55 =A0 =A0 =A0=
 =A0 4.94 =A0 =A0 937168 =A0 =A0 400472
> sdd =A0 =A0 =A0 =A0 =A0 =A0 =A033.75 =A0 =A0 11604.87 =A0 =A0 =A01954=
=2E45 =A0941509808 =A0158565904
> sde =A0 =A0 =A0 =A0 =A0 =A0 =A020.40 =A0 =A0 =A0 =A0 0.11 =A0 =A0 =A0=
9658.00 =A0 =A0 =A0 9288 =A0783558900
> sdf =A0 =A0 =A0 =A0 =A0 =A0 =A032.18 =A0 =A0 11604.88 =A0 =A0 =A01954=
=2E46 =A0941510562 =A0158566272
> sdg =A0 =A0 =A0 =A0 =A0 =A0 =A015.20 =A0 =A0 =A07705.83 =A0 =A0 =A0 =A0=
 0.03 =A0625178358 =A0 =A0 =A0 2728
> md1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.16 =A0 =A0 =A0 =A0 1.28 =A0 =A0 =A0=
 =A0 0.00 =A0 =A0 103608 =A0 =A0 =A0 =A0 =A00
> dm-0 =A0 =A0 =A0 =A0 =A0 =A0 =A00.99 =A0 =A0 =A0 =A0 7.92 =A0 =A0 =A0=
 =A0 0.02 =A0 =A0 642418 =A0 =A0 =A0 1440
>
>
> So we see what we'd expect for the three drives in the md1 array, but
> I also see reads on the drives in the md0 array (which isn't being
> reshaped, resynced, or read from). =A0That would presumably explain w=
hy
> the reshape is running more slowly than expected - assuming 7.8 MB/s
> is being read from each device in md0 (which includes partitions on
> the same drives as md1 devices) then sdd and sdf are going to be
> seeking like crazy reading data for the md0 array and the md1 array a=
t
> the same time. =A0This is potentially also causing contention on the =
PCI
> bus.
>
> One thing which might be relevant is that I've got LVM on top of thes=
e
> arrays (each array is a PV, and the PVs form a single LV). =A0I'd hav=
e
> thought the reshape would have been transparent to LVM though. =A0Als=
o
> I'd have thought that if something was genuinely trying to read data
> from md0, iostat would report reads on the array, which it doesn't.
>
> Any ideas? =A0How can I tell what's causing the reads to the devices =
in
> md0? =A0In case it's relevant, I'm running Ubuntu 8.04 with unmodifie=
d
> kernel and mdadm:
>
> james@james-server:~$ uname -r
> 2.6.24-25-server
> james@james-server:~$ mdadm --version
> mdadm - v2.6.3 - 20th August 2007
>
> Thanks,
> James Lee
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
