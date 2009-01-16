From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: mdadm man page update proposed
Date: Fri, 16 Jan 2009 16:45:02 +0000
Message-ID: <20090116164502.GA31757@cthulhu.home.robinhill.me.uk>
References: <6121ee740901160136l43925896v42d1cd35ab5ab724@mail.gmail.com> <3ECBDC05781B3D48ABD520A01ABF2F9B2A0E2BFB9A@SE-EX008.groupinfra.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3ECBDC05781B3D48ABD520A01ABF2F9B2A0E2BFB9A@SE-EX008.groupinfra.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Jan 16, 2009 at 11:51:24AM +0100, Henry, Andrew wrote:

> > I believe it would be helpful to many to note in the mdadm manual
> > page, that only version 0.90 superblocks can be auto-detected by
> > current kernels.
> >
> > Nagy Attila Gabor
>=20
> You know, I used 0.90 superblocks on CentOS 5.2 and they were
> recognized (ie assembled so that Cat/proc/mdstat saw the discs).
>=20
> I just moved to Ubuntu with 2.6.27 and decided on 1.2 superblocks and
> they were auto assembled anyway.  Is this what we mean when we say
> "autodetected by the kernel" or have I misunderstood?
>=20
> If im right then it doesn't seem to be an issue with later kernels.
>=20
Most current distributions use a ramdisk to load up a base system
(busybox + a few other tools) which allows for more advanced detection
of arrays than the kernel can do itself.  This is what you'll be seeing
- without a ramdisk the kernel will fail to assemble arrays with 1.0+
superblocks.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklwuY0ACgkQShxCyD40xBKEFwCgjl5+vLqr9mdlDt39p+MDh4mX
99kAniE23sRNTmsfTLoR53DQpkB3h9VS
=ZLWG
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
