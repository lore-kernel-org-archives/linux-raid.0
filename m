From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 1/1] raid0: discard requests do not align to chunk
 boundary
Date: Wed, 4 Jun 2014 12:20:36 +1000
Message-ID: <20140604122036.11175d7a@notabene.brown>
References: <4267B3A0-F0E8-407C-86D8-45ABC46D1464@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lCHhnD78VB38.I4Ix9tInDJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4267B3A0-F0E8-407C-86D8-45ABC46D1464@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eivind Sarto <eivindsarto@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/lCHhnD78VB38.I4Ix9tInDJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Jun 2014 14:18:53 -0700 Eivind Sarto <eivindsarto@gmail.com> wrot=
e:

> Raid0 only sets max_discard_sectors, but does not force alignment of disc=
ard requests.  Discard request
> will be broken up into chunk-sized REQ_DISCARD by blkdev_issue_discard(),=
 but if the sector is not=20
> chunk-aligned, each REQ_DISCARD to raid0 will all remain unaligned and ra=
id0 will ned to split them all.
>=20
> This patch will prevent splitting of REQ_DISCARD requests.
>=20
> -eivind

Which patch would that be, exactly.  :-)

NeilBrown

--Sig_/lCHhnD78VB38.I4Ix9tInDJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU46CdDnsnt1WYoG5AQK+BA//fUy/JzXg8efWV8gL2gSovqmF14VjqcYd
lZuRjtftcCqxYvQqonKxrYolN/bxJdYAC+bDS97CnFEMI3sl+M0kTVQMsHVUhNhu
mLRx4l1ti+fwUvEPYTjbNtMJsg+x8R1AZjkHqiqdT0FyD78nsd7Wm5/yZ9EqtNl+
ClPqaQU4nAK9T/9hMW6mJ52kxhSdaYpM3UnXX3miLiDAujbmh3BWAo78JhU17nuP
K/6wPO/pEE9klT0g47Ux3mUMSRBJN8we3RLpKOhz/Yjodg7/+9Inwu4RLoWywBYq
hpqV0NMJe1aPZvyDTSOQdiq3GvEXpxgEGgn1OBK9YtSfVREoLeYVDN+SFlo2DMab
Z71cu5Ly/0jsOyk7sn2PuxR/zKE4ONbrPdfvNALxray6UeotDGbEc2uUaWHnaMiI
HcherjpMm//Q7FfSW6y2pDPKrJuSaLB4/Ueo63ajtP4LYbPOyN+FF+GfOlD14dN4
a2URZzkhnpeHUgC/FLwUOLdR62KNAuANyLooraa5tHcQ4qwz1xd3y3yn5tMA8oti
DJlhTXuwkBrY4meNLSOYyb3zySHpwEAqskm5G8IEQfoQMV5lQbdLU7EzyNcLS33K
9FcM07XX1CsqMEc8mc4HfT6NVCo1m5Bb7Xav7IB0yaCMTWjnOYRHlUx6QBkWhCIT
GUYDSYF9Hqw=
=vqMk
-----END PGP SIGNATURE-----

--Sig_/lCHhnD78VB38.I4Ix9tInDJ--
