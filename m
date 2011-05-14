From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: /dev/md2 stopped after changing SAS controller
Date: Sat, 14 May 2011 14:36:13 +0600
Message-ID: <20110514143613.7ec29ac4@natsu>
References: <20110513202900.GA1926@apartia.fr>
	<20110514073347.15dae0b8@notabene.brown>
	<20110514082159.GA306@apartia.fr>
	<BANLkTinpJQDR=0Qnu1tS-82T=OTi37aBMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3Z9uPsdwM/V0SlPco4IsBKe"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinpJQDR=0Qnu1tS-82T=OTi37aBMQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/3Z9uPsdwM/V0SlPco4IsBKe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 14 May 2011 12:27:45 +0400
CoolCold <coolthecold@gmail.com> wrote:

> This is just one more live example for partitions vs disks setups.

Well, they did use partitions, but what do you do when the new RAID control=
ler
bites off a whopping 100 million bytes from the end of your disk? I use
partitions too, and do leave some space at the end for cases like this, but
what I leave is just 8 MB (enough for the Gigabyte motherboards HPA), not
100+. Would you suggest setting aside 500MB, 1GB just in case?

--=20
With respect,
Roman

--Sig_/3Z9uPsdwM/V0SlPco4IsBKe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3OPv0ACgkQTLKSvz+PZwhryQCgk0qn01a14CdHxcPdd8LjOP9q
1ZQAoI45mlGosVc0ETOOxWVgwidzOdyu
=A2L+
-----END PGP SIGNATURE-----

--Sig_/3Z9uPsdwM/V0SlPco4IsBKe--
