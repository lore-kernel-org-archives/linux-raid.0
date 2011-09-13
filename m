From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: RAID6 issues
Date: Tue, 13 Sep 2011 14:44:24 +0600
Message-ID: <20110913144424.64348c41@natsu>
References: <CAGZH0-dz9y5=vH7PQr8VRy15i1WsuAxKjPPpmx8-1UqCaJnRxg@mail.gmail.com>
	<20110913082511.3c34dec9@notabene.brown>
	<CAGZH0-fEU+NTdAF1AWcU6SnyBPYgd51zjizaiZT_toV=k4EDFg@mail.gmail.com>
	<20110913084419.380babcc@notabene.brown>
	<CAGZH0-fRTkKOL8ofLbChmNH3fuiYwHkC0LAv1-VVyb22O7UnwA@mail.gmail.com>
	<20110913093850.606efa70@notabene.brown>
	<CAGZH0-f+e80W36VMZMHrTakTxUHO2nppO9xHSTmHh6QV_Mo2Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/x/daAc6SRyMRbt7ZZogIqdF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGZH0-f+e80W36VMZMHrTakTxUHO2nppO9xHSTmHh6QV_Mo2Fg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andriano <chief000@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/x/daAc6SRyMRbt7ZZogIqdF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Sep 2011 17:51:56 +1000
Andriano <chief000@gmail.com> wrote:

> Apparently you're right
> blockdev --getsz /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg
> /dev/sdh /dev/sdi /dev/sdj /dev/sdk
> 3907027055
> 3907027055
> 3907029168
> 3907029168
> 3907029168
> 3907029168
> 3907027055
> 3907029168
> 3907029168
> 3907029168
>=20
> sdb, sdc and sdh - are smaller and they are problem disks
>=20
> So what would be a solution to fix this issue?

You mentioned you use Gigabyte EP35C-DS3 motherboard. Gigabyte BIOSes are k=
nown to cut off about 1 MByte or so from the end of HDDs (on the onboard co=
ntroller, and maybe just the one on Port 0), setting an HPA area and storin=
g a copy of the BIOS there. That's known as "(Virtual) Dual/Triple/Quad BIO=
S". Google for "gigabyte bios hpa" and you'll find a lot of reports about t=
his problem. You can check if you can disable that "feature" in BIOS setup,=
 but older boards did not have such option.

To restore the native capacity of the drives you can use "hdparm -N" (see i=
ts man page), while disks are on the non-onboard controller.

In the future, create your RAID from partitions, and leave 8-10 MB of space=
 in the end of each disk for cases like these.

--=20
With respect,
Roman

--Sig_/x/daAc6SRyMRbt7ZZogIqdF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk5vF+gACgkQTLKSvz+PZwjikwCeK80Y2/KM5kcozvPzNGE7ioCJ
Z90AnjEjdOprgZskdc2/PCZYUpBT7bjo
=bC4B
-----END PGP SIGNATURE-----

--Sig_/x/daAc6SRyMRbt7ZZogIqdF--
