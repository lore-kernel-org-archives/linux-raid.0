From: NeilBrown <neilb@suse.de>
Subject: Re: disk order problem in a raid 10 array
Date: Sat, 19 Mar 2011 09:22:51 +1100
Message-ID: <20110319092251.4e696367@notabene.brown>
References: <201103181549.20835.xavier@alternatif.org>
	<AANLkTin0L4wV3uFFhkeWPptvEddsS5ZntxVx51x2rjW_@mail.gmail.com>
	<201103182112.49660.xavier@alternatif.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201103182112.49660.xavier@alternatif.org>
Sender: linux-raid-owner@vger.kernel.org
To: Xavier Brochard <xavier@alternatif.org>
Cc: hansbkk@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 18 Mar 2011 21:12:49 +0100 Xavier Brochard <xavier@alternatif.o=
rg>
wrote:

> Le vendredi 18 mars 2011 18:22:34 hansbkk@gmail.com, vous avez =E9cri=
t :
> > On Fri, Mar 18, 2011 at 9:49 PM, Xavier Brochard <xavier@alternatif=
=2Eorg>=20
> wrote:
> > > disk order is mixed between each boot - even with live-cd.
> > > is that normal?
> >=20
> > If nothing is changing and the order is swapping really every boot,
> > then IMO that is odd.
>=20
> nothing has changed, except kernel minor version

Yet you don't tell us what the kernel minor version changed from or to.

That may not be important, but it might and you obviously don't know wh=
ich.
It is always better to give too much information rather than not enough=
=2E


>=20
> >=20
> > Part of my SOP is now to record both mdadm and the boot loader's
> > ordering against serial number and UUID of drives when creating an
> > array, and to put the relevant information on labels securely attac=
hed
> > to the physical drives, along with creating a map of their physical
> > location and taping that inside the case.nt
> >=20
> > It's critical to know what's what in a crisis. . .
>=20
> exactly, in my case mdadm --examine output is somewhat weird as it sh=
ows:
> /dev/sde1
> this     0       8       33        0      active sync   /dev/sdd1
> /dev/sdd1
> this     0       8       33        0      active sync   /dev/sdc1
> /dev/sdc1
> this     0       8       33        0      active sync   /dev/sde1
> and /dev/sdf1 as sdf1

You are hiding lots of details again...

Are these all from different arrays?  They all claim to be 'device 0' o=
f some
array.

Infact,  "8, 33" is *always* /dev/sdc1,  so I think the above lines hav=
e been
edited by hand because I'm 100% certain mdadm didn't output them.


>=20
> I think I can believe mdadm?

Yes, you can believe mdadm - but only if you understand what it is sayi=
ng,
and there are times when that is not as easy as one might like....

> and that /proc/mdstat content comes directly from mdadm (that is with=
 "exact"
> sdc,d,e)?
>=20
> what trouble me is that after I removed 2 disk drive from the bay, md=
adm start=20
> to recover:=20
> md0 : active raid10 sdb1[1] sdc1[4] sdd1[3]
>       976767872 blocks 64K chunks 2 near-copies [4/2] [_U_U]
>       [=3D>...................]  recovery =3D  5.0% (24436736/4883839=
36)=20
> finish=3D56.2min speed=3D137513K/sec

Why exactly does this trouble you?  It seems to be doing exactly the ri=
ght
thing.

>=20
> I guess that it is ok, and that it is recovering with the spare. But =
I would=20
> like to be sure...

Sure of what?  If you want a clear answer you need to ask a clear quest=
ion.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
