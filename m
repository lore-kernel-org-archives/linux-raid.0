From: NeilBrown <neilb@suse.de>
Subject: Re: About raid5 read error handle when raid5 was degraded.
Date: Tue, 22 May 2012 08:36:51 +1000
Message-ID: <20120522083651.194472c1@notabene.brown>
References: <201205211847549688311@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wS6KQrunGYi8qm6BlRoq=v+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201205211847549688311@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/wS6KQrunGYi8qm6BlRoq=v+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 21 May 2012 18:47:58 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

>  Hi all:
> 	I readed the latest code in function :
>=20
> raid5_end_read_request():
> >>	else if (conf->mddev->degraded >=3D conf->max_degraded)
> >>			printk_ratelimited(
> >>				KERN_WARNING
> >>				"md/raid:%s: read error not correctable "
> >>				"(sector %llu on %s).\n",
> >>				mdname(conf->mddev),
> >>				(unsigned long long)(sh->sector
> >>						     + rdev->data_offset),
> >>				bdn);
>=20
> If this occur,then exec md_error().In md_error(), remove this disk.
> The raid5 will fail and lost all data.
> Why do call rdev_set_badsector() for this situation?
>=20

You are probably right - rdev_set_badblocks should probably be called there.
I've added it to my list of issues to look at when I get a chance.

Thanks,
NeilBrown


--Sig_/wS6KQrunGYi8qm6BlRoq=v+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7rDgznsnt1WYoG5AQL1yxAAm3EcnnckryUWeI7+lWubpa9wyN4keJ/t
Jzyw8ztHWL0Wp01I/9qDvHpqk2lGHNTm2OjKpVPhKy319rTLqy0xa+ND1GqqgJOy
kYFrVqtyC2s+NgcpGptnMhNW2O4ouxMx9WnDSq9MnKhnpFxBjGxYuwuuM/d92gYo
e8GYxa8l9mEKd2gYg/AgFsUNRjfsfY2ocbauZC6siiMv0XAKNUeQxCKd92WTNG4e
Fk/6MNMRRkUQvmeTxe8qhkEoTOsJtbrlD0NYWOWswyGBVUMc5NCcuJBRJq8m657a
dMHa63bzhbp+R9PvnphUvv415/0sh0UFH3ZYx1P1xCRGxKUW2OSSHkY1doAprzIO
mJuChp0qP9XdCwL8XlG2rCYIPpDS/4zgpJHNnWYAh0qSHRK6QnE3mvH/hqt2DcX3
82JAMJ4TCSIRFqpvEOfCDdq5uvSE/Q5lVnd2+RbecL20oyzhbH/ubQS3HCt4W1A0
RtbxWeNVXCO1R2jvYNmasnfMCb8lO+qGuDU/WK7clKzA0XNlGtD/dLFzIfYFEqk9
sU+Vz8KdQZCZAcLwmaMehD2KENU/LRWLQ3pWPH3t3D2zTmYRQ8ZsuqaJPsfUYDO0
Dif2rL3aot7fXN0bPTAbjZLvFddiezKIBf/VdkmSw8h8gxrEjkZjdIBElxK18PJh
b0uW3u5/tAk=
=EGoM
-----END PGP SIGNATURE-----

--Sig_/wS6KQrunGYi8qm6BlRoq=v+--
