From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: How to boost performance
Date: Fri, 18 Jun 2010 02:02:20 +0600
Message-ID: <20100618020220.161c54b2@natsu>
References: <ea83c7a1ddca01e0a1535f130502a0f2.squirrel@www.dcsnow.com>
	<20100617100109.32a20ffa@natsu>
	<d98b7022efc6988e47f7e4114aa83f62.squirrel@www.dcsnow.com>
	<20100617221300.3e30afe0@natsu>
	<db120b2f917a2de03cbb3834ef56be7f.squirrel@www.dcsnow.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/R=RvtIdunUqnMY_=+7eo_mK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <db120b2f917a2de03cbb3834ef56be7f.squirrel@www.dcsnow.com>
Sender: linux-raid-owner@vger.kernel.org
To: aragonx@dcsnow.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/R=RvtIdunUqnMY_=+7eo_mK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Jun 2010 15:46:05 -0400
aragonx@dcsnow.com wrote:

> While I would agree with you if the performance was the same for reads as
> it was writes, that is not the case here.

Reads are a massively faster operation on RAID5 than writes, in my experien=
ce
an array easily reads at close to the theoretical limit, i.e. the speed of =
its
slowest member multiplied by the member count minus one.

--=20
With respect,
Roman

--Sig_/R=RvtIdunUqnMY_=+7eo_mK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwaf00ACgkQTLKSvz+PZwimtACeNRNX4b5u1LY4YGinFnBxV3/J
E/oAnAkEWrjlPD8zfEtX6HMrvCQ9+UZU
=TZLn
-----END PGP SIGNATURE-----

--Sig_/R=RvtIdunUqnMY_=+7eo_mK--
