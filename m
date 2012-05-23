From: NeilBrown <neilb@suse.de>
Subject: Re: SSSE6 / RAID6
Date: Wed, 23 May 2012 10:20:51 +1000
Message-ID: <20120523102051.071bf55b@notabene.brown>
References: <CADNH=7HByQyQy=Bbn5AjO=nz8437QOCjGbkVhiUAKwp61_is0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7qXBi3DhvdebKoZTVnq632d"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7HByQyQy=Bbn5AjO=nz8437QOCjGbkVhiUAKwp61_is0A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/7qXBi3DhvdebKoZTVnq632d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 22 May 2012 22:27:42 +0100 Mathias Bur=C3=A9n <mathias.buren@gmail.=
com>
wrote:

> Hi list,
>=20
> I just compiled 3.4 for my little Atom box. Is there any way I can
> confirm if the RAID6 check is using SSSE6 instructions?

SSSE6 ? What is that?  Some other name for SSSE3 ??

The SSSE3 RAID6 code was too late for 3.4. It is in -next and should appear
in 3.5-rc1.

NeilBrown

>=20
> $ zcat /proc/config.gz |grep -i -P '(raid|sss)'
> CONFIG_RAID_ATTRS=3Dy
> CONFIG_MD_RAID0=3Dm
> CONFIG_MD_RAID1=3Dm
> CONFIG_MD_RAID10=3Dm
> CONFIG_MD_RAID456=3Dy
> # CONFIG_MULTICORE_RAID456 is not set
> CONFIG_DM_RAID=3Dm
> CONFIG_ASYNC_RAID6_TEST=3Dm
> CONFIG_ASYNC_RAID6_RECOV=3Dy
> CONFIG_CRYPTO_SHA1_SSSE3=3Dy
> CONFIG_RAID6_PQ=3Dy
>=20
>  $ cat /proc/cpuinfo  |grep ssse
> flags		: fpu vme de tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc arch_perfmon pebs bts nopl aperfmperf pni dtes64 monitor
> ds_cpl tm2 ssse3 cx16 xtpr pdcm movbe lahf_lm dts
>=20
> $ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sdf1[5] sdh1[8] sdg1[0] sde1[7] sdc1[3] sdd1[4] sdb1[9]
>       9751756800 blocks super 1.2 level 6, 64k chunk, algorithm 2
> [7/7] [UUUUUUU]
>       [>....................]  check =3D  0.7% (15577860/1950351360)
> finish=3D1918.9min speed=3D16804K/sec
>=20
> unused devices: <none>
>=20
> $ ps aux |grep -i -P '(md|raid)'
> root        27  0.0  0.0      0     0 ?        S<   21:52   0:00 [md]
> root       342 15.5  0.0      0     0 ?        R    21:52   5:23 [md0_rai=
d6]
> root      3937 65.2  0.0      0     0 ?        R    22:13   9:11 [md0_res=
ync]
>=20
> Thanks,
> Mathias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/7qXBi3DhvdebKoZTVnq632d
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7wtYznsnt1WYoG5AQJHghAAhFNTWLs4g7kO2N0VSElCVBzWPK+PSMws
l/hhDmYTjnLt5wZJoMtSGVeMZpgFC6K90VFFex1YtQdiwkw3KnsyNhMZbZERDe7M
o+TTuUze2vNADnwzhN6iL/h2GzsD+oiamkIXwyIleZwm6/4DSneeFROWnWP5JyoG
plt4debfLurIcoKuM/wx//2EKHDEcmIkmekYxRD1/edsobeHX+8kaEYsSedwDVoF
QSlV1gNYJH3Ei0L0UjvFM8bf+Za8jwe2CGof0jr8bDxdwspWVq7w1L+LntIij8bR
XiQNJDHQUGFBYHRksxEXabsaLcRNzdwhrqWNE/aT6RcWvIbOUiD1TqheLHSH8q8j
2I7Y6YJ1UntmtYQM5Vb8AVYlZ9uHZ8KyBHkGS+4TsqOsuE7ssJsZ4zB8lD4pA+Fw
8soKCqyX2xhc4MqYGH0o03dwwzCnPikdnliOuNeINCtP0O6T5kNNdsz4JxO5BUS5
H1YSOhFsQQ9N0xyYlC2ji4fzK4cShFPtPswRJItEURxJf4lxKBuiHMIntfJvgW7I
9CCLADIu01pUfM5bbo5mH205VnFig97WzxU3vtGClcihojBAvnErLDW1F6QQOxQD
Y3ExcNboZFoGg2YhxnzAt2MUUap+ppRB8wXMo9wZ5RIZ9W3S+VUXwD8SldIJ90H8
w+XaJuQKdqU=
=Tlcf
-----END PGP SIGNATURE-----

--Sig_/7qXBi3DhvdebKoZTVnq632d--
