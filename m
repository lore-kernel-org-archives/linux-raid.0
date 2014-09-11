From: NeilBrown <neilb@suse.de>
Subject: Re: frequent disk activity with mdadm-3.3
Date: Fri, 12 Sep 2014 08:24:03 +1000
Message-ID: <20140912082403.549fc298@notabene.brown>
References: <AB305DF4-9DCC-47E1-9B29-130E211D4B4E@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/8EQPSKSIz1MnwTnnjks_g_="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AB305DF4-9DCC-47E1-9B29-130E211D4B4E@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marco Schindler <marco.schindler@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/8EQPSKSIz1MnwTnnjks_g_=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Sep 2014 00:05:08 +0200 Marco Schindler
<marco.schindler@gmail.com> wrote:

> Hello,
>=20
> Im seeing frequent disk activity on all raid drives from mdadm since upgr=
ading to 3.3.1/3.3.2 from 3.2.
> It keeps drives from sleeping (disk access every ~15 minutes). Is it inte=
ntional?

No.

>=20
> I reported a similar issue for udev a few weeks ago: https://bugs.gentoo.=
org/show_bug.cgi?id=3D518748

In that bug report you mention upgraded udev.  Here you mention upgrading
mdadm.... a bit confusing.

Can you use "blktrace" to gather details on exactly what is being read and
when, and  hopefully which process is doing it?

Is "mdadm --monitor" (or "-F") running?  If you kill it does the disk
activity go away?

NeilBrown

--Sig_/8EQPSKSIz1MnwTnnjks_g_=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBIhAznsnt1WYoG5AQJ20Q/+Nggpj3M7eLTJk4qejue7a51VgxSiHh2r
tWm48txS0EhKAby6YEay3QgzGQaXKxWuwyynbP846hDZLnACeifH0SUrC2aeoQEv
vv9jSOJ5e5YGMeLT+u/luRDaElGw3NAfx612ftsEnwAcJgt8HGqHRoArfeFjcSmD
bWCLJs4KJ/7O737uhsT0YLa18M7lzdNQZfGy4sbqQRNd7o+QxrS4q+nYCjp5F8SD
9QQqCBve4Cu/8LbuzblAaoLU90MhglAV297A2kIBLOqT8uHoqTqbagyfIbyH8I77
Wp/QIUMEv6+Vdb9eo574CNje0o0vqhXF84MAEmcnMzGBcj95iiUeKBNA6jr/iM5H
MwluH2j3PDOJX7oJnWz/taK87NLArpniYhEkfzPUeUDAVdqqLzEi11wRKFRNyRo2
gdSdF4psUVcXoLHE7a+jL0IPH8LcW9zn/DiV6QGuT6vdklB25/eDmSRG3p3aLjU6
g5dCMbHSWWWDrrhMiXNLoMQtctBVelF5xVC3YyA+9oJPR7VmF96FTqi+ykuwkDJ+
EZE+va+ANAfLSt9mz3zDeptrh38mk6Eug34Gs016as2bJZL5gQdPG2e2F08w9NlE
GXZlC/KYF4eprvopG3QI5d76jBC39qar9QhXEwSgMUXW12kvxlW1y26irgcyWJNZ
WCMsvRQaQnY=
=e6Ks
-----END PGP SIGNATURE-----

--Sig_/8EQPSKSIz1MnwTnnjks_g_=--
