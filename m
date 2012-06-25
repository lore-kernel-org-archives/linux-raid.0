From: NeilBrown <neilb@suse.de>
Subject: Re: linux-image-2.6.32-5-686: kernel BUG at ...
 build/source_i386_none/drivers/md/raid5.c:2764!
Date: Mon, 25 Jun 2012 12:39:06 +1000
Message-ID: <20120625123906.2c302212@notabene.brown>
References: <20120622121953.GA25149@calhariz.com>
	<20120624182146.7d63fbbb@notabene.brown>
	<20120624170234.GA13154@calhariz.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rRIxQ66nhh.zzm0soelyFT3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120624170234.GA13154@calhariz.com>
Sender: linux-raid-owner@vger.kernel.org
To: jose.spam@netvisao.pt
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/rRIxQ66nhh.zzm0soelyFT3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 24 Jun 2012 18:02:34 +0100 Jose Manuel dos Santos Calhariz
<jose.spam@netvisao.pt> wrote:

> On Sun, Jun 24, 2012 at 06:21:46PM +1000, NeilBrown wrote:
> > On Fri, 22 Jun 2012 13:19:53 +0100 Jose Manuel dos Santos Calhariz
> > <jose.spam@netvisao.pt> wrote:
> >=20
> > >=20
> > > In another day during the periodic mdadm RAID check:=20
> > >  - the linux kernel gave a kernel BUG,=20
> > >  - tried to kick out a failed disk and=20
> > >  - stopped accepting I/O to the affected raid. =20
> > >=20
> > > The affected programs were in state D.  The only way to recover was to
> > > do a reboot.  After reboot the problematic disk was replaced.
> > >=20
> > > I reported the bug to Debian and is there all the information about i=
t:
> > >=20
> > > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D675969
> > >=20
> > > I was asked to report the BUG here in case someone knows what happene=
d.
> > >=20
> > > Here is a summary of the more relevant information:
> > >=20
> > > This machine have 2 x RAID6 with 6 disks each, for a total of 12 disk=
s.=20
> > >=20
> > > I have 5 systems with a similar setup and only one failed, maybe
> > > because of the failing disk.  I will use one of the systems to try to
> > > reproduce the bug, before triyng a new kernel.
> > >=20
> > >=20
> > > The proprietary module is the openafs filesystem v1.6.1 backported
> > > from Debian testing.
> > >=20
> > > The kernel bug is:
> > >=20
> > >=20
> > > build/source_i386_none/drivers/md/raid5.c:2764!
>=20
> >=20
> > This bug was fixed in 2.6.32.49 and 3.2
> >=20
> > http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=
=3Dcommitdiff;h=3D61d433c479a6ccfed6a7e73e6111ca8fa0348c63
> >=20
> > http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dcomm=
itdiff;h=3D9a3f530f39f4490eaa18b02719fb74ce5f4d2d86
> >=20
> > NeilBrown
>=20
> The failing kernel had that fix all ready.  The machine was running
> the kernel Debian 2.6.32-41squeeze2.  Looking into the change log,
> this kernel have all the fixes until 2.6.32.51 plus other fixes.
>=20
>      Jose Calhariz
>=20

The oops report said:

(2.6.32-5-686 #1)

is "5" the same as "41squeeze2" ???  This is a genuine question - I have
little idea about Debian versioning so maybe these are the same thing
somehow.  But they look different.

NeilBrown

--Sig_/rRIxQ66nhh.zzm0soelyFT3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+fPSjnsnt1WYoG5AQLRxBAAtSbZF2VIVIEobsVmhvl+ybbYog3/n1zn
LQBJRHEWWt6tm2DOvLCi1DObDg0cnyXfqB78aUQ2xyJpAxjKCkGSufxM1kmYzMz8
H1C0XaFpXlz/jzc8nAf90Btuph0Ib+AxFlVRCGQHGk63zGhibkwQSdCaaJ/OmG7T
ZWTQm2dFA79xS1ls7X/8rmCRv3YxwyLLB1qvf7U8e+nokpBFcD7gvDvniDasTzNz
c85adHS1TMxexJqKExMIlVaG2yrELBW9DunSb4s/WM8k33Ok5SbpQcPQPFt8r+8r
hNWw2+SWs7Ov8plRuA9MRsyBRUL1GsP9BX9oKkoGgxPEcjYHkA0ZhMCbR+WMvZT7
miWmDWgSEofzttbd27yr4RExk4AzDQq6qU/hvx7kX56r8tO1FEDHP1kcRA97gDIB
B3r79z9wTGWdlHQc8wvnw1umPvcHMgZPhdpqy1NrAAmz8mg4gR7gboLnLaaE3547
qYZVw9rYWzxztG2bv8UNYB24YhjdT81mv6aG+Xm/klZLk3q4s3lgeUGNV4xSqf8a
F+pDnLGMBkxXn8A1+Ul2UB/D6UqxAK4SbmRhTdY7IFEpraDc5sDDfOESEm0413/t
HelDQ1jlT/21MYdXD/Ky4L1N8m4aNFWmvoR4DjjoYga4J3ddfUjE7ftD/v/9Qadl
9GFcEkx65Po=
=D7kD
-----END PGP SIGNATURE-----

--Sig_/rRIxQ66nhh.zzm0soelyFT3--
