From: Andre Noll <maan@systemlinux.org>
Subject: Re: Safely swapping a disk in a RAID456
Date: Sat, 1 Oct 2011 17:51:42 +0200
Message-ID: <20111001155142.GG30935@systemlinux.org>
References: <20110930154217.GA11732@albatross.gern.madduck.net>
 <20110930162811.GE30935@systemlinux.org>
 <j679h5$g42$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7mxbaLlpDEyR1+x6"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <j679h5$g42$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--7mxbaLlpDEyR1+x6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 01, 16:53, David Brown wrote:
> On 30/09/11 18:28, Andre Noll wrote:
> >On Fri, Sep 30, 17:42, martin f krafft wrote:
> >>Does anyone have any ideas?
> >
> >Create a 2-disk Raid1 (with external metadata) containing the disk
> >you'd like to replace and the replacement disk.
> >
> >And yes, it would be great if md provided an easier way to do this.
> >
>=20
> That would be "hot replace", which is quite high up on the md/mdadm
> "things to do" list.
>=20
> <http://neil.brown.name/blog/20110216044002#2>

Thanks for the pointer. I wonder if it would be useful to have an
md-aware dd command which could read from an md device and output
only the contents of one component. I.e. it would give the same result
as dd if=3D/dev/component-device of=3D/dev/new-disk if there are no read
errors but would redirect failed reads to the working devices.

This should be easy to implement as it avoids the complexity mentioned
in Neil's blog posting. Moreover, it could be written purely in user
space and would work on any kernel version.  The price to pay is of
course that the array needs to be r/o during the operation.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--7mxbaLlpDEyR1+x6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk6HNw4ACgkQWto1QDEAkw9jEACfR17FehqqEiKsZzY4ErA3kotu
3W0AnjZ6XHfJM1cU01veWPh0rv6+JxcG
=HqT2
-----END PGP SIGNATURE-----

--7mxbaLlpDEyR1+x6--
