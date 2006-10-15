From: Roger Gammans <roger@computer-surgery.co.uk>
Subject: Re: Multiple Disk Failure Recovery
Date: Sun, 15 Oct 2006 13:16:35 +0100
Message-ID: <20061015121634.GA5121@julia.computer-surgery.co.uk>
References: <45319CFC.4050708@mit.edu> <72dbd3150610142335l3920e72ev8756ce1e36b70b5a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <72dbd3150610142335l3920e72ev8756ce1e36b70b5a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: Lane Brooks <lbrooks@mit.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 14, 2006 at 11:35:31PM -0700, David Rees wrote:
> On 10/14/06, Lane Brooks <lbrooks@mit.edu> wrote:
> >functioning.  Right now I cannot get a spare disk recovery to finish
> >because these bad sectors.  Is there a way to force as much recovery as
> >possible so that I can replace this newly faulty drive?
>=20
> One technique is to use ddrescue to create an image of the failing
> drive(s) (I would image all drives if possible) and use those images
> to try to retrieve your data.


I'm currently writing error supression md layer precisely for situations
like this to remove the need for the dd step.=20

Obvisouly it doesn't recover the data in the bad sectors or masked by errors
but the aim is to reduce to need of doing multiple copies which
recoversy procdure tend to invovle.

TTFN
--=20
Roger.                          Home| http://www.sandman.uklinux.net/
Master of Peng Shui.      (Ancient oriental art of Penguin Arranging)
Work|Independent Sys Consultant | http://www.computer-surgery.co.uk/
So what are the eigenvalues and eigenvectors of 'The Matrix'? --anon

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFMiaiTryqm47jHdMRApMAAJ4pWQ+iNFMyJEZKjIX4gDPDCFnLjQCeL8B5
YctOID9Bb9wIGVFmaWi4aD0=
=qGw4
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
