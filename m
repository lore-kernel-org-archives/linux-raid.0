From: NeilBrown <neilb@suse.de>
Subject: Re: grow MULTIPATH RAID
Date: Fri, 25 Mar 2011 16:29:16 +1100
Message-ID: <20110325162916.0c47ec71@notabene.brown>
References: <loom.20110325T041239-956@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20110325T041239-956@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: shamim <shamim_99@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 25 Mar 2011 03:13:41 +0000 (UTC) shamim <shamim_99@yahoo.com> w=
rote:

> Hello Experts,
>=20
> Please help me to grow MULTIPATH RAID. =20
> My problem:
> I've Linux box which have MULTIPATH RAID created on them. Now we need=
 to remove
> those old LUN and move data onto new LUN presented to those boxes.
>=20
> My initially thought was to grow the  current MULTIPATH RAID (/dev/md=
0) and=20
> make old LUN as spare and then  failed and then remove(Is this a righ=
t
> approach?).  When I=E2=80=99m try adding new LUNs to it, they are get=
ting added as spare
> ( as shown below).  And when I try to grow , it refuse to do so.  Bel=
ow are the
> steps that I performed and error message.(Cannot reshaped!!)=20
> ( I read somehwere  that we can=E2=80=99t grow MULTIPATH RAID, if it =
is TRUE, then what
> would be suggested solution to move data from old LUNs to new LUNs)
> Please help

No, you cannot grow an md/multipath device.
However you can simply create a new multipath config across
the set of paths that you want to use.

mdadm --stop /dev/md0
mdadm --create /dev/md0 --l multipath -n 4 ..list..of..paths...

However I recommend that you stop using md/multipath and look in to
using dm-multipath instead.  See the 'multipath' command.

dm-multipath is actively developed.  md/multipath is not.

NeilBrown


> --------------------------------------------------
> =20
> # mdadm --detail /dev/md0
> /dev/md0:
>         Version : 0.90
>   Creation Time : Thu Mar 24 13:54:41 2011
>      Raid Level : multipath
>      Array Size : 10486016 (10.00 GiB 10.74 GB)
>    Raid Devices : 2
>   Total Devices : 4
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>=20
>     Update Time : Thu Mar 24 13:54:41 2011
>           State : clean
>  Active Devices : 2
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 2
>=20
>            UUID : xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
>          Events : 0.3
>=20
>     Number   Major   Minor   RaidDevice State
>        0      65        0        0      active sync   /dev/sdq
>        1       8       96        1      active sync   /dev/sdg
> --------------------------------------------------------------------
> # mdadm /dev/md0 --add /dev/sdr /dev/sdh
> mdadm: added /dev/sdr
> mdadm: re-added /dev/sdh
>=20
> --------------------------------------------------------------------
> # mdadm --detail /dev/md0
> /dev/md0:
>         Version : 0.90
>   Creation Time : Thu Mar 24 13:54:41 2011
>      Raid Level : multipath
>      Array Size : 10486016 (10.00 GiB 10.74 GB)
>    Raid Devices : 2
>   Total Devices : 4
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>=20
>     Update Time : Thu Mar 24 13:54:41 2011
>           State : clean
>  Active Devices : 2
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 2
>=20
>            UUID : xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
>          Events : 0.3
>=20
>     Number   Major   Minor   RaidDevice State
>        0      65        0        0      active sync   /dev/sdq
>        1       8       96        1      active sync   /dev/sdg
>=20
>        2      65       16        -      spare   /dev/sdr
>        3       8      112        -      spare   /dev/sdh
>=20
> --------------------------------------------------------------------
> # mdadm --grow /dev/md0 --raid-disks=3D4
> mdadm: multipath array /dev/md0 cannot be reshaped.
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
