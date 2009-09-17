From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.
Date: Thu, 17 Sep 2009 22:01:48 +0100
Message-ID: <20090917210148.GB19611@cthulhu.home.robinhill.me.uk>
References: <200909171620688.SM00612@trainer>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200909171620688.SM00612@trainer>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Sep 17, 2009 at 04:20:16PM -0400, Sunpyo Hong wrote:

> I've contacted just about everyone that knows a thing about RAID5, but no
> one is really able to help me. Anyhow I've read up a lot on RAID5 arrays =
and
> how to properly assemble them. However I've run into a problem with a NAS
> system from WD that I just can't seem to figure out.
>=20
> I have a =BE disks in the array, 1 went down and is out of commission.  I=
've
> been able to assemble my array through mdadm using --assemble --scan. How=
ever
> I cannot access the array due to the fact that the array cannot read a
> filesystem. Everytime I try to mount I get mount: wrong fs type=85 etc. I
> know that the FS is an ext3 FS. However I cannot seem to get this
> thing going. I was wondering if anyone could point me in the right
> direction with this. I can't seem to find anyone that is capable of
> solving this. I would appreciate any help. Thanks!
>=20
What's the output of 'cat /proc/mdstat' after you assemble the array?
And what exact error (and dmesg output) do you get when trying to mount
it as ext3?

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqyo7sACgkQShxCyD40xBI3bwCeN1IXfDn4FiUYlDgITkfojxT1
ibYAn2+6dS/ek5Zj5dfxYmGYi9+mc2+9
=Q1GJ
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
