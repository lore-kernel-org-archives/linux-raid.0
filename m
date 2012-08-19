From: NeilBrown <neilb@suse.de>
Subject: Re: md raid behavior, bad sector uncorrectable read error
Date: Mon, 20 Aug 2012 08:19:35 +1000
Message-ID: <20120820081935.24289755@notabene.brown>
References: <3E06D7FC-092A-4CB6-B79C-7EC94424DEEE@colorremedies.com>
	<CAGkViCFBqJJWeaA1Wrpc_BBw=wd1wV3nVrArEB51LJpJsrmsug@mail.gmail.com>
	<FEEB11B4-5CCB-49F4-8010-80CE03A49FA4@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/H9ABiM37aCe0_Mw+7FrDYwZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FEEB11B4-5CCB-49F4-8010-80CE03A49FA4@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/H9ABiM37aCe0_Mw+7FrDYwZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 19 Aug 2012 12:12:38 -0600 Chris Murphy <lists@colorremedies.com>
wrote:

> On Aug 19, 2012, at 3:47 AM, Mikael Abrahamsson wrote:
> > If I remember correctly from what has been described here before, a rea=
d error will cause a re-write with information created from parity
>=20
> That's the thing I'd like to get a definitive answer one. If only it were=
 easy to simulate bad sectors in VM's I could just test it!

If only it were easy to read the documentation, and if only the documentati=
on
were sufficiently complete.....

% man 4 md

search for 'read error'

NeilBrown

--Sig_/H9ABiM37aCe0_Mw+7FrDYwZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUDFmfTnsnt1WYoG5AQLYwA//dN398CCKUYpH3zCPxcKqqKFn81Ic8xIG
vUvUDIPGMXXW0Q67Tan3u8B5zDgwUqeUb8FVyWsqILseO10b7Hpho3nPUcSI1O+Q
S6xa84Xg8Zco6NPjaFpvQuOqAYWBbJS4zCh/NvlN3wRnZB/yPUezqi2BmMXdld/d
zN/YC9UBJggdUuBP+jVXWjzuw5itogLvHrSD9pTZIr8lHYZ8uyYiyrEaC7LNbv/O
3OHoSiLM/aXrv0HCnkVTb0Ql44crH3uzHRONm7ds8eZA81t28oDl3Q0eJnFa6F7j
SAGEUyTFgtJh1VdD12WIJgtPwtQytlZmhUkOYScszG1OjEJDRXc9SV0s9EJo01ZX
woNE8S3v+KzcBb+LVQZ2jVrHl5ZyFMh0+w33VA18eScF9XdNra08lu7KYJhxBTGy
QMxxDAE9cDjx0aytiEQPWEdKuaCmuxWmQGwrs0XxKRbHTPrglAhJTNfQ4p9ZcQzX
pTMbenk7p/14BfnVRZIvLDd+1gEBHkW8BiEFT8TdYspwY8XTgc8adlM4J5G27aHM
F7kBcVeIcOcH1+rqSnhGc6B0kRKg+uPDujarqnaPdwQXDs7rcWcFOHymoS5BjHW3
8oSdWTK4FH6suAGHGoytA0CgRjbk21MPybv6U9NSkIwOkRQ9iloroz0rAETsIUnO
jmw1FcH4lXA=
=lUb9
-----END PGP SIGNATURE-----

--Sig_/H9ABiM37aCe0_Mw+7FrDYwZ--
