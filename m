From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: High IO Wait with RAID 1
Date: Fri, 13 Mar 2009 09:39:38 +0000
Message-ID: <20090313093938.GA19733@cthulhu.home.robinhill.me.uk>
References: <7d86ddb90903121646q485ad12y90824a4c3fcc2dfd@mail.gmail.com> <20090313004802.GB29989@mint.phcomp.co.uk> <7d86ddb90903122021y5f4f0868na3f1944f87f77f4a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7d86ddb90903122021y5f4f0868na3f1944f87f77f4a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Mar 12, 2009 at 10:21:28PM -0500, Ryan Wagoner wrote:

> I'm glad I'm not the only one experiencing the issue. Luckily the
> issues on both my systems aren't as bad. I don't have any errors
> showing in /var/log/messages on either system. I've been trying to
> track down this issue for about a year now. I just recently my the
> connection with RAID 1 and mdadm when copying data on the second
> system.
>=20
> Unfortunately it looks like the fix is to avoid software RAID 1. I
> prefer software RAID over hardware RAID on my home systems for the
> flexibility it offers, especially since I can easily move the disks
> between systems in the case of hardware failure.
>=20
> If I can find time to migrate the VMs, which run my web sites and
> email to another machine, I'll reinstall the one system utilizing RAID
> 1 on the LSI controller. It doesn't support RAID 5 so I'm hoping I can
> just pass the remaining disks through.
>=20
You could also try using software RAID 10 or RAID 5 on the two drives.
Both of these will be effectively the same as a RAID 1 (ISTR you can
actually just update the metadata to convert from a RAID 1 to a RAID 5)
but will use a different code path so should eliminate the issue you're
seeing.  A 2 drive RAID 10 with far layout will also give some read
performance improvements (at the cost of slightly slower writes).

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

iEYEARECAAYFAkm6KdkACgkQShxCyD40xBJkwACffgBv8K1dX78y7ZK0Cl3K1VKy
GP0AoMI1drd1UhyZm2QfU9mv1J+7rDCt
=J6PK
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
