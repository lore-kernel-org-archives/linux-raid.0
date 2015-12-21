From: NeilBrown <nfbrown@novell.com>
Subject: Re: Reconstruct a RAID 6 that has failed in a non typical manner
Date: Mon, 21 Dec 2015 14:40:52 +1100
Message-ID: <87vb7s4gfv.fsf@notabene.neil.brown.name>
References: <1874721715.14008052.1446134381481.JavaMail.zimbra@inria.fr> <5633B79D.4000009@turmel.org> <1861199271.16131793.1446719750662.JavaMail.zimbra@inria.fr> <563B5AEB.5020006@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <563B5AEB.5020006@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Clement Parisot <clement.parisot@inria.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Nov 06 2015, Phil Turmel wrote:
>
> for x in /sys/block/*/device/timeout ; do echo 180 > $x ; done
>

Would it make sense for mdadm to automagically do something like this?
i.e. whenever it adds a device to an array (with redundancy) it write
180 (or something configurable) to the 'timeout' file if there is one?

Why do we pick 180?
Can this cause problems on some drives?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWd3TEAAoJEDnsnt1WYoG5FuoP/RTTNWBNQfyBxDDoNiVpHbkD
ME/MkhEADVpATutGk2ENVfNJ321UDT5C1+O1GLCES/8+aIHJcBNm1RNhKTD//v2x
OnVsrGkKkN5ClzPin7mVcV6VINfd/A2mhENZJawL6t5gV0wgRLMMFth+YE2UmJIn
/cBPLm/VNeRFR74FmwnW0u+wRLfkCAHR37080pFSLc4x7OO2/QdnBtNMfUP8JL5x
oMA2N/uAkUK9LHTbWuYeeZs7M7xtiv0zSDLwvnzTokFtLMKSCIShed8CNFEGNO83
c1Aik/+b1zyfxkcEyvtO2Sfl9O48q7QbjXsXwZ66ifJKfDUa9zncW6fRbi+xD+eV
1znbd8dd42xw7To9in/ruMZB05aw8FzRfYEXtAsWy2+ODNeYZxJ6afrlA6HrhiyZ
vU2eB0YaAMzYwgKTw+B0N5iJwqvjA/IUAKkXFQHFH0ZKeX0vBwPDrVYu86DhUqh6
XG0pSfmV1BKBmqUekxlBrGBTWB2kC3cvmZ46iIxAsYbGIhts6KVpNnCVa2liJMUq
XNMJXvic7HA5MDBnWTe2T20AcgyB+nAzv1JfE0Bub7ISoqGUfnOIYM82gcWMETYg
BWRLa/RBwVJDWLZ1zJhK6BoAb1YTcn/JZakFCdQ2wBfJXZQ16WFrJ1d5GJHeskn1
BJTy0fr4nqM1Rvm/ki0t
=LL1w
-----END PGP SIGNATURE-----
--=-=-=--
