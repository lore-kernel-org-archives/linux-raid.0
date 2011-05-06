From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: wish for Linux MD mirrored raid types
Date: Fri, 6 May 2011 15:30:08 -0500
Message-ID: <79.BD.29443.A4A54CD4@cdptpa-omtalb.mail.rr.com>
References: <20110506132739.GA22689@www2.open-std.org>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110506132739.GA22689@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?'Keld_J=F8rn_Simonsen'?= <keld@keldix.com>, 'David Brown' <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Keld J=F8rn Simonsen
> Sent: Friday, May 06, 2011 8:28 AM
> To: David Brown
> Cc: linux-raid@vger.kernel.org
> Subject: Re: wish for Linux MD mirrored raid types
>=20
> On Fri, May 06, 2011 at 12:54:28PM +0200, David Brown wrote:
> > On 06/05/2011 12:05, Jonathan Tripathy wrote:
> > >
> > >>>>RAID1 is traditionally a mirror only setup (ok, some RAID
> > >>>>implementations may do some load-balancing of some sort). So a =
RAID1
> > >>>>with 4 disks is one data set copied onto 4 disks. Bandwidth is
> roughly
> > >>>>the same as a single disk (ignoring any load balancing).
> > >>>>RAID10 is mirror and stripe. A RAID10 with 4 disks is similar t=
o a 2
> > >>>>disk RAID0 (double bandwidth with data split in half across bot=
h
> > >>>>disks),
> > >>>>but with each disk having a mirror (which brings the total up t=
o 4
> > >>>>drives).
> > >>>>
> > >>>>Additionally, a RAID1 disk (at least using MD) can be accessed =
just
> > >>>>like
> > >>>>a normal disk (good for recovery etc.) however a single disk ou=
t of
> a
> > >>>>RAID10 array is next to useless.
> > >Just so I can sleep at night, is my understanding of RAID10 and RA=
ID1
> > >above correct?
> > >
> >
> > It's mostly right (assuming, of course, that /I/ am correct here...=
).
> >
> > RAID1 is traditionally a two-way mirror on two disks (or possibly o=
n two
> > other raid sets, as in raid0+1).  So if you talk about RAID1 with 4
> > disks, you should probably qualify it more precisely - otherwise pe=
ople
> > will wonder what you mean, or think it is impossible (many other RA=
ID1
> > solutions, hardware or software, don't support more than two-way
> > mirrors).  /I/ would certainly say that a 4-disk RAID1 is a four-wa=
y
> > mirror as you described - but some people might think of a standard
> > layout RAID1+0.
> >
> > As you say, RAID10,near on four disks is pretty much identical to
> > RAID1+0 - i.e., a stripe of two normal RAID1 pairs.
> >
> > A single md RAID1 disk can be accessed like a normal disk, /if/ it =
uses
> > metadata format 0.90 which is put at the end of the drive.  If you =
have
> > later metadata formats that are at the beginning, then that will ca=
use
> > trouble if you try to view the disk without using md.  A single dis=
k
> > from a RAID10 is, as you say, useless without md.
> >
> > However, assuming your recovery PC supports md raid, then you can
> > assembly your single RAID10 disk as a degraded RAID10 array.  After=
 all,
> > it wouldn't be very redundant if you only had access to your data w=
hen
> > all the disks were working!
>=20
> I agree with what David Brown says here.
>=20
> Just some further remarks:
>=20
> You can have Linux MD raid10 arrays with only 2 disks.
> This is different from RAID1+0 that requires at least 4 disks.
>=20
> You can also with Linux MD have an odd number of disk, which is
> impossible with RAID1+0.
>=20
> Linux MD raid10 is a kernel driver that handles everything in
> one module, while RAID1+0 is handled in two drivers - raid0 over raid=
1.
> The latter is called nested RAID, and the Linux MD raid10 is not a
> nested RAID, while RAID1+0 is.
>=20
> With Linux MD raid10,near and superblock 0.90 you can also
> boot it from old grub, lilo etc, as each partition can be seen as a n=
ormal
> file system.
>=20
> As David pointed out, "a single disk out of a RAID10 array is next to
> useless" is not true. Linux MD RAID10 is designed to always be able t=
o
> hold all data intact if one disk is out. You just need Linux MD raid1=
0
> aware software.
>=20
> I apologise for being abrupt in my first answer. But the thing is tha=
t
> I am getting tired of explaining and correcting all these misconcepti=
ons
> again and again. And my proposal is an attempt to stop at least some
> of the need for explaining, while also bringing the best practise for=
ward
> to
> the users of our technology, for the benefit of the users.

	I think there are several more issues at hand, here, than your
suggestion takes into consideration.  Special Relativity, as the name
suggests, is a special case of General Relativity, but no one, and I me=
an
*NO ONE* ever approaches an SR problem by applying the mechanics of GR =
and
letting the equations collapse along the way.  Indeed, Einstein himself
developed SR several years before tackling the much more complex proble=
m of
GR, the fact all the same physical processes are involved and the fact =
the
postulates are identical notwithstanding.

	It doesn't really much matter whether the developers decide to
implement RAID1 as a part of the same engine that delivers RAID10, or n=
ot.
It also does not matter whether the admin can produce the exact same re=
sults
at the code execution level by implementing a specific topology of RAID=
10 or
not.  OTOH, however, if there are any functional or operational differe=
nces
between the implementation of RAID1 and an implementation of RAID10 tha=
t
produces the same layout, then the two are simply not the same, at all.
Period.

	The bottom line, however, is that even if RAID1 is at the code level
just a specific implementation of RAID10, it still is a sufficiently
distinct operational mode to warrant its own name, setting it aside fro=
m the
more general RAID10 implementation.  Aside from that, when I say, "My
servers boot from 2 disk RAID1 arrays", everyone knows exactly what I m=
ean
without my having to go into more detail about the layout.  For the mos=
t
part, it doesn't really matter if I happened to create the array using =
a
specific layout of RAID10.  This has its greatest importance for someon=
e
inexperienced with RAID systems, who perhaps is setting up his very fir=
st
mirrored array with a pair of disks.  Having to try to learn all the in=
s and
outs of RAID10 layouts just to be able to create a pair (or triplet) of
mirrored disks is not appropriate.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
