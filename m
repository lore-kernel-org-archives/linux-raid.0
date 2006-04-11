From: Andy Smith <andy@lug.org.uk>
Subject: Re: mdadm + raid1 of 2 disks and now need to add more
Date: Tue, 11 Apr 2006 20:32:16 +0000
Message-ID: <20060411203216.GV29446@strugglers.net>
References: <e3edb0fa0604110741h355f4eft3f3d42a825cb4233@mail.gmail.com> <20060411145142.GR29446@strugglers.net> <443BE6A6.5000202@unix-scripts.info>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lRMsAdG4hjP4MFkn"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <443BE6A6.5000202@unix-scripts.info>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--lRMsAdG4hjP4MFkn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 11, 2006 at 07:25:58PM +0200, Laurent CARON wrote:
> Andy Smith wrote:
> >On Tue, Apr 11, 2006 at 04:41:30PM +0200, Shai wrote:
> >>I have two SCSI disks on raid1.
> >>Since I have lots of reads from that raid, I want to add two more
> >>disks to this raid so that read will be faster.
> >>
> >>How should I add the new disks?
> >
> >Is this possible with md currently:
> >
> >Create a RAID-10 on the two new disks specifying one disk missing
> >from each mirror.
> >
> >Then copy data over and add the two existing disks letting it
> >resync?
>=20
> Why not growing the array with 2 more disks?

Well I guess a RAID-1 of 4 disks would be slightly more redundant
than a 4 disk RAID-10, but it would have half the capacity, and the
read performance would be very similar, no?


--lRMsAdG4hjP4MFkn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFEPBJQIJm2TL8VSQsRAveFAJ4/n2cEFlbiyqOnBk2rhW04E4/3XgCfdfVW
TzrfefeU5e52idMiQPjmIb8=
=yONf
-----END PGP SIGNATURE-----

--lRMsAdG4hjP4MFkn--
