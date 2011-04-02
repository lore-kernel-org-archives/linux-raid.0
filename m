From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Raid 5 Array
Date: Sun, 3 Apr 2011 04:01:13 +0600
Message-ID: <20110403040113.472838d4@natsu>
References: <BANLkTim8620MUckc+EVCWo9FCTs=65_p8Q@mail.gmail.com>
	<4D977279.30107@gmail.com>
	<BANLkTimJfUhvkpkkAH=NLJOvLL-Jotrwqg@mail.gmail.com>
	<4D97828C.8050806@gmail.com>
	<6158157523854459259@unknownmsgid>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BdAMq_ttykHPkIZATP0_ZbE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6158157523854459259@unknownmsgid>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Mcnair <simonmcnair@gmail.com>
Cc: Marcus <nexuslite@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/BdAMq_ttykHPkIZATP0_ZbE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 2 Apr 2011 22:45:58 +0100
Simon Mcnair <simonmcnair@gmail.com> wrote:

> One last thing.... I've never heard of anyone using a raid 05. Why
> wouldn't you use a RAID50 ?  Please can you dish the dirt on what
> benefit there is ? (I would have thought a raid50 would have been
> better with no disadvantages ?). I thought that raid10 & 50 were the
> main ones in use in 'the industry'.

RAID5/6 with some RAID0 (or JBOD) members is what you use when you want to
include differently-sized devices into the array:
http://louwrentius.com/blog/2008/08/building-a-raid-6-array-of-mixed-drives/
--=20
With respect,
Roman

--Sig_/BdAMq_ttykHPkIZATP0_ZbE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2XnKkACgkQTLKSvz+PZwiftgCfdk2ID0Cp9cVPvQlAMo2uvX97
YCQAnjP9CyikkdR5Iob84eZYr5DdsUEo
=SMte
-----END PGP SIGNATURE-----

--Sig_/BdAMq_ttykHPkIZATP0_ZbE--
