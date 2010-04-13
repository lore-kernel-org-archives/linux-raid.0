From: Keld Simonsen <keld@keldix.com>
Subject: Re: raid10,f2 Add a Controller: Which drives to move?
Date: Tue, 13 Apr 2010 11:23:54 +0200
Message-ID: <20100413092354.GA7581@rap.rap.dk>
References: <loom.20100411T185315-118@post.gmane.org>
 <4BC29670.6020504@unart.cz>
 <4BC2B887.6020403@stud.tu-ilmenau.de>
 <4BC2CF14.9000209@unart.cz>
 <j2t40b437201004122026zd43aa129nb501cfc83d5cdafd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <j2t40b437201004122026zd43aa129nb501cfc83d5cdafd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Matthews <simon.d.matthews@gmail.com>
Cc: =?iso-8859-2?B?VG9t4bkgRHVs7Ws=?= <dulik@unart.cz>, st0ff@npl.de, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am not sure it has been said, but for a 4 disk raid10,f2 array
you should place the first and the second disk on one controller, and t=
hen the 3rd
and 4th on the second controller. Then you would have a copy of all blo=
cks even
if one controller fails.

I believe the order is defined by the order the disks are specified in
on the mdadm --create line.

best regards
keld

On Mon, Apr 12, 2010 at 08:26:55PM -0700, Simon Matthews wrote:
> 2010/4/12 Tom=E1=B9 Dul=EDk <dulik@unart.cz>:
> > Stefan /*St0fF*/ H=FCbner napsal(a):
> >>
> >> I cannot quite understand your problem. =A0As every part of the ar=
ray
> >> contains it's own metadata, it doesn't matter to md which /dev/sdX=
 a
> >> drive is. =A0It might matter a bit for boot-time assembly, but act=
ually
> >> that's what UUIDs are for.
> >>
> >
> > I know how UUIDs work.
> > My problem with device names is not a "critical", it's about "user
> > friendliness" of the physical disk management.
> > If a disk fails and I receive email "A Fail event had been detected=
 on md
> > device /dev/md2. It could be related to component device /dev/sdd3"=
, how
> > will I know which disk should be replaced, if the device name is no=
t
> > fixed/persistent? I
>=20
> Record the serial number of the disks and  which bay they are in.
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
