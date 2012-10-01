From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm git does not work?
Date: Mon, 1 Oct 2012 22:21:58 +1000
Message-ID: <20121001222158.13885929@notabene.brown>
References: <20121001172334.277bc4c2@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5kki+ZqI1eI5Ar=q6U1n=kZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121001172334.277bc4c2@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/5kki+ZqI1eI5Ar=q6U1n=kZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Oct 2012 17:23:34 +0600 Roman Mamedov <rm@romanrm.ru> wrote:

> Hello,
>=20
> Does anyone else have this error
>=20
>   $ git clone git://neil.brown.name/mdadm mdadm
>   Cloning into 'mdadm'...
>   fatal: The remote end hung up unexpectedly
>=20
> or am I doing something wrong?
>=20

Fixed now.
I recently moved to a different server and I hadn't created all the
"git-daemon-export-ok" files.

Thanks,
NeilBrown

--Sig_/5kki+ZqI1eI5Ar=q6U1n=kZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGmK5jnsnt1WYoG5AQLG0xAAhQkokE/fWsnK5RdYeVwPngK5qx1rDnL8
67+2Q85z7XJAWryqfuybwkMD7dNCKsl08UGkXV/C7Nz8TmwWzHzmdEe3P4nl6Dh0
73r7elxYxbbNQWqCfxo4YO5Ekuioeqm+fxXAFTAOxkSKTldJZcHMz779rUeiK9vJ
acUXvnH4NCUh2XSMTRXD8oXK3xAZyY0oWh8zyd7+zWBQVT7RtpS+QNK5jwkbONpa
4rozRzJERJQYf43hAPp3V59A57A+Efwy0mjCLSpaPpSaTuenWsbJyzIA5YckDBEc
OR9iV9uvXR+CoJ3NY245Dzh96GYiyqDExcOywWBZiZcVBYAjuOJB7PhxC/Tdf60P
oBWbGhAvZRvRlWuLVcU1wDsqxt39OYpjJmdYBFxETa/9q2wQRxd/Ob7XqAUu4+xS
o3ME7VCgRizY8sWGOGNLg8yXSefuDfV/AioJl2mXzmtlUxynDrmfMaPjurCkDBoE
Lkhzr++q/OJMshpCRwMPstwY2MrFlGmbfDuazZ4r5LS7+yBle6DfVuz2PBXMDreL
lpUOBFms40oMsKYD+K0ZCnbt5G51BSc85tQKh9n0pHLXDAcgtYZ8Wtgq3HmgzaxP
Rdf9lEtVoXZU9jfcod7kK8NnFxTE0eFzzeFr1YqypJSJkeT73X6t+uCn9MMJ18hD
51NHIPEx88A=
=7/or
-----END PGP SIGNATURE-----

--Sig_/5kki+ZqI1eI5Ar=q6U1n=kZ--
