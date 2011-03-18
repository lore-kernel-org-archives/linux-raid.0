From: Xavier Brochard <xavier@alternatif.org>
Subject: Re: disk order problem in a raid 10 array
Date: Fri, 18 Mar 2011 21:12:49 +0100
Message-ID: <201103182112.49660.xavier@alternatif.org>
References: <201103181549.20835.xavier@alternatif.org> <AANLkTin0L4wV3uFFhkeWPptvEddsS5ZntxVx51x2rjW_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin0L4wV3uFFhkeWPptvEddsS5ZntxVx51x2rjW_@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Le vendredi 18 mars 2011 18:22:34 hansbkk@gmail.com, vous avez =E9crit =
:
> On Fri, Mar 18, 2011 at 9:49 PM, Xavier Brochard <xavier@alternatif.o=
rg>=20
wrote:
> > disk order is mixed between each boot - even with live-cd.
> > is that normal?
>=20
> If nothing is changing and the order is swapping really every boot,
> then IMO that is odd.

nothing has changed, except kernel minor version

>=20
> Part of my SOP is now to record both mdadm and the boot loader's
> ordering against serial number and UUID of drives when creating an
> array, and to put the relevant information on labels securely attache=
d
> to the physical drives, along with creating a map of their physical
> location and taping that inside the case.nt
>=20
> It's critical to know what's what in a crisis. . .

exactly, in my case mdadm --examine output is somewhat weird as it show=
s:
/dev/sde1
this     0       8       33        0      active sync   /dev/sdd1
/dev/sdd1
this     0       8       33        0      active sync   /dev/sdc1
/dev/sdc1
this     0       8       33        0      active sync   /dev/sde1
and /dev/sdf1 as sdf1

I think I can believe mdadm?
and that /proc/mdstat content comes directly from mdadm (that is with "=
exact"
sdc,d,e)?

what trouble me is that after I removed 2 disk drive from the bay, mdad=
m start=20
to recover:=20
md0 : active raid10 sdb1[1] sdc1[4] sdd1[3]
      976767872 blocks 64K chunks 2 near-copies [4/2] [_U_U]
      [=3D>...................]  recovery =3D  5.0% (24436736/488383936=
)=20
finish=3D56.2min speed=3D137513K/sec

I guess that it is ok, and that it is recovering with the spare. But I =
would=20
like to be sure...


Xavier
xavier@alternatif.org - 09 54 06 16 26
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
