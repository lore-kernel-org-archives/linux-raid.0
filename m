From: NeilBrown <nfbrown@novell.com>
Subject: Re: mdadm-3.4 regression tests
Date: Fri, 19 Feb 2016 14:25:16 +1100
Message-ID: <8760xlpejn.fsf@notabene.neil.brown.name>
References: <56C2AC87.7000500@gmail.com> <wrfjio1oczlj.fsf@redhat.com> <56C3695E.5030508@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56C3695E.5030508@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bruce Dubbs <bruce.dubbs@gmail.com>, Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Feb 17 2016, Bruce Dubbs wrote:
>
> Testing on linux-4.4.1-lfs-7.9-rc1 kernel

4.4.1 (and 4.4.0) have a bug, fixed in 4.4.2, that probably causes this.

Fixed by

Commit: 1501efadc524 ("md/raid: only permit hot-add of compatible integrity profiles")

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWxoscAAoJEDnsnt1WYoG5Q6cQAK6jIOnz7uM/xEUyR5KvLvdM
0LdCjD2ImfVf230oPkKFvYrcFqgWaBSS9c8/vY6kyJ+UmrBr7GxZZGz0G/vmoOza
vceOEPFwBsrsBNtWOAUAWXGDwbtnJj1/9Ir85vcKUusx7iFUKzebaT26wfY9t1W2
istBZUK1udlzh3LlT2DnDaZZ9ZZ0u11am0VJl4NBRxaMeB1aFw1gGql9+Qit3IZp
za1c5pLE6sLQtB4JfW1ADS1qOT453x8QKy2tepsha8dkIqh6jUBkeyUpET5/dllm
Oq8MEn7X/unKNMN4gv2W0WFEiHOzV7g3HXP3vSrgIBkLc+6hbbHsyk3GkmlaNbSJ
sQ1L8XSiTkVGYbifgG2XrwLbMdu0MkooQJzjEeykvwoLFyZ0ogHk1MXb95hqW/X7
pIEqUwjI2TnVl4ox9WnoXLl0d5L0o9+6D/7PojWnlt75oy3x1LZ3aE4wiTYFLLmv
knIgR0shwtl4QpC2hFcMN+/lCtjs/23FYiE7oCdXPNDo9MkLArogaUeIiYEpQtP1
BK6dbxb7y5aoMfMTq0do/et8+t42RiRH0xNG0DhKGSo89R3ev3TdrgjmwH7nE51Z
seexXOm6bYq8zJEoucgAYEBVoGvUQYmdvu8PQGAN6gHPws4znMYbzE0MTjenEZRi
uiF6sCWl3g2E6kPkBeoX
=vAc1
-----END PGP SIGNATURE-----
--=-=-=--
