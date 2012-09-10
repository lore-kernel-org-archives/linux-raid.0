From: NeilBrown <neilb@suse.de>
Subject: Re: Howto avoid full re-sync
Date: Mon, 10 Sep 2012 11:02:19 +1000
Message-ID: <20120910110219.7565cd0b@notabene.brown>
References: <50497AE6.2010005@websitemanagers.com.au>
	<81BAA7A8-B1C3-49A1-A600-A9D9D8279E30@bj-ig.de>
	<504D223A.6020707@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/W0DYlB/=lkPQm8ZA3s3Bo3b"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <504D223A.6020707@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <adam@websitemanagers.com.au>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/W0DYlB/=lkPQm8ZA3s3Bo3b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Sep 2012 09:11:54 +1000 Adam Goryachev
<adam@websitemanagers.com.au> wrote:

> On 09/07/2012 07:41 PM, Ralf M=FCller wrote:
> > Am 07.09.2012 um 06:41 schrieb Adam Goryachev:
> >
> >> I have a MD raid6 with 5 drives, and every now and then one (random)
> >> drive will fail. I've done all sorts of checks, and the drive is
> >> actually working fine, so I suspect an issue with the Linux driver
> >> and/or SATA controller (onboard).
> >>
> >> It isn't really relevant to the question, but I'll run through the sata
> >> stuff, in case anyone can point out a simple solution to stop this from
> >> happening (yes, a new server is on the way, but with budgets etc, that
> >> could be some time away. This issue has happened for years, but we are
> >> becoming more active with these failures now).
> >>
> >> 00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller
> >> (rev a1)
> >> 00:0f.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller
> >> (rev a1)
> >> 01:07.0 RAID bus controller: Silicon Image, Inc. Adaptec AAR-1210SA SA=
TA
> >> HostRAID Controller (rev 02)
> >>
> >> cat /proc/mdstat
> >> Personalities : [raid1] [raid6] [raid5] [raid4]
> >> md2 : active raid6 sdh1[5] sdg1[4] sdf1[0] sdd1[6](F) sde1[2] sda1[1]
> >>       5860535808 blocks level 6, 64k chunk, algorithm 2 [5/4] [UUU_U]
> >>       [>....................]  recovery =3D  1.4% (28663240/1953511936)
> >> finish=3D486.5min speed=3D65938K/sec
> >>
> >>
> >>
> >> Since I know sdh is actually almost up to date, is there some way to
> >> re-add it, and only have to sync the portions of the disk which have
> >> changed?
> >
> > Besides all the stuff about fix your server, a raid is not a backup and=
 you risk your data - simply add a write intent bitmap:
> >
> > # mdadm /dev/md2 --grow bitmap=3Dinternal
> >
> mdadm /dev/md2 --grow bitmap=3Dinternal
> mdadm: can only add devices to linear arrays

Check the man page....


 mdadm /dev/md2 --grow --bitmap=3Dinternal

NeilBrown


>=20
> md2 is raid6:
> md2 : active raid6 sdh1[3] sdg1[4] sdf1[0] sde1[2] sda1[1]
>        5860535808 blocks level 6, 64k chunk, algorithm 2 [5/5] [UUUUU]
>=20
> Regards,
> Adam
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/W0DYlB/=lkPQm8ZA3s3Bo3b
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE08Gznsnt1WYoG5AQLkZBAAoA1kf8YXwrnBDS6f7RzLTtMe+Vl7yrn6
FgQj2hYHXyLoQqJzEG+RTcrXcmlACaX6PRPlROxaKBJSav235UYylQ6QRk0XjVcN
Y7Ah3tYcjghybjlLZSyyStG3fnfJTuYE73I9Sfz+KA2FSBisyNEfJimpcaKydcJ6
r4gRrPDtc3k2/o2YHE90JQKWZCOFyr5FGN7zZSn5Ci2JpYnBs8ivc/neA4HayYr1
4S0nu/2PuFhPOVhJOmSL5nai1eSDAv37CI3WaOw7jGJZ6/ElmzT2/zB9Pi98MMbK
D3fl56OBMGX6AdoRUhTw3sUBljx1R2Xo31sMTl4zxO8LBPcv/0R+zTej85kgYGcF
BOWhH9tImx9AzH9eIinxDY75ynIqieldQzisNQ/VeC0a7OwAAh8KAwgODKtd4ri0
dyxT+2H7ACOTqFG6l/PBYbWDfu/PqMrRX3RWkfuedz/LnDAbIEHLu7qGLTwLzL8Z
bWU5L9Wi8UB6UP9hQcNXACrbGbFivV+V1lKXkH8aUvhYPNMYjSX/eD2M3/48n3gi
wx1YBqXGh5Da9VEBGILg/SIOrI4eHeqT9ZeR00xVV1ZSQ0C9weQElmqX2G49Lb9/
VQLKzdmHEo5RFwnB+FqzQN1LfvvlMx6k0s1G3oWljrzNnpPWkxcRCYA641RuafE1
ohWvqBZDUyQ=
=WH8D
-----END PGP SIGNATURE-----

--Sig_/W0DYlB/=lkPQm8ZA3s3Bo3b--
