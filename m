From: NeilBrown <neilb@suse.de>
Subject: Re: md road-map: 2011
Date: Thu, 17 Feb 2011 08:59:24 +1100
Message-ID: <20110217085924.01cdf22c@notabene.brown>
References: <20110216212751.51a294aa@notabene.brown>
	<4D5BDB84.8050706@gmail.com>
	<20110217082412.51afa2a6@notabene.brown>
	<20110217024402.1dd44267@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kPT6gwGmNG.p3DBNrn_DE14"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110217024402.1dd44267@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Joe Landman <joe.landman@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kPT6gwGmNG.p3DBNrn_DE14
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Feb 2011 02:44:02 +0500 Roman Mamedov <rm@romanrm.ru> wrote:

> On Thu, 17 Feb 2011 08:24:12 +1100
> NeilBrown <neilb@suse.de> wrote:
>=20
> > "read/write/compare checksum" is not a lot of words so I may well not be
> > understanding exactly what you mean, but I guess you are suggesting tha=
t we
> > could store (say) a 64bit hash of each 4K block somewhere.
> > e.g. Use 513 4K blocks to store 512 4K blocks of data with checksums.
> > When reading a block, read the checksum too and report an error if they
> > don't match.  When writing the block, calculate and write the checksum =
too.
> >=20
> > This is already done by the disk drive - I'm not sure what you hope to =
gain
> > by doing it in the RAID layer as well.
>=20
> Consider RAID1/RAID10/RAID5/RAID6, where one or more members are returnin=
g bad
> data for some reason (e.g. are failing or have written garbage to disk du=
ring
> a sudden power loss). Having per-block checksums would allow to determine
> which members have correct data and which do not, and would help the RAID
> layer recover from that situation in the smartest way possible (with abso=
lutely
> no loss or corruption of the user data).
>=20

Why do you think that md would be able to reliably write consistent data and
checksum to a device in a circumstance (power failure) where the hard drive
is not able to do it itelf?

i.e. I would need to see a clear threat-model which can cause data corrupti=
on
that the hard drive itself would not be able to reliably report, but that
checksums provided by md would be able to reliably report.
Powerfail does not qualify (without sophisticated journalling on the part of
md).

NeilBrown

--Sig_/kPT6gwGmNG.p3DBNrn_DE14
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iD4DBQFNXEjCG5fc6gV+Wb0RAl9UAKCu385ctgrvBenHdlpa95eFNZ6usQCYrkgP
mCHYCobEjNDY3CmJ+3a/2g==
=Y17k
-----END PGP SIGNATURE-----

--Sig_/kPT6gwGmNG.p3DBNrn_DE14--
