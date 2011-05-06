From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: wish for Linux MD mirrored raid types
Date: Fri, 6 May 2011 20:29:39 +0200
Message-ID: <20110506182939.GA23860@www2.open-std.org>
References: <20110506090345.GA22245@www2.open-std.org> <4DC3BDD9.1060300@abpni.co.uk> <20110506094102.GC22245@www2.open-std.org> <20110506155059.6f82cbeb@natsu> <4DC3C804.6080200@abpni.co.uk> <iq0jv1$psl$1@dough.gmane.org> <20110506132739.GA22689@www2.open-std.org> <4DC3FF4C.5090502@meetinghouse.net> <20110506152405.GB22964@www2.open-std.org> <BANLkTik8A0szuNk2HvDqQXpY3tSAdPoUKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTik8A0szuNk2HvDqQXpY3tSAdPoUKA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, Miles Fidelman <mfidelman@meetinghouse.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 06, 2011 at 12:34:36PM -0300, Roberto Spadim wrote:
> hum, i asked this question one time, the point is:
> raid1 code is very easy
> raid10 code is more complex
>=20
> easy =3D faster, less memory, less cpu
> complex =3D faster?, more memory? more cpu?


I think more complex -> more intelligent, more features.

I think it is actually amazing what raid10 can do.
Is raid 1 in other systems really limited to say 2 disks
- mirrored? Then linux raid10 is much more intelligent.=20
>=20
> check others raid system (freebsd, netbsd) and check how they do...

Yes, and also HW raid. If Linux made raid10,far the default for RAID1,
then I think Linux would compare very well with other operating systems
and HW raid.

Best regards
keld

----

> 2011/5/6 Keld J=F8rn Simonsen <keld@keldix.com>:
> > On Fri, May 06, 2011 at 10:01:48AM -0400, Miles Fidelman wrote:
> >> Keld J=F8rn Simonsen wrote:
> >> >>As you say, RAID10,near on four disks is pretty much identical t=
o
> >> >>RAID1+0 - i.e., a stripe of two normal RAID1 pairs.
> >> >>
> >>
> >> I don't that's exactly right. =A0At least as I understand it:
> >>
> >> - RAID1+0 (and RAID0+1) nests things - you start with two sets of =
RAID1
> >> mirrors, then stripe across them (or vice versa) - it's a nested s=
et of
> >> steps
> >>
> >> - md RAID10 provides both mirroring and striping, but it's a more
> >> integrated function - (from the man page) "RAID10 provides a combi=
nation
> >> of RAID1 and RAID0, and sometimes known as RAID1+0. Every databloc=
k is
> >> duplicated some number of times, and the resulting collection of
> >> datablocks are distributed over multiple drives." - but there isn'=
t an
> >> inherent nesting in the process (i.e., no two disks are copies of =
each
> >> other, and md RAID10 will work over odd numbers of drives)
> >
> > Yes, you are right, RAID1+0 is nested, while Linux MD raid10 is not=
=2E
> > But the data layout of Linux MD RAID1+0 and Linux MD
> > RAID10,near is almost identical.
> >
> > keld
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20
>=20
>=20
> --=20
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
