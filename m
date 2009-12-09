From: Andre Noll <maan@systemlinux.org>
Subject: Re: [mdadm PATCH v3] Fix required to enable RAID arrays on SAS disks.
Date: Wed, 9 Dec 2009 18:27:57 +0100
Message-ID: <20091209172757.GA21495@skl-net.de>
References: <20091209171552.29567.94832.stgit@awojcik-linux>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="72pTQ1Q5L511SwPT"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091209171552.29567.94832.stgit@awojcik-linux>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Wojcik <artur.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, ed.ciechanowski@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids


--72pTQ1Q5L511SwPT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18:15, Artur Wojcik wrote:
> The patch increases the capacity of buffers used to store
> sysfs path names. Originally the buffers were too small to
> hold the canonical representation of sysfs path (in case
> of a SAS device, especially a device installed behind an
> expander).
>=20
> Signed-off-by: Artur Wojcik <artur.wojcik@intel.com>

Looks good. Feel free to add my acked-by/reviewed-by.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--72pTQ1Q5L511SwPT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLH94dWto1QDEAkw8RAkxdAJ9dE8u0aAlLosjyLz4oIFxreczuLACfWA+Q
AteoCM2Dp8Bbx4nivR0v1Uk=
=Kva/
-----END PGP SIGNATURE-----

--72pTQ1Q5L511SwPT--
