From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 3/3] raid5: relieve lock contention in
 get_active_stripe()
Date: Wed, 11 Sep 2013 11:34:12 +1000
Message-ID: <20130911113412.5ac91a65@notabene.brown>
References: <20130905162910.179ea808@notabene.brown>
	<20130905091822.GA8401@kernel.org>
	<20130909043318.GA27517@kernel.org>
	<20130910111318.1d19e8d3@notabene.brown>
	<20130910023555.GA17907@kernel.org>
	<20130910140629.702683da@notabene.brown>
	<20130910042438.GA16797@kernel.org>
	<20130910152032.48631492@notabene.brown>
	<20130910065912.GA12038@kernel.org>
	<20130910172836.43e23cbf@notabene.brown>
	<20130910073756.GB12038@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/s/7+HZm3l5mxZXXWA22.oeT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130910073756.GB12038@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/s/7+HZm3l5mxZXXWA22.oeT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Sep 2013 15:37:56 +0800 Shaohua Li <shli@kernel.org> wrote:


> Below is my latest patch.
>=20

Thanks.  It looks good.
I have pushed it out to me for-next branch (which a few cosmetic white-space
adjustments).
I will need to review it again but it is certainly very close to 'right'.

One thing I'm a bit concerned about is the md_raid5_congested function.
It can return "false", yet a write can still block.
That isn't a huge problem, but it could have some negative consequences.
Maybe we could have an atomic_t which counts how many hash values as "full"
and we report "congested" when any are full.  Maybe.

Thanks,
NeilBrown

--Sig_/s/7+HZm3l5mxZXXWA22.oeT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUi/IlTnsnt1WYoG5AQIPBg/9HtcYRjxRVIDwPE5C9nfWdN3M7GZ0RebL
TtfVNwGuzEnGWMyqhfvp7+CgNmQN9mOo/8sWT0YhRih48vE2sKcHhIcT0AuBzv7s
6eMOH/3SsHxzDDLOqtEfbfu/JtOjxARf8MORtYQgFpy1xW7qK/oBxivnaqShHSNn
FHmc2rRCDK+A12ghBTctuN9vvrGctV+LCe2A011Za4JkW1bpmAPWHKgpJTDROKkj
DzEX+tgMMmyen3Sn9NU5nFiK7i5vFNsgh/oSAnmLNS0CZnR5zUxTdqSi64yip7IB
MwfPd3gZv6nh8TaHG3YVktsiILf6ipE4XEPJAhmV1NCjbjCCTm47IzOkpT1CQbI2
vWaem3sKRKu1NsEXW1zURKZNmJudx9MSXJIepGitdSyP/e0nLrhGIAH/kBxv0JF0
7M/AwNlFDPdpO8beKfqB0gOVBybVDkAMofvbuYJ5MtfojdKU3zJBxDklti0wR4SD
8USnaYi2QPsRAA0rlM8NCHBExUVx7LQk5KZbK5IYlOFjDJelQ7GwhV+H58JgMOxC
JGp5wEBiShGBv4NlSvqIkV0dSWBt/AWSU8S46UqEWhGdLFbn3XTbQSWZsJXOqPQN
A3s5Xvl2AijlsncH7OnvzwKnw3wyJquBe84sJ4XlZmMokR3FKH301LT3U0yvAI0k
rJc+94HsSCw=
=DgKi
-----END PGP SIGNATURE-----

--Sig_/s/7+HZm3l5mxZXXWA22.oeT--
