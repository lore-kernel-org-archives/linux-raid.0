From: NeilBrown <neilb@suse.de>
Subject: Re: Linux mdadm --grow RAID6: Something wrong - reshape aborted
Date: Mon, 6 May 2013 16:44:34 +1000
Message-ID: <20130506164434.2804bb68@notabene.brown>
References: <CANU9nT=_7HYg14sR57qffH1B8KXUoRyghQC8P1oz2KxRbZr1jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/04q9Vev_XJH/IfikCILD/EC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANU9nT=_7HYg14sR57qffH1B8KXUoRyghQC8P1oz2KxRbZr1jA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ole Tange <tange@binf.ku.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/04q9Vev_XJH/IfikCILD/EC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 2 May 2013 13:56:09 +0200 Ole Tange <tange@binf.ku.dk> wrote:

> I have a RAID60 that I want to expand.
>=20
> The current setup is: 2 axles each having 9 disks + 2 spares.
>=20
> The future wanted setup is: 4 axles each having 10 disks + 1 spare.
>=20
> So I need to do some --grow to reshape the drives.
>=20
> I thought this would be enough:
>=20
>   mdadm -v --grow /dev/md1 --raid-devices=3D10 --backup-file=3D/root/back=
-md1
>   mdadm -v --grow /dev/md2 --raid-devices=3D10 --backup-file=3D/root/back=
-md2
>   mdadm -v --grow /dev/md0 --raid-devices=3D4 --add /dev/md3 /dev/md4
>=20
> The last command works, but the 2 first commands fail with:
>=20
>   mdadm: Need to backup 7168K of critical section..
>   mdadm: /dev/md2: Something wrong - reshape aborted

I assume you are getting this error when running a test with small loop-back
devices - yes?
Very sensible to test first.  However to reshape a RAID6 from 9 to 10, you
need each device to be at least 7*8*chunksize*2 - possibly a bit more than
that.
Your script uses a chunksize of 128K, so you need at least 15Meg
Your script creates 1Meg devices.

Try your test with a  much smaller chunk size and a somewhat larger device
size.

NeilBrown

>=20
> How can I --grow a RAID6 to use more devices?
>=20
> Info about the system:
>=20
>   $ mdadm --version
>   mdadm - v3.2.5 - 18th May 2012
>   $ uname -r
>   3.5.0-17-generic
>=20
> This URL includes a Makefile to reproduce the problem:
> http://serverfault.com/questions/503832/linux-mdadm-grow-raid6-something-=
wrong-reshape-aborted
>=20
>=20
> /Ole
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/04q9Vev_XJH/IfikCILD/EC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUYdRUjnsnt1WYoG5AQLJqg/9Ef81NJgLKtQPWx3LkC47YygwjGxEmSWJ
H2cEB4Nr7XzlpemIqoe3/me4s04CJ/yjkFqGrEPTJLpACQ3J3tDRd2O906cmK9Iq
YIMGOf22OSUtPbyOjTLjnF0vi+iiQXYk+mvJd7T4lExgTgCiTq+96ZN59cF03NqJ
mDaa0NMzSPsUsgBJv2kpgXvDH1GIgYFrYzUCUynfKnU7rPOATtdRtzELxkG54MpE
Lv6PYLxa0pP4SyL+R7vezNAXezh7rKICRaqkTQS3oFFGpzmI03HuhOCoAwqq3PdB
swqCPeRF+8wQfD0DRnqJyOmo61pCEilbQYe2i6anKAandxZkgfjTjyClpGI6BPjC
XetKo3iNHvLqoCS3eFW+1mfQ+aeMCwPQSiJ5wTwbFP2lBlP45q1vhaB7gKzBIOvK
VZnl6u2798Ah1AX6s65DreT53iMyDrlNS3ssx9Ia8lazolE38YUeJ8RM+gTVuY7o
tks1nUryrUMxzXXLd0aT3HlJQzoF7/YaMZdV9QqC8J/0cYgPch2egoblGlom1brH
Fzu2Bh0C5ZTCmdYRrQKBzeQQGDfTaipZp+dfldAtUYa8mtpBih2FCEV855xrMAlC
58AcDqZYvVCJLU1/SWQCTvf3dBIWDOJDODXZ2pJaQ/QBOAdSxV6Hpjpq6shKSZer
3l6r+cYvVmk=
=1l8x
-----END PGP SIGNATURE-----

--Sig_/04q9Vev_XJH/IfikCILD/EC--
