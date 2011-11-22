From: NeilBrown <neilb@suse.de>
Subject: Re: partition based raid1 and multi boot Ubuntu/Xubuntu
Date: Wed, 23 Nov 2011 09:45:16 +1100
Message-ID: <20111123094516.16d73e97@notabene.brown>
References: <4ECC20C4.6050504@alabastercranium.demon.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/UQksB5DdZr.4v5eRKBmr1F/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ECC20C4.6050504@alabastercranium.demon.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Whitehead <gavin@alabastercranium.demon.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/UQksB5DdZr.4v5eRKBmr1F/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Nov 2011 22:23:00 +0000 Gavin Whitehead
<gavin@alabastercranium.demon.co.uk> wrote:

> I'm not sure if this is a GRUB2 problem or a RAID/MD issue but here goes.=
..
>=20
> I want to set up a machine that will boot two Linux installations using=20
> raid 1 partitions and Windows XP on a single partition.
>=20
> I have two identical disks partitioned as follows
>=20
> $ cat /proc/partitions
> major minor  #blocks  name
>=20
>     8        0  244198584 sda
>     8        1   30720000 sda1
>     8        2   30720000 sda2
>     8        3   40960000 sda3
>     8        4          1 sda4
>     8        5    4194304 sda5
>     8        6  137601024 sda6
>     8       16  244198584 sdb
>     8       17   30720000 sdb1
>     8       18   30720000 sdb2
>     8       19   40960000 sdb3
>     8       20          1 sdb4
>     8       21    4194304 sdb5
>     8       22  137601024 sdb6
>=20
> I installed WinXP first in sda3.
>=20
> I then installed Ubuntu 11.04 from the Alternate CD and created some=20
> raid1 devices
>      md0        sda1 sdb1    /
>      md1        sda5 sdb5    swap
>      md2        sda6 sdb6    /home
>=20
> I set the boot flag on sda1 and sdb1.
> This worked a treat.  I could boot in to either Ubuntu 11.04 to WinXP. =20
> I tested the RAID1 (power down, unplug a disk, power up, power down,=20
> replug the disk, power up,  use 'mdadm --add' to rebuild the array). =20
> Brilliant.
>=20
> Then I installed Xubuntu 11.10 from the Alternate CD.  For this install=20
> I created one new raid1 device (md3) and reused md1 and md2
>      md3        sda2 sdb2    /
>      md1        sda5 sdb5    swap
>      md2        sda6 sdb6    /home
>=20
> I set the boot flag on sda2 and sdb2.
>=20
> After the install had completed and grub2 had built the grub.cfg I only=20
> had my new Xubuntu 11.10 in the boot menu.  The Xubuntu 11.10 install=20
> works perfectly (and I can boot in to Win XP) but I can't boot in to the=
=20
> Ubuntu 11.04 installation.  I've re-run 'update-grub' but it doesn't=20
> find the other installation.
>=20
> If I run 'sudo mount /dev/md0 /mnt' I can access the Ubuntu 11.04 files.
>=20
> Is my intended configuration (tri-boot with two raid1, partition based,=20
> Linux installations and XP on a single parition) unachievable?
>=20

I would just dive into grub.cfg with an editor and make it work.

These wonderful "automatically make a config file for you tools" certainly
have a place, but there is a reason that config files are plain text files
and that reason is emacs (or possible vim).

NeilBrown

--Sig_/UQksB5DdZr.4v5eRKBmr1F/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTswl/Dnsnt1WYoG5AQIhaBAAk71uY4dBoHFuPmUaCZ6r9jodo0nArFpl
UTmE2nC+Ayj3euknIHHkCFn/gD76w1rR7dcK/iGrEZK9gW5i5kPimDiU3z5OI/UK
AqZ6G7hL/YO4yxvZU13PcFqGkM2fgQ/Scan/gK+eg1CqLWZaOb3T/GwayNuguMV3
olCNSSyWVssEzoJG8ppMh8OpwfY9oQkMadre/jmQ3c5s3trnY87l52fqFRBjY9Z+
rmMPX3yV7kolTnEaWd6wE3KIIzdMY54dtv7gQnaVxvVRXTSSlwcOAdsQgYSLcqOJ
eFNdB6R7I4hXoyrmforE1MDjqmHGL47j1J3IZx3Mgnj/kWU4/DMCQUl+SX7+nNGI
dhXnWjHWukvhcvO4JxjN+Hjchl9szsbxWbmItfQ5GAbihc6zKhd8H0VXxY8cYIe/
BvSij8jhSt5xTtzAcgrn2tOdHZtsP9dRq7ZMrYNe5ZYbteaPRSMLxWlJKQ35dt4V
NICRM6ZNllNCkkNAFa1tdJ0aiGZnE7rBx8hLAO4MkIuejMuNqKvpSRdASY9B+Pfk
17SsfLj7BWsXnzkW/agcbEfTJpl3itLLQqhZ7t53ER0SfL63dOOVgLP603lZLa9H
wZlbCZmDOWOQlShRlVNjcbMoZ1gB/zpp3tWUDUQJwrlCiwCu75q/MD1CsOTUCsqO
m4rMBrLq6yc=
=6Rs1
-----END PGP SIGNATURE-----

--Sig_/UQksB5DdZr.4v5eRKBmr1F/--
