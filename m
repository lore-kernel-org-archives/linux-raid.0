From: NeilBrown <neilb@suse.de>
Subject: Re: md raid6 not working
Date: Wed, 22 Aug 2012 08:38:24 +1000
Message-ID: <20120822083824.4dc16431@notabene.brown>
References: <CC5802CB.287BB%michael.vanhorn@wright.edu>
	<20120821083402.5e5b2fcf@notabene.brown>
	<429D03F4F1CC234886D1288428CFE8E0D42B0E@CH1PRD0102MB110.prod.exchangelabs.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YyYaMQp0x3TPK+C8wdnJsxW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <429D03F4F1CC234886D1288428CFE8E0D42B0E@CH1PRD0102MB110.prod.exchangelabs.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Vanhorn, Mike" <michael.vanhorn@wright.edu>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/YyYaMQp0x3TPK+C8wdnJsxW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 21 Aug 2012 11:17:57 +0000 "Vanhorn, Mike"
<michael.vanhorn@wright.edu> wrote:

> Thank you for your response. Here is the output you requested.
>=20
> >What is the result of:
> >
> >  mdadm -S /dev/md0
>=20
> # mdadm -S /dev/md0
> mdadm: stopped /dev/md0
> #
>=20
> >  mdadm -Avvv /dev/md0
>=20
> # mdadm -Avvv /dev/md0
> mdadm: looking for devices for /dev/md0
> mdadm: cannot open device /dev/sdi1: Device or resource busy
> mdadm: /dev/sdi1 has no superblock - assembly aborted
> #

So /dev/sdi1 is busy.  You need to find out why.  (the "no superblock"
message is a bit misleading... I might have fixed that in newer mdadm, I'm
not sure).

The "/proc/mdstat" that you showed in the original email had sdi1 as a memb=
er
of md0, so it clearly wasn't being used by anything else then.
"mdadm -S /dev/md0" would have removed it from md0 so it shouldn't have been
busy.
The fact that it is busy is very odd.

A device can be busy if:
 - it is mounted as a filesystem
 - it is active as swap
 - it is part of an md array
 - it is part of a dm device
 - probably something else, but those are the main ones.

NeilBrown

--Sig_/YyYaMQp0x3TPK+C8wdnJsxW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUDQN4Dnsnt1WYoG5AQKMag/+ISUzL5Tm3lV3qVe/1QSOMhfTqWnFvCpD
U2y13xQW/IrWvvOn7p4uZfE4EXe214j5UkJ/s0LngQVTlKiaZLkHkTjKk6C1JPUa
Xeqri5HWPeOq/c3RMfyoDkLD6J0ZRJwQXQthGmXsazDLOIalwVw8iM41maobfP58
VARhFi+qq4RDlI6uvtEO3F7e0I1On6jcBOICM/Av3GKNfIy9/X+I97N5bSR/Wmlz
6oIzVrD7IVfkczt18pOfyeu+qQ88iiX5oMy3YdubwQqXfIE3WSlKSlRQy5+3yDuJ
r88XgaNMy9eOk8fb2o7vuCmRgi/SnXevnrk2MnPZ58BqhJcGX0EMSm3z1mVfMzoU
95BExqCGEcPQqRuuR5+UPmuGRcWH9Vi2kv08CeMsCyMqk2aB8zdWwdJEVhi36qSa
+6asWC9A0zXYO874IWpNQ8EIS/NNYpUUOo8CPE/kQM3w7b9J/bg9xvlESbpj3XHa
EvBgg2E2KqJQvHw/efll/7aGyxAYOSCj/4T3LoTePptvIUuMIp6EDcLCartxWkRz
oNxJgm3/nL0ma1+1LuQ7QRysIjsONVrJkTdo9nVuUsYr2UYMY54+kXmUHi0MECgQ
FWOVNsVEcAvTe7B0JpsnWIJX/+XYco9igl6TYlofwxR2tYt8eKd+RVJTqFii9PDs
hOaCCcqZVnI=
=GiMt
-----END PGP SIGNATURE-----

--Sig_/YyYaMQp0x3TPK+C8wdnJsxW--
