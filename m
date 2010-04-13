From: Neil Brown <neilb@suse.de>
Subject: Re: raid10,f2 Add a Controller: Which drives to move?
Date: Tue, 13 Apr 2010 23:09:26 +1000
Message-ID: <20100413230926.1273fc64@notabene.brown>
References: <loom.20100411T185315-118@post.gmane.org>
	<4BC29670.6020504@unart.cz>
	<4BC2B887.6020403@stud.tu-ilmenau.de>
	<4BC2CF14.9000209@unart.cz>
	<j2t40b437201004122026zd43aa129nb501cfc83d5cdafd@mail.gmail.com>
	<20100413092354.GA7581@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100413092354.GA7581@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld Simonsen <keld@keldix.com>
Cc: Simon Matthews <simon.d.matthews@gmail.com>, =?UTF-8?B?VG9tw6HFoSBE?= =?UTF-8?B?dWzDrWs=?= <dulik@unart.cz>, st0ff@npl.de, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 13 Apr 2010 11:23:54 +0200
Keld Simonsen <keld@keldix.com> wrote:

> I am not sure it has been said, but for a 4 disk raid10,f2 array
> you should place the first and the second disk on one controller, and=
 then the 3rd
> and 4th on the second controller. Then you would have a copy of all b=
locks even
> if one controller fails.

Uhmm... no.

Disk:   1    2    3    4
blocks  a    b    c    d
        e    f    g    h
         .........
        d    a    b    c
        h    e    f    g

If you only have first and second, then block c is missing.
You want 1st and 3rd on one controller, 2nd and 4th on the other
Then either controller can access all blocks.


>=20
> I believe the order is defined by the order the disks are specified i=
n
> on the mdadm --create line.

Correct.

NeilBrown


>=20
> best regards
> keld
>=20
> On Mon, Apr 12, 2010 at 08:26:55PM -0700, Simon Matthews wrote:
> > 2010/4/12 Tom=C3=A1=C5=A1 Dul=C3=ADk <dulik@unart.cz>:
> > > Stefan /*St0fF*/ H=C3=BCbner napsal(a):
> > >>
> > >> I cannot quite understand your problem. =C2=A0As every part of t=
he array
> > >> contains it's own metadata, it doesn't matter to md which /dev/s=
dX a
> > >> drive is. =C2=A0It might matter a bit for boot-time assembly, bu=
t actually
> > >> that's what UUIDs are for.
> > >>
> > >
> > > I know how UUIDs work.
> > > My problem with device names is not a "critical", it's about "use=
r
> > > friendliness" of the physical disk management.
> > > If a disk fails and I receive email "A Fail event had been detect=
ed on md
> > > device /dev/md2. It could be related to component device /dev/sdd=
3", how
> > > will I know which disk should be replaced, if the device name is =
not
> > > fixed/persistent? I
> >=20
> > Record the serial number of the disks and  which bay they are in.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
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
