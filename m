From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: HBA Adaptor advice
Date: Mon, 23 May 2011 12:08:07 +0600
Message-ID: <20110523120807.42156941@natsu>
References: <4DD50C89.8060006@wildgooses.com>
	<20110520020853.GC4759@bitfolk.com>
	<4DD61948.8050302@wildgooses.com>
	<4DD6409F.9070904@hardwarefreak.com>
	<4DD79F4E.7000509@wildgooses.com>
	<4DD8D1A7.1090803@hardwarefreak.com>
	<4DD8E0D3.1030905@fnarfbargle.com>
	<4DD9633E.5000101@hardwarefreak.com>
	<4DD99A16.5010108@fnarfbargle.com>
	<20110523100939.0c019ea2@natsu>
	<4DD9F6B2.4070708@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0P04owr=KfW9Pk_8sgO/eLZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD9F6B2.4070708@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/0P04owr=KfW9Pk_8sgO/eLZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 23 May 2011 13:54:58 +0800
Brad Campbell <lists2009@fnarfbargle.com> wrote:

> I think the term "Advanced Format" crap is a bit harsh.
> The reality is that for drives > 2TB it is simply inevitable that bigger=
=20
> sectors will be required.

For >2TB maybe, but not for 2TB.

> Most sane operating systems use cluster sizes of 4k or larger and have=20
> done for years, so I really don't see what all the fuss is about.

4K drives shouldn't lie that they have 512 byte sectors, pretending all is
fine but doing that horrendous r-m-w translation under the hood; at least t=
hey
should be switchable (perhaps by a jumper?) into the 4K-native mode. No way=
 to
improperly align anything if a drive honestly tells it has 4K/4K
logical/physical sector.

--=20
With respect,
Roman

--Sig_/0P04owr=KfW9Pk_8sgO/eLZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3Z+ccACgkQTLKSvz+PZwgznACcD7uJNqgLlYcojds0iHcvsaD8
BWEAnREY4U08j9J0W8zaNnMpH4cSI0Xj
=05I2
-----END PGP SIGNATURE-----

--Sig_/0P04owr=KfW9Pk_8sgO/eLZ--
