From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm 3.3: issue with mdmon --takeover
Date: Wed, 4 Sep 2013 16:08:32 +1000
Message-ID: <20130904160832.3627bcb8@notabene.brown>
References: <CAC9WiBjg4Tbv_UM4o66-8jtFEYGvh3kuP6xSdnz7uL+fq3fZTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GNaWZDeTA9iZ3dDPjcA63ow"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBjg4Tbv_UM4o66-8jtFEYGvh3kuP6xSdnz7uL+fq3fZTQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/GNaWZDeTA9iZ3dDPjcA63ow
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Sep 2013 17:54:55 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> Hello Martin :)
>=20
> I gave 3.3 release a try and I have a first issue: basically starting
> mdmon (3.3) with --takeover twice make mdmon failing on the second
> run.
>=20
> Please find details below:
>=20
> # cat /proc/mdstat
> Personalities : [raid1]
> md126 : active raid1 sdb[1] sda[0]
>       2064384 blocks super external:/md127/0 [2/2] [UU]
>=20
> md127 : inactive sdb[1](S) sda[0](S)
>       65536 blocks super external:ddf
>=20
> # ps aux | grep dmon
> root       311  0.4  1.0  80580 10944 ?        SLsl 17:46   0:00
> @sbin/mdmon --takeover md127
>=20
> # ./mdmon --takeover --all
>=20
> # ps aux | grep dmon
> root      3182  1.3  1.0  15156 11056 ?        SLsl 17:50   0:00
> ./mdmon --takeover md127
>=20
> # ./mdmon --takeover --all
> ...
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( )
> monitor: wake ( 12:array_state )
> read_and_act(0): 1378223477.512347 state:clean prev:clean action:idle
> prev: idle start:18446744073709551615
> ddf mark 0/Linux-MDdeadbeef00000000?Ob79e0c8b1n (5) clean 184467440737095=
51615
> manage_new: inst: 0 action: 11 state: 12
> mdmon: ddf_open_new: subarray 0 doesn't exist
> mdmon: failed to monitor external:/md127/0
> free_aa: sys_name: md126
> read_and_act(0): state:clean action:idle next( )
> manage_new: inst: 0 action: 20 state: 21
> ddf_open_new: new subarray 0, GUID: Linux-MDdeadbeef00000000?Ob79e0c8b1n
> free_aa: sys_name: md126
> caught sigterm, all clean... exiting
> monitor: wake ( )
> no arrays to monitor... exiting
>=20
> # ps aux | grep dmon
> #
>=20
> Thanks

I can't easily reproduce this.

Can you run "mdmon --takeover" in one window, then the next "mdmon
--takeover" is a different window so we can clearly see which messages are
coming from the mdmon which is exiting and which are coming from the mdmon
which is starting.

Thanks.

NeilBrown

--Sig_/GNaWZDeTA9iZ3dDPjcA63ow
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUibOYDnsnt1WYoG5AQIJiQ//V/IKU+O0/KUPihWQkgCZ7o9qYzZULm0W
oBLOIFmpnGCWL6SUIq6Rcvkh6GVjocabsUtVgfRA16xNJg27Zn9U8HQnQHLvVvSO
QradU27pgmHPIOqI2y1sYsBZB1C7vXbjYh+qaMwYy3EDtBHFReXsGZ6KFN5ERGRQ
PY9cdhDcmFpGtWujZfd87OOAPr/H9MxWD12XM9xbXW9b5nEoHCF8MXa+4mHDvBQm
lXgAlQiww1Zq4JAujMmaSTzzqfERemNS2yK0M+uMH9d/5Xiy9nfFU5NeLlkK8WMK
lBAenQ9UzJd9eW3DT/vi6y0zLIYSohyrqoed1lZu3O1kdV3GjJOmhQm7CJtvrqbv
+1s87Fzz9Fg5KMY/qBC6DeeZuncF96lGxG617fI60YfNmhfEQfuvVudKa4xQa53U
Nmak7+x5+sW7AA5HEqmRgAGgdfhrmpPi8N/eYPk0dDtUlgrPMbR4jK3UnPntj0Ew
T8YRmunj2mOrYiGKHABmSooZRcCeRLpq7tpbBLi311zcf7tauR9UaOJEjpTuP/Ef
P+gd02ecxWSm55go9cOKCoBCogjxhju8jovCY+h8ZjU4SlGqleuf7kZyBp+wfesx
AcMDyMjzZJKYTN01m9/5ZsUNvXZiFid48JXaDNsu4pyoDf3zn3st2LVIZOa0ch1T
6/GGZpQow2A=
=6Sjh
-----END PGP SIGNATURE-----

--Sig_/GNaWZDeTA9iZ3dDPjcA63ow--
