From: NeilBrown <neilb@suse.de>
Subject: Re: Add disks and convert level 0 to level 5
Date: Thu, 11 Sep 2014 10:27:19 +1000
Message-ID: <20140911102719.053a5d5c@notabene.brown>
References: <loom.20140831T143354-68@post.gmane.org>
	<20140901083137.4772c8c5@notabene.brown>
	<8CF94689-0AD6-4B87-BC0C-815F794549E7@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/0DLtVWyZvBFTGFeWvDSpPMB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8CF94689-0AD6-4B87-BC0C-815F794549E7@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Muratet <muratetm@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/0DLtVWyZvBFTGFeWvDSpPMB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Sep 2014 11:15:24 -0500 Michael Muratet <muratetm@gmail.com> wro=
te:

> I have a two-disk RAID0 system that is working splendidly, thanks to the =
list for the help.
>=20
> I managed to get my hands on more identical disks and since I have the di=
sks and because I'm adding precious data, I'd like to add two more disks an=
d grow to RAID5.
>=20
> I have partitioned the two new drives to type 'fd', /dev/sde and /dev/sdf
>=20
> I believe the command to accomplish the change is this:
>=20
> mdadm /dev/md0 --grow --level=3D5 --add /dev/sde /dev/sdf
>=20
> Following the old adage "measure twice, cut once", is this syntax correct=
? Is there any danger of data loss in such a conversion?

I recommend creating a few loop-back devices and experimenting.
i.e.:
  create some 100M files.
  use "losetup" to turn them into block devices.
  create an 2-device raid0
  try converting it as you suggest.

You find it doesn't do quite what you expected, but should be easy to fix.

Providing your new devices are reliable (as least read/write the entire dri=
ve
once if you feel at all cautious) there is no particular danger of data los=
s.

NeilBrown


>=20
> Thanks
>=20
> Mike--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/0DLtVWyZvBFTGFeWvDSpPMB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBDsaDnsnt1WYoG5AQLsBA//d/b5ctxSc/D0Pw0EfIAnLJdhiiupW+B0
fbRccdfZnWPFmHWoyIIAEM3498kMDw8KNrCvdcSRQ86RuCDWPHRvkjSwO9V+hxiC
Mxwg4Bww6qals4aZQDceGq8s/T1VB4cxd+0toPU3afd306+vfx4DoKcH87bpQEGw
uWr+V946wkWEuAoFhczJMv0X/c/Je3JvmLvzm4lkOCcLyVCT0lywKuMJuG0qANcu
/NJubcJ9V8guuxIQxOmvHrhOvmo36utQInrBcW92rX7BTtSmhaVO3f6ojFgdH9A/
IfngKdLGx6+kTP4Fyn5TjjN9S537cPR/qxFpP/puiJrDsjQLECJSLpnoUu9z77F6
tuOeaSBCcVwgHtIk7lu6TDtVAY3SfknFCQY4Eci0QEIRknYhs2n9gimMe+Y8UvlD
BRNPBO7qTRUHQSSnddG3CO7vkoNqm8EELp9rdWh1VbknMkguyQyj7QxsChg8VEd/
XsdwZ9Uc+UBzgKN9YgUenZ/nsCvpoUeiKyrPv6UZ3amAPewWyg+63rdVewD8CUxa
Bn/rRhGgxvYP2Qo0L368uVSRcrKB/YRkdl+V2fcMT+cnUuKN9CYwg1R/3VtlSMLj
0/wq3Q5xUdSJ6qaHkI3rWfovm6P006BKUaHBCYIBCpHOd2XVGvjY/VRxstes9zeK
tES5uHlM+i8=
=bijC
-----END PGP SIGNATURE-----

--Sig_/0DLtVWyZvBFTGFeWvDSpPMB--
