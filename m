From: Michael Ole Olsen <gnu@gmx.net>
Subject: mdadm raid5 and bit errors resync
Date: Mon, 22 Jun 2009 07:58:08 +0200
Message-ID: <20090622055808.GN2828@rlogin.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uTRFFR9qmiCqR05s"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--uTRFFR9qmiCqR05s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

what happens in the case of a single unrecoverable bit error when resyncing a
raid5 or upgrading it?

and in the case of raid6?

would raid6 only be able to survive 2 bit errors?

couldn't really find any information on it in the docs or google, but I have
heard about systems failing because of single bit errors.

/Michael Ole Olsen

--uTRFFR9qmiCqR05s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBAgAGBQJKPx1vAAoJECXlragqp/ZI2f0P/1m3lw2lrDV4SLoCbH3w/lIi
So1VD2UVT5Uh0xp61l2qOdJ8xkyQfh2U/OVX2LTP5OTM62+TqsvAVGSkNuMyu79u
QayaF2r/bOuLddY6OAuJois5cx16LjtpkTXdsBWf3L8yxgWSTDBGslNlK58pADHg
oo5Gg5Q5JuZ6lUEpxf4Aaq21Cakb+9oFXKfiGyZIi/N0a3QQNG/Rard1FpKpTKA5
BDifmzErkb+CPVR9TI3WONVS2r/xIq4WCJsXcvzJX7DzNNs+S/A/MZS8UhhS1ZkG
Fb+hhLp6cvjwo1vWS/z8utQJIo1rMaN/XaMDD7F51SjVuojJ27WRUtTg7aNk8A8p
bxvaKaZBoCqSI7PJ5cT0GqizfW1xnS8npPsCsNIIStR/nrYZKYrE8TJzsKBD4Obp
b4GGse9J1Gh/0pnsemNobCQXHXODJNjd0aTChNZLF02996XpbQXbfmtdloWjVyB0
gQgsP4G68RLyGzx02nng6GWDUE29NcaqdyoI3rmmfsxuWFK46sZXexZpnGs96N69
O3WeBbUod3G7YoEb3ONIq6sVEn4SMkQSyMf73CpNBaIT2R//IiMlczwAxxwAb4ZL
DwZZGoJlnD1z6s+bpq/rzH9prwCLQdsKa2GQ2HOJZFSKtYbo0xUT2kPdlIFwdnI6
KZEW4FuIgbG77GPgwVv0
=UHtL
-----END PGP SIGNATURE-----

--uTRFFR9qmiCqR05s--
