From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Grow error - WTF!?
Date: Sun, 18 Jul 2010 01:47:15 -0500
Message-ID: <F4.54.21397.C73A24C4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTimR8Z_9f5tol6qeRGq96Tjw5w5iG8br6oIIUDrk@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimR8Z_9f5tol6qeRGq96Tjw5w5iG8br6oIIUDrk@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?'J=E9r=F4me_Poulin'?= <jeromepoulin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of J=E9r=F4me Poulin
> Sent: Saturday, July 17, 2010 10:35 PM
> To: Leslie Rhorer
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Grow error - WTF!?
>=20
> Seems like that problem I had:
> http://kerneltrap.org/mailarchive/linux-raid/2010/6/13/6885423
> I guess it is fixed in GIT but don't know if the release was made.
>=20
> On Sat, Jul 17, 2010 at 5:38 PM, Leslie Rhorer <lrhorer@satx.rr.com>
> wrote:
> >
> > OK, this is bizarre:
> >
> > Backup:/# mdadm -G -v -n 10 --backup-file=3D/GrowRAID.fil /dev/md0
> > mdadm: Need to backup 4503599627313152K of critical section..
> > mdadm: /dev/md0: Something wrong - reshape aborted
> >
> > A 4 Million Terabyte critical section? =A0I don't think so. =A0This=
 isn't

	So it would seem.  I downloaded Neil's most recent commit, and the
error is eliminated.  I've submitted a Debian bug report to try to make=
 sure
3.1.3 is included in the Squeeze / Sid release.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
